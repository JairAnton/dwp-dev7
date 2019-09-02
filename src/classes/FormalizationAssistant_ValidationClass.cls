global class FormalizationAssistant_ValidationClass implements dwp_dbpn.DynamicFlowValidationInterface{
    global static List<String> getErrorMessagesList(String recordId, String source, String validationClass){
            list<String> lstErrorMessage = new List<String>();
            if(PrincipalValidationHub.Condition7(recordId)){
                lstErrorMessage.add(Label.Error_validation_06);
            }       
            return lstErrorMessage;
        }
}