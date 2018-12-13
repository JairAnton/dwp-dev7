@IsTest(SeeAllData=true)
public class ReasignButtonClass_Test {
    static User user;
    static Case casetest;
    @isTest
    static void setData() {
        user=TestFactory.createUser('reasignuser', Label.lblAnalistaProf);
        casetest=TestFactory.createCase(user.Id);
        Account acc = TestFactory.createAccount();
        Opportunity opp = TestFactory.createOpportunity(acc.Id, UserInfo.getUserId());
        Product2 prod = TestFactory.createProduct();
        OpportunityLineItem oli = TestFactory.createOLI(opp.Id, prod.Id);
        System.assertNotEquals(null, oli);// yulino 12/12/2018 :Se agrego Assets
    }
    @isTest
    static void testreasign(){
        setData();
        
        Test.startTest();
        ReasignButtonClass.start(casetest.Id);
        ReasignButtonClass.fetchUser('test', casetest.Id);
        ReasignButtonClass.reasignown(casetest.Id, user);
        Test.stopTest();
        System.assertNotEquals(null, user);
    }
    
}