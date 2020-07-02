/**
 * BE_AP_CheckEditionByPeriodSchedulable for lock/unlock AP's
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		05/05/2020          Original version.<p />
 *
 * @author Diego Carbajal
 */
public without sharing class BE_AP_CheckEditionByPeriodSchedulable implements Schedulable {
	/*
	 * @author       Global Desktop
	 * @Description  Ejecuta el batch para lock/unlock AP's
	 */
	public void execute(SchedulableContext scMain) {
		Final acpl__Account_Plan_Settings__c apSetting = acpl__Account_Plan_Settings__c.getInstance();
		Final BE_AP_CheckEditionByPeriodBatch eventNotifBatch = new BE_AP_CheckEditionByPeriodBatch();
		database.executebatch(eventNotifBatch, (Integer)apSetting.acpl__Edition_Schedulable_batch_size__c);
	}
}