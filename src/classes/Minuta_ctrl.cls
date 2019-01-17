/* -------------------------------------------------------------------
* Jose Rodriguez               07/08/2019          Original version.<p />
*
* @author Jose Rodriguez
*/
public virtual class Minuta_ctrl extends MinutaWrap{
    
    public String IdVisitaActual {get; set;}
    public dwp_kitv__Visit__c DatosVisita {get; set;}
    public dwp_kitv__Visit__c visit {get; set;}
    public boolean redireccion {get; set;}
    public String currentDate { get { return formatCurrentDate(Date.today()); }}
    public String visitDate {get; set;}
    public String infoStatusVisit {get; set;}
    public boolean correoEnviado {get; set;}

    Public String formatCurrentDate(Date dateToConvert){
       
        Integer day = dateToConvert.day();
        Integer month = dateToConvert.month();
        Integer year = dateToConvert.year();
        String strMonth  = getStringMonth(month); 
        return day + ' de ' + strMonth + ' de ' + year ;  
    }
    
    Public String getStringMonth(Integer month){
       String strMonth ='';
        if(month==1){
           strMonth = 'Enero';
        }else if (month==2){
           strMonth = 'Febreo'; 
        }else if (month==3){
           strMonth = 'Marzo'; 
        }else if (month==4){
           strMonth = 'Abril'; 
        }else if (month==5){
           strMonth = 'Mayo'; 
        }else if (month==6){
           strMonth = 'Junio'; 
        }else if (month==7){
           strMonth = 'Julio'; 
        }else if (month==8){
           strMonth = 'Agosto'; 
        }else if (month==9){
           return 'Septiembre'; 
        }else if (month==10){
           strMonth = 'Octubre'; 
        }else if (month==11){
           strMonth = 'Noviembre'; 
        }else if (month==12){
           strMonth = 'Diciebre'; 
        }
        return strMonth;
    }
    
    
    public Minuta_ctrl(ApexPages.StandardController controller){
 
       IdVisitaActual = ApexPages.currentPage().getParameters().get('Id');
       DatosVisita = new dwp_kitv__Visit__c();
       visit = new dwp_kitv__Visit__c();
       redireccion = false;
       infoStatusVisit='';
       DatosVisita = [select id,Name,dwp_kitv__visit_start_date__c,account_name__c, dwp_kitv__visit_status_type__c,
                      (select id,dwp_kitv__contact_id__r.Name,dwp_kitv__contact_email_desc__c from dwp_kitv__Visit_Contacts__r ),
                      (SELECT id,dwp_kitv__user_id__r.Name,dwp_kitv__contact_email_desc__c FROM dwp_kitv__Visit_Management_Teams__r) 
                      from dwp_kitv__Visit__c where Id =:IdVisitaActual limit 1]; 
        visit.id = DatosVisita.Id;
       	visit.dwp_kitv__visit_status_type__c = DatosVisita.dwp_kitv__visit_status_type__c;
       	visit.dwp_kitv__visit_start_date__c=DatosVisita.dwp_kitv__visit_start_date__c;
        if(visit.dwp_kitv__visit_status_type__c !='02'){
        infoStatusVisit = 'AVISO: No se enviará la minuta, debe estar agendada la visita.';
       }
        correoEnviado=false;
       setValues(controller.getId());
    }
    
    
    public void sendMail() {
        string sMyCS = ApexPages.currentPage().getParameters().get('myCS');
        if(sMyCS != null && sMyCS != ''){
            dwp_kitv__Template_for_type_of_visit_cs__c myCS =(dwp_kitv__Template_for_type_of_visit_cs__c)System.JSON.deserialize(sMyCS, dwp_kitv__Template_for_type_of_visit_cs__c.class);
            String sDocumentos = ApexPages.currentPage().getParameters().get('documents');
            System.debug('--sDocumentos-->'+sDocumentos);
            List<ContentVersion> lstDocument = (List<ContentVersion>)System.JSON.deserialize(sDocumentos, List<ContentVersion>.class);
            System.debug('--lstDocument-->'+lstDocument);
        
            if(myCS != null){
                if(visit.dwp_kitv__visit_status_type__c=='02'){
                    System.debug('--si tiene sMyCS-->'+ sMyCS);
                    EnviarMinutaVF(visit, myCS, lstDocument);
                }else{
                    redireccion = true;
                }          
             } 
        }
    }
    
    
     public void EnviarMinutaVF(dwp_kitv__Visit__c visitObj, dwp_kitv__Template_for_type_of_visit_cs__c myCS,List<ContentVersion> documents){
        //keep the status of the visit
        String statusOldVisit = visitObj.dwp_kitv__visit_status_type__c;
        String templateConverted = 'BODY NULL';
        list<Messaging.Emailfileattachment> lstAdjuntos = new list<Messaging.Emailfileattachment>();//adicional ASD
        try{
            dwp_kitv.Minute_Generator_Ctrl.updateStatusVisit(visitObj,'05');
            dwp_kitv__Visit__c visitObjNew=dwp_kitv.Minute_Generator_Ctrl.getVisitObj(visitObj.Id);
            System.debug('--si tiene visitObjNew-->'+ visitObjNew);
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();   
            PageReference templateVF = Page.Minuta;
             System.debug('-- PageReference templateVF->'+templateVF);
            templateVF.getParameters().put('id',visitObjNew.Id);
            templateVF.setRedirect(true);
            //templateConverted = templateVF.getContent().tostring();
             if(!test.isRunningTest()){
                templateConverted = templateVF.getContent().tostring();
            }else{
                templateConverted='';
            }
 			String htmlBody = 	'<![CDATA[ <html lang="es">'+
                                '<meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />'+
                                templateConverted+
                                '</html>';
            email.setHtmlBody(htmlBody); 
            String inputDate = visitObj.dwp_kitv__visit_start_date__c.format('dd-MM-YYYY HH:mm a');
            String sendDate =  System.now().format('dd-MM-YYYY HH:mm a');
			email.setSubject(myCS.dwp_kitv__Subject__c +' del '+inputDate + ' - enviado: ' + sendDate );
  			List<String> typeAddress= dwp_kitv.Minute_Generator_Ctrl.getTypeAddress();
			email = dwp_kitv.Minute_Generator_Ctrl.setAddressToEmail(email,typeAddress,visitObjNew);
			boolean attachFile= dwp_kitv.Minute_Generator_Ctrl.getExistField(myCS, 'dwp_kitv__Attach_file__c');
  			List<Id> ltsIdDoc = dwp_kitv.Minute_Generator_Ctrl.getIdsDocuments(documents);
 			email = dwp_kitv.Minute_Generator_Ctrl.setFiles(email, ltsIdDoc, attachFile);
            email.setSaveAsActivity(false);
            System.debug('--attachFile->'+attachFile);
            System.debug('--ltsIdDoc->'+ltsIdDoc);
            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {email};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            System.debug('---results-EMAIL->'+results);
            if (results[0].isSuccess()) {
                createEmailAttachment(visitObjNew);
               dwp_kitv.Minute_Generator_Ctrl.createActivity(visitObjNew.Id, myCS);
				correoEnviado=true;
            }else{
               dwp_kitv.Minute_Generator_Ctrl.updateStatusVisit(visitObjNew,statusOldVisit);
            }
            redireccion = true;
        }catch(Exception ex) {
            System.debug('---Exception->'+ex);
           dwp_kitv.Minute_Generator_Ctrl.updateStatusVisit(visitObj,statusOldVisit);
        }
    }
    
    
    public String createEmailAttachment( dwp_kitv__Visit__c visitObjNew){
        		PageReference pdfMinuta = Page.Minuta;
               	pdfMinuta.getParameters().put('id',visitObjNew.Id);
               	pdfMinuta.setRedirect(true);
        		String templateConverted2 ='';
               	//String templateConverted2 = pdfMinuta.getContent().tostring();
         		if(!test.isRunningTest()){
               	 templateConverted2 = pdfMinuta.getContent().tostring();
            	}else{
                	templateConverted2='';
            	}    	
 				String htmlBody2 = '<![CDATA[ <html lang="es">'+
                                    '<meta content="text/html; " http-equiv="Content-Type" />'+
                                    templateConverted2+
                                    '</html>';
    			Attachment attach = new Attachment();
                Blob  body  ;
             	try { 
					body = Blob.valueOf(htmlBody2);
				} catch (VisualforceException e) {
        		body = Blob.valueOf('Some Text');
    		}
			attach.Body = body;  // body;
            attach.Name = 'Minuta visita del '+formatCurrentDate(Date.today())+'.html';
            attach.IsPrivate = false;
            attach.ParentId  = visitObjNew.Id;
   			insert attach;
        return attach.id;
    }


    
}