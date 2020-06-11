/**
 * Test class for BE_AP_LastVisits_tst
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
public class BE_AP_LastVisits_tst {
	/*
	 * @Description  method setUp
	 */
	@TestSetup
	static void setUp() {
		AP_FactoryTest_tst.forSetUp();
		Final User admin = [SELECT Id FROM USER Where Id =:UserInfo.getUserId()];
		Final User ejecutivo = [SELECT Id FROM USER Where LastName LIKE 'EJECUTIVO' LIMIT 1];
		System.runAs(admin) {
			Account acc = [SELECT Id FROM Account LIMIT 1];
			final acpl__Account_Planning__c accountPlanning1 = TestFactory.createAccountPlanning(acc.Id, ejecutivo.Id, null, false);
			insert accountPlanning1;
		}
	}

	/*
	 * @Description  method readRecords
	 */
	public static testmethod void readRecords() {
		Final String apId = [SELECT Id FROM acpl__Account_Planning__c WHERE RecordType.DeveloperName != 'Question_Catalog' LIMIT 1].Id;
		Final Map<String, Object> mapParams = new Map<String, Object> {'sObjName' => 'dwp_kitv__Visit__c',
			                                                           'sObjFields' => 'Name,start_date_calculated__c,dwp_kitv__visit_desc__c', 'recordId' => apId,
			                                                           'filterSQOL' => 'dwp_kitv__account_id__c = :recordId AND dwp_kitv__visit_end_date__c < TODAY AND dwp_kitv__visit_end_date__c >= LAST_YEAR ORDER BY dwp_kitv__visit_end_date__c DESC'};
		Test.startTest();
		Final BE_SingleRelatedListCRUD_Cls singleClas = (BE_SingleRelatedListCRUD_Cls)Type.forName('BE_AP_LastVisits_cls').newInstance();
		Final BE_SingleRelatedListCRUD_Cls.Response res = singleClas.readRecords(mapParams);
		Test.stopTest();
		System.assert (res.isSuccess, 'Fail');
	}
}
