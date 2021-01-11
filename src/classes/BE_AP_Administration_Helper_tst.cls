/**
 * Test class BE_AP_Administration_Helper_tst
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		04/06/2020          Original version.<p />
 *
 * @author Diego Carbajal
 */
@isTest
public class BE_AP_Administration_Helper_tst {

    /** @Description  FAIL*/
    private static Final String FAIL = 'Fail';
    
    /*
	 * @Description  method setUp
	 */
	@TestSetup
	static void setUp() {
		BE_AP_Administration_tst.setUp();
	}
    
    /*
	 * @Description  method validateStatusValidated
	 */
	public static testmethod void validateStatusValidated() {
		Map<String, Object> mapValidated = new Map<String, Object>();
		Final acpl__Account_Planning__c apR = [SELECT Id, acpl__gf_ap_substatus_type_name__c, acpl__gf_ap_status_type_name__c FROM acpl__Account_Planning__c LIMIT 1];
		Test.startTest();
		mapValidated = BE_AP_Administration_helper.validateStatus(apR);
		Test.stopTest();
		System.assert ((Boolean)mapValidated.get('validation'), FAIL);
	}

	/*
	 * @Description  method addErrorOnSobject
	 */
	public static testmethod void addErrorOnSobject() {
		Final List<acpl__Account_Planning__c> lstAP = new List<acpl__Account_Planning__c> {[SELECT Id, acpl__gf_ap_substatus_type_name__c, acpl__gf_ap_status_type_name__c FROM acpl__Account_Planning__c LIMIT 1]};
		Boolean result;
		Test.startTest();
		try {
			BE_AP_Administration_helper.addErrorOnSobject(lstAP, 'acpl__Account_Planning__c', 'Error');
			result = true;
		} catch(Exception e) {
			System.debug(e.getMessage());
			result = false;
		}
		Test.stopTest();
		System.assert (result, FAIL);
	}

	/*
	 * @Description  method customMessageInsert
	 */
	public static testmethod void customMessageInsert() {
		String result;
		Test.startTest();
		result = BE_AP_Administration_helper.customMessage('insert', 'registro', 'bloqueado');
		Test.stopTest();
		System.assert (String.isNotBlank(result), FAIL);
	}

	/*
	 * @Description  method customMessageUpdate
	 */
	public static testmethod void customMessageUpdate() {
		String result;
		Test.startTest();
		result = BE_AP_Administration_helper.customMessage('update', 'registro', 'bloqueado');
		Test.stopTest();
		System.assert (String.isNotBlank(result), FAIL);
	}

	/*
	 * @Description  method customMessageDelete
	 */
	public static testmethod void customMessageDelete() {
		String result;
		Test.startTest();
		result = BE_AP_Administration_helper.customMessage('delete', 'registro', 'bloqueado');
		Test.stopTest();
		System.assert (String.isNotBlank(result), FAIL);
	}
}