/**
* ------------------------------------------------------------------------------------------------
* @Name FormalizationAssit_ValidationClass_tst
* @Author Diego Carbajal diego.carbajal.contractor@bbva.com
* @Date Created: 2019-09-02
* @Group 
* @Description Esta clase prueba los metodos de la clase FormalizationAssistant_ValidationClass
*/
@isTest
public class FormalizationAssit_ValidationClass_tst {

    /* isTest - getErrorMessagesListTest */
    @isTest
    public static void getErrorMessagesListTest() {
        Final User asistente = TestFactory.createUser('userName', 'operativo');
        Final Case caso = new Case();
        insert caso;
        list<String> lstErrorMessage = new List<String>();
        Test.startTest();
        System.runAs(asistente) {
            lstErrorMessage = FormalizationAssistant_ValidationClass.getErrorMessagesList(caso.Id, '', '');
        }
        Test.stopTest();
        Final Integer lstErrorMessageSize = lstErrorMessage.size();
        System.assertEquals(1, lstErrorMessageSize, 'Assertion Error');
    }
}