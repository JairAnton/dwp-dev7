/**
   -------------------------------------------------------------------------------------------------
   @Name BE_AP_UpdateAPQuestions
   @Author Lolo Bravo
   @Date 2020-11-04
   @Description
   @Changes
   Date        Author       Email                  Type
   2021-03-04  LMBR     	lolo.bravo@bbva.com    Creation
   -------------------------------------------------------------------------------------------------
 */
public class BE_AP_UpdateAPQuestions  implements  Database.Batchable<sObject>, Database.Stateful {
    // instance member to retain state across transactions
    private Integer recordsProcessed = 0;
    final private Map<Id,Id> idCatalogs = new Map<Id,Id>(); //Id Account Plan Type - Id Account Plan Catalog
    final private List<Id> idAPCatalogs = new List<Id>();
    /** BatchableContext*/
    public Database.QueryLocator start(Database.BatchableContext bc) {
        for (acpl__Account_Planning__c accPlan : [SELECT Id, acpl__Account_Planning_Type__c FROM acpl__Account_Planning__c Where RecordType.DeveloperName = 'Question_Catalog']) {
    	idCatalogs.put(accPlan.acpl__Account_Planning_Type__c, accPlan.Id);
        idAPCatalogs.add(accPlan.id);
		}
        return Database.getQueryLocator(
            'SELECT ID, Name, acpl__gf_account_planning_id__r.acpl__Account_Planning_Type__c FROM acpl__AP_Question__c'
        );
    }
    
    /** Execute Method*/
    public void execute(Database.BatchableContext bc, List<acpl__AP_Question__c> scope) {
        final List<acpl__AP_Question__c> lstAPQ = new List<acpl__AP_Question__c>();
        // process each batch of records
        for (acpl__AP_Question__c accPlanQuestion : scope) {
            if (!idAPCatalogs.contains(accPlanQuestion.Name.substringBefore('_'))) {
                accPlanQuestion.Name = idCatalogs.get(accPlanQuestion.acpl__gf_account_planning_id__r.acpl__Account_Planning_Type__c)+'_'+accPlanQuestion.Name.substringAfter('_');
                lstAPQ.add(accPlanQuestion);
                // increment the instance member counter
            	recordsProcessed = recordsProcessed + 1;                
            }
        }
        if(!lstAPQ.isEmpty()) {
        update lstAPQ;
        }
    }
    /** Finish BatchableContext*/
    public void finish(Database.BatchableContext bc) {
        System.debug(recordsProcessed + 'AP Question records processed!');
        final AsyncApexJob job = [SELECT Id, Status, NumberOfErrors,
            JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()];
        System.debug('##job##'+job.Id);
    }
}