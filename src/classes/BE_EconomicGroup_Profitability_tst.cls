/**
 * BE_EconomicGroup_Profitability_tst
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		11/09/2020          Original version.<p />
 *
 * @author Diego Carbajal
 */
@isTest
public class BE_EconomicGroup_Profitability_tst {

    /** @Description  ALTAS*/
    static Final String ALTAS = 'Altas';
    /** @Description  CLIENTE*/
    static Final String CLIENTE = 'CLIENTE';
    /** @Description  TOTAL_CLIENTE*/
    static Final String TOTAL_CLIENTE = 'TOTAL CLIENTE';
    
    /**
	 * @Description  setUp
	 */
    @TestSetup
    public static void setUp() {
        Final User admin = [SELECT Id FROM User WHERE Id=:UserInfo.getUserId()];
        Final Account acc = BE_EconomicGroup_DebtAndFee_tst.generateData(admin);
        Final Account_Profitability__c [] lstProf = new Account_Profitability__c []{};
        lstProf.add(new Account_Profitability__c (account_id__c = acc.Id, unique_id__c = 'TEST_1', profitability_type__c  = '01', profitability_subcategory_type__c = TOTAL_CLIENTE, 
                                                  year_month_day_date__c = Date.newInstance(System.today().year(), System.today().month() - 1, 1), currenct_mon_amount__c = 100045, product_desc__c = CLIENTE, 
                                                  profitability_category_type__c = ALTAS));
        lstProf.add(new Account_Profitability__c (account_id__c = acc.Id, unique_id__c = 'TEST_2', profitability_type__c  = '01', profitability_subcategory_type__c = TOTAL_CLIENTE, 
                                                  year_month_day_date__c = Date.newInstance(System.today().year(), System.today().month() - 2, 1), currenct_mon_amount__c = 100045, product_desc__c = CLIENTE, 
                                                  profitability_category_type__c = ALTAS));
        lstProf.add(new Account_Profitability__c (account_id__c = acc.Id, unique_id__c = 'TEST_3', profitability_type__c  = '01', profitability_subcategory_type__c = TOTAL_CLIENTE, 
                                        		year_month_day_date__c = Date.newInstance(System.today().year(), System.today().month() - 3, 1), currenct_mon_amount__c = 100045, product_desc__c = CLIENTE, 
                                                  profitability_category_type__c = ALTAS));
        lstProf.add(new Account_Profitability__c (account_id__c = acc.Id, unique_id__c = 'TEST_4', profitability_type__c  = '01', profitability_subcategory_type__c = TOTAL_CLIENTE, 
                                        		year_month_day_date__c = Date.newInstance(System.today().year(), System.today().month() - 4, 1), currenct_mon_amount__c = 100045, product_desc__c = CLIENTE, 
                                                  profitability_category_type__c = ALTAS));
        lstProf.add(new Account_Profitability__c (account_id__c = acc.Id, unique_id__c = 'TEST_5', profitability_type__c  = '01', profitability_subcategory_type__c = TOTAL_CLIENTE, 
                                        		year_month_day_date__c = Date.newInstance(System.today().year(), System.today().month() - 5, 1), currenct_mon_amount__c = 100045, product_desc__c = CLIENTE, 
                                                  profitability_category_type__c = ALTAS));
        lstProf.add(new Account_Profitability__c (account_id__c = acc.Id, unique_id__c = 'TEST_6', profitability_type__c  = '01', profitability_subcategory_type__c = TOTAL_CLIENTE, 
                                        		year_month_day_date__c = Date.newInstance(System.today().year(), System.today().month() - 6, 1), currenct_mon_amount__c = 100045, product_desc__c = CLIENTE, 
                                                  profitability_category_type__c = ALTAS));
        System.runAs(admin) {
            insert lstProf;
        }
    }
    
    /**
	 * @Description  Test getData FROM BE_EconomicGroup_Profitability_cls
	 */
    @isTest
    public static void getValues() {
        Final acpl__Account_Planning__c[] lstAP = [SELECT Id FROM acpl__Account_Planning__c LIMIT 1];
		Test.startTest();
        Final Map<String, String> mapParams = new Map<String, String>{'config' => 'Economic_Group_ProfitabilityBilling', 'mode' => 'Basic', 'recordId' => lstAP[0].Id};
		Final Be_DTP_ResponseModel_cls.Response response = Be_DynamicTablePresentation_ctr.getValues(mapParams, 'ClientsGroup_Billing');
		Test.stopTest();
		System.assert(response.isSuccess, 'FAIL');
    }
}