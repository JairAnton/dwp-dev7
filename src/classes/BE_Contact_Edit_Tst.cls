/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_Contact_Edit_Tst>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date  2020-09-02
   @Description test for BE_Contact_Edit_Ctr class
   @Changes
   Date        Author   Email                  Type
   2020-09-02  LMBR     lolo.bravo@bbva.com    Creation
   -------------------------------------------------------------------------------------------------
 */
@IsTest
public with sharing class BE_Contact_Edit_Tst {
    /** Lang Code */
    private static final List<String> RECORD_TYPE = new List<String> {'Record_Type_Non_Client','Record_Type_Client'};
    /** GrantingTickets */
    private static final String GRANT_TICKET = 'GrantingTickets';
    /** GrantingTickets Value */
    private static final String GRANT_TICKETVAL = 'https://validation/ok';
    /** GrantingTickets */
    private static final String CACHE_PARTITION = 'iaso.ServicesPartition';
    /** GrantingTickets */
    static final List<String> SOBJTYPE_NAME=new List<String> {'Account'};
    /** ACC ONE */
    private static  Account accOne = new Account(Name='Client One',AccountNumber='20876543267',non_client_code__c='20876543267');
    /** ACC TWO */
    private static  Account accTwo = new Account(Name='Client Two',AccountNumber='20876543265',non_client_code__c='20876543265');
    /** CON ONE */
    private static  Contact conOne = new Contact(Salutation='Mr.',FirstName='NON_CLIENT',LastName='NON_CLIENTE_CONTACT_ONE',decision_making_desc__c='Si',Email='contactone@test.com',MobilePhone='924567896',prof_position_type__c='APODERADO', contact_code__c='00001',phone_1__c='9876545',phone_1_area_code__c='01',phone_2__c='2235675',phone_2_area_code__c='01');
    /**
    @Description test BE_EditNonClient_Ctr.getFields(), correct scenary
     */
    @IsTest
    static void updateRecordCreateTest() {
        final Map<String,Schema.RecordTypeInfo>recordType=BE_General_Utils.getRecordTypeInfo(SOBJTYPE_NAME);
        accOne.recordTypeId=recordType.get(RECORD_TYPE[0]).getRecordTypeId();
        accTwo.recordTypeId=recordType.get(RECORD_TYPE[1]).getRecordTypeId();
        final List<Account> accs=new List<Account> {accOne,accTwo};
        insert accs;
        final Contact contact=conOne;
        contact.AccountId=accs[1].Id;
        insert contact;
        final BE_Contact_Edit_Ctr conEdit=new BE_Contact_Edit_Ctr();
        insert new iaso__GBL_Rest_Services_Url__c(Name = GRANT_TICKET, iaso__Url__c = GRANT_TICKETVAL, iaso__Cache_Partition__c = CACHE_PARTITION);
	    insert new iaso__GBL_Rest_Services_Url__c(Name = 'CreateNonBusinessContact', iaso__Url__c = 'https://CreateNonBusinessContact/204', iaso__Cache_Partition__c = CACHE_PARTITION);
	    Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
        iaso.GBL_Mock.setMock(new Integration_MockGenerator());
        Test.startTest();
        contact.AccountId=accs[0].Id;
        final BE_CustomQuickActionCRUD_Cls.Response res= conEdit.updateRecord(contact);
        System.assert(!res.isSuccess, ' updateRecordCreate Success');
        Test.stopTest();
    }
    /**
    @Description test BE_EditNonClient_Ctr.getFields(), correct scenary
     */
    @IsTest
    static void updateRecordUpdateTest() {
        final Map<String,Schema.RecordTypeInfo>recordType=BE_General_Utils.getRecordTypeInfo(SOBJTYPE_NAME);
        accTwo.recordTypeId=recordType.get(RECORD_TYPE[0]).getRecordTypeId();
        final Account acc=accTwo;
        insert acc;
        final Contact contact=conOne;
        contact.AccountID=acc.Id;
        insert contact;
        final BE_Contact_Edit_Ctr conEdit=new BE_Contact_Edit_Ctr();
        insert new iaso__GBL_Rest_Services_Url__c(Name = GRANT_TICKET, iaso__Url__c = GRANT_TICKETVAL, iaso__Cache_Partition__c = CACHE_PARTITION);
	    insert new iaso__GBL_Rest_Services_Url__c(Name = 'ModifyNonBusinessContact', iaso__Url__c = 'https://ModifyNonBusinessContact/204', iaso__Cache_Partition__c = CACHE_PARTITION);
	    Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
	    iaso.GBL_Mock.setMock(new Integration_MockGenerator());
        Test.startTest();
        final BE_CustomQuickActionCRUD_Cls.Response res= conEdit.updateRecord(contact);
        System.assert(res.isSuccess, ' updateRecordUpdate Success');
        Test.stopTest();
    }
    /**
    @Description test BE_EditNonClient_Ctr.getFields(), correct scenary
     */
    @IsTest
    static void updateRecordDeleteCreateTest() {
	    final Map<String,Schema.RecordTypeInfo>recordType=BE_General_Utils.getRecordTypeInfo(SOBJTYPE_NAME);
        final List<Account> accs=new List<Account> {accTwo,accOne};
        accs[0].recordTypeId=recordType.get(RECORD_TYPE[0]).getRecordTypeId();
        accs[1].recordTypeId=recordType.get(RECORD_TYPE[0]).getRecordTypeId();
        accs[1].non_client_code__c='20876543265';
        insert accs;
        final List<Contact> contacts= new List<Contact> {conOne,new Contact(Salutation='Mr.',FirstName='DATA',LastName='CONTACT',decision_making_desc__c='Si',Email='contactone@test.com',MobilePhone='924567896',prof_position_type__c='APODERADO', contact_code__c='00001',phone_1__c='9876545',phone_1_area_code__c='01',phone_2__c='2235675',phone_2_area_code__c='01')};
        contacts[0].AccountId=accs[0].Id;
        contacts[1].AccountId=accs[1].Id;
        insert contacts;
        final BE_Contact_Edit_Ctr conEdit=new BE_Contact_Edit_Ctr();
        insert new iaso__GBL_Rest_Services_Url__c(Name = GRANT_TICKET, iaso__Url__c = GRANT_TICKETVAL, iaso__Cache_Partition__c = CACHE_PARTITION);
	    insert new iaso__GBL_Rest_Services_Url__c(Name = 'DeleteNonBusinessContact', iaso__Url__c = 'https://DeleteNonBusinessContact/204', iaso__Cache_Partition__c = CACHE_PARTITION);
	    Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
        iaso.GBL_Mock.setMock(new Integration_MockGenerator());
        insert new iaso__GBL_Rest_Services_Url__c(Name = GRANT_TICKET, iaso__Url__c = GRANT_TICKETVAL, iaso__Cache_Partition__c = CACHE_PARTITION);
	    insert new iaso__GBL_Rest_Services_Url__c(Name = 'CreateNonBusinessContact', iaso__Url__c = 'https://CreateNonBusinessContact/204', iaso__Cache_Partition__c = CACHE_PARTITION);
	    Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
        iaso.GBL_Mock.setMock(new Integration_MockGenerator());
        Test.startTest();
        contacts[0].AccountId=accs[1].Id;
        final BE_CustomQuickActionCRUD_Cls.Response res= conEdit.updateRecord(contacts[0]);
        System.assert(res.isSuccess, 'updateRecordDeleteCreate Success');
        Test.stopTest();
    }

        /**
    @Description test BE_EditNonClient_Ctr.getFields(), correct scenary
     */
    @IsTest
    static void updateRecordDeleteTest() {
	    final Map<String,Schema.RecordTypeInfo>recordType=BE_General_Utils.getRecordTypeInfo(SOBJTYPE_NAME);
        final List<Account> accs=new List<Account> {accOne,accTwo};
        accs[0].recordTypeId=recordType.get(RECORD_TYPE[1]).getRecordTypeId();
        accs[1].recordTypeId=recordType.get(RECORD_TYPE[0]).getRecordTypeId();
        insert accs;
        final Contact contact=conOne;
        contact.AccountID=accs[1].Id;
        insert contact;
        final BE_Contact_Edit_Ctr conEdit=new BE_Contact_Edit_Ctr();
        insert new iaso__GBL_Rest_Services_Url__c(Name = GRANT_TICKET, iaso__Url__c = GRANT_TICKETVAL, iaso__Cache_Partition__c = CACHE_PARTITION);
	    insert new iaso__GBL_Rest_Services_Url__c(Name = 'DeleteNonBusinessContact', iaso__Url__c = 'https://DeleteNonBusinessContact/204', iaso__Cache_Partition__c = CACHE_PARTITION);
	    Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
        iaso.GBL_Mock.setMock(new Integration_MockGenerator());
        Test.startTest();
        contact.AccountId=accs[0].Id;
        final BE_CustomQuickActionCRUD_Cls.Response res= conEdit.updateRecord(contact);
        System.assert(res.isSuccess, 'updateRecordDelete Success');
        Test.stopTest();
    }
}

