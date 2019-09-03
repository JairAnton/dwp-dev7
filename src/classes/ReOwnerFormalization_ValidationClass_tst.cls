/**
* ------------------------------------------------------------------------------------------------
* @Name ReOwnerFormalization_ValidationClass_tst
* @Author Diego Carbajal diego.carbajal.contractor@bbva.com
* @Date Created: 2019-09-02
* @Group 
* @Description Esta clase prueba los metodos de la clase ReOwnerFormalization_ValidationClass
*/
@isTest
public class ReOwnerFormalization_ValidationClass_tst {

    @isTest
    public static void getErrorMessagesList_Test() {
        Final User asistente = TestFactory.createUser('userName', 'operativo');
        Final Case caso = new Case();
        insert caso;
        list<String> lstErrorMessage = new List<String>();
        Test.startTest();
        System.runAs(asistente) {
            lstErrorMessage = ReOwnerFormalization_ValidationClass.getErrorMessagesList(caso.Id, '', '');
        }
        Test.stopTest();
        System.assertEquals(1, lstErrorMessage.size(), 'Assertion Error');
    }
}