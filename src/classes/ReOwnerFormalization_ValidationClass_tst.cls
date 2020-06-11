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
	/* Method to test funcionality*/
	@isTest
	public static void getErrorMessagesListTest() {
		Final User asistente = TestFactory.createUser('userName', 'operativo');
		Final Case caso = new Case();
		insert caso;
		list<String> lstErrorMessage = new List<String>();
		Test.startTest();
		System.runAs(asistente) {
			lstErrorMessage = ReOwnerFormalization_ValidationClass.getErrorMessagesList(caso.Id, '', '');
		}
		Test.stopTest();
		Final Integer lstErrorMsgSize = lstErrorMessage.size();
		Final Boolean assertion = lstErrorMsgSize > 0 ? true : false;
		System.assert (assertion, 'Assertion Error');
	}
}
