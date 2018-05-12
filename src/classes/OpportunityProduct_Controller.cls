/**OpportunityProduct_Controller
*  object.
* <p /><p />
* Modification log:<p />
* -------------------------------------------------------------------
* Developer                    Date                Description<p />
* -------------------------------------------------------------------
* Julio Medellin               7/05/2018          Original version.<p />
*
* @author Julio Medellin
*/
public without sharing class OpportunityProduct_Controller {


@AuraEnabled
    public static list<Task> getTasks(String val){
    if(val==null)val='';
    string Search ='%'+val+'%';
    list<Task>  tasks = new list<task>();
    tasks = [SELECT Status,Subject FROM Task WHERE Status =: System.Label.taskFilter AND Subject  LIKE : Search LIMIT 10];
        for(task t :tasks ) {
           t.subject = t.subject.substring(0,t.subject.indexOf('#'));
        }

    return tasks;
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
    op = [SELECT StageName FROM Opportunity WHERE ID =:opp];
    op.StageName='04';
    op.Modality__c='Requires authorization';
    op.isProcess__c=true;
    op.LastSIOcode__c=savedRow;
    OpportunityLineItem  oli = new OpportunityLineItem();
    oli = [SELECT Id FROM OpportunityLineItem WHERE OpportunityID =:opp LIMIT 1];
    oli.SIOCode__c = savedRow;
    update oli;
    update op;
    op.isProcess__c=false;
    update op;
    }
 @AuraEnabled
    public static void sendApproval(String opp){
    Opportunity op  = new Opportunity();
    op = [SELECT StageName FROM Opportunity WHERE ID =:opp];
    op.StageName='04';
    op.isProcess__c=true;
    op.opportunity_status_type__c = '08';
    op.Modality__c='Inside line';
    update op;
    op.isProcess__c=false;
    update op;
    }
}
