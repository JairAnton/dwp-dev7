/**
 * Test class for AccountContact_Handler class.
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------------
 * Alberto Gómez                27/02/2018          Original version.<p />
 *
 * @author Alberto Gómez
 */
@isTest(SeeAllData=false)
public class AccountContact_Handler_TEST {

    //Setup data.
    @testSetup
    static void setupData() {

        //Create Accounts.
        List<Account> lstAccounts = new List<Account>();
        for(Integer intI = 0; intI < 2; intI++) {
            lstAccounts.add(new Account(Name = 'AccountName'+ intI));
        }
        insert lstAccounts;
    }

    //Positive method.
    @isTest
    static void positiveMethod() {

        //Start test.
        Test.startTest();
        List<Account> lstAccounts = [SELECT Id, Name FROM Account];
        List<Contact> lstContacts = new List<Contact>();
        Integer intJ = 0;
        for(Account objAccount : lstAccounts) {
            lstContacts.add(
                new Contact(
                    FirstName = 'FirstName' + intJ,
                    LastName = 'LastName' + intJ,
                    Salutation = 'Mr.',
                    decision_making_desc__c = 'Si',
                    AccountId = objAccount.Id
                )
            );
            intJ++;
        }
        insert lstContacts;

        //Stop test.
        Test.stopTest();
    }
}