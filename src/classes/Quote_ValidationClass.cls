/**
 * @author bbva.com developers
 * @date 2018
 *
 * @group global_hub
 *
 * @description Validation class for "Quote" button
 **/
global class Quote_ValidationClass implements dwp_dbpn.DynamicFlowValidationInterface {
	global static List<String> getErrorMessagesList(String recordId, String source, String validationClass) {
		list<String> lstErrorMessage = new List<String>();
		if(PrincipalValidationHub.Condition2(recordId)) {
			lstErrorMessage.add(Label.Error_validation_02);
		}
		List<String> errors = PrincipalValidationHub.Condition4(recordId);
		for(String error : errors) {
			lstErrorMessage.add(error);
		}
		return lstErrorMessage;
	}
}
