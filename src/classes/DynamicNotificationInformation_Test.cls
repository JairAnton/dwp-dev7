@IsTest(SeeAllData=true)
public class DynamicNotificationInformation_Test {
    static User usertest;
    static Case casetest;
    static Opportunity opptest;
    static Account acctest;
    @isTest
    static void setData(){
        usertest = TestFactory.createUser('usernameTestNotif', Label.profAdministrator);
        casetest = TestFactory.createCase(usertest.Id);
        acctest = TestFactory.createAccount();
        opptest = TestFactory.createOpportunity(acctest.Id, usertest.Id);
    }
    @isTest
    static void  dynamicNotif(){
       setData();
        Test.startTest();
        List<String> lstcase =new List<String>();
        lstcase.add(String.valueOf(casetest.Id));
        List<String> lstopp =new List<String>();
        lstopp.add(String.valueOf(opptest.Id));
        DynamicNotificationInformation.getDynamicNotificationInformation(lstcase, 'Case', 'CREATE_CASE');
        DynamicNotificationInformation.getDynamicNotificationInformation(lstopp, 'Opportunity', 'REJECT');  
        Test.stopTest();
        System.assertEquals(casetest.Id, lstcase[0]);
        System.assertEquals(opptest.Id, lstopp[0]);
    }
}