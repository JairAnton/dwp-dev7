/**
 * @author bbva.com developers
 * @date 2018
 *
 * @group global_hub
 *
 * @description Validation class
 **/
public class checkIfUserNotOppAccountOwner implements DynamicNotificationMessageValidation {
	//Return the Account Owner
	public static List<String> getValidRecords(List<Id> lstrecord, String sObjectName) {
		List<String> returnValues = new List<String>();
		String owner = UserInfo.getUserId();
		if(lstrecord.size() != 0) {
			if(sObjectName != '' || sObjectName != null) {
				//Return the Account Owner asociated with de Opportunity
				if(sObjectName == 'Opportunity') {
					List<Opportunity> oppOwned = [select Id, Account.OwnerId from Opportunity where Id =:lstrecord];
					for(Opportunity o : oppOwned) {
						if(o.Account.OwnerId != owner) {
							returnValues.add(o.Id);
						}
					}
				}

				//Return the Account Owner asociated with de OpportunityLineItem contained in the Opportunity
				if(sObjectName == 'OpportunityLineItem') {
					List<OpportunityLineItem> oliList = [select Id, Opportunity.Account.OwnerId from OpportunityLineItem where Id =:lstrecord];
					for(OpportunityLineItem oli : oliList) {
						if(oli.Opportunity.Account.OwnerId != owner) {
							returnValues.add(oli.Id);
						}
					}
				}
			}
		}
		return returnValues;
	}
}
