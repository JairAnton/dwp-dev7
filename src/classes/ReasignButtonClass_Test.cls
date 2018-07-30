@istest
public class ReasignButtonClass_Test {
    static User user;
    static Case casetest;
    @testSetup
    static void setData() {
        user=TestFactory.createUser('reasignuser', Label.lblAnalistaProf);
        casetest=TestFactory.createCase(user.Id);
    }
    @isTest
    static void testreasign(){
        setData();

        Test.startTest();
        ReasignButtonClass.start(casetest.Id);
        ReasignButtonClass.fetchUser('test', casetest.Id);
        ReasignButtonClass.reasignown(casetest.Id, user);
        ReasignButtonClass.reasignown(user.Id, user);
        Test.stopTest();

        List <User> lstuser= new List <User>();
        System.assertEquals(null, ReasignButtonClass.start(casetest.Id));
        System.assertEquals(lstuser, ReasignButtonClass.fetchUser('test', casetest.Id));
        System.assertEquals('Updated', ReasignButtonClass.reasignown(casetest.Id, user));
    }

}