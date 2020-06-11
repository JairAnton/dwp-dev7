@isTest
public class DynamicNotificationMessageStructure_Test {
	static Account acctest;
	static Opportunity opptest;
	@testSetup
	static void setData() {
		acctest = TestFactory.createAccount();
		opptest = TestFactory.createOpportunity(acctest.Id, UserInfo.getUserId());
	}

	@isTest
	static void  messagedetail() {
		setData();
		Test.startTest();
		List<Id> lstopp = new List<Id>();
		lstopp.add(opptest.Id);

		String msg = 'La oportunidad #Name# del cliente #Account.Name# ha sido desestimada por #UserInfo# el día #CurrentDateTime#. Acceda a la oportunidad a través del siguiente link #SalesforceBaseUrl#/#Id#';
		DynamicNotificationMessageStructure.getMessageStructure(lstopp, 'Opportunity', msg);
		Test.stopTest();
		System.assertEquals(opptest.Id, lstopp[0]);
	}
}
