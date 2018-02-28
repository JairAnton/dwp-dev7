@isTest
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
        Test.stopTest();
    }
}