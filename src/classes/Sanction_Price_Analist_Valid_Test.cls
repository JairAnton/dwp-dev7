@istest
public class Sanction_Price_Analist_Valid_Test {
	@testSetup
	static void setData() {
		Account acc = TestFactory.createAccount();
		Opportunity opp = TestFactory.createOpportunity(acc.Id, UserInfo.getUserId());
		Product2 prod = TestFactory.createProduct();
		OpportunityLineItem oli = TestFactory.createOLI(opp.Id, prod.Id);
		Case cs = TestFactory.createCase(UserInfo.getUserId());
		cs.opportunity_id__c = opp.Id;
		update cs;
		User testUser1 = TestFactory.createUser('TestUser1', 'Ejecutivo');
	}

	@isTest
	static void test_method_one() {
		setData();
		List<Opportunity> lstOpp = [SELECT Id FROM Opportunity];
		List<User> listUser = [select Id, LastName, IsActive from User where Profile.Name = 'Ejecutivo' AND IsActive = true];

		System.runAs(listUser[0]) {
			List<String> lstError = Sanction_Price_Analist_ValidationClass.getErrorMessagesList(lstOpp[0].Id, '', '');
			System.assertEquals(lstError.isEmpty(), false);
		}
	}
}
