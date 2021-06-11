/**
 * Test class for BE_AP_OpportunityInProgress_tst
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		05/06/2020          Original version.<p />
 * Jair Antón				07/06/2021			Modificación cobertura de test AP
 * @author Diego Carbajal
 */
@isTest
public class BE_AP_OpportunityInProgress_tst {
    
	/*
	 * @Description  method setUp
	 */
	@TestSetup
	static void setUp() {
        //Create User GOF
		Final String perfil=[SELECT Id FROM Profile WHERE name='Ejecutivo'].Id;
        Final Id gerenteRole = [SELECT Id FROM UserRole WHERE DeveloperName = 'GERENTE_BANCA_EMPRESAS_MIRAFLORES' LIMIT 1].Id;
        Map<Schema.SObjectField, Object> mapFields = new Map<Schema.SObjectField, Object>{User.LastName => 'GERENTE', User.ProfileId => perfil, 
           User.prof_position_id__c => 'E01', User.user_position_equivalence__c => 'User Test', User.UserRoleId => gerenteRole};
		Final User gof = TestFactory.getUser(true, mapFields);
        //Create User EJECUTIVO
        Final Id ejecutivoRole = [SELECT Id FROM UserRole WHERE DeveloperName = 'EJECUTIVO_BANCA_EMPRESAS_MIRAFLORES' LIMIT 1].Id;
        mapFields = new Map<Schema.SObjectField, Object>{User.LastName => 'EJECUTIVO', User.ProfileId => perfil, 
            User.user_position_equivalence__c => 'User Test', User.ManagerId => gof.Id, User.UserRoleId => ejecutivoRole};
		Final User ejecutivo = TestFactory.getUser(true, mapFields);
        Final User admin = [SELECT Id FROM User WHERE Id=:UserInfo.getUserId()];
        System.runAs(admin) {
            //Create Account
            Final Id rtIdGE = [SELECT Id FROM RecordType WHERE DeveloperName = 'Record_Type_Economic_Group' LIMIT 1].Id;
			mapFields = new Map<Schema.SObjectField, Object> {Account.OwnerId => UserInfo.getUserId(), Account.Name => 'CLIENTE MARTÍN', 
                				Account.RecordTypeId => rtIdGE};
            Final Account accGroup = TestFactory.getAccount(true, mapFields);
            Final Account accClient = TestFactory.createAccount(accGroup.Id);
            Final Id rtIdAP = [SELECT Id FROM RecordType WHERE DeveloperName = 'Account_Planning' LIMIT 1].Id;
            List<acpl__Account_Planning__c> apList = new List<acpl__Account_Planning__c>();
            apList.add(AP_FactoryTest_tst.createAccountPlanning(accGroup.Id, ejecutivo.Id, rtIdAP, true));
            apList.add(AP_FactoryTest_tst.createAccountPlanning(accClient.Id, ejecutivo.Id, rtIdAP, true));
            insert apList;
        }
	}

	/*
	 * @Description  method readRecordsClient
	 */
	public static testmethod void readRecordsClient() {
		Final String apId = [SELECT Id FROM acpl__Account_Planning__c WHERE RecordType.DeveloperName NOT IN ('Question_Catalog') 
                             AND acpl__participant_id__r.RecordType.DeveloperName = 'Record_Type_Client' LIMIT 1].Id;
		Final Map<String, Object> mapParams = new Map<String, Object> {'sObjName' => 'Opportunity',
			                                                           'sObjFields' => 'Name,toLabel(opportunity_status_type__c),Amount,CloseDate', 'recordId' => apId,
			                                                           'filterSQOL' => 'AccountId=:recordId AND CloseDate = THIS_YEAR'};
		Test.startTest();
		Final BE_SingleRelatedListCRUD_Cls singleClas = (BE_SingleRelatedListCRUD_Cls)Type.forName('BE_AP_OpportunityInProgress_cls').newInstance();
		Final BE_SingleRelatedListCRUD_Cls.Response res = singleClas.readRecords(mapParams);
		Test.stopTest();
		System.assert (res.isSuccess, 'Fail');
	}
    
    /*
	 * @Description  method readRecordsGroups
	 */
	public static testmethod void readRecordsGroups() {
		Final String apId = [SELECT Id FROM acpl__Account_Planning__c WHERE RecordType.DeveloperName NOT IN ('Question_Catalog') 
                             AND acpl__participant_id__r.RecordType.DeveloperName = 'Record_Type_Economic_Group' LIMIT 1].Id;
		Final Map<String, Object> mapParams = new Map<String, Object> {'sObjName' => 'Opportunity',
			                                                           'sObjFields' => 'Name,toLabel(opportunity_status_type__c),Amount,CloseDate', 'recordId' => apId,
			                                                           'filterSQOL' => 'AccountId=:recordId AND CloseDate = THIS_YEAR'};
		Test.startTest();
		Final BE_SingleRelatedListCRUD_Cls singleClas = (BE_SingleRelatedListCRUD_Cls)Type.forName('BE_AP_OpportunityInProgress_cls').newInstance();
		Final BE_SingleRelatedListCRUD_Cls.Response res = singleClas.readRecords(mapParams);
		Test.stopTest();
		System.assert (res.isSuccess, 'Fail');
	}
    
    /*
	 * @Description  method readRecordsFail
	 */
	public static testmethod void readRecordsFail() {
		Final String apId = [SELECT Id FROM acpl__Account_Planning__c WHERE RecordType.DeveloperName NOT IN ('Question_Catalog') LIMIT 1].Id;
		Final Map<String, Object> mapParams = new Map<String, Object> {'sObjName' => '',
			                                                           'sObjFields' => 'Name,toLabel(opportunity_status_type__c),Amount,CloseDate', 'recordId' => apId};
		Test.startTest();
		Final BE_SingleRelatedListCRUD_Cls singleClas = (BE_SingleRelatedListCRUD_Cls)Type.forName('BE_AP_OpportunityInProgress_cls').newInstance();
		Final BE_SingleRelatedListCRUD_Cls.Response res = singleClas.readRecords(mapParams);
		Test.stopTest();
		System.assert (!res.isSuccess, 'Fail');
	}
}