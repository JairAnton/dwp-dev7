/**
* ------------------------------------------------------------------------------------------------
* @Name ReOwnerFormalization_ValidationClass
* @Author Diego Carbajal diego.carbajal.contractor@bbva.com
* @Date Created: 2019-09-02
* @Group 
* @Description Esta clase valida los filtros determinados
*/
global class ReOwnerFormalization_ValidationClass implements dwp_dbpn.DynamicFlowValidationInterface {
    
    /* Global static method for validation */
	global static List<String> getErrorMessagesList(String recordId, String source, String validationClass) {
        list<String> lstErrorMessage = new List<String>();
        if(PrincipalValidationHub.condition7(recordId)) {
            lstErrorMessage.add(Label.Error_validation_07);
        }       
        return lstErrorMessage;
    }
}