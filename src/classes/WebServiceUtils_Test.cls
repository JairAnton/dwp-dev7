@istest
public class WebServiceUtils_Test {
	@isTest
	public static void test_method_one() {
		insert new Web_Service_Value_Mapping__c(label__c = 'a',
		                                        value__c = 'a',
		                                        web_service_value__c = 'a',
		                                        web_service_parameter_id__c = 'ws1',
		                                        pricing_model_id__c = '3');
		Map<String, Web_Service_Value_Mapping__c> mapReturn = WebServiceUtils.getWebServiceValuesMapping(new List<String> {'ws1'}, '3');
		System.assertEquals(mapReturn.get('ws1a').value__c, 'a');

		String endPoint = WebServiceUtils.getUrlFromCustomSettings('customSettingEndpoint');
		System.assertEquals(endPoint, '');
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'customSettingEndpoint', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		endPoint = WebServiceUtils.getUrlFromCustomSettings('customSettingEndpoint');
		System.assertEquals(endPoint, 'https://validation/ok');

		WebServiceUtils.ResponseErrorMessage_Wrapper errorWrapper = WebServiceUtils.parse('{"version":1,"severity":"FATAL","http-status":409,"error-code":"functionalError","error-message":null,"consumer-request-id":"96a1c59d-f5df-40eb-ac83-551f5ceca963","system-error-code":"functionalError","system-error-description":"Default functional error."}');
		System.assertEquals(errorWrapper.status, 409);
	}
}
