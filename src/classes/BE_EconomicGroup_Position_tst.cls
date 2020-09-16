/**
 * BE_EconomicGroup_Position_tst
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		14/09/2020          Original version.<p />
 *
 * @author Diego Carbajal
 */
@isTest
public class BE_EconomicGroup_Position_tst {

    /**
	 * @Description  setUp
	 */
    @TestSetup
    public static void setUp() {
        Final User admin = [SELECT Id FROM User WHERE Id=:UserInfo.getUserId()];
        Final Account acc = BE_EconomicGroup_DebtAndFee_tst.generateData(admin);
        acc.bank_turnover_volume_amount__c = 45654645;
        Final Account_BBVA_Information__c [] lstBBVAInfo = new Account_BBVA_Information__c []{};
        lstBBVAInfo.add(new Account_BBVA_Information__c (account_id__c = acc.Id, unique_id__c = 'TEST_1', product_group_classification_id__c  = 'Directa', type__c = '01', 
                                                  year_month_day_date__c = System.today(), average_balance_amount__c = 12345678));
        lstBBVAInfo.add(new Account_BBVA_Information__c (account_id__c = acc.Id, unique_id__c = 'TEST_2',  product_group_classification_id__c  = 'Indirecta', type__c = '01',
                                                  year_month_day_date__c = System.today(), average_balance_amount__c = 876543));
        lstBBVAInfo.add(new Account_BBVA_Information__c (account_id__c = acc.Id, unique_id__c = 'TEST_3', product_group_classification_id__c  = 'Recursos Gestionados', type__c = '02', 
                                                  year_month_day_date__c = System.today(), average_balance_amount__c = 3645874));
        System.runAs(admin) {
            insert new Account(Name = 'Testing', parentId = acc.ParentId);
            update acc;
            insert lstBBVAInfo;
        }
    }
    
    /**
	 * @Description  Test getData FROM BE_EconomicGroup_Position_cls
	 */
    @isTest
    public static void getValues() {
        Final acpl__Account_Planning__c[] lstAP = [SELECT Id FROM acpl__Account_Planning__c LIMIT 1];
		Test.startTest();
        Final Map<String, String> mapParams = new Map<String, String>{'config' => 'Economic_Group_Position', 'mode' => 'Basic', 'recordId' => lstAP[0].Id};
		Final Be_DTP_ResponseModel_cls.Response response = Be_DynamicTablePresentation_ctr.getValues(mapParams, 'ClientsGroup_Position');
		Test.stopTest();
		System.assert(response.isSuccess, 'FAIL');
    }
    
}