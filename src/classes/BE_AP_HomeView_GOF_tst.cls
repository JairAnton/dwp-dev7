/**
 * ------------------------------------------------------------------------------------------------
 * @Name BE_AP_HomeView_GOF_tst
 * @Author Diego Carbajal diego.carbajal@bbva.com
 * @Date Created: 2020-06-01
 * @Group
 * @Description Test class BE_AP_HomeView_GOF_cls
 *
 */
@isTest
public class BE_AP_HomeView_GOF_tst {

    /** @Description  variable FAIL*/
	private static Final String FAIL = 'FAIL';
    /** @Description  variable HOME_CLASS_GOF*/
    private static Final String HOME_CLASS_GOF = 'BE_AP_HomeView_GOF_cls';
    /** @Description  variable EXT_ID*/
    private static FINAL String EXT_ID = 'ap123';
    /** @Description  variable PERIOD_PRORITY*/
    private static FINAL String PERIOD_PRIORITY = 'period by priority';
    /** @Description  variable NOT_STARTED*/
    private static FINAL String NOT_STARTED = 'Not started';
    
    /*
	 * @Description  method setUp
	 */
	@TestSetup
	public static void setUp() {
		//La metadata de Be_Dynamic_Table_Presentation__mdt ya existe ne la org
		//Create Account
		Map<Schema.SObjectField, Object> mapFields = new Map<Schema.SObjectField, Object> {Account.OwnerId => UserInfo.getUserId(), Account.Name => 'CLIENTE MARTíN'};
		TestFactory.getAccount(true, mapFields);
		Final String perfil = [SELECT Id FROM Profile WHERE name = 'Ejecutivo'].Id;
		// GOF
		mapFields = new Map<Schema.SObjectField, Object> {User.LastName => 'Risotto', User.ProfileId => perfil,
			                                              User.prof_position_id__c => 'E01'};
		TestFactory.getUser(true, mapFields);
	}
    
    /*
	 * @Description  method getDataGOFNotStarted
	 */
	public static testmethod void getDataGOFNotStarted() {
		Final User userOwner = [SELECT Id FROM User WHERE User.prof_position_id__c = 'E01' AND isActive = true LIMIT 1];
		Final Account cuenta = [SELECT Id FROM Account LIMIT 1];
		Final Id apRT = [SELECT Id FROM RecordType WHERE DeveloperName = 'Account_Planning' LIMIT 1].Id;
		Final acpl__Account_Planning__c apR = new acpl__Account_Planning__c(acpl__participant_id__c = cuenta.Id, acpl__external_reference_id__c = EXT_ID, Name = EXT_ID,
		                                                                   acpl__gf_ap_limit_date__c = System.today() + 1, acpl__proposal_manager_id__c = userOwner.Id,
		                                                                   acpl__gf_ap_launch_name__c = PERIOD_PRIORITY, acpl__gf_ap_status_type_name__c = NOT_STARTED,
		                                                                   recordTypeId = apRT);
		insert apR;
		Be_DTP_ResponseModel_cls.Response response = new Be_DTP_ResponseModel_cls.Response();
		Test.startTest();
		System.runAs(UserOwner) {
			Final Be_DTP_ResponseModel_cls singleClass = (Be_DTP_ResponseModel_cls)Type.forName(HOME_CLASS_GOF).newInstance();
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
		Final acpl__Account_Planning__c apR = new acpl__Account_Planning__c(acpl__participant_id__c = cuenta.Id, acpl__external_reference_id__c = EXT_ID, Name = EXT_ID,
		                                                                   acpl__gf_ap_limit_date__c = System.today() + 1, acpl__proposal_manager_id__c = userOwner.Id,
		                                                                   acpl__gf_ap_launch_name__c = PERIOD_PRIORITY, acpl__gf_ap_status_type_name__c = NOT_STARTED,
		                                                                   recordTypeId = apRT);
		insert apR;
		apR.acpl__gf_ap_status_type_name__c = 'In Progress';
		update apR;
		Be_DTP_ResponseModel_cls.Response response = new Be_DTP_ResponseModel_cls.Response();
		Test.startTest();
		System.runAs(UserOwner) {
			Final Be_DTP_ResponseModel_cls singleClass = (Be_DTP_ResponseModel_cls)Type.forName(HOME_CLASS_GOF).newInstance();
			response = singleClass.getData('in_progress');
		}
		Test.stopTest();
		Final Boolean condition = response.isSuccess;
		System.assert (condition, FAIL);
	}

	/*
	 * @Description  method getDataGOFPending
	 */
	public static testmethod void getDataGOFPending() {
		Final User userOwner = [SELECT Id FROM User WHERE User.prof_position_id__c = 'E01' AND isActive = true LIMIT 1];
		Final Account cuenta = [SELECT Id FROM Account LIMIT 1];
		Final Id apRT = [SELECT Id FROM RecordType WHERE DeveloperName = 'Account_Planning' LIMIT 1].Id;
		Final acpl__Account_Planning__c apR = new acpl__Account_Planning__c(acpl__participant_id__c = cuenta.Id, acpl__external_reference_id__c = EXT_ID, Name = EXT_ID,
		                                                                   acpl__gf_ap_limit_date__c = System.today() + 1, acpl__proposal_manager_id__c = userOwner.Id,
		                                                                   acpl__gf_ap_launch_name__c = PERIOD_PRIORITY, acpl__gf_ap_status_type_name__c = NOT_STARTED,
		                                                                   recordTypeId = apRT);
		insert apR;
		apR.acpl__gf_ap_status_type_name__c = 'Pending Validation';
		apR.acpl__gf_ap_substatus_type_name__c = 'Pending validation';
		update apR;
		Be_DTP_ResponseModel_cls.Response response = new Be_DTP_ResponseModel_cls.Response();
		Test.startTest();
		System.runAs(UserOwner) {
			Final Be_DTP_ResponseModel_cls singleClass = (Be_DTP_ResponseModel_cls)Type.forName(HOME_CLASS_GOF).newInstance();
			response = singleClass.getData('pending_validation');
		}
		Test.stopTest();
		Final Boolean condition = response.isSuccess;
		System.assert (condition, FAIL);
	}

	/*
	 * @Description  method getDataGOFValidated
	 */
	public static testmethod void getDataGOFValidated() {
		Final User userOwner = [SELECT Id FROM User WHERE User.prof_position_id__c = 'E01' AND isActive = true LIMIT 1];
		Final Account cuenta = [SELECT Id FROM Account LIMIT 1];
		Final Id apRT = [SELECT Id FROM RecordType WHERE DeveloperName = 'Account_Planning' LIMIT 1].Id;
		Final acpl__Account_Planning__c apR = new acpl__Account_Planning__c(acpl__participant_id__c = cuenta.Id, acpl__external_reference_id__c = EXT_ID, Name = EXT_ID,
		                                                                   acpl__gf_ap_limit_date__c = System.today() + 1, acpl__proposal_manager_id__c = userOwner.Id,
		                                                                   acpl__gf_ap_launch_name__c = PERIOD_PRIORITY, acpl__gf_ap_status_type_name__c = 'Not started',
		                                                                   recordTypeId = apRT);
		insert apR;
        apR.acpl__gf_ap_status_type_name__c = 'Validated';
		apR.acpl__gf_ap_substatus_type_name__c = 'In place';
		update apR;
		Be_DTP_ResponseModel_cls.Response response = new Be_DTP_ResponseModel_cls.Response();
		Test.startTest();
		System.runAs(UserOwner) {
			Final Be_DTP_ResponseModel_cls singleClass = (Be_DTP_ResponseModel_cls)Type.forName(HOME_CLASS_GOF).newInstance();
			response = singleClass.getData('validated');
		}
		Test.stopTest();
		System.assert (response.isSuccess, FAIL);
	}

	/*
	 * @Description  method getDataGOFCloseThisM
	 */
	public static testmethod void getDataGOFCloseThisM() {
		Final User userOwner = [SELECT Id FROM User WHERE User.prof_position_id__c = 'E01' AND isActive = true LIMIT 1];
		Final Account cuenta = [SELECT Id FROM Account LIMIT 1];
		Final Id apRT = [SELECT Id FROM RecordType WHERE DeveloperName = 'Account_Planning' LIMIT 1].Id;
		Final acpl__Account_Planning__c apR = new acpl__Account_Planning__c(acpl__participant_id__c = cuenta.Id, acpl__external_reference_id__c = EXT_ID, Name = EXT_ID,
		                                                                   acpl__gf_ap_limit_date__c = System.today() + 1, acpl__proposal_manager_id__c = userOwner.Id,
		                                                                   acpl__gf_ap_launch_name__c = PERIOD_PRIORITY, acpl__gf_ap_status_type_name__c = NOT_STARTED,
		                                                                   recordTypeId = apRT);
		insert apR;
		apR.acpl__gf_ap_limit_date__c = System.today();
		update apR;
		Be_DTP_ResponseModel_cls.Response response = new Be_DTP_ResponseModel_cls.Response();
		Test.startTest();
		System.runAs(UserOwner) {
			Final Be_DTP_ResponseModel_cls singleClass = (Be_DTP_ResponseModel_cls)Type.forName(HOME_CLASS_GOF).newInstance();
			response = singleClass.getData('closed_this_month');
		}
		Test.stopTest();
		Final Boolean condition = response.isSuccess;
		System.assert (condition, FAIL);
	}

	/*
	 * @Description  method getDataGOFClosedNextM
	 */
	public static testmethod void getDataGOFClosedNextM() {
		Final User userOwner = [SELECT Id FROM User WHERE User.prof_position_id__c = 'E01' AND isActive = true LIMIT 1];
		Final Account cuenta = [SELECT Id FROM Account LIMIT 1];
		Final Id apRT = [SELECT Id FROM RecordType WHERE DeveloperName = 'Account_Planning' LIMIT 1].Id;
		Final acpl__Account_Planning__c apR = new acpl__Account_Planning__c(acpl__participant_id__c = cuenta.Id, acpl__external_reference_id__c = EXT_ID, Name = EXT_ID,
		                                                                   acpl__gf_ap_limit_date__c = System.today() + 1, acpl__proposal_manager_id__c = userOwner.Id,
		                                                                   acpl__gf_ap_launch_name__c = PERIOD_PRIORITY, acpl__gf_ap_status_type_name__c = NOT_STARTED,
		                                                                   recordTypeId = apRT);
		insert apR;
		apR.acpl__gf_ap_limit_date__c = System.today() + 31;
		update apR;
		Be_DTP_ResponseModel_cls.Response response = new Be_DTP_ResponseModel_cls.Response();
		Test.startTest();
		System.runAs(UserOwner) {
			Final Be_DTP_ResponseModel_cls singleClass = (Be_DTP_ResponseModel_cls)Type.forName(HOME_CLASS_GOF).newInstance();
			response = singleClass.getData('closed_next_month');
		}
		Test.stopTest();
		Final Boolean condition = response.isSuccess;
		System.assert (condition, FAIL);
	}
}