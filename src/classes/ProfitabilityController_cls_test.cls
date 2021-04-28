/**
 * ProfitabilityController_tst
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * None			    			  None          	Original version.<p />
 * Diego Carbajal    			14/09/2020          Modified version.<p />
 *
 * @author Diego Carbajal
 */
@isTest
public class ProfitabilityController_cls_test {

	/**
	 * @Description  setUp
	 */
    @TestSetup
    public static void setUp() {
        Final User admin = [SELECT Id FROM User WHERE Id=:UserInfo.getUserId()];
        Final Account acc = BE_EconomicGroup_DebtAndFee_tst.generateData(admin);
        Final Account_Profitability__c [] lstProf = new Account_Profitability__c []{};
        lstProf.add(new Account_Profitability__c (account_id__c = acc.Id, unique_id__c = 'TEST_1', current_ydt_amount__c = 35436456, profitability_type__c  = '03',
                                                  profitability_category_type__c = 'Margen financiero', year_month_day_date__c = System.today()));
        lstProf.add(new Account_Profitability__c (account_id__c = acc.Id, unique_id__c = 'TEST_2', current_ydt_amount__c = 45654434, profitability_type__c  = '03',
                                                  profitability_category_type__c = 'Comisiones', year_month_day_date__c = System.today()));
        System.runAs(admin) {
            insert lstProf;
        }
    }
    
    /**
	 * @Description  Test getData FROM ProfitabilityController_cls
	 */
    @isTest
    public static void getValues1() {
        Final acpl__Account_Planning__c[] lstAP = [SELECT Id FROM acpl__Account_Planning__c LIMIT 2];
		Test.startTest();
        Final Map<String, String> mapParams = new Map<String, String>{'config' => 'Economic_Group_Profitability', 'mode' => 'Basic', 'recordId' => lstAP[0].Id};
		Final Be_DTP_ResponseModel_cls.Response response = Be_DynamicTablePresentation_ctr.getValues(mapParams, 'ClientsGroup_Profitability');
		Test.stopTest();
		System.assert(response.isSuccess, 'FAIL');
    }
    
    /**
	 * @Description  Test getData FROM ProfitabilityController_cls
	 */
    @isTest
    public static void getValues2() {
        Final acpl__Account_Planning__c[] lstAP = [SELECT Id FROM acpl__Account_Planning__c LIMIT 2];
		Test.startTest();
        Final Map<String, String> mapParams = new Map<String, String>{'config' => 'Economic_Group_Profitability', 'mode' => 'Basic', 'recordId' => lstAP[1].Id};
		Final Be_DTP_ResponseModel_cls.Response response = Be_DynamicTablePresentation_ctr.getValues(mapParams, 'ClientsGroup_Profitability');
		Test.stopTest();
		System.assert(response.isSuccess, 'FAIL');
    }
}