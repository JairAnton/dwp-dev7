/**
 * Test class BE_AP_Administration_tst
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
public class BE_AP_Administration_tst {
    /** @Description  FAIL*/
    private static Final String FAIL = 'Fail';
	/*
	 * @Description  method setUp
	 */
	@TestSetup
	public static void setUp() {
		Final String perfil = [SELECT Id FROM Profile WHERE name = 'Ejecutivo'].Id;
		//Creación de usuario
		Final Id gerenteRole = [SELECT Id FROM UserRole WHERE DeveloperName = 'GERENTE_BANCA_EMPRESAS_MIRAFLORES' LIMIT 1].Id;
		Final Map<Schema.SObjectField, Object> mapFields = new Map<Schema.SObjectField, Object> {User.LastName => 'GERENTE', User.ProfileId => perfil,
			                                                                               User.prof_position_id__c => 'E01', User.user_position_equivalence__c => 'User Test', 
            																				User.UserRoleId => gerenteRole};
		Final User gof = TestFactory.getUser(true, mapFields);
		Final User usuario = [SELECT Id FROM User WHERE Id =:UserInfo.getUserId()];
		System.runAs(usuario) {
			Final Account acc = TestFactory.createAccount();
			insert TestFactory.createAccountPlanning(acc.Id, gof.Id, null, true);
		}
	}

	/*
	 * @Description  method getAP
	 */
	public static testmethod void getAP() {
		Final Id apId = getCurrentAP().Id;
		Test.startTest();
		Final acpl__Account_Planning__c[] lstAP = BE_AP_Administration_helper.getAp(apId);
		Test.stopTest();
		Final Integer size = lstAP.size();
		System.assertEquals (size, 1, FAIL);
	}

	/*
	 * @Description  method validateStatusExpired
	 */
	public static testmethod void validateStatusExpired() {
		Map<String, Object> mapExpired = new Map<String, Object>();
		Final acpl__Account_Planning__c apR = getCurrentAP();
		apR.acpl__gf_ap_substatus_type_name__c = 'Expired';
		update apR;
		Test.startTest();
		mapExpired = BE_AP_Administration_helper.validateStatus(apR);
		Test.stopTest();
		System.assertEquals (mapExpired.get('status'), 'expirado.', FAIL);
	}

	/*
	 * @Description  method validateStatusPending
	 */
	public static testmethod void validateStatusPending() {
		Map<String, Object> mapPending = new Map<String, Object>();
		Final acpl__Account_Planning__c apR = getCurrentAP();
		apR.acpl__gf_ap_status_type_name__c = 'Pending Validation';
		update apR;
		Test.startTest();
		mapPending = BE_AP_Administration_helper.validateStatus(apR);
		Test.stopTest();
		System.assertEquals (mapPending.get('status'), 'pendiente de validación.', FAIL);
	}

	/*
	 * @Description  method validateStatusValidation
	 */
	public static testmethod void validateStatusValidation() {
		Map<String, Object> mapValidation = new Map<String, Object>();
		Final acpl__Account_Planning__c apR = getCurrentAP();
		apR.acpl__gf_ap_status_type_name__c = 'Validated';
		update apR;
		Test.startTest();
		mapValidation = BE_AP_Administration_helper.validateStatus(apR);
		Test.stopTest();
		System.assertEquals (mapValidation.get('status'), 'validado.', FAIL);
	}

	/*
	 * @Description  method getCurrentAP
	 */
	public static acpl__Account_Planning__c getCurrentAP() {
		return [SELECT Id, acpl__gf_ap_substatus_type_name__c, acpl__gf_ap_status_type_name__c FROM acpl__Account_Planning__c LIMIT 1];
	}
}