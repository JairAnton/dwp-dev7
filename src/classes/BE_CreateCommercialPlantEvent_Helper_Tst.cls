/**@Name <BE_CreateCommercialPlantEvent_Tst>
   @Author Jair Anton Atuncar (jair.anton.contractor@bbva.com)
   Date        Author   Email                  				Type
   2021-08-19  JAAA    jair.anton.contractor@bbva.com		Creation
   -------------------------------------------------------------------------------------------------
 */
@isTest
public class BE_CreateCommercialPlantEvent_Helper_Tst {
    /** @Description VALIDATED*/
    Final static String VALIDATED = 'Validated';
    /** @Description IN_PROGRESS*/
    Final static String IN_PROGRESS = 'In Progress';
    /** @Description PRE_VALIDATED*/
    Final static String PRE_VALIDATED = 'Pre-validated';
    /**@Description IN_PLACE */
    Final static String IN_PLACE = 'In place';
    /**@Description FAILED */
    Final static String FAILED = 'Failed';
    /**@Description SUCCESS */
    Final static String SUCCESS = 'Success';
    /**@Description TASK */
    Final static String TASK = 'Task';
    /**@Description RECORD_NAME */ 
    Final static String RECORD_NAME = 'AP_RECORD_102 - 2020-05-31';

    /*Setup Data*/
    @TestSetup
    public static void setUp() {
        final List<String> sObjNames=new List<String>{'acpl__Account_Planning__c'};
        final Map<String,Schema.RecordTypeInfo> recordType = BE_General_Utils.getRecordTypeInfo(sObjNames);
        
        final User userExecutiveO = TestFactory.createUser('userExecutiveOwner','Ejecutivo');
        final Account acc = TestFactory.createAccount();        
        
        insert new acpl__Account_Planning__c(Name = 'Account_Planning Test', acpl__gf_ap_indvi_lock_edit_ind_type__c = true,
                                             acpl__gf_ap_limit_date__c = System.today().addDays(90), acpl__gf_ap_public_ind_type__c = true, 
                                             acpl__gf_ap_status_type_name__c = 'Not started', acpl__proposal_manager_id__c = userExecutiveO.Id, 
                                             acpl__participant_id__c = acc.Id, recordTypeId = recordType.get('Account_Planning').getRecordTypeId());
    }
    
    /**
     @Description test updateRecords method, correct scenary task
    */
    @isTest
    static void updateRecordsTaskTest() {
        Final acpl__Account_Planning__c accPlan = [SELECT Id, acpl__participant_id__c FROM acpl__Account_Planning__c LIMIT 1][0];
        Final acpl__Commercial_Plan_Event__c evt1 = new acpl__Commercial_Plan_Event__c(Name = RECORD_NAME, acpl__gf_account_planning_id__c = accPlan.Id, acpl__gf_comm_plan_event_type_name__c = TASK, 
                                                            acpl__gf_event_date__c = System.today(), acpl__participant_id__c = accPlan.acpl__participant_id__c);
        
        Final List<SObject> sObjs = new List<SObject>();
        sObjs.add(evt1);
        
        new BE_CreateCommercialPlantEvent_cls().createRecords(sObjs);

        Test.startTest();
        
		accPlan.acpl__gf_ap_status_type_name__c = VALIDATED;
        accPlan.acpl__gf_ap_substatus_type_name__c = IN_PLACE;
        accPlan.acpl__gf_ap_indvi_lock_edit_ind_type__c = false;
        update accPlan;

		accPlan.acpl__gf_ap_status_type_name__c = IN_PROGRESS;
        accPlan.acpl__gf_ap_substatus_type_name__c = PRE_VALIDATED;
        accPlan.acpl__gf_ap_indvi_lock_edit_ind_type__c = true;
        update accPlan;

        final BE_SingleRelatedListCRUD_Cls.Response resp = new BE_CreateCommercialPlantEvent_cls().updateRecords(sObjs);
        Test.stopTest();
        System.assert(!resp.isSuccess, FAILED);
    }
    
    /**
     @Description test deleteRecords method, correct scenary 
    */
    @isTest
    static void deleteRecordsTest() {
        final acpl__Account_Planning__c accPlan = [SELECT Id, acpl__participant_id__c FROM acpl__Account_Planning__c LIMIT 1][0];
        final acpl__Commercial_Plan_Event__c planEvt = new acpl__Commercial_Plan_Event__c();
        planEvt.Name = RECORD_NAME;
        planEvt.acpl__gf_account_planning_id__c = accPlan.Id;
        planEvt.acpl__gf_comm_plan_event_type_name__c = TASK;
        planEvt.acpl__gf_event_date__c = System.today();
        planEvt.acpl__participant_id__c = accPlan.acpl__participant_id__c;
        final List<SObject> sObjs = new List<SObject>();
        sObjs.add(planEvt);
        
        new BE_CreateCommercialPlantEvent_cls().createRecords(sObjs);

        Test.startTest();

        final BE_SingleRelatedListCRUD_Cls.Response resp = new BE_CreateCommercialPlantEvent_cls().deleteRecords(sObjs);
        Test.stopTest();
        System.assert(resp.isSuccess, SUCCESS);
    }

    /**
     @Description test deleteRecords method, correct scenary visit
    */
    @isTest
    static void deleteRecordsVisitTest() {
        Final acpl__Account_Planning__c accPlan = [SELECT Id, acpl__participant_id__c FROM acpl__Account_Planning__c LIMIT 1][0];
        Final acpl__Commercial_Plan_Event__c evt3 = new acpl__Commercial_Plan_Event__c(Name = RECORD_NAME, acpl__gf_account_planning_id__c = accPlan.Id, acpl__gf_comm_plan_event_type_name__c = 'Visit', 
                                                                acpl__gf_event_date__c = System.today(), acpl__participant_id__c = accPlan.acpl__participant_id__c);
        
        Final List<SObject> sObjs = new List<SObject>();
        sObjs.add(evt3);
        
        new BE_CreateCommercialPlantEvent_cls().createRecords(sObjs);

        Test.startTest();
        
		accPlan.acpl__gf_ap_status_type_name__c = VALIDATED;
        accPlan.acpl__gf_ap_substatus_type_name__c = IN_PLACE;
        accPlan.acpl__gf_ap_indvi_lock_edit_ind_type__c = false;
        update accPlan;

		accPlan.acpl__gf_ap_status_type_name__c = IN_PROGRESS;
        accPlan.acpl__gf_ap_substatus_type_name__c = PRE_VALIDATED;
        accPlan.acpl__gf_ap_indvi_lock_edit_ind_type__c = true;
        update accPlan;

        final BE_SingleRelatedListCRUD_Cls.Response resp = new BE_CreateCommercialPlantEvent_cls().deleteRecords(sObjs);
        Test.stopTest();
        System.assert(!resp.isSuccess, FAILED);
    }

    
    /**
     @Description test deleteRecords method, correct scenary opportunity
    */
    @isTest
    static void deleteRecordsOpportunityTest() {
        Final acpl__Account_Planning__c accPlan = [SELECT Id, acpl__participant_id__c FROM acpl__Account_Planning__c LIMIT 1][0];
        Final acpl__Commercial_Plan_Event__c evt2 = new acpl__Commercial_Plan_Event__c(Name = RECORD_NAME, acpl__gf_account_planning_id__c = accPlan.Id, acpl__gf_comm_plan_event_type_name__c = 'Opportunity', 
                                                                acpl__gf_event_date__c = System.today(), acpl__participant_id__c = accPlan.acpl__participant_id__c);
        
        Final List<SObject> sObjs = new List<SObject>();
        sObjs.add(evt2);
        
        new BE_CreateCommercialPlantEvent_cls().createRecords(sObjs);
        
        Test.startTest();
        
		accPlan.acpl__gf_ap_status_type_name__c = VALIDATED;
        accPlan.acpl__gf_ap_substatus_type_name__c = IN_PLACE;
        accPlan.acpl__gf_ap_indvi_lock_edit_ind_type__c = false;
        update accPlan;

		accPlan.acpl__gf_ap_status_type_name__c = IN_PROGRESS;
        accPlan.acpl__gf_ap_substatus_type_name__c = PRE_VALIDATED;
        accPlan.acpl__gf_ap_indvi_lock_edit_ind_type__c = true;
        update accPlan;

        final BE_SingleRelatedListCRUD_Cls.Response resp = new BE_CreateCommercialPlantEvent_cls().deleteRecords(sObjs);
        Test.stopTest();
        System.assert(!resp.isSuccess, FAILED);
    }

    /**
     @Description test deleteRecords method, correct scenary task
    */
    @isTest
    static void deleteRecordsTaskTest() {
        Final acpl__Account_Planning__c accPlan = [SELECT Id, acpl__participant_id__c FROM acpl__Account_Planning__c LIMIT 1][0];
        Final acpl__Commercial_Plan_Event__c evt1 = new acpl__Commercial_Plan_Event__c(Name = RECORD_NAME, acpl__gf_account_planning_id__c = accPlan.Id, acpl__gf_comm_plan_event_type_name__c = TASK, 
                                                            acpl__gf_event_date__c = System.today(), acpl__participant_id__c = accPlan.acpl__participant_id__c);
        
        Final List<SObject> sObjs = new List<SObject>();
        sObjs.add(evt1);
        
        new BE_CreateCommercialPlantEvent_cls().createRecords(sObjs);
        
        Test.startTest();
        
		accPlan.acpl__gf_ap_status_type_name__c = VALIDATED;
        accPlan.acpl__gf_ap_substatus_type_name__c = IN_PLACE;
        accPlan.acpl__gf_ap_indvi_lock_edit_ind_type__c = false;
        update accPlan;

		accPlan.acpl__gf_ap_status_type_name__c = IN_PROGRESS;
        accPlan.acpl__gf_ap_substatus_type_name__c = PRE_VALIDATED;
        accPlan.acpl__gf_ap_indvi_lock_edit_ind_type__c = true;
        update accPlan;

        final BE_SingleRelatedListCRUD_Cls.Response resp = new BE_CreateCommercialPlantEvent_cls().deleteRecords(sObjs);
        Test.stopTest();
        System.assert(!resp.isSuccess, FAILED);
    }
}
