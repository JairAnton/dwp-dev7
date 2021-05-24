/**
   -------------------------------------------------------------------------------------------------
   @Name BE_SM_Alerts_helper
   @Author Gerson R. Díaz Alvarado (gerson.diaz@bbva.com)
   @Date 2020-11-11
   @Description
   @Changes
   Date        Author   Email                  				Type
   2021-05-11  GRDA     gerson.diaz@bbva.com   			 	Creation
   -------------------------------------------------------------------------------------------------
 */
public without sharing class BE_SM_Alerts_helper {
            
    /** @Description  today*/
    private static final Date today = Date.today();
    /** @Description  StartDate1T*/
    private static final Date StartDate1T = date.valueOf(today.year()+ '-01-01');
    /** @Description  EndDate1T*/
    private static final Date EndDate1T = date.valueOf(today.year()+ '-03-31');
    /** @Description  StartDate2T*/
    private static final Date StartDate2T = date.valueOf(today.year()+ '-04-01');
    /** @Description  EndDate2T*/
    private static final Date EndDate2T = date.valueOf(today.year()+ '-06-30');
    /** @Description  StartDate3T*/
    private static final Date StartDate3T = date.valueOf(today.year()+ '-07-01');
    /** @Description  EndDate3T*/
    private static final Date EndDate3T = date.valueOf(today.year()+ '-09-30');
    /** @Description  StartDate4T*/
    private static final Date StartDate4T = date.valueOf(today.year()+ '-10-01');
    /** @Description  EndDate4T*/
    private static final Date EndDate4T = date.valueOf(today.year()+ '-12-31');
    
    /*
	 * @Description method BE_SM_Alerts_helper
	 */
    private BE_SM_Alerts_helper() {}

    /*
	 * @Description method getSMAlerts
	 */
    public static BE_SingleRelatedListCRUD_Cls.Response getSMAlerts(Set<String> setStatus, Map<String,Object> params) {
        BE_SingleRelatedListCRUD_Cls.Response response = new BE_SingleRelatedListCRUD_Cls.Response(true, '');
    	final Date startDate, endDate;
        
        if(today >= StartDate1T  && today <= EndDate1T) {
            startDate= StartDate1T;
            endDate= EndDate1T;
        } else if(today >= StartDate2T && today <= EndDate2T) {
            startDate= StartDate2T;
            endDate= EndDate2T;
        } else if(today >= StartDate3T && today <= EndDate3T) {
            startDate= StartDate3T;
            endDate= EndDate3T;
        } else {
            startDate= StartDate4T;
            endDate= EndDate4T;
        }
        
        Final slmt__Sales_Meeting__c salesMeeting = [SELECT slmt__management_plan_meeting_date__c, Collaborator__c 
                                                    FROM slmt__Sales_Meeting__c WHERE Id=:(String)params.get('recordId')];
        Final Set<Id> setIdsAlert = getAlertsIds(salesMeeting.Collaborator__c, setStatus, startDate, endDate);
        if(!setIdsAlert.isEmpty()) {
            response = getAlerts(setIdsAlert, params);
        }
        return response;
    }
    

    /*
	 * @Description method getAlertsIds
	 */
    private static Set<Id> getAlertsIds(Id collaborator, Set<String> setStatus, Date startDate, Date endDate) {
        Final Set<Id> setIdsAlert = new Set<Id>();
        for(altm__Commercial_Alert__c commercialAlert : [SELECT Id, altm__commercial_alert_end_date__c, commercial_alert_category__c, altm__alert_stage_type__c, OwnerId FROM altm__Commercial_Alert__c 
                                                            WHERE OwnerId =:collaborator AND 
                                                         	altm__alert_stage_type__c IN: setStatus AND
                                                            (altm__commercial_alert_end_date__c >= :startDate AND altm__commercial_alert_end_date__c <= :endDate)]) {
            setIdsAlert.add(commercialAlert.Id);
        }
        return setIdsAlert;
    }
    
    /*
	 * @Description method getAlerts
	 */
    public static BE_SingleRelatedListCRUD_Cls.Response getAlerts(Set<Id> setIds, Map<String, Object> params) {
        Final BE_SingleRelatedListCRUD_Cls.Response response = new BE_SingleRelatedListCRUD_Cls.Response();
        Final String query = 'SELECT Id, '+ String.escapeSingleQuotes((String)params.get('sObjFields'))+ ' FROM '+ String.escapeSingleQuotes((String)params.get('sObjName')) + ' WHERE Id IN:setIds '+ String.escapeSingleQuotes((String)params.get('filterSQOL'));
        response.data = Database.query(query);
        response.isSuccess = true;
        return response;
    }

}