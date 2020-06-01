/**
 * @author bbva.com developers
 * @date 2018
 *
 * @group global_hub
 *
 * @description get Account Owner without context User
 **/
public class getAccountOwner implements DynamicNotificationMessageRecipent {
	public static Map<Id, List<Id>> getRecipients(List<Id> lstrecord, String sObjectName) {
		Map<Id, List<Id>> returnValues = new Map<Id, List<Id>>();
		Id contextUserId = UserInfo.getUserId();
		if(!lstrecord.isEmpty()) {
			List<Opportunity> oppList = [select Id, AccountId from Opportunity where Id =:lstrecord];
			if(!oppList.isEmpty()) {
				List<Id> accIdList = new List<Id>();
				for(Opportunity opp : oppList) {
					accIdList.add(opp.AccountId);
				}
				List<Account> accList = [select Id, OwnerId from Account where Id =: accIdList];
				if(!accList.isEmpty()) {
					for(Opportunity opp : oppList) {
						for(Account acc : accList) {
							if((opp.AccountId == acc.Id) && (acc.OwnerId != contextUserId)) {
								List<Id> ownerId = new List<Id>();
								ownerId.add(acc.OwnerId);
								returnValues.put(opp.Id, ownerId);
							}
						}
					}
				}
			}
		}
		return returnValues;
	}
}
