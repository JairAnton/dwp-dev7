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
	/*
	 * @Description  method setUp
	 */
	@TestSetup
	static void setUp() {
		Final String perfil = [SELECT Id FROM Profile WHERE name = 'Ejecutivo'].Id;
		//Creaci�n de usuario
		Final Id gerenteRole = [SELECT Id FROM UserRole WHERE DeveloperName = 'GERENTE_BANCA_EMPRESAS_MIRAFLORES' LIMIT 1].Id;
		Map<Schema.SObjectField, Object> mapFields = new Map<Schema.SObjectField, Object> {User.LastName => 'GERENTE', User.ProfileId => perfil,
			                                                                               User.prof_position_id__c => 'E01', User.user_position_equivalence__c => 'User Test', User.UserRoleId => gerenteRole};
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
		System.assert (size == 1);
	}

	/*
	 * @Description  method validateStatusExpired
	 */
	public static testmethod void validateStatusExpired() {
		Map<String, Object> mapExpired = new Map<String, Object>();
		Final acpl__Account_Planning__c ap = getCurrentAP();
		ap.acpl__gf_ap_substatus_type_name__c = 'Expired';
		update ap;
		Test.startTest();
		mapExpired = BE_AP_Administration_helper.validateStatus(ap);
		Test.stopTest();
		System.assert (mapExpired.get('status') == 'expirado.');
	}

	/*
	 * @Description  method validateStatusPending
	 */
	public static testmethod void validateStatusPending() {
		Map<String, Object> mapPending = new Map<String, Object>();
		Final acpl__Account_Planning__c ap = getCurrentAP();
		ap.acpl__gf_ap_status_type_name__c = 'Pending Validation';
		update ap;
		Test.startTest();
		mapPending = BE_AP_Administration_helper.validateStatus(ap);
		Test.stopTest();
		System.assert (mapPending.get('status') == 'pendiente de validaci�n.');
	}

	/*
	 * @Description  method validateStatusValidation
	 */
	public static testmethod void validateStatusValidation() {
		Map<String, Object> mapValidation = new Map<String, Object>();
		Final acpl__Account_Planning__c ap = getCurrentAP();
		ap.acpl__gf_ap_status_type_name__c = 'Validated';
		update ap;
		Test.startTest();
		mapValidation = BE_AP_Administration_helper.validateStatus(ap);
		Test.stopTest();
		System.assert (mapValidation.get('status') == 'validado.');
	}

	/*
	 * @Description  method validateStatusValidated
	 */
	public static testmethod void validateStatusValidated() {
		Map<String, Object> mapValidated = new Map<String, Object>();
		Final acpl__Account_Planning__c ap = getCurrentAP();
		Test.startTest();
		mapValidated = BE_AP_Administration_helper.validateStatus(ap);
		Test.stopTest();
		System.assert ((Boolean)mapValidated.get('validation'));
	}

	/*
	 * @Description  method addErrorOnSobject
	 */
	public static testmethod void addErrorOnSobject() {
		Map<String, Object> mapValidated = new Map<String, Object>();
		Final List<acpl__Account_Planning__c> lstAP = new List<acpl__Account_Planning__c> {getCurrentAP()};
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
		System.assert (result, 'Fail');
	}

	/*
	 * @Description  method customMessageInsert
	 */
	public static testmethod void customMessageInsert() {
		String result;
		Test.startTest();
		result = BE_AP_Administration_helper.customMessage('insert', 'registro', 'bloqueado');
		Test.stopTest();
		System.assert (String.isNotBlank(result));
	}

	/*
	 * @Description  method customMessageUpdate
	 */
	public static testmethod void customMessageUpdate() {
		String result;
		Test.startTest();
		result = BE_AP_Administration_helper.customMessage('update', 'registro', 'bloqueado');
		Test.stopTest();
		System.assert (String.isNotBlank(result));
	}

	/*
	 * @Description  method customMessageDelete
	 */
	public static testmethod void customMessageDelete() {
		String result;
		Test.startTest();
		result = BE_AP_Administration_helper.customMessage('delete', 'registro', 'bloqueado');
		Test.stopTest();
		System.assert (String.isNotBlank(result));
	}

	/*
	 * @Description  method getCurrentAP
	 */
	private static acpl__Account_Planning__c getCurrentAP() {
		return [SELECT Id, acpl__gf_ap_substatus_type_name__c, acpl__gf_ap_status_type_name__c FROM acpl__Account_Planning__c LIMIT 1];
	}
}
