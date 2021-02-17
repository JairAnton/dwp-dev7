/**
 * @Name Be_RecordId_Related_Sobject_tst
 * @Author Diego Carbajal diego.carbajal@bbva.com
 * @Date Created: 2020-06-01
 * @Group
 * @Description Esta clase valida la funcionalidad de los metodos de la clase Be_RecordId_Related_Sobject_helper
 */
@isTest
public class Be_RecordId_Related_Sobject_tst {
    /*FAIL*/
    private static Final String FAIL = 'Fail';
	/*Setup Data*/
	@TestSetup
	public static void setUp() {
		//Create custom settings
		Final Be_Dynamic_Report_Chart__c chartConfig = new Be_Dynamic_Report_Chart__c(Name = 'Account_Risk_Strategy', Active_cache__c = true,  Rendered__c = true, Size__c = 'large',
		                                                                              Filters__c = '[{column:\'Account.Id\',operator:\'equals\',value:\'recordId\'}]',
		                                                                              Hide_on_error__c = false, Report_DeveloperName__c = 'Account_Risk_Strategy',
		                                                                              Show_refresh_button__c = false, Time_cache_data__c = 86400000,
		                                                                              unique_id__c = 'AP_Account_Risk_Strategy');
		insert chartConfig;
		//Create Account
		Map<Schema.SObjectField, Object> mapFields = new Map<Schema.SObjectField, Object> {Account.OwnerId => UserInfo.getUserId(), Account.Name => 'CLIENTE MARTÍN'};
		TestFactory.getAccount(true, mapFields);
        //Create User
        Final String perfil = [SELECT Id FROM Profile WHERE name = 'Ejecutivo'].Id;
		mapFields = new Map<Schema.SObjectField, Object> {User.LastName => 'Risotto', User.ProfileId => perfil, User.user_position_equivalence__c => 'EJECUTIVO BEC'};
		TestFactory.getUser(true, mapFields);
	}

	/*
	 * @Description  method instanceClass
	 */
	public static testmethod void instanceClass() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		Final List<Be_Dynamic_Report_Chart__c> chartConfig = Be_Dynamic_Report_Chart__c.getAll().values();
		Boolean condition = false;
		ApexPages.currentPage().getParameters().put('Id', String.valueOf(acc.Id));
		ApexPages.currentPage().getParameters().put('configName', String.valueOf(chartConfig[0].Report_DeveloperName__c));
		Test.startTest();
		Try {
			new Be_RecordId_Related_Sobject_helper();
			condition = true;
		} catch(Exception e) {
			System.debug(e.getMessage());
		}
		Test.stopTest();
		System.assert (condition, FAIL);
	}

	/*
	 * @Description  method getRecordIdSobjectTest
	 */
	public static testmethod void getRecordIdSobjectTest() {
		insert new dwp_kitv__Visit_validations_acc_cs__c(SetupOwnerId = UserInfo.getOrganizationId(), dwp_kitv__User_Team_Member__c = true);
		Final Account cuenta = [SELECT Id, branch_id__c FROM Account LIMIT 1];
		Final dwp_kitv__Visit__c visita = new dwp_kitv__Visit__c(Name = 'Visita', dwp_kitv__account_id__c = cuenta.Id, dwp_kitv__visit_duration_number__c = '15',
		                                                         dwp_kitv__visit_start_date__c = DateTime.now());
		insert visita;
		String result;
		Test.startTest();
		result = Be_RecordId_Related_Sobject_helper.getRecordIdSobject('dwp_kitv__Visit__c', 'dwp_kitv__account_id__c', visita.Id);
		Test.stopTest();
		Final Boolean condition = String.isNotBlank(result);
		System.assert (condition, FAIL);
	}

	/*
	 * @Description  method getUrlPageSuccess
	 */
	public static testmethod void getUrlPageSuccess() {
		insert new dwp_kitv__Visit_validations_acc_cs__c(SetupOwnerId = UserInfo.getOrganizationId(), dwp_kitv__User_Team_Member__c = true);
		Final Account cuenta = [SELECT Id, branch_id__c FROM Account LIMIT 1];
		Final dwp_kitv__Visit__c visita = new dwp_kitv__Visit__c(Name = 'Visita', dwp_kitv__account_id__c = cuenta.Id, dwp_kitv__visit_duration_number__c = '15',
		                                                         dwp_kitv__visit_start_date__c = DateTime.now());
		insert visita;
		Map<String, Object> mapResult;
		Test.startTest();
		mapResult = Be_RecordId_Related_Sobject_helper.getUrlPage(
            '{"reportDeveloperName":"Account_Risk_Strategy","sObjType":"dwp_kitv__Visit__c", "field":"dwp_kitv__account_id__c", "recordId":"'+visita.Id+'"}');
		Test.stopTest();
		Final Boolean condition = (Boolean)mapResult.get('isError');
		System.assert(condition, FAIL);
	}

	/*
	 * @Description  method getVisitValuesClients
	 */
	public static testmethod void getVisitValuesClients() {
		Final User userOwner = [SELECT Id FROM User WHERE LastName LIKE '%Risotto%' LIMIT 1];
		Final Account cuenta = [SELECT Id, branch_id__c FROM Account LIMIT 1];
		Final acpl__Account_Planning__c apR = new acpl__Account_Planning__c(acpl__participant_id__c = cuenta.Id, acpl__external_reference_id__c = 'AP123', Name = 'AP record',
		                                                             acpl__gf_ap_limit_date__c = System.today(), acpl__proposal_manager_id__c = userOwner.Id, ACPL__GF_AP_INDVI_LOCK_EDIT_IND_TYPE__C = true);
		insert apR;
		List<Integer> lstResult;
		Test.startTest();
		lstResult = Be_RecordId_Related_Sobject_helper.getVisitValues(apR.Id);
		Test.stopTest();
		Final Integer size = lstResult.size();
		Final Boolean condition = size > 0;
		System.assert (condition, FAIL);
	}
    
    /*
	 * @Description  method getVisitValues
	 */
	public static testmethod void getVisitValuesGroups() {
        Final Id rtIdGE = [SELECT Id FROM RecordType WHERE DeveloperName = 'Record_Type_Economic_Group' LIMIT 1].Id;
		Final User userOwner = [SELECT Id FROM User WHERE LastName LIKE '%Risotto%' LIMIT 1];
		Final Account cuenta = [SELECT Id, branch_id__c, recordTypeId FROM Account LIMIT 1];
        cuenta.RecordTypeId = rtIdGE;
        update cuenta;
		Final acpl__Account_Planning__c apR = new acpl__Account_Planning__c(acpl__participant_id__c = cuenta.Id, acpl__external_reference_id__c = 'AP123', Name = 'AP record',
		                                                             acpl__gf_ap_limit_date__c = System.today(), acpl__proposal_manager_id__c = userOwner.Id, ACPL__GF_AP_INDVI_LOCK_EDIT_IND_TYPE__C = true);
		insert apR;
		List<Integer> lstResult;
		Test.startTest();
		lstResult = Be_RecordId_Related_Sobject_helper.getVisitValues(apR.Id);
		Test.stopTest();
		Final Integer size = lstResult.size();
		Final Boolean condition = size > 0;
		System.assert (condition, FAIL);
	}

    /*
	 * @Description  method getMetadataConfig Success
	 */
	public static testmethod void getMetadataConfigSuccess() {
		Final User ejecutivo = [SELECT Id FROM User WHERE Profile.Name = 'Ejecutivo' AND isActive = true LIMIT 1];
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		acc.recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName IN ('Record_Type_Economic_Group', 'Record_Type_Client') LIMIT 1].Id;
		update acc;
		Final acpl__Account_Planning__c accountPlanning1 = AP_FactoryTest_tst.createAccountPlanning(acc.Id, ejecutivo.Id, null, true);
        insert accountPlanning1;
		Map<String, Object> mapResponse;
		Test.startTest();
		mapResponse = Be_RecordId_Related_Sobject_helper.getMetadataConfig(accountPlanning1.Id);
		Test.stopTest();
		System.assert((Boolean) mapResponse.get('isSuccess'), 'Assert Error');
	}
    
    /*
	 * @Description  method getMetadataConfig Error
	 */
    public static testmethod void getMetadataConfigError() {
		Map<String, Object> mapResponse;
		Test.startTest();
		mapResponse = Be_RecordId_Related_Sobject_helper.getMetadataConfig(null);
		Test.stopTest();
		System.assert(!(Boolean) mapResponse.get('isSuccess'), 'Assert Error');
	}
}