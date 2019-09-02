@isTest
public class FormalizationAssit_ValidationClass_tst {

    @isTest
    public static void getErrorMessagesList_Test(){
        User asistente = TestFactory.createUser('userName', 'operativo');
        Case caso = new Case();
        insert caso;
        list<String> lstErrorMessage = new List<String>();
        Test.startTest();
        System.runAs(asistente){
            lstErrorMessage = FormalizationAssistant_ValidationClass.getErrorMessagesList(caso.Id, '', '');
        }
        Test.stopTest();
        System.assertEquals(1, lstErrorMessage.size(), 'Assertion Error');
    }
}