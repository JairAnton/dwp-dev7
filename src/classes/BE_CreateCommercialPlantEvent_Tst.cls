/**@Name <BE_CreateCommercialPlantEvent_Tst>
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   Date        Author   Email                  				Type
   2020-06-04  MAMC     martin.mori.contractor@bbva.com		Creation
   2020-10-09  DCP     diego.carbajal@bbva.com				Modified
   19/08/2021  JAA     jair.anton.contractor@bbva.com      Valida CPE creados.
   -------------------------------------------------------------------------------------------------
 */
@isTest
public without sharing class BE_CreateCommercialPlantEvent_Tst {
    /** @Description VALIDATED*/
    Final static String VALIDATED = 'Validated';
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
     @Description test readRecords method, correct scenary
    */
    @isTest
    static void readRecordsTest() {
        Final acpl__Account_Planning__c accPlan = [SELECT Id, acpl__participant_id__c FROM acpl__Account_Planning__c LIMIT 1][0];
        Final acpl__Commercial_Plan_Event__c evt1 = new acpl__Commercial_Plan_Event__c(Name = RECORD_NAME, acpl__gf_account_planning_id__c = accPlan.Id, acpl__gf_comm_plan_event_type_name__c = TASK, 
                                                            acpl__gf_event_date__c = System.today(), acpl__participant_id__c = accPlan.acpl__participant_id__c);
        Final acpl__Commercial_Plan_Event__c evt2 = new acpl__Commercial_Plan_Event__c(Name = RECORD_NAME, acpl__gf_account_planning_id__c = accPlan.Id, acpl__gf_comm_plan_event_type_name__c = 'Opportunity', 
                                                                acpl__gf_event_date__c = System.today(), acpl__participant_id__c = accPlan.acpl__participant_id__c);
        Final acpl__Commercial_Plan_Event__c evt3 = new acpl__Commercial_Plan_Event__c(Name = RECORD_NAME, acpl__gf_account_planning_id__c = accPlan.Id, acpl__gf_comm_plan_event_type_name__c = 'Visit', 
                                                                acpl__gf_event_date__c = System.today(), acpl__participant_id__c = accPlan.acpl__participant_id__c);
        
        Final List<SObject> sObjs = new List<SObject>();
        sObjs.add(evt1);
        
        new BE_CreateCommercialPlantEvent_cls().createRecords(sObjs);
        sObjs[0] = evt2;        
        new BE_CreateCommercialPlantEvent_cls().createRecords(sObjs);
        sObjs[0] = evt3;
        new BE_CreateCommercialPlantEvent_cls().createRecords(sObjs);

        Test.startTest();
		accPlan.acpl__gf_ap_status_type_name__c = VALIDATED;
        accPlan.acpl__gf_ap_substatus_type_name__c = IN_PLACE;
        accPlan.acpl__gf_ap_indvi_lock_edit_ind_type__c = false;
        update accPlan;

        
        Final Map<String,Object> apMap = new Map<String,Object>();
        apMap.put('recordId', accPlan.Id);

        final BE_SingleRelatedListCRUD_Cls.Response response = new BE_CreateCommercialPlantEvent_cls().readRecords(apMap);

        Test.stopTest();
        System.assert(response.isSuccess, SUCCESS);
    }


    /**
     @Description test createRecords method, correct scenary
    */
    @isTest
    static void createRecordsTest() {
        final acpl__Account_Planning__c accPlan = [SELECT Id, acpl__participant_id__c FROM acpl__Account_Planning__c LIMIT 1][0];
        final acpl__Commercial_Plan_Event__c planEvt = new acpl__Commercial_Plan_Event__c();
        planEvt.Name = RECORD_NAME;
        planEvt.acpl__gf_account_planning_id__c = accPlan.Id;
        planEvt.acpl__gf_comm_plan_event_type_name__c = TASK;
        planEvt.acpl__gf_event_date__c = System.today();
        planEvt.acpl__participant_id__c = accPlan.acpl__participant_id__c;
        final List<SObject> sObjs = new List<SObject>();
        sObjs.add(planEvt);
        
        Test.startTest();
        final BE_CreateCommercialPlantEvent_cls commPlanEvt = new BE_CreateCommercialPlantEvent_cls();
        final BE_SingleRelatedListCRUD_Cls.Response resp = commPlanEvt.createRecords(sObjs);
        System.assert(resp.isSuccess, SUCCESS);
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
        System.assert(!resp.isSuccess, FAILED);
        Test.stopTest();
    }
    
    /**
     @Description test updateRecords method, correct scenary
    */
    @isTest
    static void updateRecordsTest() {
        Final User usrInactive = [SELECT Id FROM User WHERE IsActive = false AND Profile.Name = 'Ejecutivo' LIMIT 1][0];
        Final User usrActive = [SELECT Id FROM User WHERE IsActive = true AND Profile.Name = 'Especialista' LIMIT 1][0];
        Final acpl__Account_Planning__c accPlan = [SELECT Id, acpl__participant_id__c FROM acpl__Account_Planning__c LIMIT 1][0];
        Final bupl__BusinessPlan__c bpAux = [SELECT Id, acpl__gf_account_planning_id__r.acpl__participant_id__c, acpl__gf_account_planning_id__r.Name
                                                     FROM bupl__BusinessPlan__c WHERE acpl__gf_account_planning_id__c = :accPlan.Id LIMIT 1];
        Final bupl__BP_GrowthDriver__c gdAux = new bupl__BP_GrowthDriver__c(acpl__gf_account_planning_id__c = accPlan.Id, bupl__gf_business_plan_id__c = bpAux.Id,
                                                                            CurrencyIsoCode = 'PEN', Amount__c = 123.4567, bupl__solution_category_id__c = 'Financiamiento a corto plazo', 
                                                                            bupl__solution_category_desc__c = '0160010_NEW', ExpectedDate__c = System.today());
        insert gdAux;
        acpl__Commercial_Plan_Event__c planEvt = new acpl__Commercial_Plan_Event__c();
        planEvt.Name = RECORD_NAME;
        planEvt.acpl__gf_account_planning_id__c = accPlan.Id;
        planEvt.acpl__gf_comm_plan_event_type_name__c = 'Opportunity';
        planEvt.acpl__gf_event_date__c = System.today();
        planEvt.acpl__participant_id__c = accPlan.acpl__participant_id__c;
        planEvt.GrowthDriver__c = gdAux.Id;
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
        System.assert(resp.isSuccess, SUCCESS);
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
        System.assert(!resp.isSuccess, FAILED);
        Test.stopTest();
    }
}