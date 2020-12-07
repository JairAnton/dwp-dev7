/**
   -------------------------------------------------------------------------------------------------
   @Name BE_SM_FinalizeModal_Ctr
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-11-11
   @Description
   @Changes
   Date        Author   Email                  				Type
   2020-12-04  MAMCH    martin.mori.contractor@bbva.com    	Creation
   -------------------------------------------------------------------------------------------------
 */
public without sharing class BE_SM_ReasignTopics_Ctr {
    /* @Variable: MESSAGE */
    public static Final String MESSAGE = 'message';
    /*   @Variable: ISSUCCESS*/
    public static Final String ISSUCCESS = 'isSuccess';
    
    /*
	 * @Description constructor method
	 */
    private BE_SM_ReasignTopics_Ctr() {}
    
    /*
	 * @Description method returnUsers
	 */
    @AuraEnabled
    public static Map<String, String> returnUsers(String slmtId) {
        Final Map<String, String> mapReturn = new Map<String, String>();
        for(slmt__Sales_Meeting__c slmtAux : [SELECT Id, Collaborator__c, Collaborator__r.Name, slmt__mngmt_plan_meeting_user_id__c, slmt__mngmt_plan_meeting_user_id__r.Name FROM slmt__Sales_Meeting__c WHERE Id=:slmtId]) {
            mapReturn.put(slmtAux.Collaborator__c, slmtAux.Collaborator__r.Name);
            mapReturn.put(slmtAux.slmt__mngmt_plan_meeting_user_id__c, slmtAux.slmt__mngmt_plan_meeting_user_id__r.Name);
        }  
        return mapReturn;
    }
    
    /*
	 * @Description method reasingTopics
	 */
    @AuraEnabled
    public static  Map<String, Object> reasingTopics(String slmtId, String ownerId) {
        final Map<String, Object> res = new Map<String, Object>();
        //try {
            final Map<Id,Task> taskMap= new Map<Id,Task>([SELECT ID,OwnerId FROM Task WHERE slmt__management_plan_meeting_id__c=:slmtId AND OwnerId=:ownerId AND Status='Open']);
            for (String taskId : taskMap.KeySet()) {
                taskMap.get(taskId).OwnerId=UserInfo.getUserId();
            }
            if(taskMap.isEmpty()) {
                res.put(ISSUCCESS, false);
                res.put(MESSAGE, 'No existen registros a actualizar.');
            } else {
                final slmt__Sales_Meeting__c ltsSM = [SELECT Id, Collaborator__c, slmt__mngmt_plan_meeting_user_id__c FROM slmt__Sales_Meeting__c WHERE Id = :slmtId LIMIT 1];
                if(ltsSM.Collaborator__c == ownerId) {
                    update new slmt__Sales_Meeting__c(Id=slmtId, auxiliar_collaborator__c=UserInfo.getUserId());
                } else {
                    update new slmt__Sales_Meeting__c(Id=slmtId, auxiliar_manager__c=UserInfo.getUserId());
                }
                update taskMap.values();
                res.put(ISSUCCESS, true);
            }
        /*} catch (Exception e) {
            res.put(ISSUCCESS, false);
            res.put(MESSAGE, 'Error al reasignar temas.');
        }*/
        return res;
    }
}