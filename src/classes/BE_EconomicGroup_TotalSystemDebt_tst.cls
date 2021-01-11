/**
 * BE_EconomicGroup_TotalSystemDebt_tst
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
public class BE_EconomicGroup_TotalSystemDebt_tst {

    /*** @Description  TOTAL*/
    static Final String TOTAL = 'TOTAL';
    
    /**
	 * @Description  setUp
	 */
    @TestSetup
    public static void setUp() {
        Final User admin = [SELECT Id FROM User WHERE Id=:UserInfo.getUserId()];
        Final Account acc = BE_EconomicGroup_DebtAndFee_tst.generateData(admin);
        Final Account_Banking_System_Debt__c[] lstABSD = new Account_Banking_System_Debt__c[]{};
        lstABSD.add(new Account_Banking_System_Debt__c(account_id__c = acc.Id, debt_current_balance_amount__c = 150000, debt_quote_amount__c = 0.22, entity_name__c = 'BBVA', 
                                                      unique_id__c = 'TEST_1', year_month_day_date__c = System.today(), product_group_classification_id__c = TOTAL));
        lstABSD.add(new Account_Banking_System_Debt__c(account_id__c = acc.Id, debt_current_balance_amount__c = 5000, debt_quote_amount__c = 0.32, entity_name__c = 'BCP', 
                                                      unique_id__c = 'TEST_2', year_month_day_date__c = System.today(), product_group_classification_id__c = TOTAL));
        lstABSD.add(new Account_Banking_System_Debt__c(account_id__c = acc.Id, debt_current_balance_amount__c = 6000, debt_quote_amount__c = 0.12, entity_name__c = 'IBK', 
                                                      unique_id__c = 'TEST_3', year_month_day_date__c = System.today(), product_group_classification_id__c = TOTAL));
        lstABSD.add(new Account_Banking_System_Debt__c(account_id__c = acc.Id, debt_current_balance_amount__c = 7000, debt_quote_amount__c = 0.02, entity_name__c = 'SCOTIA', 
                                                      unique_id__c = 'TEST_4', year_month_day_date__c = System.today(), product_group_classification_id__c = TOTAL));
        lstABSD.add(new Account_Banking_System_Debt__c(account_id__c = acc.Id, debt_current_balance_amount__c = 8000, debt_quote_amount__c = 0.26, entity_name__c = 'OTROS', 
                                                      unique_id__c = 'TEST_5', year_month_day_date__c = System.today(), product_group_classification_id__c = TOTAL));
        System.runAs(admin) {
            insert lstABSD;
        }
    }
    
    /**
	 * @Description  Test getData FROM BE_EconomicGroup_TotalSystemDebt_cls
	 */
    @isTest
    public static void getValues() {
        Final acpl__Account_Planning__c[] lstAP = [SELECT Id FROM acpl__Account_Planning__c LIMIT 1];
		Test.startTest();
        Final Map<String, String> mapParams = new Map<String, String>{'config' => 'Economic_Group_BankingDebt', 'mode' => 'Basic', 'recordId' => lstAP[0].Id};
		Final Be_DTP_ResponseModel_cls.Response response = Be_DynamicTablePresentation_ctr.getValues(mapParams, 'ClientsGroup_Total_BankingDebt');
		Test.stopTest();
		System.assert(response.isSuccess, 'FAIL');
    }
}