/**@Name AP_Reopen_Validation
   @Author Jair Anton
   @Date 2021-08-19
   Date        Author       Email                  Type
   2021-08-19   JAAA    jair.anton.contractor@bbva.com  creation
*/
global without sharing class AP_Reopen_Validation implements dwp_dbpn.DynamicFlowValidationInterface {
    // private static variable referencing the class
    private static AP_Reopen_Validation instance = null;

    // a static method that returns the instance of the record type
    public static AP_Reopen_Validation getInstance(){
        // lazy load the record type - only initialize if it doesn't already exist
        if(instance == null) {
            instance = new AP_Reopen_Validation();
        }

        return instance;
    }

	/** getErrorMessagesList*/
    global static List<String> getErrorMessagesList(String recordId, String source, String validationClass) {
        Final List<String> lstErrorMessage = new List<String>();
        /*Id del AP para obtener su estado*/
        Final acpl__Account_Planning__c accountPlan = [SELECT Id, acpl__gf_ap_status_type_name__c, acpl__gf_ap_indvi_lock_edit_ind_type__c, acpl__gf_ap_validator_user_id__c
                                            FROM acpl__Account_Planning__c
                                            WHERE Id = :recordId LIMIT 1].get(0);

        //Si ap in validated, desbloqueado y rol correcto, añado el botón "Ask for Validation"
        if(apValidatedUnlocked(accountPlan) && !hasCorrectRoleReopen(accountPlan)) {
            lstErrorMessage.add('No tiene permisos necesarios para reabrir el plan.');
        }

        return lstErrorMessage;
    }

    /** apValidatedUnlocked*/
    public static Boolean apValidatedUnlocked(acpl__Account_Planning__c accountPlan) {
        Boolean isValidated = false;
        if(accountPlan != null && accountPlan.acpl__gf_ap_status_type_name__c == 'Validated' && !accountPlan.acpl__gf_ap_indvi_lock_edit_ind_type__c) {
            isValidated = true;
        }

        return isValidated;
    }

    
    private static Boolean hasCorrectRoleReopen(acpl__Account_Planning__c accountPlan) {
        Boolean hasCorrectRole = false;

        if(accountPlan.acpl__gf_ap_validator_user_id__c == UserInfo.getUserId() || searchManager()) {
            hasCorrectRole = true;
        }
    
        return hasCorrectRole;
    }
    
    private static Boolean searchManager() {
        Boolean hasCorrectRole = false;
        Final List<User> userList = [SELECT Id, Name, UserRoleId, UserRole.Name FROM User WHERE prof_position_id__c IN ('OS8', 'OS9', 'E01') AND Id =: UserInfo.getUserId() AND isActive = TRUE];
        
        if(userList.isEmpty() == false) {
            hasCorrectRole = true;
        }

        return hasCorrectRole;
    }
}