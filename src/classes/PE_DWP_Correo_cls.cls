/*
 * Ejemplo de correo Electronico
 * 
*/
global class PE_DWP_Correo_cls implements Messaging.InboundEmailHandler {
    Global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope env ) {
        // Create an inboundEmailResult object for returning 
        // the result of the email service.
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        map<String,String> varieble= new map<String,String>();
        String mySubject = email.subject;
        String SioCode ='';
        String SioStatus ='';
        String myPlainText = '';
        myPlainText = email.plainTextBody;
        Schema.DescribeFieldResult fieldResult = Opportunity.Opportunity_status_type__c.getDescribe();    
        List<Schema.picklistEntry> vls = fieldResult.getPicklistValues();
        for(Schema.picklistEntry v:vls)    
            {    
                varieble.put(v.getLabel(),v.getValue());
            } 
       System.debug(varieble);
        // Capture the record ID from the subject line
        list<String> refg = mySubject.split('##');
       	
        // [Select id, StageName, Opportunity_status_type__c from Opportunity where  ='' limmit 1];
        // New email task to be created
         Task[] newTask = new Task[0];
        try
        {
            // Try to lookup the lead record that matches the ID in the subject
             
            if(refg.size()==4){
             newTask.add(new Task(Description = myPlainText, Priority = 'Normal',
                                    Status = 'Inbound Email', Subject = mySubject));
             SioCode = refg[0];
             SioStatus=refg[1];
            }else if(refg.size()==5){
                List <User> IdENtrante = new List<User>();
                IdENtrante=[Select id from User where FederationIdentifier =:refg[0]];
                if(!IdENtrante.isEmpty()){
                    newTask.add(new Task(Description = myPlainText, Priority = 'Normal',
                                    Status = 'Inbound Email', Subject = mySubject, whoId=IdENtrante[0].Id));
                }else{
                    newTask.add(new Task(Description = myPlainText, Priority = 'Normal',
                                    Status = 'Inbound Email', Subject = mySubject));
                }               
                SioCode = refg[1];
                SioStatus=refg[2];
            }else if(refg.size()==2){
                ActualizaClienteGrupo(refg);
                SioCode='';
            }else {
                SioCode='';
            } 
             
            
            if(!String.isEmpty(SioCode)){
                List<OpportunityLineItem> Oppsele = new list<OpportunityLineItem>();
                
            	Oppsele = [select id,opportunityId, opportunity.StageName,opportunity.Opportunity_status_type__c 
                            from OpportunityLineItem where SioCode__c=:SioCode limit 1];
                if(Oppsele.size()>0&&(Oppsele[0].opportunity.StageName=='04')){
                    
                    Opportunity OppStatus = new Opportunity(
                        id=Oppsele[0].opportunityId,
                        StageName=Oppsele[0].opportunity.StageName,
                        Opportunity_status_type__c=SioStatus
                    );
                    Update OppStatus;
                }
            // insert the new task
             insert newTask;
             System.debug('New Task Created:' +newTask);
                 if (email.binaryAttachments != null && email.binaryAttachments.size() > 0) 
                 {
                     for (integer i = 0 ; i < email.binaryAttachments.size() ; i++) 
                     {
                         Attachment attachment = new Attachment();
                         // attach to the found record
                         
                         attachment.Name = email.binaryAttachments[i].filename;
                         attachment.Body = email.binaryAttachments[i].body;
                         attachment.Description = mySubject;
                         insert attachment;
                     }
                 }  
            }
        }
        catch(Exception e)
        {
            System.debug('Exception Issue: ' +e);
        }

        // Return True and exit.
        // True confirms program is complete and no emails 
        // should be sent to the sender of the reply email. 
        result.success = true;
        return result;
    } 
    public void ActualizaClienteGrupo(List<String> valores){
        List <Account> variables = new List<Account>();
        LIST<Account> temp = new LIST<Account>();
            temp= [select Id from Account where main_code_id__c=:valores[0] limit 1];
        	Variables=[Select id from Account where ParentId =:temp[0].Id or Id=:temp[0].Id];
        for(Account cuenta: variables){
            cuenta.financial_program_expiry_date__c=date.parse(valores[1]);
        }
        update variables;
    }
}