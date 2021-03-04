public class BE_AP_DeleteFieldConfigs  implements Database.Batchable<sObject>, Database.Stateful {
    // instance member to retain state across transactions
    public Integer recordsProcessed = 0;
    public List<Id> idCatalogs = new List<Id>();
    public Database.QueryLocator start(Database.BatchableContext bc) {
		for (acpl__Account_Planning__c accPlan : [SELECT Id FROM acpl__Account_Planning__c Where RecordType.DeveloperName = 'Question_Catalog']) {
    	idCatalogs.add(accPlan.id);
		}
        return Database.getQueryLocator(
            'SELECT Id, dyfr__DeveloperName__c FROM dyfr__Field_Config__c WHERE dyfr__Tab__r.dyfr__Template__r.acpl__Account_Planning_Type__c != null'
        );
        
    }
    public void execute(Database.BatchableContext bc, List<dyfr__Field_Config__c> scope){
        List<dyfr__Field_Config__c> lstFCDelete = new List<dyfr__Field_Config__c>();
        // process each batch of records
        for (dyfr__Field_Config__c fieldConfig : scope) {
            if (!idCatalogs.contains(fieldConfig.dyfr__DeveloperName__c.substringBefore('_'))) {
				lstFCDelete.add(fieldConfig);      
            	// increment the instance member counter
            	recordsProcessed = recordsProcessed + 1;
            }
        }
        if(!lstFCDelete.isEmpty()) {
        	delete lstFCDelete;
        }
    }
    public void finish(Database.BatchableContext bc){
        System.debug(recordsProcessed + 'Field Config records processed!');
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors,
            JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()];
    }
}