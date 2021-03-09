/**
   -------------------------------------------------------------------------------------------------
   @Name BE_AP_UpdateAPQuestions
   @Author Lolo Bravo
   @Date 2020-11-04
   @Description
   @Changes
   Date        Author       Email                  Type
   2021-03-04  LMBR     	lolo.bravo@bbva.com    Creation
   -------------------------------------------------------------------------------------------------
 */
global without sharing class APDynamicButtonsStatusHandlerTactico implements dwp_dbpn.DynamicButtonsStatusInterface {
	/** getDynamicButtonStatus*/
    global static Set<String> getDynamicButtonStatus(String recordId, String sObjectName) {
        Set<String> buttonsStatusSet = new Set<String>();
        /*string para guardar el perfil del current user*/
        final String currentUserId = userInfo.getProfileId();

        /*Id del AP para obtener su estado*/
        final acpl__Account_Planning__c accountPlan = [SELECT Id, acpl__gf_ap_status_type_name__c, acpl__gf_ap_indvi_lock_edit_ind_type__c
                                            FROM acpl__Account_Planning__c
                                            WHERE Id = :recordId LIMIT 1].get(0);

        /*Rol del usuario*/
        acpl__Account_Plan_Settings__c apSetting = acpl__Account_Plan_Settings__c.getInstance();

        //Si ap desbloqueado, añado los botones de "Growth Drivers" y "Needs"
        if(accountPlan.acpl__gf_ap_indvi_lock_edit_ind_type__c) {
            buttonsStatusSet.add('AP_New_Growth_Driver_Tactico');
            buttonsStatusSet.add('AP_New_Need_Tactico');
        }
        //Si ap in progress, desbloqueado y rol correcto, añado el botón "Ask for Validation"
        if(apInProgressUnlocked(accountPlan) && hasCorrectRole(accountPlan, apSetting)) {
            buttonsStatusSet.add('AP_Ask_for_validation_Tactico');
        }
        return buttonsStatusSet;
    }
	
    /** apInProgressUnlocked*/
    public static Boolean apInProgressUnlocked(acpl__Account_Planning__c accountPlan) {
        Boolean isInProgress = false;
        if (accountPlan != null) {
            if ( accountPlan.acpl__gf_ap_status_type_name__c == Label.acpl.In_Progress && accountPlan.acpl__gf_ap_indvi_lock_edit_ind_type__c) {
                isInProgress = true;
            }
        }
        return isInProgress;
    }
    /** hasCorrectRole*/
    public static Boolean hasCorrectRole(acpl__Account_Planning__c accountPlan, acpl__Account_Plan_Settings__c apSetting) {
        Boolean hasCorrectRole = false;
        System.debug(Label.acpl.Button_Collection_No_Actions);
        System.debug(Label.acpl.Ask_for_validation);
        if(apSetting.acpl__Member_Role__c == null || apSetting.acpl__Member_Role__c== '') {
            hasCorrectRole = true;
        } else {
            final List <bupl__AP_Team__c> apTeamList = [SELECT Id, bupl__gf_ap_team_role_user_name__c, bupl__gf_ap_team_user_id__c
                                                  FROM bupl__AP_Team__c
                                                  WHERE bupl__gf_ap_team_role_user_name__c = :apSetting.acpl__Member_Role__c  AND acpl__gf_account_planning_id__c =:accountPlan.Id];

            Set<Id> apTeamIdSet = new Set<Id>();
            if(!apTeamList.isEmpty()) {
                for(bupl__AP_Team__c apTeamMAux :apTeamList) {
                    apTeamIdSet.add(apTeamMAux.bupl__gf_ap_team_user_id__c);
                }
                if(apTeamIdSet.contains(userInfo.getUserId())) {
                    hasCorrectRole = true;
                }
            }
        }
        return hasCorrectRole;
    }

}