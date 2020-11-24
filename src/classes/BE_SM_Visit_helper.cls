/**
   -------------------------------------------------------------------------------------------------
   @Name BE_SM_Visit_helper
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-11-11
   @Description
   @Changes
   Date        Author   Email                  				Type
   2020-11-11  MAMCH    martin.mori.contractor@bbva.com    	Creation
   -------------------------------------------------------------------------------------------------
 */
public without sharing class BE_SM_Visit_helper {
    /*
	 * @Description method BE_SM_Opportunity_helper
	 */
    private BE_SM_Visit_helper() {}

    /*
	 * @Description method getSMPlanningVisits
	 */
    public static BE_SingleRelatedListCRUD_Cls.Response getSMPlanningVisits(Set<String> setStatus, Map<String,Object> params) {
        BE_SingleRelatedListCRUD_Cls.Response response = new BE_SingleRelatedListCRUD_Cls.Response(true, '');
        Final slmt__Sales_Meeting__c salesMeeting = [SELECT slmt__management_plan_meeting_date__c, Collaborator__c 
                                                    FROM slmt__Sales_Meeting__c WHERE Id=:(String)params.get('recordId')];
        Final Date initDate = Date.newInstance(salesMeeting.slmt__management_plan_meeting_date__c.year(), 
                                               salesMeeting.slmt__management_plan_meeting_date__c.month(), 1);
        Final Integer numberOfDays = Date.daysInMonth(initDate.year(), initDate.month());
		Final Date lastDate = Date.newInstance(initDate.year(), initDate.month(), numberOfDays);
        Final Set<Id> setIdsVisit = getVisitIds(salesMeeting.Collaborator__c, setStatus, initDate, lastDate);
        if(!setIdsVisit.isEmpty()) {
            response = getVisits(setIdsVisit, params);
        }
        return response;
    }
    
    /*
	 * @Description method getSMRealizedVisits
	 */
    public static BE_SingleRelatedListCRUD_Cls.Response getSMRealizedVisits(Set<String> setStatus, Map<String,Object> params) {
        BE_SingleRelatedListCRUD_Cls.Response response = new BE_SingleRelatedListCRUD_Cls.Response(true, '');
        Final slmt__Sales_Meeting__c salesMeeting = [SELECT slmt__management_plan_meeting_date__c, Collaborator__c 
                                                    FROM slmt__Sales_Meeting__c WHERE Id=:(String)params.get('recordId')];
        Final Date initDate = salesMeeting.slmt__management_plan_meeting_date__c.addDays(-30);
        Final Set<Id> setIdsVisit = getVisitIds(salesMeeting.Collaborator__c, setStatus, initDate, salesMeeting.slmt__management_plan_meeting_date__c);
        if(!setIdsVisit.isEmpty()) {
            response = getVisits(setIdsVisit, params);
        }
        return response;
    }

    /*
	 * @Description method getVisitIds
	 */
    private static Set<Id> getVisitIds(Id collaborator, Set<String> setStages, Date initDate, Date lastDate) {
        Final Set<Id> setIdsVisit = new Set<Id>();
        for(dwp_kitv__Visit_Management_Team__c vTeam : [SELECT Id, dwp_kitv__visit_id__c FROM dwp_kitv__Visit_Management_Team__c  WHERE dwp_kitv__visit_id__r.dwp_kitv__visit_status_type__c IN: setStages 
                                                        AND dwp_kitv__user_id__c = :collaborator AND dwp_kitv__visit_id__r.start_date_calculated__c >= :initDate AND dwp_kitv__visit_id__r.start_date_calculated__c <= :lastDate]) {
            setIdsVisit.add(vTeam.dwp_kitv__visit_id__c);
        }
        return setIdsVisit;
    }

    /*
	 * @Description method getVisits
	 */
    public static BE_SingleRelatedListCRUD_Cls.Response getVisits(Set<Id> setIds, Map<String, Object> params) {
        Final BE_SingleRelatedListCRUD_Cls.Response response = new BE_SingleRelatedListCRUD_Cls.Response();
        Final String query = 'SELECT Id, '+ String.escapeSingleQuotes((String)params.get('sObjFields'))+ ' FROM '+ String.escapeSingleQuotes((String)params.get('sObjName')) + ' WHERE Id IN:setIds';
        response.data = Database.query(query);
        response.isSuccess = true;
        return response;
    }
}