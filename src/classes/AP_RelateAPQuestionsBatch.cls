/** AP_RelateAPQuestionsBatch
 * Developer                    		Date                Description<p />
 * Jair Anton							11/08/2021			batch for insert questions to AP
 * @author jair.anton.contractor@bbva.com
 */
global class AP_RelateAPQuestionsBatch implements Database.Batchable<SObject> {
    /**
	 * @Description handler package
	 */
    Final acpl.AccountPlanningHandler apHandler = acpl.AccountPlanningHandler.getInstance();

    /** QueryLocator BatchableContext*/
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT Id, Name, acpl__Account_Planning_Type__c, CreatedDate, acpl__gf_mandatory_type__c FROM acpl__Account_Planning__c WHERE CreatedDate = TODAY]);
    }
    /** Execute BatchableContext*/
    global void execute(Database.BatchableContext bc, List<acpl__Account_Planning__c> scope) {
        apHandler.relateAPQuestions(scope);
    }
    /** Finish BatchableContext*/   
    global void finish(Database.BatchableContext bc) {
        System.debug('Batch finish');
    }
}