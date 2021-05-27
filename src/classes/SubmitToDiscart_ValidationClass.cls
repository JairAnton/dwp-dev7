/**
 * @author bbva.com developers
 * @date 2018
 *
 * @group global_hub
 *
 * @description Validation class for "Reject" button
 * 
 *  * * *  * Cambio de condicion 1 a condición 2 para validación de acceso a botonera de oportunidades :<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Jair Anton    			27/05/2021         Modification condición 2 para validación de acceso a botonera de oportunidades <p />
 * @description PrincipalValidationHub
 **/
global class SubmitToDiscart_ValidationClass implements dwp_dbpn.DynamicFlowValidationInterface {
	global static List<String> getErrorMessagesList(String recordId, String source, String validationClass) {
		list<String> lstErrorMessage = new List<String>();
		if(PrincipalValidationHub.Condition2(recordId)) {
			lstErrorMessage.add(Label.Error_validation_02);
		}
		return lstErrorMessage;
	}
}