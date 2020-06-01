/**
 * @author bbva.com developers
 * @date 2018
 *
 * @group global_hub
 *
 * @description get Operative Users in Branch without context User
 **/
public class GetOppBranchOperative implements DynamicNotificationMessageRecipent {
	public static Map<Id, List<Id>> getRecipients(List<Id> lstrecord, String sObjectName) {
		Map<Id, List<Id>> returnValues = new Map<Id, List<Id>>();
		Id userId = UserInfo.getUserId();
		System.debug('User Id: ' + userId);

		//Retieve information about Opportunity lstRecord
		List<Opportunity> oppList = [select Id, Branch_id__c from Opportunity where Id =:lstrecord];
		List<Id> branchOppIdList = new List<Id>();
		for(Opportunity opp : oppList) {
			branchOppIdList.add(opp.Branch_id__c);
		}
		System.debug('Lista de oficinas de las oportunidades: ' + branchOppIdList);

		Map<Id, List<Id>> operativesPerBranchMap = getBranchOperatives(branchOppIdList, userId);

		//Create the return info Map with the Branch Id and their Operative Users and without Operative context User
		for(Opportunity opp : oppList) {
			if(operativesPerBranchMap.containsKey(opp.Branch_id__c)) {
				returnValues.put(opp.Id, operativesPerBranchMap.get(opp.Branch_id__c));
			}
		}
		System.debug('Mapa resultante: ' + returnValues);
		return returnValues;
	}

	public static Map<Id, List<Id>> getBranchOperatives(List<Id> branchIdList, Id userId) {
		Map<Id, List<Id>> returnValues = new Map<Id, List<Id>>();
		System.debug('Metodo. Lista de oficinas entrante: ' + branchIdList);
		// Retrieve input branch users with profile Operativo
		List<User_Branch__c> userBranchList = [select Id, branch_name__c, User__c from User_Branch__c where branch_name__c =: branchIdList and User__r.Profile.Name = 'Operativo'];
		System.debug('Metodo. User Branch con Usuarios Operativos: ' + userBranchList);
		//Create a Map with each Branch and their User with Operative profile
		for(User_Branch__c ub : userBranchList) {
			if(!returnValues.containsKey(ub.branch_name__c)) {
				if(ub.User__c != userId) {
					List<Id> userList = new List<Id>();
					userList.add(ub.User__c);
					returnValues.put(ub.branch_name__c, userList);
				}
			} else {
				if(ub.User__c != userId) {
					returnValues.get(ub.branch_name__c).add(ub.User__c);
				}
			}
		}
		System.debug('Metodo. Mapa resultante: ' + returnValues);
		return returnValues;
	}

	public static Map<Id, List<Id>> getOperatives(List<User_Branch__c> ubList) {
		Map<Id, List<Id>> returnOperatives = new Map<Id, List<Id>>();
		List<Id> userList = new List<Id>();
		//Get user Id from the input user_branch
		for(User_Branch__c ub : ubList) {
			userList.add(ub.User__c);
		}

		List<User> operativeUserList = [select Id, Profile.Name from User where Id =:userList and Profile.Name = 'Operativo'];
		for(User_Branch__c ub : ubList) {
			List<Id> userIdList = new List<Id>();
			for(User u : operativeUserList) {
				if(ub.User__c == u.Id) {
					userIdList.add(u.Id);
				}
			}
			returnOperatives.put(ub.branch_name__c, userIdList);
		}
		return returnOperatives;
	}
}
