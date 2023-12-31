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
public without sharing class BE_SM_FinalizeModal_Ctr {
    /* @Variable: MESSAGE */
    public static Final String MESSAGE = 'message';
    /*   @Variable: ISSUCCESS
	 */
	public static Final String ISSUCCESS = 'isSuccess';
    /*   @Variable: ISSUCCESS
	 */
	public static Final String PLANNED = 'Planned';
    
    /*
	 * @Description constructor method
	 */
    private BE_SM_FinalizeModal_Ctr() {}

    /*
	 * @Description method getStatusMeeting
	 */
    @AuraEnabled
    public static Map<String, Object> getStatusMeeting(String recordId) {
        Final Map<String, Object> res = new Map<String, Object>();
        if(recordId==null) {
            res.put(ISSUCCESS, false);
            res.put(MESSAGE, 'error id no valid');
        } else {
            try {
                Final slmt__Sales_Meeting__c meeting = [SELECT Id, slmt__mngmt_plan_meeting_status_name__c, Summary__c FROM slmt__Sales_Meeting__c WHERE Id =:recordId LIMIT 1];
                if(meeting.slmt__mngmt_plan_meeting_status_name__c==PLANNED) {
                    res.put('summary', meeting.Summary__c);
                    res.put(ISSUCCESS, true);
                    res.put(MESSAGE, 'success');
                } else {
                    res.put(ISSUCCESS, false);
                    res.put(MESSAGE, 'Solo las reuniones en estado: En preparación, pueden ser finalizadas.');
                }
            } catch (Exception ex) {
                res.put(ISSUCCESS, false);
                res.put(MESSAGE, ex.getMessage());
            }
        }
        return res;
    }

    /*
	 * @Description method finalizeMeeting
	 */
    @AuraEnabled
    public static Map<String, Object> finalizeMeeting(String recordId, String summary) {
        Final Map<String, Object> res = new Map<String, Object>();
        if(recordId==null) {
            res.put(ISSUCCESS, false);
            res.put(MESSAGE, 'error id no valid');
        } else {
            try {
                Final slmt__Sales_Meeting__c slmtRecord = new slmt__Sales_Meeting__c();
                slmtRecord.Id = recordId;
                slmtRecord.slmt__mngmt_plan_meeting_status_name__c = 'Finalized';
                slmtRecord.Summary__c = summary;
                update slmtRecord;
                res.put(ISSUCCESS, true);
                res.put(MESSAGE, 'success');
            } catch (DMLException ex) {
                res.put(ISSUCCESS, false);
                res.put(MESSAGE, eX.getDmlMessage(0));
            } catch (Exception ex) {
                res.put(ISSUCCESS, false);
                res.put(MESSAGE, ex.getMessage());
            }
        }
        return res;
    }
    
    /*
	 * @Description method sendMinute
	 */
    @AuraEnabled
    public static Map<String, Object> sendMinute(String recordId) {
        Final Map<String, Object> res = new Map<String, Object>();
        if(recordId==null) {
            res.put(ISSUCCESS, false);
            res.put(MESSAGE, 'error id no valid');
        } else {
            try {
                Final ApexPages.StandardController standCtr = new ApexPages.StandardController(new slmt__Sales_Meeting__c(Id = recordId));
				Final BE_SM_Minute_Ctr slmtMinute = new BE_SM_Minute_Ctr(standCtr);
                slmtMinute.sendMail();
                res.put(ISSUCCESS, true);
                res.put(MESSAGE, 'success');
            } catch (DMLException ex) {
                res.put(ISSUCCESS, false);
                res.put(MESSAGE, eX.getDmlMessage(0));
            } catch (Exception ex) {
                res.put(ISSUCCESS, false);
                res.put(MESSAGE, ex.getMessage());
            }
        }
        return res;
    }
}
