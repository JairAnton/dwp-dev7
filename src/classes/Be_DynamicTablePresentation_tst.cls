/**
 * ------------------------------------------------------------------------------------------------
 * @Name Be_DynamicTablePresentation_tst
 * @Author Diego Carbajal diego.carbajal@bbva.com
 * @Date Created: 2020-06-01
 * @Group
 * @Description Test class Be_DynamicTablePresentation_tst
 *
 */
@isTest
public class Be_DynamicTablePresentation_tst {
    /*@Description FAIL*/
    private static Final String FAIL = 'Fail';
	/*Setup Data*/
	@TestSetup
	public static void setUp() {
		//La metadata de Be_Dynamic_Table_Presentation__mdt ya existe en la org
		//Create Account
		Final Map<Schema.SObjectField, Object> mapFields = new Map<Schema.SObjectField, Object> {Account.OwnerId => UserInfo.getUserId(), Account.Name => 'CLIENTE MARTÍN'};
		Final Account acc = TestFactory.getAccount(true, mapFields);
        TestFactory.createOpportunity(acc.Id, UserInfo.getUserId());
	}

    /*@Description getData*/
	public static testmethod void getValues() {
        Final Account acc = [SELECT Id FROM Account LIMIT 1];
		Test.startTest();
        Final Map<String, String> mapParams = new Map<String, String>{'config' => 'DynamicTable_Opp_Demo', 'mode' => 'Basic', 'recordId' => acc.Id};
		Final Be_DTP_ResponseModel_cls.Response response = Be_DynamicTablePresentation_ctr.getValues(mapParams, 'model_1');
		Test.stopTest();
		System.assert(response.isSuccess, FAIL);
	}

    /*@Description getFiltersTest*/
	public static testmethod void getFiltersTestSuccess() {
		String result;
		Test.startTest();
		result = Be_DynamicTablePresentation_ctr.getFilters('DynamicTable_Opp_Demo');
		Test.stopTest();
		Final Boolean condition = String.isNotBlank(result);
		System.assert (condition, FAIL);
	}
    
    /*@Description getFiltersTest*/
	public static testmethod void getValuesMdtFail() {
		Be_DTP_ResponseModel_cls.Response response;
        Final Map<String, String> mapParams = new Map<String, String>{'config' => 'Mdt_Fail', 'mode' => 'Basic'};
		Test.startTest();
		response = Be_DynamicTablePresentation_ctr.getValues(mapParams, 'Test');
		Test.stopTest();
		System.assert (!response.isSuccess, FAIL);
	}

    /*@Description getValuesTestFail*/
	public static testmethod void getValuesConverted() {
		Be_DTP_ResponseModel_cls.Response response;
        Final Map<String, String> mapParams = new Map<String, String>{'config' => 'DynamicTable_Opp_Demo', 'mode' => 'Title'};
		Test.startTest();
		response = Be_DynamicTablePresentation_ctr.getValues(mapParams, 'model_2');
		Test.stopTest();
		System.assert(response.isSuccess, FAIL);
	}

    /*@Description getDataResponse*/
    public static testmethod void getDataResponse() {
        Be_DTP_ResponseModel_cls.Response response;
        Test.startTest();
        response = dtpModel.getData(new Map<String, String>(), 'columns', new List<String>());
        Test.stopTest();
        System.assertEquals(response.columns, null, FAIL);
    }

}