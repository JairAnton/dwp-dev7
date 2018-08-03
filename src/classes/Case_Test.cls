@isTest(SeeAllData=true)
public class Case_Test {
    static User usertest;
    @isTest
    static void setData(){     
        usertest = TestFactory.createUser('caseTest', Label.profAdministrator);
    }
    @isTest
    static void AfterInsertUpdate(){
        setData();
        Test.startTest();
        Case casetest = new Case();
        casetest.Status = 'New';
        casetest.OwnerId = UserInfo.getUserId();
        insert casetest;
        casetest.OwnerId = usertest.Id;
        update casetest;
        Test.stopTest();
        System.assertEquals('New', casetest.Status);
    }
    
    
}