/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_CreateCommercialPlantEvent_Tst>
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-06-04
   @Description test for BE_CreateCommercialPlantEvent_cls class
   @Changes
   Date        Author   Email                  				Type
   2020-06-04  MAMC     martin.mori.contractor@bbva.com		Creation
   -------------------------------------------------------------------------------------------------
 */
@isTest
public without sharing class BE_CreateCommercialPlantEvent_Tst {
    /*Setup Data*/
    @TestSetup
    public static void setUp() {
        final List<String> sObjNames=new List<String>{'acpl__Account_Planning__c'};
        final Map<String,Schema.RecordTypeInfo> recordType=BE_General_Utils.getRecordTypeInfo(sObjNames);
        
        final User userExecutiveOwner = TestFactory.createUser('userExecutiveOwner','Ejecutivo');
        final Account acc = TestFactory.createAccount();        
        
        final acpl__Account_Planning__c accPlan = new acpl__Account_Planning__c();
        accPlan.recordTypeId = recordType.get('Account_Planning').getRecordTypeId();
        accPlan.Name = 'Account_Planning Test';
        accPlan.acpl__gf_ap_indvi_lock_edit_ind_type__c = true;
        accPlan.acpl__gf_ap_limit_date__c = System.today().addDays(90);
        accPlan.acpl__gf_ap_public_ind_type__c = true;
        accPlan.acpl__gf_ap_status_type_name__c = 'Not started';
        accPlan.acpl__participant_id__c = acc.Id;
        accPlan.acpl__proposal_manager_id__c = userExecutiveOwner.Id;
        insert accPlan;
    }
    
    /**
     @Description test createRecords method, correct scenary
    */
    @isTest
    static void createRecordsTest() {
        final acpl__Account_Planning__c accPlan = [SELECT Id, acpl__participant_id__c FROM acpl__Account_Planning__c LIMIT 1][0];
        final acpl__Commercial_Plan_Event__c planEvt = new acpl__Commercial_Plan_Event__c();
        planEvt.Name = 'AP_RECORD_102 - 2020-05-31';
        planEvt.acpl__gf_account_planning_id__c = accPlan.Id;
        planEvt.acpl__gf_comm_plan_event_type_name__c = 'Task';
        planEvt.acpl__gf_event_date__c = System.today();
        planEvt.acpl__participant_id__c = accPlan.acpl__participant_id__c;
        final List<SObject> sObjs = new List<SObject>();
        sObjs.add(planEvt);
        
        Test.startTest();
        final BE_CreateCommercialPlantEvent_cls commPlanEvt = new BE_CreateCommercialPlantEvent_cls();
        final BE_SingleRelatedListCRUD_Cls.Response resp = commPlanEvt.createRecords(sObjs);
        System.assertEquals(resp.message, 'Successful', 'success!!!');
        Test.stopTest();
    }
    
    /**
     @Description test createRecords method, fail scenary
    */
    @isTest
    static void createRecordsNullTest() {
        Test.startTest();
        final BE_CreateCommercialPlantEvent_cls commPlanEvt = new BE_CreateCommercialPlantEvent_cls();
        final BE_SingleRelatedListCRUD_Cls.Response resp = commPlanEvt.createRecords(null);
        System.assert(!resp.isSuccess, 'fail!');
        Test.stopTest();
    }
    
    /**
     @Description test updateRecords method, correct scenary
    */
    @isTest
    static void updateRecordsTest() {
        final acpl__Account_Planning__c accPlan = [SELECT Id, acpl__participant_id__c FROM acpl__Account_Planning__c LIMIT 1][0];
        final User usrInactive = [SELECT Id FROM User WHERE IsActive = false AND Profile.Name = 'Ejecutivo' LIMIT 1][0];
        final User usrActive = [SELECT Id FROM User WHERE IsActive = true AND Profile.Name = 'Especialista' LIMIT 1][0];
        acpl__Commercial_Plan_Event__c planEvt = new acpl__Commercial_Plan_Event__c();
        planEvt.Name = 'AP_RECORD_102 - 2020-05-31';
        planEvt.acpl__gf_account_planning_id__c = accPlan.Id;
        planEvt.acpl__gf_comm_plan_event_type_name__c = 'Task';
        planEvt.acpl__gf_event_date__c = System.today();
        planEvt.acpl__participant_id__c = accPlan.acpl__participant_id__c;
        final List<SObject> sObjCreate = new List<SObject>();
        sObjCreate.add(planEvt);
        
        final BE_CreateCommercialPlantEvent_cls commPlanEvt1 = new BE_CreateCommercialPlantEvent_cls();
        commPlanEvt1.createRecords(sObjCreate);
        
        planEvt = [SELECT Id, acpl__gf_event_date__c, acpl__gf_account_planning_id__c, Asiggned_User__c FROM acpl__Commercial_Plan_Event__c LIMIT 1][0];
        
        Test.startTest();
        planEvt.acpl__gf_event_date__c = System.today().addDays(30);
        planEvt.Asiggned_User__c = usrInactive.Id;
        final List<SObject> sObjUpd1 = new List<SObject>();
        sObjUpd1.add(planEvt);
        final BE_CreateCommercialPlantEvent_cls commPlanEvt2 = new BE_CreateCommercialPlantEvent_cls();
        commPlanEvt2.updateRecords(sObjUpd1);
        
        planEvt.Asiggned_User__c = usrActive.Id;
        final List<SObject> sObjUpd2 = new List<SObject>();
        sObjUpd2.add(planEvt);
        final BE_CreateCommercialPlantEvent_cls commPlanEvt3 = new BE_CreateCommercialPlantEvent_cls();
        final BE_SingleRelatedListCRUD_Cls.Response resp = commPlanEvt3.updateRecords(sObjUpd2);
        System.assertEquals(resp.message, 'Successful');
        Test.stopTest();
    }
    
    /**
     @Description test updateRecords method, fail scenary
    */
    @isTest
    static void updateRecordsNullTest() {
        final BE_CreateCommercialPlantEvent_cls commPlanEvt = new BE_CreateCommercialPlantEvent_cls();
        Test.startTest();
        final BE_SingleRelatedListCRUD_Cls.Response resp  = commPlanEvt.updateRecords(null);
        System.assert(!resp.isSuccess, 'fail!');
        Test.stopTest();
    }
}