/**
 * BE_EconomicGroup_DebtAndFee_tst
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
public class BE_EconomicGroup_DebtAndFee_tst {

    /**
	 * @Description  setUp
	 */
    @TestSetup
    public static void setUp() {
        Final User admin = [SELECT Id FROM User WHERE Id=:UserInfo.getUserId()];
        Final Account acc = generateData(admin);
        Final Account_Banking_System_Debt__c[] lstABSD = new Account_Banking_System_Debt__c[]{};
        lstABSD.add(new Account_Banking_System_Debt__c(account_id__c = acc.Id, debt_current_balance_amount__c = 150000, debt_quote_amount__c = 0.22, entity_name__c = 'BBVA', 
                                                      unique_id__c = 'TEST_BBVA_1', year_month_day_date__c = System.today(), product_group_classification_id__c = 'TOTAL'));
        lstABSD.add(new Account_Banking_System_Debt__c(account_id__c = acc.Id, debt_current_balance_amount__c = 5000, debt_quote_amount__c = 0.22, entity_name__c = 'BBVA', 
                                                      unique_id__c = 'TEST_BBVA_2', year_month_day_date__c = System.today(), product_group_classification_id__c = 'DIRECTA'));
        lstABSD.add(new Account_Banking_System_Debt__c(account_id__c = acc.Id, debt_current_balance_amount__c = 5000, debt_quote_amount__c = 0.22, entity_name__c = 'BBVA', 
                                                      unique_id__c = 'TEST_BBVA_3', year_month_day_date__c = System.today(), product_group_classification_id__c = 'INDIRECTA'));
        lstABSD.add(new Account_Banking_System_Debt__c(account_id__c = acc.Id, debt_current_balance_amount__c = 5000, debt_quote_amount__c = 0.22, entity_name__c = 'BCP', 
                                                      unique_id__c = 'TEST_BCP', year_month_day_date__c = System.today(), product_group_classification_id__c = 'TOTAL'));
        lstABSD.add(new Account_Banking_System_Debt__c(account_id__c = acc.Id, debt_current_balance_amount__c = 5000, debt_quote_amount__c = 0.22, entity_name__c = 'IBK', 
                                                      unique_id__c = 'TEST_IBK', year_month_day_date__c = System.today(), product_group_classification_id__c = 'TOTAL'));
        System.runAs(admin) {
            insert lstABSD;
        }
    }
    
    /**
	 * @Description  Test getData FROM BE_EconomicGroup_DebtAndFee_cls
	 */
    @isTest
    public static void getValues() {
        Final acpl__Account_Planning__c[] lstAP = [SELECT Id FROM acpl__Account_Planning__c LIMIT 1];
		Test.startTest();
        Final Map<String, String> mapParams = new Map<String, String>{'config' => 'Economic_Group_Debt_Fee_BBVA', 'mode' => 'Basic', 'recordId' => lstAP[0].Id};
		Final Be_DTP_ResponseModel_cls.Response response = Be_DynamicTablePresentation_ctr.getValues(mapParams, 'ClientsGroup_Debt_Fee_BBVA');
		Test.stopTest();
		System.assert(response.isSuccess, 'FAIL');
    }
    
    /**
	 * @Description  Reusable generate Data
	 */
    public static Account generateData(User admin) {
        Account accChild;
        //La metadata de Be_Dynamic_Table_Presentation__mdt ya existe en la org
		//Create User GOF
		Final String perfil=[SELECT Id FROM Profile WHERE name='Ejecutivo'].Id;
        Final Id gerenteRole = [SELECT Id FROM UserRole WHERE DeveloperName = 'GERENTE_BANCA_EMPRESAS_MIRAFLORES' LIMIT 1].Id;
        Map<Schema.SObjectField, Object> mapFields = new Map<Schema.SObjectField, Object>{User.LastName => 'GERENTE', User.ProfileId => perfil, 
           User.prof_position_id__c => 'E01', User.user_position_equivalence__c => 'User Test', User.UserRoleId => gerenteRole};
		Final User gof = TestFactory.getUser(true, mapFields);
        //Create User EJECUTIVO
        Final Id ejecutivoRole = [SELECT Id FROM UserRole WHERE DeveloperName = 'EJECUTIVO_BANCA_EMPRESAS_MIRAFLORES' LIMIT 1].Id;
        mapFields = new Map<Schema.SObjectField, Object>{User.LastName => 'EJECUTIVO', User.ProfileId => perfil, 
            User.user_position_equivalence__c => 'User Test', User.ManagerId => gof.Id, User.UserRoleId => ejecutivoRole};
		Final User ejecutivo = TestFactory.getUser(true, mapFields);
		//Create Account
		mapFields = new Map<Schema.SObjectField, Object> {Account.OwnerId => UserInfo.getUserId(), Account.Name => 'CLIENTE MARTÍN'};
        System.runAs(admin) {
            Final Account acc = TestFactory.getAccount(true, mapFields);
            accChild = TestFactory.createAccount(acc.Id);
            Final Id rtId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Account_Planning' LIMIT 1].Id;
            insert AP_FactoryTest_tst.createAccountPlanning(acc.Id, ejecutivo.Id, rtId, true);
        }
        return accChild;
    }
}