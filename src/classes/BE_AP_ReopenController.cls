/**@Name BE_AP_ReopenController
   @Author Jair Anton
   @Date 2021-08-19
   Date        Author       Email                  Type
   2021-08-19   JAAA    jair.anton.contractor@bbva.com  creation
*/
public with sharing class BE_AP_ReopenController {
    @AuraEnabled
    public static Boolean reopenAPValidated(String recordId) {
        Boolean isValidated = false;

        Final List<acpl__Account_Planning__c> apList = [SELECT Id, Name, acpl__gf_ap_status_type_name__c, acpl__gf_ap_substatus_type_name__c, acpl__gf_ap_indvi_lock_edit_ind_type__c 
                            FROM acpl__Account_Planning__c WHERE Id =: recordId];
        
        for(acpl__Account_Planning__c item : apList) {
            item.acpl__gf_ap_status_type_name__c = 'In Progress';
            item.acpl__gf_ap_substatus_type_name__c = 'Pre-validated';
            item.acpl__gf_ap_indvi_lock_edit_ind_type__c = true;
        }

        if(apList.size() > 0) {
            update apList;
            isValidated = true;
        }
        
        return isValidated;
    }
}