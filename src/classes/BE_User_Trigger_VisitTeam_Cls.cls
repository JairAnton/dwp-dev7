/**
   ----------------------------------------------------------------------------------------------------
   @Name <BE_User_Trigger_VisitTeam_Cls>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2020-04-15
   @Description Class for create dwp_kitv__Visit__Share record for reactive users.
   @Changes
    Date        Author   Email                  Type
    2020-04-15  LMBR     lolo.bravo@bbva.com    Creation
   ----------------------------------------------------------------------------------------------------
 */
public without sharing class BE_User_Trigger_VisitTeam_Cls {
	/** public constructor */
	private BE_User_Trigger_VisitTeam_Cls() {
	}

	/**
	   @Description get desactives User to active.
	   @param  userNewMap Map<id,User>
	   @param  userOldMap Map<id,User>
	   @return void
	 */
	public static void sharingVisitTeamMember(Map<id, User> userNewMap, Map<id, User> userOldMap) {
		Set<Id> userIds = new Set<Id>();
		for(String userId: userNewMap.keySet()) {
			if(userOldMap.get(userId).IsActive == false && userNewMap.get(userId).IsActive == true) {
				userIds.add(userId);
			}
		}
		sharingVisitTeamMember(userIds);
	}

	/**
	   @Description create dwp_kitv__Visit__Share record for reactive users.
	   @param  userIds Set<Id>
	   @return void
	 */
	@future
	public static void sharingVisitTeamMember(Set<Id> userIds) {
		final List<String> openStatus = new List<String> {'No realizada', 'Pendiente de feedback'};
		final List<String> sObjNames = new List<String> {'Account'};
		final Map<String, Schema.RecordTypeInfo> recordType = BE_General_Utils.getRecordTypeInfo(sObjNames);
		final List<Id> recordTypes = new List<Id> {recordType.get('Record_Type_Non_Client').getRecordTypeId(), recordType.get('Record_Type_Client').getRecordTypeId()};
		Final List<dwp_kitv__Visit__Share> lstVisitShare = new List<dwp_kitv__Visit__Share>();
		for(dwp_kitv__Visit_Management_Team__c visitManTeam : [SELECT dwp_kitv__user_id__c, dwp_kitv__visit_id__c FROM dwp_kitv__Visit_Management_Team__c WHERE
		                                                       dwp_kitv__visit_id__r.report_visit_status_type__c IN:openStatus AND dwp_owner_visit__c = false AND dwp_kitv__visit_id__r.dwp_kitv__account_id__r.RecordTypeId IN:recordTypes AND dwp_kitv__user_id__c IN:userIds]) {
			lstVisitShare.add(new dwp_kitv__Visit__Share(ParentId = visitManTeam.dwp_kitv__visit_id__c, UserOrGroupId  =  visitManTeam.dwp_kitv__user_id__c, AccessLevel = 'Edit', RowCause = 'Manual'));
		}
		final Integer visitShareSize = lstVisitShare.size();
		if(visitShareSize > 0) {insert lstVisitShare;}
	}
}
