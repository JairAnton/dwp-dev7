/**@Name AP_Reopen_Validation
   @Author Jair Anton
   @Date 2021-08-19
   Date        Author       Email                  Type
   2021-08-19   JAAA    jair.anton.contractor@bbva.com  creation
*/
global with sharing class AP_Reopen_Validation implements dwp_dbpn.DynamicFlowValidationInterface {
    private AP_Reopen_Validation() {}
	/** getErrorMessagesList*/
    global static List<String> getErrorMessagesList(String recordId, String source, String validationClass) {
        return new List<String>();
    }
}