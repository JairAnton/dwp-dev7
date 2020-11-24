/**
   -------------------------------------------------------------------------------------------------
   @Name BE_SM_Opportunity_helper
   @Author Diego Carbajal Pastor (diego.carbajal@bbva.com)
   @Date 2020-11-04
   @Description
   @Changes
   Date        Author   Email                  Type
   2020-11-04  DCP     diego.carbajal@bbva.com    Creation
   -------------------------------------------------------------------------------------------------
 */
public without sharing class BE_SM_Opportunity_helper {

    /* @Description  Variable PRODUCTS*/
    static Final List<String> PRODUCTS = System.Label.Opp_LP_Products.split(',');

    /* @Description  Variable PRODUCTS*/
    static Final Integer MONTH12 = 12;

    /*
	 * @Description  method BE_SM_Opportunity_helper
	 */
    private BE_SM_Opportunity_helper() {}

    /*
	 * @Description  method getSMPipeline
	 */
    public static BE_SingleRelatedListCRUD_Cls.Response getSMPipeline(Set<String> setStages, Map<String,Object> params) {
        BE_SingleRelatedListCRUD_Cls.Response response = new BE_SingleRelatedListCRUD_Cls.Response(true, '');
        Final slmt__Sales_Meeting__c salesMeeting= [SELECT slmt__management_plan_meeting_date__c, Collaborator__c 
                                                    FROM slmt__Sales_Meeting__c WHERE Id=:(String)params.get('recordId')];
        System.debug('salesMeeting.slmt__management_plan_meeting_date__c => '+salesMeeting.slmt__management_plan_meeting_date__c);
        Final Date initDate = Date.newInstance(salesMeeting.slmt__management_plan_meeting_date__c.year(), 
                                                salesMeeting.slmt__management_plan_meeting_date__c.month(), 1);
        Final Set<Id> setIdsOpp = getOppIds(salesMeeting.Collaborator__c, setStages, initDate);
        if(!setIdsOpp.isEmpty()) {
            response = getOpportunities(setIdsOpp, params);
        }
        return response;
    }

    /*
	 * @Description  method getOppIds
	 */
    private static Set<Id> getOppIds(Id collaborator, Set<String> setStages, Date initDate) {
        Final Set<Id> setIdsCol = BE_SM_Utils.getColaborators(collaborator);
        Final Date lastDate = getLastDate(initDate);
        Final Set<Id> setAuxIdsOpp = getOppIdsInColaboration(setIdsCol, setStages);
        Final Set<Id> setIdsOpp = new Set<Id>();
        for(OpportunityLineItem oli: [SELECT Id, OpportunityId FROM OpportunityLineItem WHERE Opportunity.stageName IN: setStages 
                                    AND Opportunity.CloseDate >=:initDate AND Opportunity.CloseDate <=:lastDate AND 
                                    Product2.Unique_id__c IN: PRODUCTS AND (Opportunity.OwnerId IN:setIdsCol OR 
                                    OpportunityId IN:setAuxIdsOpp)]) {
            setIdsOpp.add(oli.OpportunityId);
        }
        return setIdsOpp;
    }

    /*
	 * @Description  method getLastDate
	 */
    private static Date getLastDate(Date initDate) {
        Date lastDate;
        //Si el siguiente mes es enero o mes actual es diciembre
        if(initDate.Month() == MONTH12) {
            lastDate = Date.newInstance(initDate.Year() + 1, 1, Date.daysInMonth(initDate.Year() + 1, 1));
        } else {
            lastDate = Date.newInstance(initDate.Year(), initDate.Month() + 1, Date.daysInMonth(initDate.Year(), initDate.Month() + 1));
        }
        return lastDate;
    }

    /*
	 * @Description  method getOppIdsInColaboration
	 */
    public static Set<Id> getOppIdsInColaboration(Set<Id> setIdsCol, Set<String> setStages) {
        Final List<OpportunityTeamMember> lstOTM = [SELECT Id, OpportunityId FROM OpportunityTeamMember WHERE UserId IN:setIdsCol AND 
                                                    Opportunity.StageName IN: setStages];
        Final Set<Id> setOpp = new Set<Id>();
        for(OpportunityTeamMember otm :lstOTM) {
            setOpp.add(otm.OpportunityId);
        }
        Final Set<Id> setOppIds = new Set<Id>();
        for(OpportunityLineItem oli:[SELECT Id, OpportunityId FROM OpportunityLineItem WHERE OpportunityId IN:setOpp AND 
                                    Product2.Unique_id__c IN: PRODUCTS]) {
            setOppIds.add(oli.OpportunityId);
        }
        return setOppIds;
    }

    /*
	 * @Description  method getOpportunities
	 */
    public static BE_SingleRelatedListCRUD_Cls.Response getOpportunities(Set<Id> setIds, Map<String, Object> params) {
        Final BE_SingleRelatedListCRUD_Cls.Response response = new BE_SingleRelatedListCRUD_Cls.Response();
        Final String query = 'SELECT Id, CurrencyIsoCode, '+ String.escapeSingleQuotes((String)params.get('sObjFields'))+ ' FROM '+ 
                                    String.escapeSingleQuotes((String)params.get('sObjName')) + ' WHERE Id IN:setIds';
        response.data = Database.query(query);
        response.isSuccess = true;
        return response;
    }
}