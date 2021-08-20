/**@Name BE_AP_UpdateAPQuestions
   @Author Lolo Bravo
   @Date 2020-11-04
   Date        Author       Email                  Type
   2021-03-04  LMBR     lolo.bravo@bbva.com             Creation
   2021-08-19   JAAA    jair.anton.contractor@bbva.com  Valida acceso a boton reabrir
*/
global without sharing class APDynamicButtonsStatusHandlerTactico implements dwp_dbpn.DynamicButtonsStatusInterface {
	/** getDynamicButtonStatus*/
    global static Set<String> getDynamicButtonStatus(String recordId, String sObjectName) {
        Final Set<String> buttonsStatusSet = new Set<String>();
        /*Id del AP para obtener su estado*/
        Final acpl__Account_Planning__c accountPlan = [SELECT Id, acpl__gf_ap_status_type_name__c, acpl__gf_ap_indvi_lock_edit_ind_type__c, acpl__gf_ap_validator_user_id__c
                                            FROM acpl__Account_Planning__c
                                            WHERE Id = :recordId LIMIT 1].get(0);

        /*Rol del usuario*/
        Final acpl__Account_Plan_Settings__c apSetting = acpl__Account_Plan_Settings__c.getInstance();
        //Si ap desbloqueado, añado los botones de "Growth Drivers" y "Needs"
        if(accountPlan.acpl__gf_ap_indvi_lock_edit_ind_type__c) {
            buttonsStatusSet.add('AP_New_Growth_Driver_Tactico');
            buttonsStatusSet.add('AP_New_Need_Tactico');
        }
        //Si ap in progress, desbloqueado y rol correcto, añado el botón "Ask for Validation"
        if(apInProgressUnlocked(accountPlan) && hasCorrectRole(accountPlan,apSetting)) {
            buttonsStatusSet.add('AP_Ask_for_validation_Tactico');
        }

        //Si ap in validated, desbloqueado y rol correcto, añado el botón "Ask for Validation"
        if(apValidatedUnlocked(accountPlan) && hasCorrectRoleReopen(accountPlan)) {
            buttonsStatusSet.add('AP_Reopen');
        }

        return buttonsStatusSet;
    }
	
    public static Boolean apValidatedUnlocked(acpl__Account_Planning__c accountPlan) {
        Boolean isValidated = false;
        if(accountPlan != null && accountPlan.acpl__gf_ap_status_type_name__c == 'Validated' && !accountPlan.acpl__gf_ap_indvi_lock_edit_ind_type__c) {
            isValidated = true;
        }

        return isValidated;
    }

    /** apInProgressUnlocked*/
    public static Boolean apInProgressUnlocked(acpl__Account_Planning__c accountPlan) {
        Boolean isInProgress = false;
        if (accountPlan != null && accountPlan.acpl__gf_ap_status_type_name__c == Label.acpl.In_Progress && accountPlan.acpl__gf_ap_indvi_lock_edit_ind_type__c) {
            isInProgress = true;
        }
        return isInProgress;
    }

    /** hasCorrectRole*/
    public static Boolean hasCorrectRole(acpl__Account_Planning__c accountPlan, acpl__Account_Plan_Settings__c apSetting) {
        Boolean hasCorrectRole = false;

        if(apSetting.acpl__Member_Role__c == null || apSetting.acpl__Member_Role__c== '') {
            hasCorrectRole = true;
        } else {
            final List <bupl__AP_Team__c> apTeamList = [SELECT Id, bupl__gf_ap_team_role_user_name__c, bupl__gf_ap_team_user_id__c
                                                  FROM bupl__AP_Team__c
                                                  WHERE bupl__gf_ap_team_role_user_name__c = :apSetting.acpl__Member_Role__c  AND acpl__gf_account_planning_id__c =:accountPlan.Id];

            Final Set<Id> apTeamIdSet = new Set<Id>();
            hasCorrectRole = validateEmpty(apTeamList, apTeamIdSet, hasCorrectRole);
        }
        return hasCorrectRole;
    }

    private static Boolean validateEmpty(List <bupl__AP_Team__c> apTeamList, Set<Id> apTeamIdSet, Boolean hasCorrectRole) {
        if(!apTeamList.isEmpty()) {
            for(bupl__AP_Team__c apTeamMAux : apTeamList) {
                apTeamIdSet.add(apTeamMAux.bupl__gf_ap_team_user_id__c);
            }

            if(apTeamIdSet.contains(userInfo.getUserId())) {
                hasCorrectRole = true;
            }
        }
        return hasCorrectRole;
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
        Final List<User> userList = [SELECT Id, Name, UserRoleId, UserRole.Name FROM User WHERE prof_position_id__c IN ('OS8', 'OS9', 'E01') AND isActive = TRUE];
        
        for(User usItem : userList) {
            if(usItem.UserRoleId == UserInfo.getUserRoleId()) {
                hasCorrectRole = true;
            }
        }
        
        return hasCorrectRole;
    }
    

}