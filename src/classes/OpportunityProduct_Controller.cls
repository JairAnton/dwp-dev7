/**OpportunityProduct_Controller
*  object.
* <p /><p />
* Modification log:<p />
* -------------------------------------------------------------------
* Developer                    Date                Description<p />
* -------------------------------------------------------------------
* Julio Medellin               7/05/2018          Original version.<p />
*
* @author Julio Medellín
*/
public without sharing class OpportunityProduct_Controller {
    
    
    @AuraEnabled
    public static list<Task> getTasks(String val){
        if(val==null)val='';
        string Search ='%'+val+'%';
        list<Task>  tasks = new list<task>();
        list<Task>  tasks2 = new list<task>();
        tasks = [SELECT Id,Status,Subject,CreatedDate FROM Task WHERE Status =: System.Label.taskFilter AND Subject  LIKE : Search ORDER BY Subject,CreatedDate DESC  LIMIT 10 ];
        
        String SIOtmp ='';
        Boolean duplicate;
        for(task t :tasks ){
            duplicate=false;
            if(SIOtmp != t.subject.substring(0,t.subject.indexOf('#'))){
                SIOtmp =  t.subject.substring(0,t.subject.indexOf('#'));
                t.Subject = SIOtmp;
                for(task t2 :tasks2){
                    system.debug(SIOtmp+' task2:'+t2.subject);
                    if(SIOtmp==t2.subject)
                        duplicate=true;
                }
                if(!duplicate) tasks2.add(t);
            }}
        return tasks2;
    }
    
    @AuraEnabled
    public static OpportunityLineItem getOppLI(String opp){
        OpportunityLineItem  oli = new OpportunityLineItem();
        oli = [SELECT Id,SIOCode__c,PE_List_Product_mode__c FROM OpportunityLineItem WHERE OpportunityID =:opp LIMIT 1];
        return oli;
    }
    @AuraEnabled
    public static void saveSIO(String opp,String savedRow){
        Opportunity op  = new Opportunity();
        Map<string,string> MapStatus = getMapOppStatus();
        Task t = [SELECT Id,Subject,Status FROM Task WHERE Id = : savedRow];
        t.Status='Completed';
        op = [SELECT StageName FROM Opportunity WHERE ID =:opp];
        op.StageName='04';
        String[] valStatus = t.Subject.split('##');
        String filter = '%'+valStatus[0]+'%';
        list<Task> ts = [SELECT Id,Subject,Status FROM Task WHERE Subject LIKE :filter];
        for(task td :ts){
            td.Status='Completed';
        }
        op.opportunity_status_type__c=MapStatus.get(valStatus[1]);
        op.Risk_modality_type__c='02';
        op.isProcess__c=true;
        op.sio_code__c=valStatus[0];
        OpportunityLineItem  oli = new OpportunityLineItem();
        oli = [SELECT Id FROM OpportunityLineItem WHERE OpportunityID =:opp LIMIT 1];
        oli.SIOCode__c = valStatus[0];
        update oli;
        update op;
        op.isProcess__c=false;
        update op;
        update t;
        update ts;
		//BEGIN Traceability - 2018-06-11
		//Isaías Vellázquez Cortés
		new OpportunityTraceability_cls().addOpportunityTraceability(valStatus[1],'Código SIO:' +valStatus[0],'Opportunity',op.Id,'quickText','TRSR00001',UserInfo.getUserId(),'embedded',1,true);
		//END Traceability
    }
    
    private static  Map<string,string> getMapOppStatus(){
        Map<string,string> MapStatus = new Map<string,string>();
        Schema.DescribeFieldResult fieldResult = Opportunity.opportunity_status_type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple)
        {
            MapStatus.put(f.getLabel(), f.getValue());
        }
        return MapStatus;
    }
    @AuraEnabled
    public static void sendApproval(String opp){
        Opportunity op  = new Opportunity();
        op = [SELECT StageName FROM Opportunity WHERE ID =:opp];
        op.StageName='04';
        op.isProcess__c=true;
        op.opportunity_status_type__c = '18';
        op.Risk_modality_type__c='01';
        update op;
        op.isProcess__c=false;
        update op;
		//BEGIN Traceability - 2018-06-11
		//Isaías Vellázquez Cortés
		new OpportunityTraceability_cls().addOpportunityTraceability('Riesgo aprobado dentro de linea','Dentro de Linea','Opportunity',op.Id,'approve','TRSR00001',UserInfo.getUserId(),'embedded',1,true);
		//END Traceability
    }
    @AuraEnabled
    public static string requestModality(String opp){
        String val='';
        list<Modality_Mode__c> mcs = Modality_Mode__c.getAll().values();
        map<String,string> msc2 = new map<String,string>();
        OpportunityLineItem  oli = new OpportunityLineItem();
        oli = [SELECT Id,tolabel(PE_List_Product_mode__c), Opportunity.Risk_modality_type__c, Product2.ProductCode FROM OpportunityLineItem 
               WHERE OpportunityID =:opp LIMIT 1];
        if(String.isEmpty(oli.Opportunity.Risk_modality_type__c)){           
            for(Modality_Mode__c m:mcs){
                if(m.Product_Name__c==oli.Product2.ProductCode)
                    msc2.put(m.Modalidad_producto__c,m.Modality_Select__c);
            }
            if(!msc2.isEmpty()){
                val=msc2.get(Oli.PE_List_Product_mode__c);
            }
        }
        return val;
    }
}