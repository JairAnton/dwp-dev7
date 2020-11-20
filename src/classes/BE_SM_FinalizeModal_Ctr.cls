/**
   -------------------------------------------------------------------------------------------------
   @Name BE_SM_FinalizeModal_Ctr
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-11-11
   @Description
   @Changes
   Date        Author   Email                  				Type
   2020-11-11  MAMCH    martin.mori.contractor@bbva.com    	Creation
   -------------------------------------------------------------------------------------------------
 */
public with sharing class BE_SM_FinalizeModal_Ctr {
    /* @Variable: FORMAT_DATE */
    public static Final String FORMAT_DATE = 'dd-MM-YYYY HH:mm a';
    
    /*
	 * @Description method getStatusMeeting
	 */
    @AuraEnabled
    public static Map<String, Object> getStatusMeeting(String recordId) {
        Final Map<String, Object> res = new Map<String, Object>();
        if(recordId!=null) {
            try {
                Final slmt__Sales_Meeting__c meeting = [SELECT Id, slmt__mngmt_plan_meeting_status_name__c FROM slmt__Sales_Meeting__c WHERE Id =:recordId LIMIT 1];
                if(meeting.slmt__mngmt_plan_meeting_status_name__c=='Planned') {
                    res.put('isSuccess', true);
                    res.put('message', 'success');
                } else {
                    res.put('isSuccess', false);
                    res.put('message', 'Solo las reuniones en estado: En preparación, pueden ser finalizadas.');
                }
            } catch (Exception ex) {
                res.put('isSuccess', false);
                res.put('message', ex.getMessage());
            }
        } else {
            res.put('isSuccess', false);
            res.put('message', 'error id no valid');
        }
        return res;
    }

    /*
	 * @Description method finalizeMeeting
	 */
    @AuraEnabled
    public static Map<String, Object> finalizeMeeting(String recordId, String summary) {
        Final Map<String, Object> res = new Map<String, Object>();
        if(recordId!=null) {
            try {
                Final slmt__Sales_Meeting__c slmtRecord = new slmt__Sales_Meeting__c();
                slmtRecord.Id = recordId;
                slmtRecord.slmt__mngmt_plan_meeting_status_name__c = 'Finalized';
                slmtRecord.Summary__c = summary;
                update slmtRecord;
                Final slmt__Sales_Meeting__c meeting = [SELECT Id, Name, slmt__management_plan_meeting_date__c, slmt__mngmt_plan_meet_dur_number__c, 
                	slmt__mngmt_plan_meeting_start_desc__c, slmt__mngmt_plan_meeting_status_name__c, slmt__mngmt_plan_meeting_user_id__c, 
                	slmt__mngmt_plan_meeting_user_id__r.Email, Type_of_meeting__c, Collaborator__c, Collaborator__r.Email, 
                	DateTime__c, Url__c FROM slmt__Sales_Meeting__c WHERE Id =:recordId LIMIT 1];
                Final ApexPages.StandardController sc = new ApexPages.StandardController(slmtRecord);
				Final BE_SM_Minute_Ctr slmtMinute = new BE_SM_Minute_Ctr(sc);
                slmtMinute.sendMail();
                
                res.put('isSuccess', true);
                res.put('message', 'success');
            } catch (Exception ex) {
                res.put('isSuccess', false);
                res.put('message', ex.getMessage());
            }
        } else {
            res.put('isSuccess', false);
            res.put('message', 'error id no valid');
        }
        return res;
    }
}