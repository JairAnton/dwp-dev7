/**
 * @author bbva.com developers
 * @date 2018
 *
 * @group global_hub
 *
 * @description get Account Owner without context User
 **/
public class GetAccountOwnerAndOppTeam implements DynamicNotificationMessageRecipent {
	public static Map<Id, List<Id>> getRecipients(List<Id> lstrecord, String sObjectName) {
		Map<Id, List<Id>> returnValues = new Map<Id, List<Id>>();
		Id contextUserId = UserInfo.getUserId();
		returnValues = GetAccountOwner.getRecipients(lstrecord, sObjectName);
		List<OpportunityTeamMember> optmList = [select Id, UserId, OpportunityId from OpportunityTeamMember where OpportunityId =: lstrecord];
		if(!optmList.isEmpty()) {
			for(OpportunityTeamMember optm : optmList) {
				if(returnValues.containsKey(optm.OpportunityId) && (optm.UserId != contextUserId)) {
					returnValues.get(optm.OpportunityId).add(optm.userId);
				}
			}
		}
		return returnValues;
	}
}
