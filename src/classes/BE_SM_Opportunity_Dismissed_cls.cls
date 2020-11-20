/**
   -------------------------------------------------------------------------------------------------
   @Name BE_SM_Opportunity_Dismissed_cls
   @Author Diego Carbajal Pastor (diego.carbajal@bbva.com)
   @Date 2020-11-04
   @Description
   @Changes
   Date        Author   Email                  Type
   2020-11-04  DCP     diego.carbajal@bbva.com    Creation
   -------------------------------------------------------------------------------------------------
 */
public with sharing class BE_SM_Opportunity_Dismissed_cls extends BE_SingleRelatedListCRUD_Cls {
    
    /*
	 * @Description  method readRecords
	 */
    public override BE_SingleRelatedListCRUD_Cls.Response readRecords(Map<String,Object> params) {
        //return BE_SM_Opportunity_helper.getSMOpportunities(new Set<String>{'07'}, params);
        Final Set<String> setStages = new Set<String>{'07'};
        BE_SingleRelatedListCRUD_Cls.Response response = new BE_SingleRelatedListCRUD_Cls.Response(true, '');
        Final slmt__Sales_Meeting__c salesMeeting= [SELECT slmt__management_plan_meeting_date__c, Collaborator__c 
                                                    FROM slmt__Sales_Meeting__c WHERE Id=:(String)params.get('recordId')];
        Final Set<Id> setIdsCol = BE_SM_Utils.getColaborators(salesMeeting.Collaborator__c);
        Final List<String> lstProducts = System.Label.Opp_LP_Products.split(',');
        Final Date last30Date = salesMeeting.slmt__management_plan_meeting_date__c.addDays(-30);
        Final Set<Id> setAuxIdsOpp = BE_SM_Opportunity_helper.getOppIdsInColaboration(setIdsCol, setStages);
        Final Set<Id> setIdsOpp = new Set<Id>();
        System.debug('setIdsCol => '+setIdsCol);
        System.debug('setAuxIdsOpp => '+setAuxIdsOpp);
        System.debug('setStages => '+setStages);
        System.debug('slmt__management_plan_meeting_date__c => '+salesMeeting.slmt__management_plan_meeting_date__c);
        System.debug('lstProducts => '+lstProducts);
        for(OpportunityLineItem oli: [SELECT Id, OpportunityId, Opportunity.CloseDate FROM OpportunityLineItem WHERE 
                                    Opportunity.CloseDate <:salesMeeting.slmt__management_plan_meeting_date__c AND 
                                    Opportunity.CloseDate >=:last30Date AND Product2.Unique_id__c IN: lstProducts AND 
                                    Opportunity.stageName IN: setStages AND  
                                    (Opportunity.OwnerId IN:setIdsCol OR OpportunityId in:setAuxIdsOpp)]) {
            setIdsOpp.add(oli.OpportunityId);
        }
        System.debug('setIdsOpp => '+setIdsOpp);
        if(!setIdsOpp.isEmpty()) {
            response = BE_SM_Opportunity_helper.getOpportunities(setIdsOpp, params);
        }
        return response;
    }
}