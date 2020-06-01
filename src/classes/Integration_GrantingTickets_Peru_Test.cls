@istest
public class Integration_GrantingTickets_Peru_Test {
	@isTest
	public static void test_method_one() {
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		Test.startTest();

		Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
		iaso.GBL_Mock.setMock(new Integration_MockGenerator());
		List<iaso__GBL_Authentication_Service__mdt> lstAuth = [SELECT iaso__isOrgCache__c,
		                                                       iaso__Apex_Class__c,
		                                                       iaso__Custom_Setting__c,
		                                                       DeveloperName,
		                                                       iaso__Cache_Key__c,
		                                                       iaso__Cache_Partition__c,
		                                                       iaso__Header_Token__c,
		                                                       iaso__CryptoKey__c,
		                                                       iaso__Password__c,
		                                                       iaso__User__c,
		                                                       iaso__Service_Parameters__c
		                                                       FROM iaso__GBL_Authentication_Service__mdt
		                                                       WHERE DeveloperName = 'bbvaPeruGrantingTickets'
		                                                                             LIMIT 1];
		Integration_GrantingTickets_Peru.resetToken(lstAuth[0]);
		HttpRequest request = new HttpRequest();
		Integration_GrantingTickets_Peru.applySecurity(request, lstAuth[0]);
		Boolean aut = Integration_GrantingTickets_Peru.isAuthenticated(lstAuth[0]); // Yulino 11/12/2018 : Se agregó la variable bool y Assets al final de la linea
		Test.stopTest();
		System.assertEquals(false, aut);
	}
}
