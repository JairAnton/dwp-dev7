/**
 * ------------------------------------------------------------------------------------------------
 * @Name BE_AccountPlanning_HomeView_tst
 * @Author Diego Carbajal diego.carbajal@bbva.com
 * @Date Created: 2020-06-01
 * @Group
 * @Description Test class BE_AccountPlanning_HomeView_tst
 *
 */
@isTest
public class BE_AccountPlanning_HomeView_tst {
	/*
	 * @Description  variable fail
	 */
	static Final String fail = 'fail';
	/*
	 * @Description  method setUp
	 */
	@TestSetup
	public static void setUp() {
		//La metadata de Be_Dynamic_Table_Presentation__mdt ya existe ne la org
		//Create Account
		Map<Schema.SObjectField, Object> mapFields = new Map<Schema.SObjectField, Object> {Account.OwnerId => UserInfo.getUserId(), Account.Name => 'CLIENTE MARTíN'};
		Final Account acc = TestFactory.getAccount(true, mapFields);
		Final String perfil = [SELECT Id FROM Profile WHERE name = 'Ejecutivo'].Id;
		//Ejecutivo
		mapFields = new Map<Schema.SObjectField, Object> {User.LastName => 'Risotto', User.ProfileId => perfil,
			                                              User.user_position_equivalence__c => 'EJECUTIVO BEC'};
		TestFactory.getUser(true, mapFields);
		// GOF
		mapFields = new Map<Schema.SObjectField, Object> {User.LastName => 'Risotto', User.ProfileId => perfil,
			                                              User.prof_position_id__c => 'E01'};
		TestFactory.getUser(true, mapFields);
	}

	/*
	 * @Description  method getDataEjecutivoPriority
	 */
	public static testmethod void getDataEjecutivoPriority() {
		Final User userOwner = [SELECT Id FROM User WHERE user_position_equivalence__c = 'EJECUTIVO BEC' AND isActive = true LIMIT 1];
		Final Account cuenta = [SELECT Id FROM Account LIMIT 1];
		Final Id apRT = [SELECT Id FROM RecordType WHERE DeveloperName = 'Account_Planning' LIMIT 1].Id;
		Final acpl__Account_Planning__c ap = new acpl__Account_Planning__c(acpl__participant_id__c = cuenta.Id, acpl__external_reference_id__c = 'AP123', Name = 'AP record',
		                                                                   acpl__gf_ap_limit_date__c = System.today() + 1, acpl__proposal_manager_id__c = userOwner.Id,
		                                                                   acpl__gf_ap_launch_name__c = 'Period by priority', acpl__gf_ap_status_type_name__c = 'Not started',
		                                                                   recordTypeId = apRT);
		insert ap;
		Be_DTP_ResponseModel_cls.Response response = new Be_DTP_ResponseModel_cls.Response();
		Test.startTest();
		System.runAs(UserOwner) {
			Final Be_DTP_ResponseModel_cls singleClass = (Be_DTP_ResponseModel_cls)Type.forName('BE_AccountPlanning_HomeView_cls').newInstance();
			response = singleClass.getData('priority');
		}
		Test.stopTest();
		Final Boolean condition = response.isSuccess;
		System.assert (condition, fail);
	}

	/*
	 * @Description  method getDataEjecutivoValidated
	 */
	public static testmethod void getDataEjecutivoValidated() {
		Final User userOwner = [SELECT Id FROM User WHERE user_position_equivalence__c = 'EJECUTIVO BEC' AND isActive = true LIMIT 1];
		Final Account cuenta = [SELECT Id FROM Account LIMIT 1];
		Final Id apRT = [SELECT Id FROM RecordType WHERE DeveloperName = 'Account_Planning' LIMIT 1].Id;
		Final acpl__Account_Planning__c ap = new acpl__Account_Planning__c(acpl__participant_id__c = cuenta.Id, acpl__external_reference_id__c = 'AP123', Name = 'AP record',
		                                                                   acpl__gf_ap_limit_date__c = System.today() + 1, acpl__proposal_manager_id__c = userOwner.Id,
		                                                                   acpl__gf_ap_launch_name__c = 'Period by priority', acpl__gf_ap_status_type_name__c = 'Not started',
		                                                                   recordTypeId = apRT);
		insert ap;
		ap.acpl__gf_ap_status_type_name__c = 'Validated';
		ap.acpl__gf_ap_substatus_type_name__c = 'In place';
		update ap;
		Be_DTP_ResponseModel_cls.Response response = new Be_DTP_ResponseModel_cls.Response();
		Test.startTest();
		System.runAs(UserOwner) {
			Final Be_DTP_ResponseModel_cls singleClass = (Be_DTP_ResponseModel_cls)Type.forName('BE_AccountPlanning_HomeView_cls').newInstance();
			response = singleClass.getData('validated');
		}
		Test.stopTest();
		Final Boolean condition = response.isSuccess;
		System.assert (condition, fail);
	}

	/*
	 * @Description  method getDataEjecutivoClosedThisM
	 */
	public static testmethod void getDataEjecutivoClosedThisM() {
		Final User userOwner = [SELECT Id FROM User WHERE user_position_equivalence__c = 'EJECUTIVO BEC' AND isActive = true LIMIT 1];
		Final Account cuenta = [SELECT Id FROM Account LIMIT 1];
		Final Id apRT = [SELECT Id FROM RecordType WHERE DeveloperName = 'Account_Planning' LIMIT 1].Id;
		Final acpl__Account_Planning__c ap = new acpl__Account_Planning__c(acpl__participant_id__c = cuenta.Id, acpl__external_reference_id__c = 'AP123', Name = 'AP record',
		                                                                   acpl__gf_ap_limit_date__c = System.today() + 1, acpl__proposal_manager_id__c = userOwner.Id,
		                                                                   acpl__gf_ap_launch_name__c = 'Period by priority', acpl__gf_ap_status_type_name__c = 'Not started',
		                                                                   recordTypeId = apRT);
		insert ap;
		ap.acpl__gf_ap_limit_date__c = System.today();
		update ap;
		Be_DTP_ResponseModel_cls.Response response = new Be_DTP_ResponseModel_cls.Response();
		Test.startTest();
		System.runAs(UserOwner) {
			Final Be_DTP_ResponseModel_cls singleClass = (Be_DTP_ResponseModel_cls)Type.forName('BE_AccountPlanning_HomeView_cls').newInstance();
			response = singleClass.getData('closed_this_month');
		}
		Test.stopTest();
		Final Boolean condition = response.isSuccess;
		System.assert (condition, fail);
	}

	/*
	 * @Description  method getDataEjecutivoClosedNextM
	 */
	public static testmethod void getDataEjecutivoClosedNextM() {
		Final User userOwner = [SELECT Id FROM User WHERE user_position_equivalence__c = 'EJECUTIVO BEC' AND isActive = true LIMIT 1];
		Final Account cuenta = [SELECT Id FROM Account LIMIT 1];
		Final Id apRT = [SELECT Id FROM RecordType WHERE DeveloperName = 'Account_Planning' LIMIT 1].Id;
		Final acpl__Account_Planning__c ap = new acpl__Account_Planning__c(acpl__participant_id__c = cuenta.Id, acpl__external_reference_id__c = 'AP123', Name = 'AP record',
		                                                                   acpl__gf_ap_limit_date__c = System.today() + 1, acpl__proposal_manager_id__c = userOwner.Id,
		                                                                   acpl__gf_ap_launch_name__c = 'Period by priority', acpl__gf_ap_status_type_name__c = 'Not started',
		                                                                   recordTypeId = apRT);
		insert ap;
		ap.acpl__gf_ap_limit_date__c = System.today() + 31;
		update ap;
		Be_DTP_ResponseModel_cls.Response response = new Be_DTP_ResponseModel_cls.Response();
		Test.startTest();
		System.runAs(UserOwner) {
			Final Be_DTP_ResponseModel_cls singleClass = (Be_DTP_ResponseModel_cls)Type.forName('BE_AccountPlanning_HomeView_cls').newInstance();
			response = singleClass.getData('closed_next_month');
		}
		Test.stopTest();
		Final Boolean condition = response.isSuccess;
		System.assert (condition, fail);
	}

	/*
	 * @Description  method getDataGOFNotStarted
	 */
	public static testmethod void getDataGOFNotStarted() {
		Final User userOwner = [SELECT Id FROM User WHERE User.prof_position_id__c = 'E01' AND isActive = true LIMIT 1];
		Final Account cuenta = [SELECT Id FROM Account LIMIT 1];
		Final Id apRT = [SELECT Id FROM RecordType WHERE DeveloperName = 'Account_Planning' LIMIT 1].Id;
		Final acpl__Account_Planning__c ap = new acpl__Account_Planning__c(acpl__participant_id__c = cuenta.Id, acpl__external_reference_id__c = 'AP123', Name = 'AP record',
		                                                                   acpl__gf_ap_limit_date__c = System.today() + 1, acpl__proposal_manager_id__c = userOwner.Id,
		                                                                   acpl__gf_ap_launch_name__c = 'Period by priority', acpl__gf_ap_status_type_name__c = 'Not started',
		                                                                   recordTypeId = apRT);
		insert ap;
		Be_DTP_ResponseModel_cls.Response response = new Be_DTP_ResponseModel_cls.Response();
		Test.startTest();
		System.runAs(UserOwner) {
			Final Be_DTP_ResponseModel_cls singleClass = (Be_DTP_ResponseModel_cls)Type.forName('BE_AP_HomeView_GOF_cls').newInstance();
			response = singleClass.getData('not_started');
		}
		Test.stopTest();
		Final Boolean condition = response.isSuccess;
		System.assert (condition, 'Success');
	}

	/*
	 * @Description  method getDataGOFInProgress
	 */
	public static testmethod void getDataGOFInProgress() {
		Final User userOwner = [SELECT Id FROM User WHERE User.prof_position_id__c = 'E01' AND isActive = true LIMIT 1];
		Final Account cuenta = [SELECT Id FROM Account LIMIT 1];
		Final Id apRT = [SELECT Id FROM RecordType WHERE DeveloperName = 'Account_Planning' LIMIT 1].Id;
		Final acpl__Account_Planning__c ap = new acpl__Account_Planning__c(acpl__participant_id__c = cuenta.Id, acpl__external_reference_id__c = 'AP123', Name = 'AP record',
		                                                                   acpl__gf_ap_limit_date__c = System.today() + 1, acpl__proposal_manager_id__c = userOwner.Id,
		                                                                   acpl__gf_ap_launch_name__c = 'Period by priority', acpl__gf_ap_status_type_name__c = 'Not started',
		                                                                   recordTypeId = apRT);
		insert ap;
		ap.acpl__gf_ap_status_type_name__c = 'In Progress';
		update ap;
		Be_DTP_ResponseModel_cls.Response response = new Be_DTP_ResponseModel_cls.Response();
		Test.startTest();
		System.runAs(UserOwner) {
			Final Be_DTP_ResponseModel_cls singleClass = (Be_DTP_ResponseModel_cls)Type.forName('BE_AP_HomeView_GOF_cls').newInstance();
			response = singleClass.getData('in_progress');
		}
		Test.stopTest();
		Final Boolean condition = response.isSuccess;
		System.assert (condition, fail);
	}

	/*
	 * @Description  method getDataGOFPending
	 */
	public static testmethod void getDataGOFPending() {
		Final User userOwner = [SELECT Id FROM User WHERE User.prof_position_id__c = 'E01' AND isActive = true LIMIT 1];
		Final Account cuenta = [SELECT Id FROM Account LIMIT 1];
		Final Id apRT = [SELECT Id FROM RecordType WHERE DeveloperName = 'Account_Planning' LIMIT 1].Id;
		Final acpl__Account_Planning__c ap = new acpl__Account_Planning__c(acpl__participant_id__c = cuenta.Id, acpl__external_reference_id__c = 'AP123', Name = 'AP record',
		                                                                   acpl__gf_ap_limit_date__c = System.today() + 1, acpl__proposal_manager_id__c = userOwner.Id,
		                                                                   acpl__gf_ap_launch_name__c = 'Period by priority', acpl__gf_ap_status_type_name__c = 'Not started',
		                                                                   recordTypeId = apRT);
		insert ap;
		ap.acpl__gf_ap_status_type_name__c = 'Pending Validation';
		ap.acpl__gf_ap_substatus_type_name__c = 'Pending validation';
		update ap;
		Be_DTP_ResponseModel_cls.Response response = new Be_DTP_ResponseModel_cls.Response();
		Test.startTest();
		System.runAs(UserOwner) {
			Final Be_DTP_ResponseModel_cls singleClass = (Be_DTP_ResponseModel_cls)Type.forName('BE_AP_HomeView_GOF_cls').newInstance();
			response = singleClass.getData('pending_validation');
		}
		Test.stopTest();
		Final Boolean condition = response.isSuccess;
		System.assert (condition, fail);
	}

	/*
	 * @Description  method getDataGOFValidated
	 */
	public static testmethod void getDataGOFValidated() {
		Final User userOwner = [SELECT Id FROM User WHERE User.prof_position_id__c = 'E01' AND isActive = true LIMIT 1];
		Final Account cuenta = [SELECT Id FROM Account LIMIT 1];
		Final Id apRT = [SELECT Id FROM RecordType WHERE DeveloperName = 'Account_Planning' LIMIT 1].Id;
		Final acpl__Account_Planning__c ap = new acpl__Account_Planning__c(acpl__participant_id__c = cuenta.Id, acpl__external_reference_id__c = 'AP123', Name = 'AP record',
		                                                                   acpl__gf_ap_limit_date__c = System.today() + 1, acpl__proposal_manager_id__c = userOwner.Id,
		                                                                   acpl__gf_ap_launch_name__c = 'Period by priority', acpl__gf_ap_status_type_name__c = 'Not started',
		                                                                   recordTypeId = apRT);
		insert ap;
		ap.acpl__gf_ap_status_type_name__c = 'Validated';
		ap.acpl__gf_ap_substatus_type_name__c = 'In place';
		update ap;
		Be_DTP_ResponseModel_cls.Response response = new Be_DTP_ResponseModel_cls.Response();
		Test.startTest();
		System.runAs(UserOwner) {
			Final Be_DTP_ResponseModel_cls singleClass = (Be_DTP_ResponseModel_cls)Type.forName('BE_AP_HomeView_GOF_cls').newInstance();
			response = singleClass.getData('validated');
		}
		Test.stopTest();
		Final Boolean condition = response.isSuccess;
		System.assert (condition, fail);
	}

	/*
	 * @Description  method getDataGOFCloseThisM
	 */
	public static testmethod void getDataGOFCloseThisM() {
		Final User userOwner = [SELECT Id FROM User WHERE User.prof_position_id__c = 'E01' AND isActive = true LIMIT 1];
		Final Account cuenta = [SELECT Id FROM Account LIMIT 1];
		Final Id apRT = [SELECT Id FROM RecordType WHERE DeveloperName = 'Account_Planning' LIMIT 1].Id;
		Final acpl__Account_Planning__c ap = new acpl__Account_Planning__c(acpl__participant_id__c = cuenta.Id, acpl__external_reference_id__c = 'AP123', Name = 'AP record',
		                                                                   acpl__gf_ap_limit_date__c = System.today() + 1, acpl__proposal_manager_id__c = userOwner.Id,
		                                                                   acpl__gf_ap_launch_name__c = 'Period by priority', acpl__gf_ap_status_type_name__c = 'Not started',
		                                                                   recordTypeId = apRT);
		insert ap;
		ap.acpl__gf_ap_limit_date__c = System.today();
		update ap;
		Be_DTP_ResponseModel_cls.Response response = new Be_DTP_ResponseModel_cls.Response();
		Test.startTest();
		System.runAs(UserOwner) {
			Final Be_DTP_ResponseModel_cls singleClass = (Be_DTP_ResponseModel_cls)Type.forName('BE_AP_HomeView_GOF_cls').newInstance();
			response = singleClass.getData('closed_this_month');
		}
		Test.stopTest();
		Final Boolean condition = response.isSuccess;
		System.assert (condition, fail);
	}

	/*
	 * @Description  method getDataGOFClosedNextM
	 */
	public static testmethod void getDataGOFClosedNextM() {
		Final User userOwner = [SELECT Id FROM User WHERE User.prof_position_id__c = 'E01' AND isActive = true LIMIT 1];
		Final Account cuenta = [SELECT Id FROM Account LIMIT 1];
		Final Id apRT = [SELECT Id FROM RecordType WHERE DeveloperName = 'Account_Planning' LIMIT 1].Id;
		Final acpl__Account_Planning__c ap = new acpl__Account_Planning__c(acpl__participant_id__c = cuenta.Id, acpl__external_reference_id__c = 'AP123', Name = 'AP record',
		                                                                   acpl__gf_ap_limit_date__c = System.today() + 1, acpl__proposal_manager_id__c = userOwner.Id,
		                                                                   acpl__gf_ap_launch_name__c = 'Period by priority', acpl__gf_ap_status_type_name__c = 'Not started',
		                                                                   recordTypeId = apRT);
		insert ap;
		ap.acpl__gf_ap_limit_date__c = System.today() + 31;
		update ap;
		Be_DTP_ResponseModel_cls.Response response = new Be_DTP_ResponseModel_cls.Response();
		Test.startTest();
		System.runAs(UserOwner) {
			Final Be_DTP_ResponseModel_cls singleClass = (Be_DTP_ResponseModel_cls)Type.forName('BE_AP_HomeView_GOF_cls').newInstance();
			response = singleClass.getData('closed_next_month');
		}
		Test.stopTest();
		Final Boolean condition = response.isSuccess;
		System.assert (condition, fail);
	}
}