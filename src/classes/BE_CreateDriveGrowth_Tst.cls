/**@Name <BE_CreateDriveGrowth_Tst>
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   Date        Author   Email                  				Type
   2020-06-04  MAMC     martin.mori.contractor@bbva.com		Creation
   2020-10-09  DCP     diego.carbajal@bbva.com				Modified
   2021-08-19  JAAA    jair.anton.contractor@bbva.com       Valida GD creados.
   -------------------------------------------------------------------------------------------------
 */
@isTest
public without sharing class BE_CreateDriveGrowth_Tst {
    /** @Description VALIDATED*/
    Final static String VALIDATED = 'Validated';
    /**@Description IN_PLACE */
    Final static String IN_PLACE = 'In place';
    /**@Description FAILED */
    Final static String FAILED = 'Failed';
    /**@Description SUCCESS */
    Final static String SUCCESS = 'Success';

    /*Setup Data*/
    @TestSetup
    public static void setUp() {
        final List<String> sObjNames=new List<String>{'acpl__Account_Planning__c'};
        final Map<String,Schema.RecordTypeInfo> recordType=BE_General_Utils.getRecordTypeInfo(sObjNames);
        
        final User userExecutive = TestFactory.createUser('userExecutiveOwner','Ejecutivo');
        final Account acc = TestFactory.createAccount();        
        
        final acpl__Account_Planning__c accPlan = new acpl__Account_Planning__c(recordTypeId = recordType.get('Account_Planning').getRecordTypeId(), Name = 'Account_Planning Test', 
                                                                               acpl__gf_ap_indvi_lock_edit_ind_type__c = true, acpl__gf_ap_limit_date__c = System.today().addDays(90), 
                                                                               acpl__gf_ap_status_type_name__c = 'Not started', acpl__participant_id__c = acc.Id, 
                                                                               acpl__proposal_manager_id__c = userExecutive.Id);
        insert accPlan;
        
        final bupl__BusinessPlan__c bussPlan = new bupl__BusinessPlan__c(Name = 'Plan de Negocio AP_RECORD_102', bupl__gf_ap_public_ind_type__c = false, 
                                                                        bupl__gf_business_growth_rec_number__c = 1, bupl__status_type__c = 'Validated', 
                                                                        acpl__gf_account_planning_id__c = accPlan.id);
        insert bussPlan;
        AP_FactoryTest_tst.generateProduct();
    }
    
    private static bupl__BP_GrowthDriver__c obtainGD() {
        Final bupl__BusinessPlan__c bpAux = [SELECT Id, acpl__gf_account_planning_id__c FROM bupl__BusinessPlan__c LIMIT 1];
        return new bupl__BP_GrowthDriver__c(bupl__gf_business_plan_id__c = bpAux.Id, bupl__gf_business_growth_rec_number__c = 1, ExpectedDate__c = System.today(), 
                                     bupl__solution_category_desc__c = '0292235_NEW', CurrencyIsoCode = 'PEN', bupl__solution_category_id__c = 'Riesgo de firma', 
                                     acpl__gf_account_planning_id__c = bpAux.acpl__gf_account_planning_id__c);
    }
    
    /**
     @Description test createRecords method, correct scenary
    */
    @isTest
    static void readRecordsTest() {
        Final List<acpl__Account_Planning__c> apList = [SELECT Id FROM acpl__Account_Planning__c LIMIT 1];
        Final bupl__BP_GrowthDriver__c growthDriver = obtainGD();
        new BE_CreateDriveGrowth_ctr().createRecords(new List<SObject>{growthDriver});

        Test.startTest();
		apList[0].acpl__gf_ap_status_type_name__c = VALIDATED;
        apList[0].acpl__gf_ap_substatus_type_name__c = IN_PLACE;
        apList[0].acpl__gf_ap_indvi_lock_edit_ind_type__c = false;
        update apList[0];

        Final Map<String,Object> apMap = new Map<String,Object>();
        apMap.put('recordId', apList[0].Id);

        Final BE_SingleRelatedListCRUD_Cls.Response response = new BE_CreateDriveGrowth_ctr().readRecords(apMap);
        Test.stopTest();
        System.assert(response.isSuccess, SUCCESS);
    }

    /**
     @Description test createRecords method, correct scenary
    */
    @isTest
    static void createRecordsTest() {
        final List<SObject> sObjs = new List<SObject>{obtainGD()};
        Test.startTest();
        Final BE_SingleRelatedListCRUD_Cls.Response resp = new BE_CreateDriveGrowth_ctr().createRecords(sObjs);
        Test.stopTest();
        System.assert(resp.isSuccess, SUCCESS);
    }
    
    /**
     @Description test createRecords method, correct scenary invalid Product
    */
    @isTest
    static void createRecordsInvalidPrdTest() {
        Final bupl__BP_GrowthDriver__c growthDriver = obtainGD();
        growthDriver.bupl__solution_category_desc__c = '0292235';
        final List<SObject> sObjs = new List<SObject>{growthDriver};
        Test.startTest();
        final BE_CreateDriveGrowth_ctr createDriveGro = new BE_CreateDriveGrowth_ctr();
        final BE_SingleRelatedListCRUD_Cls.Response resp = createDriveGro.createRecords(sObjs);
        System.assert(!resp.isSuccess, FAILED);
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
        System.assert(!resp.isSuccess, FAILED);
        Test.stopTest();
    }
    
    /**
     @Description test updateRecords method, correct scenary
    */
    @isTest
    static void updateRecordsTest() {
        Final bupl__BP_GrowthDriver__c growthDriver = obtainGD();
        new BE_CreateDriveGrowth_ctr().createRecords(new List<SObject>{growthDriver});
        growthDriver.ExpectedDate__c = System.today() +1;
        Test.startTest();
        final BE_SingleRelatedListCRUD_Cls.Response resp = new BE_CreateDriveGrowth_ctr().updateRecords(new List<SObject>{growthDriver});
        Test.stopTest();
        System.assert(resp.isSuccess, SUCCESS);
    }
    
    /**
     @Description test updateRecords method, correct scenary invalid Product
    */
    @isTest
    static void updateRecordsExpectedTest() {
        Final bupl__BP_GrowthDriver__c growthDriver = obtainGD();
        new BE_CreateDriveGrowth_ctr().createRecords(new List<SObject>{growthDriver});
        growthDriver.ExpectedDate__c = null;
        Test.startTest();
        final BE_SingleRelatedListCRUD_Cls.Response resp = new BE_CreateDriveGrowth_ctr().updateRecords(new List<SObject>{growthDriver});
        Test.stopTest();
        System.assert(!resp.isSuccess, FAILED);
    }

    /**
     @Description test updateRecords method, correct scenary invalid Product
    */
    @isTest
    static void updateRecordsInvalidPrdTest() {
        Final bupl__BP_GrowthDriver__c growthDriver = obtainGD();
        new BE_CreateDriveGrowth_ctr().createRecords(new List<SObject>{growthDriver});
        growthDriver.bupl__solution_category_desc__c = '0292235';
        Test.startTest();
        final BE_SingleRelatedListCRUD_Cls.Response resp = new BE_CreateDriveGrowth_ctr().updateRecords(new List<SObject>{growthDriver});
        Test.stopTest();
        System.assert(!resp.isSuccess, FAILED);
    }
}