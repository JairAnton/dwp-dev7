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
    /**
    @Description test BE_EditNonClient_Ctr.getFields(), correct scenary
     */
    @IsTest
    static void updateRecordCreateTest() {
        final List<String>sObjNames=new List<String> {'Account'};
	    final Map<String,Schema.RecordTypeInfo>recordType=BE_General_Utils.getRecordTypeInfo(sObjNames);
        List<Account> accs=new List<Account> {
            new Account(Name='Client',AccountNumber='20876543267',non_client_code__c='20876543267',recordTypeId=recordType.get(RECORD_TYPE[0]).getRecordTypeId()),
            new Account(Name='NoClient',AccountNumber='20876543265',non_client_code__c='20876543265',recordTypeId=recordType.get(RECORD_TYPE[1]).getRecordTypeId())
        };
        insert accs;
        List<Contact> contacts= new List<Contact> {
            new Contact(AccountId=accs[1].Id,Salutation='Mr.',FirstName='NON_CLIENT',LastName='NON_CLIENTE_CONTACT_ONE',decision_making_desc__c='Si',Email='contactone@test.com',MobilePhone='924567896',prof_position_type__c='APODERADO', contact_code__c='00001',phone_1__c='9876545',phone_1_area_code__c='01',phone_2__c='2235675',phone_2_area_code__c='01')
        };
        insert contacts;
        BE_Contact_Edit_Ctr conEdit=new BE_Contact_Edit_Ctr();
        insert new iaso__GBL_Rest_Services_Url__c(Name = GRANT_TICKET, iaso__Url__c = GRANT_TICKETVAL, iaso__Cache_Partition__c = CACHE_PARTITION);
	    insert new iaso__GBL_Rest_Services_Url__c(Name = 'CreateNonBusinessContact', iaso__Url__c = 'https://CreateNonBusinessContact/204', iaso__Cache_Partition__c = CACHE_PARTITION);
	    Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
        iaso.GBL_Mock.setMock(new Integration_MockGenerator());
        Test.startTest();
        contacts[0].AccountId=accs[0].Id;
        conEdit.updateRecord(contacts[0]);
        Test.stopTest();
    }
    /**
    @Description test BE_EditNonClient_Ctr.getFields(), correct scenary
     */
    @IsTest
    static void updateRecordUpdateTest() {
        final List<String>sObjNames=new List<String> {'Account'};
	    final Map<String,Schema.RecordTypeInfo>recordType=BE_General_Utils.getRecordTypeInfo(sObjNames);
        final Account acc=new Account(Name='Client',AccountNumber='20876543267',non_client_code__c='20876543267',recordTypeId=recordType.get(RECORD_TYPE[0]).getRecordTypeId());
        insert acc;
        final Contact contact= new Contact(AccountId=acc.Id,Salutation='Mr.',FirstName='NON_CLIENT',LastName='NON_CLIENTE_CONTACT_ONE',decision_making_desc__c='Si',Email='contactone@test.com',MobilePhone='924567896',prof_position_type__c='APODERADO', contact_code__c='00001',phone_1__c='9876545',phone_1_area_code__c='01',phone_2__c='2235675',phone_2_area_code__c='01');
        insert contact;
        final BE_Contact_Edit_Ctr conEdit=new BE_Contact_Edit_Ctr();
        insert new iaso__GBL_Rest_Services_Url__c(Name = GRANT_TICKET, iaso__Url__c = GRANT_TICKETVAL, iaso__Cache_Partition__c = CACHE_PARTITION);
	    insert new iaso__GBL_Rest_Services_Url__c(Name = 'ModifyNonBusinessContact', iaso__Url__c = 'https://ModifyNonBusinessContact/204', iaso__Cache_Partition__c = CACHE_PARTITION);
	    Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
	    iaso.GBL_Mock.setMock(new Integration_MockGenerator());
        Test.startTest();
        conEdit.updateRecord(contact);
        Test.stopTest();
    }
    /**
    @Description test BE_EditNonClient_Ctr.getFields(), correct scenary
     */
    @IsTest
    static void updateRecordDeleteCreateTest() {
        final List<String>sObjNames=new List<String> {'Account'};
	    final Map<String,Schema.RecordTypeInfo>recordType=BE_General_Utils.getRecordTypeInfo(sObjNames);
        List<Account> accs=new List<Account> {
            new Account(Name='NoClient',AccountNumber='20876543265',non_client_code__c='20876543265',recordTypeId=recordType.get(RECORD_TYPE[0]).getRecordTypeId()),
            new Account(Name='NoClient',AccountNumber='20876543265',non_client_code__c='20876543265',recordTypeId=recordType.get(RECORD_TYPE[0]).getRecordTypeId())
        };
        insert accs;
        List<Contact> contacts= new List<Contact> {
            new Contact(AccountId=accs[0].Id,Salutation='Mr.',FirstName='NON_CLIENT',LastName='NON_CLIENTE_CONTACT_ONE',decision_making_desc__c='Si',Email='contactone@test.com',MobilePhone='924567896',prof_position_type__c='APODERADO', contact_code__c='00001',phone_1__c='9876545',phone_1_area_code__c='01',phone_2__c='2235675',phone_2_area_code__c='01'),
            new Contact(AccountId=accs[1].Id,Salutation='Mr.',FirstName='NON_CLIENT',LastName='NON_CLIENTE_CONTACT_ONE',decision_making_desc__c='Si',Email='contactone@test.com',MobilePhone='924567896',prof_position_type__c='APODERADO', contact_code__c='00001',phone_1__c='9876545',phone_1_area_code__c='01',phone_2__c='2235675',phone_2_area_code__c='01')
        };
        insert contacts;
        BE_Contact_Edit_Ctr conEdit=new BE_Contact_Edit_Ctr();
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
        conEdit.updateRecord(contacts[0]);
        Test.stopTest();
    }

        /**
    @Description test BE_EditNonClient_Ctr.getFields(), correct scenary
     */
    @IsTest
    static void updateRecordDeleteTest() {
        final List<String>sObjNames=new List<String> {'Account'};
	    final Map<String,Schema.RecordTypeInfo>recordType=BE_General_Utils.getRecordTypeInfo(sObjNames);
        List<Account> accs=new List<Account> {
            new Account(Name='NoClient',AccountNumber='20876543267',non_client_code__c='20876543267',recordTypeId=recordType.get(RECORD_TYPE[1]).getRecordTypeId()),
            new Account(Name='NoClient',AccountNumber='20876543265',non_client_code__c='20876543265',recordTypeId=recordType.get(RECORD_TYPE[0]).getRecordTypeId())
        };
        insert accs;
        Contact contact= new Contact(AccountId=accs[1].Id,Salutation='Mr.',FirstName='NON_CLIENT',LastName='NON_CLIENTE_CONTACT_ONE',decision_making_desc__c='Si',Email='contactone@test.com',MobilePhone='924567896',prof_position_type__c='APODERADO', contact_code__c='00001',phone_1__c='9876545',phone_1_area_code__c='01',phone_2__c='2235675',phone_2_area_code__c='01');
        insert contact;
        BE_Contact_Edit_Ctr conEdit=new BE_Contact_Edit_Ctr();
        insert new iaso__GBL_Rest_Services_Url__c(Name = GRANT_TICKET, iaso__Url__c = GRANT_TICKETVAL, iaso__Cache_Partition__c = CACHE_PARTITION);
	    insert new iaso__GBL_Rest_Services_Url__c(Name = 'DeleteNonBusinessContact', iaso__Url__c = 'https://DeleteNonBusinessContact/204', iaso__Cache_Partition__c = CACHE_PARTITION);
	    Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
        iaso.GBL_Mock.setMock(new Integration_MockGenerator());
        Test.startTest();
        contact.AccountId=accs[0].Id;
        conEdit.updateRecord(contact);
        Test.stopTest();
    }
}