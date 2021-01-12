/**
   -------------------------------------------------------------------------------------------------
   @Name BE_NotUIAPIForm_Tst
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2021-01-08
   @Description
   @Changes
   Date        Author   Email                  				Type
   2021-01-08  MAMCH    martin.mori.contractor@bbva.com    	Creation
   -------------------------------------------------------------------------------------------------
 */
@isTest
public class BE_NotUIAPIForm_Tst {
    /*
	 * @Description method test getStatusMeeting error
	 */
    @isTest
    static void findLookupRecordsTest() {
        final Id rTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Record_Type_Non_Client').getRecordTypeId();
        final Account accOne= new Account(Name='NON_CLIENT_CONTACT_2020_001',AccountNumber='20876543267',non_client_code__c='20876543267',recordTypeId=rTypeId);
        insert accOne;
        final Contact con= new Contact(AccountId=accOne.Id,Salutation='Mr.',FirstName='NON_CLIENT',LastName='NON_CLIENTE_CONTACT_ONE',decision_making_desc__c='Si',Email='contactone@test.com',MobilePhone='924567896',prof_position_type__c='APODERADO', contact_code__c='00001',phone_1__c='9876545',phone_1_area_code__c='01',phone_2__c='2235675',phone_2_area_code__c='01');
        insert con;
        Test.startTest();
        BE_NotUIAPIForm_Ctr.findLookupRecords(null, 'Contact');
        BE_NotUIAPIForm_Ctr.findLookupRecords('NON_CLIENTE_CONTACT_ONE', 'Contact');
        final List<sObject> objs = BE_NotUIAPIForm_Ctr.findLookupRecords('NON_CLIENTE_CONTACT_ONE', 'Contact');
        Test.stopTest();
        System.assert(!objs.isEmpty(), 'success!!!');
    }
    
    /*
	 * @Description method test getStatusMeeting error
	 */
    @isTest
    static void lookUpByIdTest() {
        final Account acc = new Account(Name='Test');
        insert acc;
        Test.startTest();
        Final Account obj = (Account)BE_NotUIAPIForm_Ctr.lookUpById(acc.Id, 'Account', 'Name');
        Test.stopTest();
        System.assert(String.isNotBlank(obj.Name), 'success!!!');
    }
    
    /*
	 * @Description method test getStatusMeeting error
	 */
    @isTest
    static void findRelatedToLookupTest() {
        final Account acc = new Account(Name='Test');
        insert acc;
        Test.startTest();
        Final List<List<SObject>> objs = BE_NotUIAPIForm_Ctr.findRelatedToLookup('Test', 'Account');
        Test.stopTest();
        System.assert(!objs.isEmpty(), 'success!!!');
    }
}