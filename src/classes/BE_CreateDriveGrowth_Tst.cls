/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_CreateDriveGrowth_Tst>
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-06-04
   @Description test for BE_CreateDriveGrowth_ctr class
   @Changes
   Date        Author   Email                  				Type
   2020-06-04  MAMC     martin.mori.contractor@bbva.com		Creation
   -------------------------------------------------------------------------------------------------
 */
@isTest
public without sharing class BE_CreateDriveGrowth_Tst {
    /*Setup Data*/
    @TestSetup
    public static void setUp() {
        final List<String> sObjNames=new List<String>{'acpl__Account_Planning__c'};
        final Map<String,Schema.RecordTypeInfo> recordType=BE_General_Utils.getRecordTypeInfo(sObjNames);
        
        final User userExecutive = TestFactory.createUser('userExecutiveOwner','Ejecutivo');
        final Account acc = TestFactory.createAccount();        
        
        final acpl__Account_Planning__c accPlan = new acpl__Account_Planning__c();
        accPlan.recordTypeId = recordType.get('Account_Planning').getRecordTypeId();
        accPlan.Name = 'Account_Planning Test';
        accPlan.acpl__gf_ap_indvi_lock_edit_ind_type__c = true;
        accPlan.acpl__gf_ap_limit_date__c = System.today().addDays(90);
        accPlan.acpl__gf_ap_status_type_name__c = 'Not started';
        accPlan.acpl__participant_id__c = acc.Id;
        accPlan.acpl__proposal_manager_id__c = userExecutive.Id;
        insert accPlan;
        
        final bupl__BusinessPlan__c bussPlan = new bupl__BusinessPlan__c();
        bussPlan.Name = 'Plan de Negocio AP_RECORD_102';
        bussPlan.bupl__gf_ap_public_ind_type__c = false;
        bussPlan.bupl__gf_business_growth_rec_number__c = 1;
        bussPlan.bupl__status_type__c = 'Validated';
        bussPlan.acpl__gf_account_planning_id__c = accPlan.id;
        insert bussPlan;
    }
    
    /**
     @Description test createRecords method, correct scenary
    */
    @isTest
    static void createRecordsTest() {
        final bupl__BusinessPlan__c bussPlan = [SELECT Id, acpl__gf_account_planning_id__c FROM bupl__BusinessPlan__c LIMIT 1][0];
        final bupl__BP_GrowthDriver__c growthDriver = new bupl__BP_GrowthDriver__c();
        growthDriver.bupl__gf_business_plan_id__c = bussPlan.Id;
        growthDriver.bupl__gf_business_growth_rec_number__c = 1;
        growthDriver.bupl__solution_category_desc__c = 'Carta fianza técnica';
        growthDriver.bupl__solution_category_id__c = 'Riesgo de firma';
        growthDriver.acpl__gf_account_planning_id__c = bussPlan.acpl__gf_account_planning_id__c;
        final List<SObject> sObjs = new List<SObject>();
        sObjs.add(growthDriver);
        
        Test.startTest();
        final BE_CreateDriveGrowth_ctr createDriveGro = new BE_CreateDriveGrowth_ctr();
        final BE_SingleRelatedListCRUD_Cls.Response resp = createDriveGro.createRecords(sObjs);
        System.assertEquals(resp.message, 'Successful', 'success!!!');
        Test.stopTest();
    }
    
    /**
     @Description test createRecords method, fail scenary
    */
    @isTest
    static void createRecordsNullTest() {
        Test.startTest();
        final BE_CreateDriveGrowth_ctr createDriveGro = new BE_CreateDriveGrowth_ctr();
        final BE_SingleRelatedListCRUD_Cls.Response resp = createDriveGro.createRecords(null);
        System.assert(!resp.isSuccess, 'fail!');
        Test.stopTest();
    }
}