/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_NonClient_Tst>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2020-03-03
   @Description test for BE_NonClient_Ctr class
   @Changes
   Date        Author   Email                  Type
   2020-03-03  LMBR     lolo.bravo@bbva.com    Creation
   -------------------------------------------------------------------------------------------------
 */
@IsTest
public without sharing class BE_NonClient_Tst {
/** GrantingTickets */
private static final String GRANT_TICKET = 'GrantingTickets';
/** GrantingTickets */
private static final String CACHE_PARTITION = 'local.CredentialsPeru';
/** GrantingTickets */
private static final String RUC_ACC = '20876543262';
/** GrantingTickets */
private static final String URL_GT = 'https://validation/ok';
/**
   @Description test BE_NonClient_Ctr.checkDuplicateNonClients(), correct scenary
 */
@IsTest
static void checkDuplicateNonClientsTest() {
	Test.startTest();
	final Id rTypeId =Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Record_Type_Non_Client').getRecordTypeId();
	final Account acc=new Account(Name='TEST_NON_CLIENT',AccountNumber='20876543265',recordTypeId=rTypeId, non_client_code__c='EXISTENOCLIENTE');
	insert acc;
	final String resJSON=BE_NonClient_Ctr.checkDuplicateNonClients('TEST_NON_CLIENT','AccountNumber',acc.AccountNumber);
	final List<BE_NonClient_Ctr.WrapperAccount>lWrapper=(List<BE_NonClient_Ctr.WrapperAccount>)JSON.deserialize(resJSON, List<BE_NonClient_Ctr.WrapperAccount>.Class);
	System.assertEquals(1, lWrapper.size(), 'Sucesss');
	Test.stopTest();
}
/**
   @Description test BE_NonClient_Ctr.validateNonCliente(), exist non cliente.
 */
@IsTest
static void validateNonClienteTestExistNonClient() {
	insert new iaso__GBL_Rest_Services_Url__c(Name = GRANT_TICKET, iaso__Url__c = URL_GT, iaso__Cache_Partition__c = CACHE_PARTITION);
	insert new iaso__GBL_Rest_Services_Url__c(Name = 'ListNonClient', iaso__Url__c = 'https://ListNonClient/200', iaso__Cache_Partition__c = CACHE_PARTITION);
	Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
	iaso.GBL_Mock.setMock(new Integration_MockGenerator());
	Test.startTest();
	final Account acc=new Account(Name='TEST_NON_CLIENT_TEST_ONE',AccountNumber=RUC_ACC,phone_area_code__c='01',other_phone_number__c='9876543');
	final String res=BE_NonClient_Ctr.validateNonCliente(acc);
	final BE_NonClient_Ctr.ResultValidation resultVal= (BE_NonClient_Ctr.ResultValidation )JSON.deserialize(res,BE_NonClient_Ctr.ResultValidation.class);
	System.assertEquals('success',resultVal.status,'Sucess message');
	Test.stopTest();
}
/**
   @Description test BE_NonClient_Ctr.validateNonCliente(), error 500
 */
@IsTest
static void validateNonClienteTestNoAvailableService() {
	insert new iaso__GBL_Rest_Services_Url__c(Name = GRANT_TICKET, iaso__Url__c = URL_GT, iaso__Cache_Partition__c = CACHE_PARTITION);
	insert new iaso__GBL_Rest_Services_Url__c(Name = 'ListNonClient', iaso__Url__c = 'https://ListNonClient/500', iaso__Cache_Partition__c = CACHE_PARTITION);
	Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
	iaso.GBL_Mock.setMock(new Integration_MockGenerator());
	Test.startTest();
	final Account acc=new Account(Name='TEST_NON_CLIENT_TEST_TWO',AccountNumber=RUC_ACC);
	final String res=BE_NonClient_Ctr.validateNonCliente(acc);
	final BE_NonClient_Ctr.ResultValidation resultVal= (BE_NonClient_Ctr.ResultValidation )JSON.deserialize(res,BE_NonClient_Ctr.ResultValidation.class);
	System.assertEquals('error',resultVal.status,'Error Non Avialable Service');
	Test.stopTest();
}

/**
   @Description test BE_NonClient_Ctr.validateNonCliente(), correct scenary
 */
@IsTest
static void validateNonClienteTestSucess() {
	insert new iaso__GBL_Rest_Services_Url__c(Name = GRANT_TICKET, iaso__Url__c = URL_GT, iaso__Cache_Partition__c = CACHE_PARTITION);
	insert new iaso__GBL_Rest_Services_Url__c(Name = 'CreateNonClient', iaso__Url__c = 'https://CreateNonClient/204/v1/non-businesses', iaso__Cache_Partition__c = CACHE_PARTITION);
	insert new iaso__GBL_Rest_Services_Url__c(Name = 'ListNonClient', iaso__Url__c = 'https://ListNonClient/400', iaso__Cache_Partition__c = CACHE_PARTITION);
	Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
	iaso.GBL_Mock.setMock(new Integration_MockGenerator());
	Test.startTest();
	final Account acc=new Account(Name='TEST_NON_CLIENT_TEST_THREE',AccountNumber=RUC_ACC,phone_area_code__c='02',other_phone_number__c='456783');
	final String res=BE_NonClient_Ctr.validateNonCliente(acc);
	final BE_NonClient_Ctr.ResultValidation resultVal= (BE_NonClient_Ctr.ResultValidation )JSON.deserialize(res,BE_NonClient_Ctr.ResultValidation.class);
	System.assertEquals('success',resultVal.status,'Success Non Client');
	Test.stopTest();
}
/**
   @Description test BE_NonClient_Ctr.checkConvertedClients(), correct scenary
 */
@IsTest
static void checkConvertedClientsTest() {
	Test.startTest();
	final String res=BE_NonClient_Ctr.checkConvertedClients(null,null);
	System.assertEquals('',res,'Empty Result');
	Test.stopTest();
}
}