/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_CalCommissionValidation_Cls>
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2021-03-17
   @Description validation class of the action calculate commission
   @Changes
   Date        Author   Email                  				Type		Description
   2021-03-17  MAMC     martin.mori.contractor@bbva.com    	Creation
   -------------------------------------------------------------------------------------------------
 */
 global class BE_CalCommissionValidation_Cls implements dwp_dbpn.DynamicFlowValidationInterface {
              
	/**method used to validate the action**/
    global List<String> getErrorMessagesList(String recordId, String source, String validationClass) {
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