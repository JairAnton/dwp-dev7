/**
 * Test class BE_AP_CheckEditionByPeriodSchedl_tst for BE_AP_CheckEditionByPeriodBatchHandler,
 * BE_AP_CheckEditionByPeriodBatch and BE_AP_CheckEditionByPeriodSchedulable
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
public class BE_AP_CheckEditionByPeriodSchdl_tst {
	/*
	 * @Description  method setUp
	 */
	@TestSetup
	public static void setUp() {
		AP_FactoryTest_tst.forSetUp();
		Final User admin = [SELECT Id FROM User WHERE Id =:UserInfo.getUserId()];
		System.runAs(admin) {
			insert new acpl__Account_Plan_Settings__c(SetupOwnerId = UserInfo.getOrganizationId(), acpl__Edition_Schedulable_batch_size__c = 200,
			                                          acpl__Member_Role__c = 'Gestor del Plan', acpl__NotificationSchedulable_batch_size__c = 200,
			                                          acpl__Timed_Out_Schedulable_batch_size__c = 200);
			Final User usuario = [SELECT Id FROM User WHERE LastName LIKE 'EJECUTIVO' LIMIT 1];
			Final Account[] lstAccount = new Account[] {};
			for(Integer i = 0; i < 20; i++) {
				lstAccount.add(new Account(name = 'Acc ' + i));
			}
			insert lstAccount;
			Final acpl__Account_Planning__c[] lstAP = new acpl__Account_Planning__c[] {};
			for(Integer i = 0; i < 20; i++) {
				if(math.mod(i, 2) == 0) {
					lstAP.add(TestFactory.createAccountPlanning(lstAccount[i].Id, usuario.Id, null, false));
				} else {
					lstAP.add(TestFactory.createAccountPlanning(lstAccount[i].Id, usuario.Id, null, true));
				}
			}
			Integer i = 0;
			for(acpl__Account_Planning__c ap:lstAP) {
				if(i < 5) {
					ap = getAP(ap, 'General period', Date.today() - 1);
				} else if(i < 10) {
					ap = getAP(ap, 'Period by priority', Date.today() + 1);
				} else if(i < 15) {
					ap = getAP(ap, 'Event driven', Date.today() - 1);
				} else {
					ap = getAP(ap, 'Event driven', Date.today());
				}
				i++;
			}
			insert lstAP;
		}
	}

	/*
	 * @Description  method setGeneralAPUnlock
	 */
	public static testmethod void setGeneralAPUnlock() {
		setGeneral(System.today(), System.today() + 1, null);
		Test.startTest();
		Final BE_AP_CheckEditionByPeriodSchedulable batch = new BE_AP_CheckEditionByPeriodSchedulable();
		batch.execute(null);
		Test.stopTest();
		Final acpl__Account_Planning__c[] lstAP = [SELECT Id FROM acpl__Account_Planning__c WHERE acpl__gf_ap_indvi_lock_edit_ind_type__c = true AND
		                                                                                                                                    RecordType.DeveloperName = 'Account_Planning' AND acpl__gf_ap_launch_name__c = 'General period'];
		Final Integer size = lstAP.size();
		System.assertEquals(size, 5, 'Fail');
	}

	/*
	 * @Description  method setGeneralAPlock
	 */
	public static testmethod void setGeneralAPlock() {
		setGeneral(System.today() - 2, System.today() - 1, null);
		Test.startTest();
		Final BE_AP_CheckEditionByPeriodSchedulable batch = new BE_AP_CheckEditionByPeriodSchedulable();
		batch.execute(null);
		Test.stopTest();
		Final acpl__Account_Planning__c[] lstAP = [SELECT Id FROM acpl__Account_Planning__c WHERE acpl__gf_ap_indvi_lock_edit_ind_type__c = false AND
		                                                                                                                                    RecordType.DeveloperName = 'Account_Planning' AND acpl__gf_ap_launch_name__c = 'General period'];
		Final Integer size = lstAP.size();
		System.assertEquals(size, 5, 'Fail');
	}

	/*
	 * @Description  method setPriorityAPlock
	 */
	public static testmethod void setPriorityAPlock() {
		setPriority(System.today() - 2, System.today() - 1, null);
		Test.startTest();
		Final BE_AP_CheckEditionByPeriodSchedulable batch = new BE_AP_CheckEditionByPeriodSchedulable();
		batch.execute(null);
		Test.stopTest();
		Final acpl__Account_Planning__c[] lstAP = [SELECT Id FROM acpl__Account_Planning__c WHERE acpl__gf_ap_indvi_lock_edit_ind_type__c = false AND
		                                                                                                                                    RecordType.DeveloperName = 'Account_Planning' AND acpl__gf_ap_launch_name__c = 'Period by priority'];
		Final Integer size = lstAP.size();
		System.assertEquals(size, 5, 'Fail');
	}

	/*
	 * @Description  method setPriorityAPUnlock
	 */
	public static testmethod void setPriorityAPUnlock() {
		setPriority(System.today(), System.today() + 1, null);
		Test.startTest();
		Final BE_AP_CheckEditionByPeriodSchedulable batch = new BE_AP_CheckEditionByPeriodSchedulable();
		batch.execute(null);
		Test.stopTest();
		Final acpl__Account_Planning__c[] lstAP = [SELECT Id FROM acpl__Account_Planning__c WHERE acpl__gf_ap_indvi_lock_edit_ind_type__c = true AND
		                                                                                                                                    RecordType.DeveloperName = 'Account_Planning' AND acpl__gf_ap_launch_name__c = 'Period by priority'];
		Final Integer size = lstAP.size();
		System.assertEquals(size, 5, 'Fail');
	}

	/*
	 * @Description  method setEventInitAPUnLock
	 */
	public static testmethod void setEventInitAPUnLock() {
		setGeneral(System.today(), System.today() + 1, 2);
		Test.startTest();
		Final BE_AP_CheckEditionByPeriodSchedulable batch = new BE_AP_CheckEditionByPeriodSchedulable();
		batch.execute(null);
		Test.stopTest();
		Final acpl__Account_Planning__c[] lstAP = [SELECT Id FROM acpl__Account_Planning__c WHERE acpl__gf_ap_indvi_lock_edit_ind_type__c = true AND
		                                                                                                                                    RecordType.DeveloperName = 'Account_Planning' AND acpl__gf_ap_launch_name__c = 'Event driven'];
		Final Integer size = lstAP.size();
		System.assertEquals(size, 10, 'Fail');
	}

	/*
	 * @Description  method setEventEndAPUnLock
	 */
	public static testmethod void setEventEndAPUnLock() {
		setGeneral(System.today(), System.today() + 1, -2);
		Test.startTest();
		Final BE_AP_CheckEditionByPeriodSchedulable batch = new BE_AP_CheckEditionByPeriodSchedulable();
		batch.execute(null);
		Test.stopTest();
		Final acpl__Account_Planning__c[] lstAP = [SELECT Id FROM acpl__Account_Planning__c WHERE acpl__gf_ap_indvi_lock_edit_ind_type__c = true AND
		                                                                                                                                    RecordType.DeveloperName = 'Account_Planning' AND acpl__gf_ap_launch_name__c = 'Event driven'];
		Final Integer size = lstAP.size();
		System.assertEquals(size, 10, 'Fail');
	}

	/*
	 * @Description  method setGeneral
	 */
	private static void setGeneral(Date inicio, Date fin, Integer leftDays) {
		delete [SELECT Id FROM acpl__AP_PeriodConfiguration__c];
		delete [SELECT Id FROM acpl__AP_Period__c];
		insert new acpl__AP_PeriodConfiguration__c(acpl__gf_ap_edit_prms_type_name__c = 'General',
		                                           acpl__gf_ap_edit_days_left_number__c = leftDays,
		                                           acpl__gf_ap_genrl_lock_edit_ind_type__c = false);
		insert new acpl__AP_Period__c(acpl__gf_ap_edit_start_date__c = inicio, acpl__gf_ap_edit_end_date__c = fin);
	}

	/*
	 * @Description  method setPriority
	 */
	private static void setPriority(Date inicio, Date fin, Integer leftDays) {
		delete [SELECT Id FROM acpl__AP_PeriodConfiguration__c];
		delete [SELECT Id FROM acpl__AP_Period__c];
		insert new acpl__AP_PeriodConfiguration__c(acpl__gf_ap_edit_prms_type_name__c = 'Priority',
		                                           acpl__gf_ap_edit_days_left_number__c = leftDays,
		                                           acpl__gf_ap_genrl_lock_edit_ind_type__c = false);
		Final List<acpl__AP_Period__c> period = new List<acpl__AP_Period__c> {new acpl__AP_Period__c(acpl__gf_ap_edit_start_date__c = inicio,
			                                                                                         acpl__gf_ap_edit_end_date__c = fin, acpl__gf_ap_priority_edit_type__c = 'High'),
			                                                                  new acpl__AP_Period__c(acpl__gf_ap_edit_start_date__c = inicio, acpl__gf_ap_edit_end_date__c = fin, acpl__gf_ap_priority_edit_type__c = 'Medium'),
			                                                                  new acpl__AP_Period__c(acpl__gf_ap_edit_start_date__c = inicio, acpl__gf_ap_edit_end_date__c = fin, acpl__gf_ap_priority_edit_type__c = 'Low')};
		insert period;
	}

	/*
	 * @Description  method getAP
	 */
	private static acpl__Account_Planning__c getAP(acpl__Account_Planning__c ap, String type, Date fecha) {
		ap.acpl__gf_ap_launch_name__c = type;
		ap.acpl__gf_event_date__c = fecha;
		return ap;
	}
}
