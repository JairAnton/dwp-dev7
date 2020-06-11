/**
 * @author bbva.com developers
 * @date 2018
 *
 * @group global_hub
 *
 * @description Validation class for "Reject" button
 **/
global class SubmitToDiscart_ValidationClass implements dwp_dbpn.DynamicFlowValidationInterface {
	global static List<String> getErrorMessagesList(String recordId, String source, String validationClass) {
		list<String> lstErrorMessage = new List<String>();
		if(PrincipalValidationHub.Condition1(recordId)) {
			lstErrorMessage.add(Label.Error_validation_01);
		}
		return lstErrorMessage;
	}
}
