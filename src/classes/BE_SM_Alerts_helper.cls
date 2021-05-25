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
            
    /** @Description  TODAY*/
    private static final Date TODAY = Date.today();
    /** @Description  STARTDATE1T*/
    private static final Date STARTDATE1T = date.valueOf(today.year()+ '-01-01');
    /** @Description  ENDDATE1T*/
    private static final Date ENDDATE1T = date.valueOf(today.year()+ '-03-31');
    /** @Description  STARTDATE2T*/
    private static final Date STARTDATE2T = date.valueOf(today.year()+ '-04-01');
    /** @Description  ENDDATE2T*/
    private static final Date ENDDATE2T = date.valueOf(today.year()+ '-06-30');
    /** @Description  STARTDATE3T*/
    private static final Date STARTDATE3T = date.valueOf(today.year()+ '-07-01');
    /** @Description  ENDDATE3T*/
    private static final Date ENDDATE3T = date.valueOf(today.year()+ '-09-30');
    /** @Description  STARTDATE4T*/
    private static final Date STARTDATE4T = date.valueOf(today.year()+ '-10-01');
    /** @Description  ENDDATE4T*/
    private static final Date ENDDATE4T = date.valueOf(today.year()+ '-12-31');
    
    /*
	 * @Description method BE_SM_Alerts_helper
	 */
    private BE_SM_Alerts_helper() {}

    /*
	 * @Description method getSMAlerts
	 */
    public static BE_SingleRelatedListCRUD_Cls.Response getSMAlerts(Set<String> setStatus, Map<String,Object> params) {
        BE_SingleRelatedListCRUD_Cls.Response response = new BE_SingleRelatedListCRUD_Cls.Response(true, '');
    	Date startDate, endDate;
        
        if(TODAY >= STARTDATE1T  && TODAY <= ENDDATE1T) {
            startDate= STARTDATE1T;
            endDate= ENDDATE1T;
        } else if(TODAY >= STARTDATE2T && TODAY <= ENDDATE2T) {
            startDate= STARTDATE2T;
            endDate= ENDDATE2T;
        } else if(TODAY >= STARTDATE3T && TODAY <= ENDDATE3T) {
            startDate= STARTDATE3T;
            endDate= ENDDATE3T;
        } else {
            startDate= STARTDATE4T;
            endDate= ENDDATE4T;
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