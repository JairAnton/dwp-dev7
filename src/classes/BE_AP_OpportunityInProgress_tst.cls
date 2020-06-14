/**
 * Test class for BE_AP_OpportunityInProgress_tst
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
public class BE_AP_OpportunityInProgress_tst {
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
			final acpl__Account_Planning__c accountPlanning1 = AP_FactoryTest_tst.createAccountPlanning(acc.Id, ejecutivo.Id, null, false);
			insert accountPlanning1;
		}
	}

	/*
	 * @Description  method readRecords
	 */
	public static testmethod void readRecords() {
		Final String apId = [SELECT Id FROM acpl__Account_Planning__c WHERE RecordType.DeveloperName NOT IN ('Question_Catalog') LIMIT 1].Id;
		Final Map<String, Object> mapParams = new Map<String, Object> {'sObjName' => 'Opportunity',
			                                                           'sObjFields' => 'Name,toLabel(opportunity_status_type__c),Amount,CloseDate', 'recordId' => apId,
			                                                           'filterSQOL' => 'AccountId=:recordId AND CloseDate = THIS_YEAR'};
		Test.startTest();
		Final BE_SingleRelatedListCRUD_Cls singleClas = (BE_SingleRelatedListCRUD_Cls)Type.forName('BE_AP_NextVisits_cls').newInstance();
		Final BE_SingleRelatedListCRUD_Cls.Response res = singleClas.readRecords(mapParams);
		Test.stopTest();
		System.assert (res.isSuccess, 'Fail');
	}
}