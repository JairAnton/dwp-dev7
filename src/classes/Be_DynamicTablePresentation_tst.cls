/**
 * ------------------------------------------------------------------------------------------------
 * @Name Be_DynamicTablePresentation_tst
 * @Author Diego Carbajal diego.carbajal@bbva.com
 * @Date Created: 2020-06-01
 * @Group
 * @Description Test class Be_DynamicTablePresentation_tst
 *
 */
@isTest
public class Be_DynamicTablePresentation_tst {
	/*Setup Data*/
	@TestSetup
	public static void setUp() {
		//La metadata de Be_Dynamic_Table_Presentation__mdt ya existe ne la org
		//Create Account
		Final Map<Schema.SObjectField, Object> mapFields = new Map<Schema.SObjectField, Object> {Account.OwnerId => UserInfo.getUserId(), Account.Name => 'CLIENTE MARTÍN'};
		Final Account acc = TestFactory.getAccount(true, mapFields);
	}

	public static testmethod void getData() {
		Test.startTest();
		Be_DTP_ResponseModel_cls dtpModel = new Be_DTP_ResponseModel_cls();
		Be_DTP_ResponseModel_cls.Response response = dtpModel.getData('');
		Test.stopTest();
		System.assertEquals(response.isSuccess, null, 'Success');
	}

	public static testmethod void getFiltersTest() {
		String result;
		Test.startTest();
		result = Be_DynamicTablePresentation_ctr.getFilters('AP_Test_Metadata_Fail');
		Test.stopTest();
		Final Boolean condition = String.isNotBlank(result);
		System.assert (condition, 'Success');
	}

	public static testmethod void getValuesTestFail() {
		map<String, Object> result;
		Test.startTest();
		result = Be_DynamicTablePresentation_ctr.getValues('AP_Test_Metadata_Fail', 'Basic', 'priority');
		Test.stopTest();
		Final Boolean condition = (Boolean) result.get('isSuccess');
		System.assertEquals(condition, false, 'Success');
	}

	public static testmethod void getValuesEjecutivoTestSuccess() {
		Final String perfil = [SELECT Id FROM Profile WHERE name = 'Ejecutivo'].Id;
		Map<Schema.SObjectField, Object> mapFields = new Map<Schema.SObjectField, Object> {User.LastName => 'Risotto', User.ProfileId => perfil,
			                                                                               User.user_position_equivalence__c => 'EJECUTIVO BEC'};
		Final User userOwner = TestFactory.getUser(true, mapFields);
		Final Account cuenta = [SELECT Id FROM Account LIMIT 1];
		Final Id apRT = [SELECT Id FROM RecordType WHERE DeveloperName = 'Account_Planning' LIMIT 1].Id;
		acpl__Account_Planning__c ap = new acpl__Account_Planning__c(acpl__participant_id__c = cuenta.Id, acpl__external_reference_id__c = 'AP123', Name = 'AP record',
		                                                             acpl__gf_ap_limit_date__c = System.today() + 1, acpl__proposal_manager_id__c = userOwner.Id,
		                                                             acpl__gf_ap_launch_name__c = 'Period by priority', acpl__gf_ap_status_type_name__c = 'Not started',
		                                                             recordTypeId = apRT);
		insert ap;
		map<String, Object> result;
		Test.startTest();
		System.runAs(UserOwner) {
			result = Be_DynamicTablePresentation_ctr.getValues('AP_Test_Metadata_Success', 'Title', 'priority');
		}
		Test.stopTest();
		Final Boolean condition = (Boolean) result.get('isSuccess');
		System.assert (condition, 'Success');
	}

	public static testmethod void getValuesGOFTestSuccess() {
		Final String perfil = [SELECT Id FROM Profile WHERE name = 'Ejecutivo'].Id;
		Map<Schema.SObjectField, Object> mapFields = new Map<Schema.SObjectField, Object> {User.LastName => 'Risotto', User.ProfileId => perfil,
			                                                                               User.prof_position_id__c => 'E01'};
		Final User userOwner = TestFactory.getUser(true, mapFields);
		Final Account cuenta = [SELECT Id FROM Account LIMIT 1];
		Final Id apRT = [SELECT Id FROM RecordType WHERE DeveloperName = 'Account_Planning' LIMIT 1].Id;
		acpl__Account_Planning__c ap = new acpl__Account_Planning__c(acpl__participant_id__c = cuenta.Id, acpl__external_reference_id__c = 'AP123', Name = 'AP record',
		                                                             acpl__gf_ap_limit_date__c = System.today() + 1, acpl__proposal_manager_id__c = userOwner.Id,
		                                                             acpl__gf_ap_status_type_name__c = 'Not started', recordTypeId = apRT);
		insert ap;
		ap.acpl__gf_ap_status_type_name__c = 'Validated';
		ap.acpl__gf_ap_substatus_type_name__c = 'In place';
		update ap;
		map<String, Object> result;
		Test.startTest();
		System.runAs(UserOwner) {
			result = Be_DynamicTablePresentation_ctr.getValues('AP_Test_Metadata_Success', 'Title', 'validated');
		}
		Test.stopTest();
		Final Boolean condition = (Boolean) result.get('isSuccess');
		System.assert (condition, 'Success');
	}
}
