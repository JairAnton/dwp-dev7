/**
 * Test class for BE_AP_NextVisits_tst
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		05/06/2020          Original version.<p />
 *
 * @author Diego Carbajal
 */
@isTest
public class BE_AP_NextVisits_tst {
	/*
	 * @Description  method setUp
	 */
	@TestSetup
	static void setUp() {
		AP_FactoryTest_tst.forSetUp();
		Final User admin = [SELECT Id FROM USER Where Id =:UserInfo.getUserId()];
		Final User ejecutivo = [SELECT Id FROM USER Where LastName LIKE 'EJECUTIVO' LIMIT 1];
		System.runAs(admin) {
			Final Account acc = [SELECT Id FROM Account LIMIT 1];
			final acpl__Account_Planning__c accountPlanning1 = AP_FactoryTest_tst.createAccountPlanning(acc.Id, ejecutivo.Id, null, true);
			insert accountPlanning1;
		}
	}

	/*
	 * @Description  method readRecordsClients
	 */
	public static testmethod void readRecordsClients() {
		Final String apId = [SELECT Id FROM acpl__Account_Planning__c WHERE RecordType.DeveloperName = 'Account_Planning' LIMIT 1].Id;
		Final Map<String, Object> mapParams = new Map<String, Object> {'sObjName' => 'dwp_kitv__Visit__c', 'recordId' => apId,
			                                                           'sObjFields' => 'Name,start_date_calculated__c,dwp_kitv__visit_desc__c', 
			                                                           'filterSQOL' => 'dwp_kitv__account_id__c = :recordId AND start_date_calculated__c >= TODAY ORDER BY start_date_calculated__c DESC'};
		Test.startTest();
		Final BE_SingleRelatedListCRUD_Cls singleClas = (BE_SingleRelatedListCRUD_Cls)Type.forName('BE_AP_NextVisits_cls').newInstance();
		Final BE_SingleRelatedListCRUD_Cls.Response res = singleClas.readRecords(mapParams);
		Test.stopTest();
		System.assert (res.isSuccess, 'Fail');
	}
    
    /*
	 * @Description  method readRecordsGroups
	 */
	public static testmethod void readRecordsGroups() {
        Final Id rtIdGE = [SELECT Id FROM RecordType WHERE DeveloperName = 'Record_Type_Economic_Group' LIMIT 1].Id;
        Final Account acc = [SELECT Id, RecordTypeId FROM Account LIMIT 1];
        acc.RecordTypeId = rtIdGE;
        update acc;
		Final String apId = [SELECT Id FROM acpl__Account_Planning__c WHERE RecordType.DeveloperName = 'Account_Planning' LIMIT 1].Id;
		Final Map<String, Object> mapParams = new Map<String, Object> {'sObjName' => 'dwp_kitv__Visit__c', 'recordId' => apId,
			                                                           'sObjFields' => 'Name,start_date_calculated__c,dwp_kitv__visit_desc__c', 
			                                                           'filterSQOL' => 'dwp_kitv__account_id__c = :recordId AND start_date_calculated__c >= TODAY ORDER BY start_date_calculated__c DESC'};
		Test.startTest();
		Final BE_SingleRelatedListCRUD_Cls singleClas = (BE_SingleRelatedListCRUD_Cls)Type.forName('BE_AP_NextVisits_cls').newInstance();
		Final BE_SingleRelatedListCRUD_Cls.Response res = singleClas.readRecords(mapParams);
		Test.stopTest();
		System.assert (res.isSuccess, 'Fail');
	}
    
    /*
	 * @Description  method readRecordsGroups
	 */
	public static testmethod void readRecordsError() {
		Final Map<String, Object> mapParams = new Map<String, Object>();
		Test.startTest();
		Final BE_SingleRelatedListCRUD_Cls singleClas = (BE_SingleRelatedListCRUD_Cls)Type.forName('BE_AP_NextVisits_cls').newInstance();
		Final BE_SingleRelatedListCRUD_Cls.Response res = singleClas.readRecords(mapParams);
		Test.stopTest();
		System.assert (!res.isSuccess, 'Fail');
	}
}