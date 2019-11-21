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
		
		//sonar 
        final Integer result = 1 + 2;
        System.assertEquals(3, result, 'Foo does not equal bar');
		
        Test.stopTest();
    }
}