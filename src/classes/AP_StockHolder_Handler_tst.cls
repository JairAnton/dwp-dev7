/**
 * Handler of Trigger of the BE_Stockholder__c object.
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		06/10/2020          Original version.<p />
 *
 * @author Diego Carbajal
 */
@isTest
public class AP_StockHolder_Handler_tst {

    /*** @Description variable DNI*/
    Final static String DNI = 'DNI';
    /*** @Description variable ACCIONISTA*/
    Final static String ACCIONISTA = 'Accionista';
    /*** @Description variable ACCIONISTA*/
    Final static String DOCUMENT_NUMBER = '1029384756';
    /*** @Description variable mapUsers*/
	static Map<String, User> mapUsers = AP_FactoryTest_tst.obtainUsers();
	/*** @Description variable EJECUTIVO*/
	static Final String EJECUTIVO = 'EJECUTIVO';
	/*** @Description variable FAIL*/
	static Final String FAIL = 'FAIL Assertion';
    /*** @Description variable VISIT*/
	static Final String VISIT = 'Visit';
	/**
	 * @Description method setUp
	 */
	@TestSetup
	public static void setUp() {
		AP_FactoryTest_tst.forSetUp();
	}

	/**
	 * @Description Test method beforeInsert
	 */
	public static testmethod void beforeInsert() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		Final acpl__Account_Planning__c apRecord = AP_FactoryTest_tst.createAccountPlanning(acc.Id, mapUsers.get(EJECUTIVO).Id, null, true);
		insert apRecord;
        Boolean error = false;
		Test.startTest();
		System.runAs(mapUsers.get(EJECUTIVO)) {
			try {
				apRecord.ACPL__GF_AP_INDVI_LOCK_EDIT_IND_TYPE__C = false;
                update apRecord;
				insert new BE_Stockholder__c(account_planning__c = apRecord.Id, Name = ACCIONISTA, DocumentNumber__c = DOCUMENT_NUMBER, DocumentType__c = DNI);
			} catch(Exception e) {
                error = true;
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		System.assert(error, FAIL);
	}

	/**
	 * @Description Test method beforeUpdate
	 */
	public static testmethod void beforeUpdate() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		Final acpl__Account_Planning__c apRecord = AP_FactoryTest_tst.createAccountPlanning(acc.Id, mapUsers.get(EJECUTIVO).Id, null, true);
		insert apRecord;
		Final BE_Stockholder__c stockholder = new BE_Stockholder__c(account_planning__c = apRecord.Id, Name = ACCIONISTA, DocumentNumber__c = DOCUMENT_NUMBER, DocumentType__c = DNI);
		insert stockholder;
        Boolean error = false;
		Test.startTest();
		System.runAs(mapUsers.get(EJECUTIVO)) {
			try {
				apRecord.ACPL__GF_AP_INDVI_LOCK_EDIT_IND_TYPE__C = false;
                update apRecord;
				stockholder.Name = 'ACCIONISTA Aux';
				update stockholder;
			} catch(Exception e) {
                error = true;
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		System.assert(error, FAIL);
	}

	/**
	 * @Description Test method beforeDelete
	 */
	public static testmethod void beforeDelete() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		Final acpl__Account_Planning__c apRecord = AP_FactoryTest_tst.createAccountPlanning(acc.Id, mapUsers.get(EJECUTIVO).Id, null, true);
		insert apRecord;
		Final BE_Stockholder__c stockholder = new BE_Stockholder__c(account_planning__c = apRecord.Id, Name = ACCIONISTA, DocumentNumber__c = DOCUMENT_NUMBER, DocumentType__c = DNI);
		insert stockholder;
        Boolean error = false;
		Test.startTest();
		System.runAs(mapUsers.get(EJECUTIVO)) {
			try {
				apRecord.ACPL__GF_AP_INDVI_LOCK_EDIT_IND_TYPE__C = false;
                update apRecord;
				delete stockholder;
			} catch(Exception e) {
                error = true;
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		System.assert(error, FAIL);
	}

	/**
	 * @Description Test method afterInsert
	 */
	public static testmethod void afterInsert() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		Final acpl__Account_Planning__c apRecord = AP_FactoryTest_tst.createAccountPlanning(acc.Id, mapUsers.get(EJECUTIVO).Id, null, true);
		insert apRecord;
		Test.startTest();
		System.runAs(mapUsers.get(EJECUTIVO)) {
			insert new BE_Stockholder__c(account_planning__c = apRecord.Id, Name = ACCIONISTA, DocumentNumber__c = DOCUMENT_NUMBER, DocumentType__c = DNI);
		}
		Test.stopTest();
		Final acpl__Account_Planning__c apAux = [SELECT Id, acpl__gf_ap_status_type_name__c FROM acpl__Account_Planning__c WHERE Id =:apRecord.Id LIMIT 1];
		System.assertEquals('In Progress', apAux.acpl__gf_ap_status_type_name__c, FAIL);
	}
}