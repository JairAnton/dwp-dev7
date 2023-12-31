/*
 * ------------------------------------------------------------------------------------------------
 * @Name Dwp_Utils_helper_tst
 * @Author Diego Carbajal diego.carbajal.contractor@bbva.com
 * @Date Created: 2019-09-02
 * @Group
 * @Description Esta clase valida la funcionalidad de los metodos de la clase Dwp_Utils_helper
 *
 */
@isTest
public class Dwp_Utils_helper_tst {
	/*Campo IS_ERROR inicializado para soluciones del SonarQ*/
	public static Final String IS_ERROR = 'isError';
	/*Campo ERROR_ASSERT inicializado para soluciones del SonarQ*/
	public static Final String ERROR_ASSERT = 'Error Assertion';

	/* isTest - validateFormattSuccessTest */
	@isTest
	public static void validateFormattSuccessTest() {
		Map<String, Object> mapRes = new Map<String, Object>();
		Test.startTest();
		mapRes = Dwp_Utils_helper.validateFormatt('[0-9]{4}-[0-9]{4}-[0-9]{10}', '1234-1234-1234567890');
		Test.stopTest();
		Final Boolean assertion = (Boolean)mapRes.get(IS_ERROR) ? false : true;
		System.assert (assertion, ERROR_ASSERT);
	}

	/* isTest - validateFormattErrorTest */
	@isTest
	public static void validateFormattErrorTest() {
		Map<String, Object> mapRes = new Map<String, Object>();
		Test.startTest();
		mapRes = Dwp_Utils_helper.validateFormatt('[0-9]{4}-[0-9]{4}-[0-9]{10}', '1234-34567890');
		Test.stopTest();
		System.assert ((Boolean) mapRes.get(IS_ERROR), ERROR_ASSERT);
	}

	/* isTest - getPicklistValuesTest */
	@isTest
	public static void getPicklistValuesTest() {
		Map<String, Object> mapRes = new Map<String, Object>();
		Test.startTest();
		mapRes = Dwp_Utils_helper.getPicklistValues('Case', 'status');
		Test.stopTest();
		Final Integer mapSize = mapRes.size();
		Final Boolean result = mapSize > 0 ? true : false;
		System.assert (result, ERROR_ASSERT);
	}

	/* isTest - getListViewTest */
	@isTest
	public static void getListViewTest() {
		Map<String, Object> mapRes = new Map<String, Object>();
		Test.startTest();
		mapRes = Dwp_Utils_helper.getListView('Case', 'MyCases');
		Test.stopTest();
		Final Boolean result = (Boolean) mapRes.get(IS_ERROR) ? false : true;
		System.assert (result, ERROR_ASSERT);
	}

	/* isTest - formatAmount */
	@isTest
	public static void formatAmount() {
		String response;
		Test.startTest();
		response = Dwp_Utils_helper.formatAmount(1323.2, 'PEN');
		Test.stopTest();
		System.assertEquals('PEN 1,323.20', response);
	}
}
