@isTest
public class caseStatusButtonClass_tst {

    /* isTest - getDynamicButtonStatusTest */
    @isTest
    public static void getDynamicButtonStatusTest(){
        Final User usr1 = TestFactory.createUser('TestUser1', 'Operativo');
        Set<String> res = new Set<String>();
        Test.startTest();
        caseStatusButtonClass statusButton = new caseStatusButtonClass();
        res = statusButton.getDynamicButtonStatus(usr1.Id, 'Case');
        Test.stopTest();
    }
}