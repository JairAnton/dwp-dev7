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
                for(task t2 :tasks2)
                {
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
    oli = [SELECT Id,SIOCode__c FROM OpportunityLineItem WHERE OpportunityID =:opp LIMIT 1];
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
    op.Modality__c='Requires authorization';
    op.isProcess__c=true;
    op.LastSIOcode__c=valStatus[0];
    OpportunityLineItem  oli = new OpportunityLineItem();
    oli = [SELECT Id FROM OpportunityLineItem WHERE OpportunityID =:opp LIMIT 1];
    oli.SIOCode__c = valStatus[0];
    update oli;
    update op;
    op.isProcess__c=false;
    update op;
    update t;
    update ts;
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
    op.opportunity_status_type__c = '46';
    op.Modality__c='Inside line';
    update op;
    op.isProcess__c=false;
    update op;
    }
}