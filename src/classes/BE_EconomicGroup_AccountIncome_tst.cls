/**
 * BE_EconomicGroup_AccountIncome_tst
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
public class BE_EconomicGroup_AccountIncome_tst {

    /**
	 * @Description  setUp
	 */
    @TestSetup
    public static void setUp() {
        Final User admin = [SELECT Id FROM User WHERE Id=:UserInfo.getUserId()];
        Final Account acc = BE_EconomicGroup_DebtAndFee_tst.generateData(admin);
        Final Account_Income__c[] lstAI = new Account_Income__c[]{};
        lstAI.add(new Account_Income__c(account_id__c = acc.Id, unique_id__c = 'TEST_1', CurrencyIsoCode = 'PEN', gf_income_type__c = '03', 
                                        gf_income_movement_date__c = Date.newInstance(System.today().year(), 1, 1), gf_income_amount__c = 10000));
        lstAI.add(new Account_Income__c(account_id__c = acc.Id, unique_id__c = 'TEST_2', CurrencyIsoCode = 'USD', gf_income_type__c = '03', 
                                        gf_income_movement_date__c = Date.newInstance(System.today().year(), 1, 1), gf_income_amount__c = 10000));
        lstAI.add(new Account_Income__c(account_id__c = acc.Id, unique_id__c = 'TEST_3', CurrencyIsoCode = 'PEN', gf_income_type__c = '03', 
                                        gf_income_movement_date__c = Date.newInstance(System.today().year() - 1, 1, 1), gf_income_amount__c = 10000));
        lstAI.add(new Account_Income__c(account_id__c = acc.Id, unique_id__c = 'TEST_4', CurrencyIsoCode = 'USD', gf_income_type__c = '03', 
                                        gf_income_movement_date__c = Date.newInstance(System.today().year() - 1, 1, 1), gf_income_amount__c = 10000));
        System.runAs(admin) {
            insert lstAI;
        }
    }
    
    /**
	 * @Description  Test getData FROM BE_EconomicGroup_AccountIncome_cls
	 */
    @isTest
    public static void getValues() {
        Final acpl__Account_Planning__c[] lstAP = [SELECT Id FROM acpl__Account_Planning__c LIMIT 1];
		Test.startTest();
        Final Map<String, String> mapParams = new Map<String, String>{'config' => 'Economic_Group_AccountIncome', 'mode' => 'Basic', 'recordId' => lstAP[0].Id};
		Final Be_DTP_ResponseModel_cls.Response response = Be_DynamicTablePresentation_ctr.getValues(mapParams, 'ClientsGroup_AccountIncome');
		Test.stopTest();
		System.assert(response.isSuccess, 'FAIL');
    }
}