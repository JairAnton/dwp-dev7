/**
 * Test class for AccountContact_Handler class.
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------------
 * Isaías Velázquez            09/07/2018          Original version.<p />
 *
 * @author Isaías Velázquez
 */
@isTest(SeeAllData=false)
public class Account_Handler_test {

    //Setup data.
    @testSetup
    static void setupData() {

    	//Create Branches.
        List<Branch__c> lstBranches = new List<Branch__c>();
        for(Integer intI = 0; intI < 2; intI++) {
            lstBranches.add(new Branch__c(Name = 'BranchName'+ intI));
        }
        insert lstBranches;
        //Create Accounts.
        List<Account> lstAccounts = new List<Account>();
        for(Integer intI = 0; intI < 2; intI++) {
            lstAccounts.add(new Account(Name = 'AccountName'+ intI,Branch_id__c= lstBranches[1-intI].Id));
        }
        insert lstAccounts;


    }

    //Positive method.
    @isTest
    static void positiveMethod() {

        //Start test.
        Test.startTest();
        List<Account> lstAccounts = [SELECT Id, Name FROM Account];
        List<Branch__c> lstBranches = [SELECT Id, Name FROM Branch__c];
        Integer i = 0;
        for(Account objAccount : lstAccounts) {
           objAccount.branch_id__c=lstBranches[i].Id;
           i++;
        }
        update lstAccounts;
        
        //Stop test.
        Test.stopTest();
    }
}