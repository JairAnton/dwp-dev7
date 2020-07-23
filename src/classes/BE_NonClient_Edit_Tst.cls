/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_NonClient_Edit_Tst>
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-03-13
   @Description test for BE_EditNonClient_Ctr class
   @Changes
   Date        Author   Email                  				Type
   2020-03-13  MAMC     martin.mori.contractor@bbva.com    	Creation
   -------------------------------------------------------------------------------------------------
 */
@IsTest
public without sharing class BE_NonClient_Edit_Tst {
/** GrantingTickets */
private static final String GRANT_TICKET = 'GrantingTickets';
/** GrantingTickets */
private static final String CACHE_PARTITION = 'local.CredentialsPeru';
/** GrantingTickets */
private static final String API_NAME = 'ModifyNonClient';
/** GrantingTickets */
private static final String RECORD_TYPE = 'Record_Type_Non_Client';
/** GrantingTickets */
private static final String URL_GT = 'https://validation/ok';
/** sObjNames */
private static final List<String>SOBJNAME =new List<String> {'Account'};
/** sObjNames */
private static final String NOCLIENT_CODE='P0234234234';
/** RUC */
private static final String RUC='20000000002';
/**
   @Description test BE_EditNonClient_Ctr.getFields(), correct scenary
 */
@IsTest
static void getFieldsTest() {
	BE_NonClient_Edit_Ctr.getFields('BE_EditNonClient');
	final BE_SingleRelatedList_QuickAction__mdt configMeta=(BE_SingleRelatedList_QuickAction__mdt) JSON.deserialize('{"DeveloperName":"TESTMETADATA_TST","MasterLabel":"Phone"}',BE_SingleRelatedList_QuickAction__mdt.class);
	System.assertEquals('TESTMETADATA_TST',configMeta.DeveloperName,'Good');
}
/**
   @Description test BE_EditNonClient_Ctr.updateNonClient(),correct scenary
 */
@IsTest
static void updateNonClientTestSucess() {
	final Map<String,Schema.RecordTypeInfo>recordType=BE_General_Utils.getRecordTypeInfo(SOBJNAME);
	final Account nonClient=new Account(Name='NO CLIENT TEST ONE',AccountNumber=RUC,recordTypeId=recordType.get(RECORD_TYPE).getRecordTypeId(),non_client_code__c=NOCLIENT_CODE);
	insert nonClient;
	insert new iaso__GBL_Rest_Services_Url__c(Name = GRANT_TICKET, iaso__Url__c = URL_GT, iaso__Cache_Partition__c = CACHE_PARTITION);
	insert new iaso__GBL_Rest_Services_Url__c(Name = API_NAME, iaso__Url__c = 'https://ModifyNonClient/204', iaso__Cache_Partition__c = CACHE_PARTITION);
	Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
	iaso.GBL_Mock.setMock(new Integration_MockGenerator());
	Test.startTest();
	final String json = '{"sobejctType":"Account","id":"'+nonClient.Id+'","Name":"NON CLIENT TEST 2","AccountNumber":"10212210244","email__c":"test@gmail.com","Website":"www.test.com","phone_area_code__c":"41","other_phone_number__c":"987654"}';
	final BE_SingleRelatedListCRUD_Cls.Response res=(BE_SingleRelatedListCRUD_Cls.Response)BE_NonClient_Edit_Ctr.updateNonClient(json);
	System.assert (res.isSuccess,'Success Edit Non Client');
	Test.stopTest();
}
@IsTest
static void updateNonClientTestServerError() {
	final Map<String,Schema.RecordTypeInfo>recordType=BE_General_Utils.getRecordTypeInfo(SOBJNAME);
	final Account nonClient=new Account(Name='NO CLIENT TEST TWO',AccountNumber=RUC,recordTypeId=recordType.get(RECORD_TYPE).getRecordTypeId(),non_client_code__c=NOCLIENT_CODE);
	insert nonClient;
	insert new iaso__GBL_Rest_Services_Url__c(Name = GRANT_TICKET, iaso__Url__c = URL_GT, iaso__Cache_Partition__c = CACHE_PARTITION);
	insert new iaso__GBL_Rest_Services_Url__c(Name = API_NAME, iaso__Url__c = 'https://ModifyNonClient/500', iaso__Cache_Partition__c = CACHE_PARTITION);
	Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
	iaso.GBL_Mock.setMock(new Integration_MockGenerator());
	Test.startTest();
	final String json = '{"sobejctType":"Account","id":"'+nonClient.Id+'","Name":"NON CLIENT TEST 2","AccountNumber":"10212210244"}';
	final BE_SingleRelatedListCRUD_Cls.Response res=(BE_SingleRelatedListCRUD_Cls.Response)BE_NonClient_Edit_Ctr.updateNonClient(json);
	System.assert (!res.isSuccess,'Server error Edit Non Client');
	Test.stopTest();
}
@IsTest
static void updateNonClientTestError() {
	final Map<String,Schema.RecordTypeInfo>recordType=BE_General_Utils.getRecordTypeInfo(SOBJNAME);
	final Account nonClient=new Account(Name='NO CLIENT TEST THREE',AccountNumber=RUC,recordTypeId=recordType.get(RECORD_TYPE).getRecordTypeId(),non_client_code__c=NOCLIENT_CODE);
	insert nonClient;
	insert new iaso__GBL_Rest_Services_Url__c(Name = GRANT_TICKET, iaso__Url__c = URL_GT, iaso__Cache_Partition__c = CACHE_PARTITION);
	insert new iaso__GBL_Rest_Services_Url__c(Name = API_NAME, iaso__Url__c = 'https://ModifyNonClient/400', iaso__Cache_Partition__c = CACHE_PARTITION);
	Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
	iaso.GBL_Mock.setMock(new Integration_MockGenerator());
	Test.startTest();
	final String json = '{"sobejctType":"Account","id":"'+nonClient.Id+'","Name":"NON CLIENT TEST 2","AccountNumber":"10212210244"}';
	final BE_SingleRelatedListCRUD_Cls.Response res=(BE_SingleRelatedListCRUD_Cls.Response)BE_NonClient_Edit_Ctr.updateNonClient(json);
	System.assert (!res.isSuccess,'Error Edit Non Client');
	Test.stopTest();
}
/**
   @Description test BE_EditNonClient_Ctr.updateNonClient(),correct scenary
 */
@IsTest
static void updateNonClientTestException() {
	final Map<String,Schema.RecordTypeInfo>recordType=BE_General_Utils.getRecordTypeInfo(SOBJNAME);
	final Account nonClient=new Account(Name='NO CLIENT TEST FOUR',AccountNumber=RUC,recordTypeId=recordType.get(RECORD_TYPE).getRecordTypeId(),non_client_code__c=NOCLIENT_CODE);
	insert nonClient;
	insert new iaso__GBL_Rest_Services_Url__c(Name = GRANT_TICKET, iaso__Url__c = URL_GT, iaso__Cache_Partition__c = CACHE_PARTITION);
	insert new iaso__GBL_Rest_Services_Url__c(Name = API_NAME, iaso__Url__c = 'https://ModifyNonClient/204', iaso__Cache_Partition__c = CACHE_PARTITION);
	Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
	iaso.GBL_Mock.setMock(new Integration_MockGenerator());
	Test.startTest();
	final String json = '{"sobejctType":"Account","id":"'+nonClient.Id+'","Name":"NON CLIENT TEST 2","AccountNumber":"10212210244","email__c":"test@gmail.com","Website":"www.test.com","phone_area_code__c":"00","other_phone_number__c":"987654"}';
	final BE_SingleRelatedListCRUD_Cls.Response res=(BE_SingleRelatedListCRUD_Cls.Response)BE_NonClient_Edit_Ctr.updateNonClient(json);
	System.assert (!res.isSuccess,'Exception Non Client');
	Test.stopTest();
}
/**
   @Description test BE_EditNonClient_Ctr.updateNonClient(),correct scenary
 */
@IsTest
static void updateNonClientAlphaTestError() {
	final Map<String,Schema.RecordTypeInfo>recordType=BE_General_Utils.getRecordTypeInfo(SOBJNAME);
	final Account nonClient=new Account(Name='NO CLIENT TEST FIVE',AccountNumber=RUC,recordTypeId=recordType.get(RECORD_TYPE).getRecordTypeId(),non_client_code__c='EXISTENOCLIENTE');
	insert nonClient;
	insert new iaso__GBL_Rest_Services_Url__c(Name = GRANT_TICKET, iaso__Url__c = URL_GT, iaso__Cache_Partition__c = CACHE_PARTITION);
	insert new iaso__GBL_Rest_Services_Url__c(Name = API_NAME, iaso__Url__c = 'https://ModifyNonClient/204', iaso__Cache_Partition__c = CACHE_PARTITION);
	Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
	iaso.GBL_Mock.setMock(new Integration_MockGenerator());
	Test.startTest();
	final String json = '{"sobejctType":"Account","id":"'+nonClient.Id+'","Name":"NON CLIENT TEST 2","AccountNumber":"10212210244","email__c":"test@gmail.com","Website":"www.test.com","phone_area_code__c":"00","other_phone_number__c":"987654"}';
	final BE_SingleRelatedListCRUD_Cls.Response res=(BE_SingleRelatedListCRUD_Cls.Response)BE_NonClient_Edit_Ctr.updateNonClient(json);
	System.assert (!res.isSuccess,'Exception');
	Test.stopTest();
}
/**
   @Description test BE_EditNonClient_Ctr.updateNonClient(),correct scenary
 */
@IsTest
static void getNonClientTest() {
	final Map<String,Schema.RecordTypeInfo>recordType=BE_General_Utils.getRecordTypeInfo(SOBJNAME);
	final Account nonClient=new Account(Name='NO CLIENT TEST SIX',AccountNumber=RUC,recordTypeId=recordType.get(RECORD_TYPE).getRecordTypeId());
	insert nonClient;
	final List<String>fields = new List<String> {'Name','AccountNumber'};
	final Account nonClientRes=BE_NonClient_Edit_Ctr.getNonClient(nonClient.Id,fields);
	System.assertEquals(nonClient.Id, nonClientRes.Id,'Successs Account');
}
}