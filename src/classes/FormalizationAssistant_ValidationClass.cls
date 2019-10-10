/*
* ------------------------------------------------------------------------------------------------
* @Name FormalizationAssistant_ValidationClass
* @Author Diego Carbajal diego.carbajal.contractor@bbva.com
* @Date Created: 2019-09-02
* @Group 
* @Description Esta clase valida los filtros determinados
*/
global class FormalizationAssistant_ValidationClass implements dwp_dbpn.DynamicFlowValidationInterface {
    
    /* Method getErrorMessagesList*/
    global static List<String> getErrorMessagesList(String recordId, String source, String validationClass) {
            list<String> lstErrorMessage = new List<String>();
            if(PrincipalValidationHub.condition6(recordId)) {
                lstErrorMessage.add(Label.Error_validation_06);
            }       
            return lstErrorMessage;
        }
}