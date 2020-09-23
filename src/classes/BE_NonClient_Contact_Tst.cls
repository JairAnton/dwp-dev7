/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_NonClientContact_Tst>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2020-03-03
   @Description test for BE_NonClientContact_Tst class
   @Changes
   Date        Author   Email                  Type
   2020-03-03  LMBR     lolo.bravo@bbva.com    Creation
   -------------------------------------------------------------------------------------------------
 */
@isTest
public without sharing class BE_NonClient_Contact_Tst {
/** GrantingTickets */
private static final String GRANT_TICKET = 'GrantingTickets';
/** GrantingTickets Value */
private static final String GRANT_TICKETVAL = 'https://validation/ok';
/** GrantingTickets */
private static final String CACHE_PARTITION = 'local.CredentialsPeru';
/** GrantingTickets */
private static final String CONTACT_CODE = '00001';
/** GrantingTickets */
private static final String RECORD_TYPE = 'Record_Type_Non_Client';
/** Make Data */
@TestSetup
static void makeData() {
	final Id rTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(RECORD_TYPE).getRecordTypeId();
	final Account accOne= new Account(Name='NON_CLIENT_CONTACT_2020_001',AccountNumber='20876543267',non_client_code__c='20876543267',recordTypeId=rTypeId);
	final Account accTwo= new Account(Name='NON_CLIENT_CONTACT_2020_002',AccountNumber='20876543265',non_client_code__c='20876543265',recordTypeId=rTypeId);
	insert accOne;
	final Contact con= new Contact(AccountId=accOne.Id,Salutation='Mr.',FirstName='NON_CLIENT',LastName='NON_CLIENTE_CONTACT_ONE',decision_making_desc__c='Si',Email='contactone@test.com',MobilePhone='924567896',prof_position_type__c='APODERADO', contact_code__c='00001',phone_1__c='9876545',phone_1_area_code__c='01',phone_2__c='2235675',phone_2_area_code__c='01');
	insert accTwo;
	insert con;
}
/**
   @Description test BE_NonClient_Ctr.checkDuplicateNonClients(), correct scenary
 */
@IsTest
static void  createRecordsTestSuccess() {
	final Account acc=[SELECT Id,Name FROM Account WHERE AccountNumber='20876543265' LIMIT 1];
	final Contact con=[SELECT Id,LastName,MobilePhone,Email,prof_position_type__c FROM Contact WHERE LastName='NON_CLIENTE_CONTACT_ONE' LIMIT 1];
	insert new iaso__GBL_Rest_Services_Url__c(Name = GRANT_TICKET, iaso__Url__c = GRANT_TICKETVAL, iaso__Cache_Partition__c = CACHE_PARTITION);
	insert new iaso__GBL_Rest_Services_Url__c(Name = 'CreateNonBusinessContact', iaso__Url__c = 'https://CreateNonBusinessContact/204', iaso__Cache_Partition__c = CACHE_PARTITION);
	Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
	iaso.GBL_Mock.setMock(new Integration_MockGenerator());
	Test.startTest();
	final List<AccountContactRelation>accConList=new List<AccountContactRelation> {new AccountContactRelation(AccountId=acc.Id, ContactId=con.Id,prof_position_type__c=con.prof_position_type__c,decision_making_desc__c='Si',MobilePhone__c=con.MobilePhone,email__c=con.Email)};
	final BE_NonClient_Contact_Ctr nonClientCon=new BE_NonClient_Contact_Ctr();
	final BE_SingleRelatedListCRUD_Cls.Response res = nonClientCon.createRecords(accConList);
	System.assert (res.isSuccess, 'Create contact successfull');
	Test.stopTest();
}
/**
   @Description test BE_NonClient_Ctr.checkDuplicateNonClients(), correct scenary
 */
@IsTest
static void  createRecordsTestError() {
	final Account acc=[SELECT Id,Name FROM Account WHERE AccountNumber='20876543265' LIMIT 1];
	final Contact con=[SELECT Id,LastName,MobilePhone,Email,prof_position_type__c FROM Contact WHERE LastName='NON_CLIENTE_CONTACT_ONE' LIMIT 1];
	insert new iaso__GBL_Rest_Services_Url__c(Name = GRANT_TICKET, iaso__Url__c = GRANT_TICKETVAL, iaso__Cache_Partition__c = CACHE_PARTITION);
	insert new iaso__GBL_Rest_Services_Url__c(Name = 'CreateNonBusinessContact', iaso__Url__c = 'https://CreateNonBusinessContact/500', iaso__Cache_Partition__c = CACHE_PARTITION);
	Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
	iaso.GBL_Mock.setMock(new Integration_MockGenerator());
	Test.startTest();
	final List<AccountContactRelation>accConList=new List<AccountContactRelation> {new AccountContactRelation(AccountId=acc.Id, ContactId=con.Id,prof_position_type__c=con.prof_position_type__c,decision_making_desc__c='Si',MobilePhone__c=con.MobilePhone,email__c=con.Email)};
	final BE_NonClient_Contact_Ctr nonClientCon=new BE_NonClient_Contact_Ctr();
	final BE_SingleRelatedListCRUD_Cls.Response res=nonClientCon.createRecords(accConList);
	System.assert (!res.isSuccess, 'Error create contact');
	Test.stopTest();
}
/**
   @Description test BE_NonClient_Ctr.checkDuplicateNonClients(), correct scenary
 */
@IsTest
static void  createRecordsTestException() {
	final Account acc=[SELECT Id,Name FROM Account WHERE AccountNumber='20876543265' LIMIT 1];
	final Contact con=[SELECT Id,LastName,MobilePhone,Email,prof_position_type__c FROM Contact WHERE LastName='NON_CLIENTE_CONTACT_ONE' LIMIT 1];
	insert new iaso__GBL_Rest_Services_Url__c(Name = GRANT_TICKET, iaso__Url__c = GRANT_TICKETVAL, iaso__Cache_Partition__c = CACHE_PARTITION);
	insert new iaso__GBL_Rest_Services_Url__c(Name = 'CreateNonBusinessContact', iaso__Url__c = 'https://CreateNonBusinessContact/204', iaso__Cache_Partition__c = CACHE_PARTITION);
	Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
	iaso.GBL_Mock.setMock(new Integration_MockGenerator());
	Test.startTest();
	final List<AccountContactRelation>accConList=new List<AccountContactRelation> {new AccountContactRelation(AccountId=acc.Id, ContactId=con.Id,prof_position_type__c=con.prof_position_type__c,decision_making_desc__c='Sii',MobilePhone__c=con.MobilePhone,email__c=con.Email)};
	final BE_NonClient_Contact_Ctr nonClientCon=new BE_NonClient_Contact_Ctr();
	final BE_SingleRelatedListCRUD_Cls.Response res=nonClientCon.createRecords(accConList);
	System.assert (!res.isSuccess, 'Exception create contact');
	Test.stopTest();
}
/**
   @Description test BE_NonClient_Ctr.checkDuplicateNonClients(), correct scenary
 */
@IsTest
static void  updateRecordsTestSuccess() {
	final Account acc=[SELECT Id,Name FROM Account WHERE AccountNumber='20876543265' LIMIT 1];
	final Contact con=[SELECT Id,LastName,MobilePhone,Email,prof_position_type__c FROM Contact WHERE LastName='NON_CLIENTE_CONTACT_ONE' LIMIT 1];
	final List<AccountContactRelation>accConList=new List<AccountContactRelation> {new AccountContactRelation(AccountId=acc.Id, ContactId=con.Id,prof_position_type__c=con.prof_position_type__c,decision_making_desc__c='No',MobilePhone__c=con.MobilePhone,email__c=con.Email,contact_code__c=CONTACT_CODE)};
	insert accConList;
	insert new iaso__GBL_Rest_Services_Url__c(Name = GRANT_TICKET, iaso__Url__c = GRANT_TICKETVAL, iaso__Cache_Partition__c = CACHE_PARTITION);
	insert new iaso__GBL_Rest_Services_Url__c(Name = 'ModifyNonBusinessContact', iaso__Url__c = 'https://ModifyNonBusinessContact/204', iaso__Cache_Partition__c = CACHE_PARTITION);
	Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
	iaso.GBL_Mock.setMock(new Integration_MockGenerator());
	Test.startTest();
	final BE_NonClient_Contact_Ctr nonClientCon=new BE_NonClient_Contact_Ctr();
	final BE_SingleRelatedListCRUD_Cls.Response res=nonClientCon.updateRecords(accConList);
	System.assert (res.isSuccess, 'Modify contact successfull');
	Test.stopTest();
}
}