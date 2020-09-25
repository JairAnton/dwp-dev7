/**
 * BE_EconomicGroup_Spread_Rate_tst
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
public class BE_EconomicGroup_Spread_Rate_tst {

    /**
	 * @Description  setUp
	 */
    @TestSetup
    public static void setUp() {
        Final User admin = [SELECT Id FROM User WHERE Id=:UserInfo.getUserId()];
        Final Account acc = BE_EconomicGroup_DebtAndFee_tst.generateData(admin);
        Final Account_Profitability__c [] lstProf = new Account_Profitability__c []{};
        lstProf.add(new Account_Profitability__c (account_id__c = acc.Id, unique_id__c = 'TEST_1', profitability_type__c  = '03', profitability_subcategory_type__c = 'TOTAL CLIENTE', 
                                                  year_month_day_date__c = System.today(), currenct_mon_amount__c = 100045));
        lstProf.add(new Account_Profitability__c (account_id__c = acc.Id, unique_id__c = 'TEST_2', profitability_type__c  = '02', profitability_subcategory_type__c = 'TOTAL Spread', 
                                                  year_month_day_date__c = System.today(), currenct_mon_per__c = 1.10, product_desc__c = 'CLIENTE', profitability_category_type__c = 'Spread'));
        lstProf.add(new Account_Profitability__c (account_id__c = acc.Id, unique_id__c = 'TEST_3', profitability_type__c  = '02', profitability_subcategory_type__c = 'TOTAL Tasa', 
                                                  year_month_day_date__c = System.today(), currenct_mon_per__c = 1.72, product_desc__c = 'CLIENTE', profitability_category_type__c = 'Tasa'));
        System.runAs(admin) {
            insert lstProf;
        }
    }
    
    /**
	 * @Description  Test getData FROM BE_EconomicGroup_Spread_Rate_cls
	 */
    @isTest
    public static void getValues() {
        Final acpl__Account_Planning__c[] lstAP = [SELECT Id FROM acpl__Account_Planning__c LIMIT 1];
		Test.startTest();
        Final Map<String, String> mapParams = new Map<String, String>{'config' => 'Economic_Group_Spread_Rate', 'mode' => 'Basic', 'recordId' => lstAP[0].Id};
		Final Be_DTP_ResponseModel_cls.Response response = Be_DynamicTablePresentation_ctr.getValues(mapParams, 'ClientsGroup_Spread_Rate');
		Test.stopTest();
		System.assert(response.isSuccess, 'FAIL');
    }
}