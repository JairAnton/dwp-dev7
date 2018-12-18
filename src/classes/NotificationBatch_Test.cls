@isTest(SeeAllData=true)
public class NotificationBatch_Test { //Yulino 12/12/2018 : Se agrego Assets (linea 15)
    static Account acctest;
    static Opportunity opptest;
    static User usertest;
    static Case casetest;
    @isTest
    static void setData(){
        acctest = TestFactory.createAccount();        
        usertest = TestFactory.createUser('usernameTestNotif', Label.profAdministrator);
        acctest.OwnerId = usertest.Id;
        update acctest;
        opptest = TestFactory.createOpportunity(acctest.Id,usertest.Id);
        casetest = TestFactory.createCase(usertest.Id);
        System.assertNotEquals(usertest.Id, null); 
    }
    @isTest
    static void  notifBatch(){
        setData();
        Test.startTest();
        List<String> lstcase = new List<String>();
        lstcase.add(casetest.Id);
        DynamicNotificationInformation.getDynamicNotificationInformation(lstcase, 'Case', 'CREATE_CASE');
        List <DynamicNotificationInformation.NotificationInformation_wrapper> lstwrap = DynamicNotificationInformation.getDynamicNotificationInformation(lstcase, 'Case', 'CREATE_CASE');
        Test.stopTest();
        System.assertEquals(casetest.Id, lstcase[0]);        
    }
    
}