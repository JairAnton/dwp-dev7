@isTest
public class caseStatusButtonClass_tst {

    @isTest
    public static void getDynamicButtonStatus_Test(){
        User usr1 = TestFactory.createUser('TestUser1', 'Operativo');
        Set<String> res = new Set<String>();
        Test.startTest();
        caseStatusButtonClass statusButton = new caseStatusButtonClass();
        res = statusButton.getDynamicButtonStatus(usr1.Id, 'Case');
        Test.stopTest();
        System.debug('res => '+res);
    }
}