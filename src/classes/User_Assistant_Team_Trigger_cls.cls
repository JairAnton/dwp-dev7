/*
 * @Name: User_Assistant_Team_Trigger_cls
 * @Description: User_Assistant_Team__c trigger
 * @Create by: Jose Luis Ruiz Garrido
 *
 */
public without sharing class User_Assistant_Team_Trigger_cls {

	/**
     * @Description constructor
     */
	private User_Assistant_Team_Trigger_cls() {}

	/**
     * @Description AsignAfterInsert
     */
	public static void asignAfterInsert(list<User_Assistant_Team__c> uatNew, Map<id, User_Assistant_Team__c> uatNewMap,
	                             list<User_Assistant_Team__c> uatOld, Map<id, User_Assistant_Team__c> uatOldMap) {
		insertAssistants(uatNew);
		insertSMSharing(uatNew);
	}

	/**
     * @Description AsignAfterDelete
     */
	public static void AsignAfterDelete(list<User_Assistant_Team__c> uatOld) {
		deleteAssistants(uatOld);
		deleteSMSharing(uatOld);
	}

	/**
     * @Description insertAssistants
     */
	private static void insertAssistants(list<User_Assistant_Team__c> UAssT_New) {
		list<AccountTeamMember> atmList = new List<AccountTeamMember>();
		list<String> uatIdList = new List<String>();
		for(User_Assistant_Team__c uat : UAssT_New) {
			uatIdList.add(uat.user_Id__c);
		}
		List<Account> accList = [Select id, OwnerId From Account where OwnerId IN :uatIdList];

		for(User_Assistant_Team__c uat : UAssT_New) {
			for(Account acc : accList) {
				if(acc.OwnerId == uat.user_Id__c) {
					AccountTeamMember atm = new AccountTeamMember();
					atm.AccountId = acc.id;
					atm.UserId = uat.assistant_id__c;
					atm.AccountAccessLevel = Label.AccessLevelRead;
					atm.CaseAccessLevel = Label.AccessLevelEdit;
					atm.ContactAccessLevel = Label.AccessLevelEdit;
					atm.OpportunityAccessLevel = Label.AccessLevelEdit;
					atm.TeamMemberRole = Label.TeamMemberRoleExecutive;
					atmList.add(atm);
				}
			}
		}
		if(!atmList.isEmpty()) {
			insert atmList;
		}
	}
	
	/**
     * @Description insertSMSharing
     */
	private static void insertSMSharing(List<User_Assistant_Team__c> triggerNew) {
		Final Map<Id, Set<Id>> mapEjeAndAst = new Map<Id, Set<Id>>();
		Final List<String> ASSIST_CODE = System.Label.lblAssistants.split(',');
		Final Map<Id, User> mapAssist = new Map<Id, User>([SELECT Id FROM User WHERE prof_position_id__c IN: ASSIST_CODE]);
		Set<Id> setAssistAux;
		for(User_Assistant_Team__c uat : triggerNew) {
			if(mapAssist.containsKey(uat.assistant_id__c)) {
				setAssistAux = new Set<Id>{uat.assistant_id__c};
				if(mapEjeAndAst.containsKey(uat.user_Id__c)) {
					setAssistAux.addAll(mapEjeAndAst.get(uat.user_Id__c));
				}
				mapEjeAndAst.put(uat.user_Id__c, setAssistAux);
			}
		}
		Final slmt__Sales_Meeting__c[] lstSM = [SELECT Id, Collaborator__c FROM slmt__Sales_Meeting__c WHERE 
												Collaborator__c IN:mapEjeAndAst.keySet()];
		Final slmt__Sales_Meeting__Share[] lstSMSNew = new slmt__Sales_Meeting__Share[]{};
		for(slmt__Sales_Meeting__c smAux:lstSM) {
			for(Id assistAux: mapEjeAndAst.get(smAux.Collaborator__c)) {
				lstSMSNew.add(new slmt__Sales_Meeting__Share(parentId = smAux.Id, AccessLevel = 'Edit', RowCause = 'Manual', 
							UserOrGroupId = assistAux));
			}
		}
		SalesMeeting_Trigger_cls.insertSharedUser(lstSMSNew);
		/** SHARE MANAGEMENT PLAN TO ASSISTANT */
		final dwp_frct__management_plan__c[] cPlans=[SELECT OwnerId FROM dwp_frct__management_plan__c WHERE OwnerId IN:mapEjeAndAst.keySet()];
        final dwp_frct__management_plan__Share[] cPlansShare = new dwp_frct__management_plan__Share[]{};
        for(dwp_frct__management_plan__c cplanAux:cPlans) {
			for(Id assistAux: mapEjeAndAst.get(cplanAux.OwnerId)) {
				cPlansShare.add(new dwp_frct__management_plan__Share(parentId = cplanAux.Id, AccessLevel = 'Edit', RowCause = 'Manual', 
							UserOrGroupId = assistAux));
			}
		}
		insert cPlansShare;
	}

	/**
     * @Description deleteAssistants
     */
	private static void deleteAssistants(list<User_Assistant_Team__c> UAssT_Old) {
		list<AccountTeamMember> atmList = new List<AccountTeamMember>();
		list<String> uatIdList = new List<String>();
		for(User_Assistant_Team__c uat : UAssT_Old) {
			uatIdList.add(uat.user_Id__c);
		}
		List<Account> accList = [Select id, OwnerId, (select id, AccountId, UserId from AccountTeamMembers) From Account where OwnerId IN :uatIdList];

		for(User_Assistant_Team__c uat : UAssT_Old) {
			for(Account acc : accList) {
				if(acc.OwnerId == uat.user_Id__c) {
					for(AccountTeamMember atm : acc.AccountTeamMembers) {
						if(uat.assistant_id__c == atm.UserId) {
							atmList.add(atm);
						}
					}
				}
			}
		}
		if(!atmList.isEmpty()) {
			delete atmList;
		}
	}

	/**
     * @Description deleteSMSharing
     */
	private static void deleteSMSharing(List<User_Assistant_Team__c> triggerOld) {
		Final Map<Id, Set<Id>> mapEjeAndAst = new Map<Id, Set<Id>>();
		Set<Id> setAssistAux;
		for(User_Assistant_Team__c uat : triggerOld) {
			setAssistAux = new Set<Id>{uat.assistant_id__c};
			if(mapEjeAndAst.containsKey(uat.user_Id__c)) {
				setAssistAux.addAll(mapEjeAndAst.get(uat.user_Id__c));
			}
			mapEjeAndAst.put(uat.user_Id__c, setAssistAux);
		}
		final Map<Id, slmt__Sales_Meeting__c> mapSM = new Map<Id, slmt__Sales_Meeting__c>([SELECT Id FROM slmt__Sales_Meeting__c 
													WHERE Collaborator__c IN:mapEjeAndAst.keySet()]);
		final slmt__Sales_Meeting__Share[] lstSMS = [SELECT Id, parent.Collaborator__c, UserOrGroupId FROM slmt__Sales_Meeting__Share 
														WHERE parentId IN:mapSM.keySet() AND AccessLevel = 'Edit' AND 
														RowCause = 'Manual' AND UserOrGroupId IN: setAssistAux];
		final slmt__Sales_Meeting__Share[] lstSMStoDel = new slmt__Sales_Meeting__Share[]{};
		Set<Id> setIdAux;
		for(slmt__Sales_Meeting__Share smsAux: lstSMS) {
			setIdAux = mapEjeAndAst.get(smsAux.parent.Collaborator__c);
			if(setIdAux.contains(smsAux.UserOrGroupId)) {
				lstSMStoDel.add(smsAux);
			}
		}
		if(!lstSMStoDel.isEmpty()) {delete lstSMStoDel;}
		//final mAP<Id,dwp_frct__management_plan__c> cPlans= new Map<Id,dwp_frct__management_plan__c>([SELECT OwnerId FROM dwp_frct__management_plan__c WHERE OwnerId IN:mapEjeAndAst.keySet()]);
		final dwp_frct__management_plan__Share[] cPlansShare =[SELECT Id, parent.OwnerId, UserOrGroupId FROM dwp_frct__management_plan__Share WHERE parentId IN:mapSM.keySet() AND 
		AccessLevel = 'Edit' AND RowCause = 'Manual' AND UserOrGroupId IN: setAssistAux];
		final dwp_frct__management_plan__Share[] cPlansShareDel= new dwp_frct__management_plan__Share[]{};
        for(dwp_frct__management_plan__Share cPlanShareAux:cPlansShare) {
			if(mapEjeAndAst.get(cPlanShareAux.parent.OwnerId).contains(cPlanShareAux.UserOrGroupId)){
				cPlansShareDel.add(cPlanShareAux);
			}
		}
        if(!cPlansShareDel.isEmpty()) {delete cPlansShareDel;}
	}
}