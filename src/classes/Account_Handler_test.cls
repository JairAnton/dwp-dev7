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
    
    @isTest
    static void afterInsertTest() {
        User UserOwnerTest01 = TestFactory.createUser('UserOwnerTest01', 'Ejecutivo');
        User UserOwnerTest02 = TestFactory.createUser('UserOwnerTest02', 'Ejecutivo');
        User UserAssitantTest011 = TestFactory.createUser('UserAssitantTest011', 'Ejecutivo');
        User UserAssitantTest012 = TestFactory.createUser('UserAssitantTest012', 'Ejecutivo');
        List<User_Assistant_Team__c> uat_insert = new List<User_Assistant_Team__c>();
        uat_insert.add(new User_Assistant_Team__c(user_id__c = UserOwnerTest01.Id, assistant_id__c = UserAssitantTest011.Id));
        uat_insert.add(new User_Assistant_Team__c(user_id__c = UserOwnerTest01.Id, assistant_id__c = UserAssitantTest012.Id));
        insert uat_insert;
        System.runAs(UserOwnerTest01) {
            Test.startTest();
				Account acc = new Account(Name = 'AccountTest');
            	insert acc;
            Test.stopTest();
        }
        System.assertEquals(2, [Select Id from User_Assistant_Team__c].size());
    }
    
    @isTest
    static void afterUpdateTest() {
        User UserOwnerTest01 = TestFactory.createUser('UserOwnerTest01', 'Ejecutivo');
        User UserOwnerTest02 = TestFactory.createUser('UserOwnerTest02', 'Ejecutivo');
        User UserAssitantTest011 = TestFactory.createUser('UserAssitantTest011', 'Ejecutivo');
        User UserAssitantTest012 = TestFactory.createUser('UserAssitantTest012', 'Ejecutivo');
        User UserAssitantTest013 = TestFactory.createUser('UserAssitantTest013', 'Ejecutivo');
        User UserAssitantTest021 = TestFactory.createUser('UserAssitantTest021', 'Ejecutivo');
        List<User_Assistant_Team__c> uat_insert = new List<User_Assistant_Team__c>();
        uat_insert.add(new User_Assistant_Team__c(user_id__c = UserOwnerTest01.Id, assistant_id__c = UserAssitantTest011.Id));
        uat_insert.add(new User_Assistant_Team__c(user_id__c = UserOwnerTest01.Id, assistant_id__c = UserAssitantTest012.Id));
        uat_insert.add(new User_Assistant_Team__c(user_id__c = UserOwnerTest02.Id, assistant_id__c = UserAssitantTest013.Id));
        insert uat_insert;
        
        System.runAs(UserOwnerTest01) {
            Test.startTest();
            	Account acc = new Account(Name = 'AccountTest');
            	insert acc;
            	acc.OwnerId = UserOwnerTest02.Id;
            	update acc;
            Test.stopTest();
        }
        System.assertEquals(3, [Select Id from User_Assistant_Team__c].size());
    }
}