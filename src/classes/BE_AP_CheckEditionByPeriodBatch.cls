/**
 * BE_AP_CheckEditionByPeriodBatch for lock/unlock AP's
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		05/05/2020          Original version.<p />
 *
 * @author Diego Carbajal
 */
public without sharing class BE_AP_CheckEditionByPeriodBatch implements Database.Batchable<Sobject>, Database.Stateful {
	//--------------------------------------- PRIVATE ATTRIBUTES ------------------------------------
	/** @Description    Records processed*/
	private Integer recordsProcessed = 0;
	/** @Description    Query to obtain records*/
	private Final String query = 'SELECT Id, Name, acpl__gf_ap_indvi_lock_edit_ind_type__c, acpl__gf_event_date__c, acpl__gf_ap_priority_type_name__c, acpl__gf_ap_launch_name__c '
	                       + 'FROM acpl__Account_Planning__c WHERE acpl__gf_ap_status_type_name__c != \'Validated\' AND acpl__gf_ap_status_type_name__c != \'Pending Validation\' AND acpl__gf_ap_substatus_type_name__c != \'Expired\''
	                       + 'AND RecordType.Name = \'Account Planning\'';

	/*
	 * * @author         Global Desktop
	 * * @Description    Constructor method
	 */
	public BE_AP_CheckEditionByPeriodBatch() {
		system.debug('>>>>> Query: ' + query);
	}

	/*
	 * * @author         Global Desktop
	 * @Description    Batchable method
	 */
	public Database.QueryLocator start(Database.BatchableContext batchC) {
		return Database.getQueryLocator(query);
	}

	/*
	 * @author         Global Desktop
	 * @Description    Batchable method
	 */
	public void execute(Database.BatchableContext batchC, List<acpl__Account_Planning__c> apList) {
		system.debug('>>>>> BATCH apList: ' + apList);
		BE_AP_CheckEditionByPeriodBatchHandler.editionControl(apList);
		system.debug('>>>>> DESPUES apList');
		recordsProcessed += apList.size();
	}

	/*
	 * @author         Global Desktop
	 * @Description    Batchable method
	 */
	public void finish(Database.BatchableContext batchC) {
		Final AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id = :batchC.getJobId()];
		System.debug('>>>>> SUMMARY: ');
		System.debug('>>>>>   Records Processed: ' + recordsProcessed);
		System.debug('>>>>>   Batches Created: ' + job.JobItemsProcessed);
		System.debug('>>>>>   Number of Errors: ' + job.NumberOfErrors);
		System.debug('>>>>>   Status: ' + job.Status);
	}
}