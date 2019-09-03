/**
* ------------------------------------------------------------------------------------------------
* @Name User_Trigger_Case_tst
* @Author Diego Carbajal diego.carbajal.contractor@bbva.com
* @Date Created: 2019-09-02
* @Group 
* @Description Esta clase valida la funcionalidad de los metodos de la clase Dwp_Utils_helper
* 
*/
@isTest
public class Dwp_Utils_helper_tst {
    
	@isTest
    public static void validateFormatt_Success_Test() {
        Map<String, Object> mapRes = new Map<String, Object>();
        Test.startTest();
        mapRes = Dwp_Utils_helper.validateFormatt('[0-9]{4}-[0-9]{4}-[0-9]{10}', '1234-1234-1234567890');
        Test.stopTest();
        System.assertEquals(false, mapRes.get('isError'), 'Error Assertion');
    }
        
	@isTest
    public static void validateFormatt_Error_Test() {
        Map<String, Object> mapRes = new Map<String, Object>();
        Test.startTest();
        mapRes = Dwp_Utils_helper.validateFormatt('[0-9]{4}-[0-9]{4}-[0-9]{10}', '1234-34567890');
        Test.stopTest();
        System.assertEquals(true, mapRes.get('isError'), 'Error Assertion');
    }
    
    @isTest
    public static void getPicklistValues_Test() {
        Map<String, Object> mapRes = new Map<String, Object>();
        Test.startTest();
        mapRes = Dwp_Utils_helper.getPicklistValues('Case', 'status');
        Test.stopTest();
        Boolean result = mapRes.size() > 0 ? true : false;
        System.assertEquals(true, result, 'Error Assertion');
    }
    
    @isTest
    public static void getListView_Test() {
        Map<String, Object> mapRes = new Map<String, Object>();
        Test.startTest();
        mapRes = Dwp_Utils_helper.getListView('Case', 'MyCases');
        Test.stopTest();
        System.assertEquals(false, mapRes.get('isError'), 'Error Assertion');
    }
}