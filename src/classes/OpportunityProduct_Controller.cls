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
public class OpportunityProduct_Controller {

    
@AuraEnabled     
    public static list<Task> getTasks(String val){    
    string Search ='%'+val+'%';    
    list<Task>  tasks = new list<task>();   
    tasks = [SELECT Status,Subject FROM Task WHERE /*Status =: System.Label.taskFilter AND*/ Subject LIKE : Search LIMIT 10];
    return tasks;    
    }    

@AuraEnabled     
    public static string getOppLI(String opp){   
    OpportunityLineItem  oli = new OpportunityLineItem();   
    oli = [SELECT Id FROM OpportunityLineItem WHERE OpportunityID =:opp LIMIT 1];   
    return oli.Id;    
    }        
 @AuraEnabled     
    public static void saveSIO(String opp,String savedRow){
    Opportunity op  = new Opportunity();
    op = [SELECT StageName FROM Opportunity WHERE ID =:opp];
    op.StageName='04';    
    OpportunityLineItem  oli = new OpportunityLineItem();   
    oli = [SELECT Id FROM OpportunityLineItem WHERE OpportunityID =:opp LIMIT 1];   
    oli.SIOCode__c = savedRow;
    update oli;
    update op;    
    }
 @AuraEnabled     
    public static void sendApproval(String opp){
    Opportunity op  = new Opportunity();
    op = [SELECT StageName FROM Opportunity WHERE ID =:opp];
    op.StageName='04';
    op.opportunity_status_type__c = '08';    
    update op;    
    }          
}