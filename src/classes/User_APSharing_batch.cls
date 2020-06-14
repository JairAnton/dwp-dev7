/**
 * User_APSharing_batch
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		04/06/2020          Original version.<p />
 *
 * @author Diego Carbajal
 */
public without sharing class User_APSharing_batch implements Database.Batchable<sObject>, Database.Stateful {
	/**
	   @Description userIds
	 */
    private Set<Id> userIds {get; set;}
	/**
	   @Description User_APSharing_batch
	 */
	public User_APSharing_batch(Set<Id> ids) {
		this.userIds = ids;
	}

	/**
	   @Description start
	 */
	public Database.QueryLocator start(Database.BatchableContext batchC) {
		return Database.getQueryLocator([SELECT Id, acpl__gf_account_planning_id__c, bupl__gf_ap_team_user_id__c, bupl__gf_business_plan_id__c FROM bupl__AP_Team__c 
                                         WHERE bupl__gf_ap_team_user_id__c IN: userIds AND acpl__gf_account_planning_id__r.RecordType.DeveloperName = 'Account_Planning' 
                                         AND(acpl__gf_account_planning_id__r.acpl__gf_ap_status_type_name__c NOT IN ('Validated') OR 
                                             acpl__gf_account_planning_id__r.acpl__gf_ap_substatus_type_name__c NOT IN ('Expired'))]);
	}

	/**
	   @Description execute
	 */
	public void execute(Database.BatchableContext batchC, List<bupl__AP_Team__c> lstobj) {
		system.debug('>>>>> BATCH lstobj: ' + lstobj);
		Final Map<Id, bupl__AP_Team__c> mapAPT = new Map<Id, bupl__AP_Team__c>();
		for(bupl__AP_Team__c apt:lstobj) {
			mapAPT.put(apt.Id, apt);
		}
		if(!mapAPT.isEmpty()) {
			Sharing_AP_Team_User_cls.SharingAPT(mapAPT, false);
		}
	}

	/**
	   @Description finish
	 */
	public void finish(Database.BatchableContext batchC) {}
}
