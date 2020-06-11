@isTest
public class SchedulableProductModel_Test {
	@isTest
	public static void test_method_one() {
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'CompromiseProducts', iaso__Url__c = 'https://CompromiseProducts/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		insert new Product_Model__c(Name = '3');
		Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
		iaso.GBL_Mock.setMock(new Integration_MockGenerator());

		Test.StartTest();
		SchedulableProductModel sh1 = new SchedulableProductModel();
		String sch = '0 0 23 * * ?';
		String jobId = System.schedule('Test check', sch, sh1);

		CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
		System.assertEquals(sch, ct.CronExpression);
		System.assertEquals(0, ct.TimesTriggered);

		Test.stopTest();
	}
}
