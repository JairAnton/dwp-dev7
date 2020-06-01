/*
 * @Name: User_Assistant_Team_Trigger_cls
 * @Description: User_Assistant_Team__c trigger
 * @Create by: Jose Luis Ruiz Garrido
 *
 */
public without sharing class User_Assistant_Team_Trigger_cls {
	public void AsignAfterInsert(list<User_Assistant_Team__c> UAssT_New, Map<id, User_Assistant_Team__c> UAssT_NewMap,
	                             list<User_Assistant_Team__c> UAssT_Old, Map<id, User_Assistant_Team__c> UAssT_OldMap) {
		insertAssistants(UAssT_New);
	}

	public void AsignAfterDelete(list<User_Assistant_Team__c> UAssT_Old) {
		deleteAssistants(UAssT_Old);
	}

	private void insertAssistants(list<User_Assistant_Team__c> UAssT_New) {
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
    
	private void deleteAssistants(list<User_Assistant_Team__c> UAssT_Old) {
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
}
