/**
 * @author bbva.com developers
 * @date 2018
 *
 * @group global_hub
 *
 * @description get Opportunity Owner without context User
 **/
public class GetOppOwner implements DynamicNotificationMessageRecipent {
	public static Map<Id, List<Id>> getRecipients(List<Id> lstrecord, String sObjectName) {
		Id userId = UserInfo.getUserId();
		Map<Id, List<Id>> returnValues = new Map<Id, List<Id>>();
		if(!lstrecord.isEmpty()) {
			List<Opportunity> oppList = [select Id, OwnerId from Opportunity where Id =:lstrecord];
			if(!oppList.isEmpty()) {
				for(Opportunity opp : oppList) {
					if(opp.OwnerId != userId) {
						List<Id> ownerIdList = new List<Id>();
						ownerIdList.add(opp.OwnerId);
						returnValues.put(opp.Id, ownerIdList);
					}
				}
			}
		}

		return returnValues;
	}
}
