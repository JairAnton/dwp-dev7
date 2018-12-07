@isTest
public class Case_Test {
    static User usertest;
    @testSetup //Yulino 07/12/2018 : se cambio a testSetup
    static void setData(){     
        usertest = TestFactory.createUser('caseTest', Label.profAdministrator);
    }
    @isTest
    static void AfterInsertUpdate(){
        //setData(); //Yulino 07/12/2018 : se cambio a testSetup
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