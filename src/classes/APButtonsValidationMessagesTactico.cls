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
global without sharing class APButtonsValidationMessagesTactico implements dwp_dbpn.DynamicFlowValidationInterface {
	/** getErrorMessagesList*/
    global static List<String> getErrorMessagesList(String recordId, String source, String validationClass) {
        List<String> lstErrorMessage;
        lstErrorMessage = new List<String>();
        
        lstErrorMessage = fieldsNoComplete(recordId, source, validationClass);
        
        Set<String> buttonsStatusSet = new Set<String>();
        /*string para guardar el perfil del current user*/
        final String currentUserId = userInfo.getProfileId();
        
        /*Id del AP para obtener su estado*/
        final acpl__Account_Planning__c accountPlan = [SELECT Id, acpl__gf_ap_status_type_name__c, acpl__gf_ap_indvi_lock_edit_ind_type__c
                                                       FROM acpl__Account_Planning__c
                                                       WHERE Id = :recordId LIMIT 1].get(0);
        System.debug('#accountPlan##'+accountPlan);
        /*Rol del usuario*/
        acpl__Account_Plan_Settings__c apSetting = acpl__Account_Plan_Settings__c.getInstance();
        
        //Si ap desbloqueado, añado los botones de "Growth Drivers" y "Needs"
        if (validationClass == 'AP_New_Growth_Driver' || validationClass == 'AP_New_Need'){
            if(!accountPlan.acpl__gf_ap_indvi_lock_edit_ind_type__c) {
                lstErrorMessage.add(system.label.acpl.Acc_Plan_Do_Not_Meet_Conds);
            }
        }
        //Si ap in progress, desbloqueado y rol correcto, añado el botón "Ask for Validation"
        if (validationClass == 'AP_Ask_for_validation'){
            if(!APDynamicButtonsStatusHandlerTactico.apInProgressUnlocked(accountPlan) || !APDynamicButtonsStatusHandlerTactico.hasCorrectRole(accountPlan, apSetting)) {
                lstErrorMessage.add(system.label.acpl.Acc_Plan_Do_Not_Meet_Conds);
            }
        }
        System.debug('##lstErrorMessage###'+lstErrorMessage);
        return lstErrorMessage;
    }
    /** fieldsNoComplete*/
    public static List<String> fieldsNoComplete (String recordId, String source, String validationClass){
        List<String> lstErrorMessage = new List<String>();
        acpl__Account_Planning__c ap = [SELECT Id, acpl__Account_Planning_Type__c FROM acpl__Account_Planning__c WHERE id = :recordId LIMIT 1];
        Id devRecordTypeId = Schema.SObjectType.acpl__Account_Planning__c.getRecordTypeInfosByName().get('Question Catalog').getRecordTypeId();
        acpl__Account_Planning__c apCatalog = [SELECT Id from acpl__Account_Planning__c where RecordTypeId = :devRecordTypeId AND acpl__Account_Planning_Type__c = :ap.acpl__Account_Planning_Type__c limit 1];
        
        string recordLike = recordId + '%';
        list<dyfr__Field_Config__c> fcList = [select Id, Name, dyfr__DeveloperName__c, dyfr__Important__c,
                                              dyfr__Map_field__c from dyfr__Field_Config__c where dyfr__DeveloperName__c like :recordLike];
        if (fcList.isEmpty()) {
            string recordLikeCatalog = apCatalog.Id + '%';
            fcList = [select Id, Name, dyfr__DeveloperName__c, dyfr__Important__c,
                      dyfr__Map_field__c from dyfr__Field_Config__c where dyfr__DeveloperName__c like :recordLikeCatalog];            
            
        }
        list<acpl__AP_Question__c> apList = [select Id, Name, acpl__gf_account_planning_id__c, acpl__AA_answer__c, acpl__AA_answer_checkbox__c,
                                             acpl__AA_answer_currency__c, acpl__AA_answer_date__c, acpl__AA_answer_is_checkbox__c,
                                             acpl__AA_answer_number__c, acpl__AA_answer_text__c, acpl__AA_answer_text_area2__c,
                                             acpl__AA_answer_text_area__c, acpl__gf_ap_answer_form_desc2__c, acpl__gf_ap_answer_form_desc__c,
                                             acpl__gf_ap_question_form_desc__c from acpl__AP_Question__c where acpl__gf_account_planning_id__c = :recordId];
        System.debug('###apList###'+apList);
        Map<String, dyfr__Field_Config__c> fcMap = new Map<String, dyfr__Field_Config__c>();
        for(integer i = 0 ; i < fcList.size() ; i++ ){
            fcMap.put(fcList[i].dyfr__DeveloperName__c,fcList[i]);
        }
        
        for(integer i = 0 ; i < apList.size() ; i++ ) {
            boolean isImportant = fcMap.get(apList[i].name).dyfr__Important__c;
            if(isImportant) {
                String fieldName = fcMap.get(apList[i].name).dyfr__Map_field__c;
                if(fieldName == 'acpl__AA_answer_checkbox__c' && !apList[i].acpl__AA_answer_checkbox__c){
                    lstErrorMessage.add(System.Label.Validation_error_for_fields_not_completed_tactico + ': ' + apList[i].acpl__gf_ap_question_form_desc__c);
                } else if(String.isBlank(String.valueOf(apList[i].get(fieldName)))) {
                    lstErrorMessage.add(System.Label.Validation_error_for_fields_not_completed_tactico + ': ' + apList[i].acpl__gf_ap_question_form_desc__c);
                }
            }
        }
        System.debug('##lstErrorMessage###'+lstErrorMessage);
        return lstErrorMessage;
        
    }
}