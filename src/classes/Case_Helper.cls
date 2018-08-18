public with sharing class Case_Helper {
    public static void updateCaseNotification(List<Case> lstNew, Map<Id,Case> mapOld){
        List <Id> lstId = new List <Id>();
        for (Case casnew : lstNew){
            Case oldRecord = mapOld.get(casnew.Id);
            if(!casnew.IsClosed && casnew.OwnerId!=oldRecord.OwnerId){
                lstId.add(casnew.Id);                
            }            
        }
        if(!lstId.isEmpty()){
            DynamicBatchChatterNotification.getDynamicBatchChatterNotification(lstId, 'Case', Label.lblREASIGN_CASE);
        }       
        
    }
    public static void insertCaseNotification(List<Case> lstNew){
        List <Id> lstId = new List <Id>();
        for (Case cas : lstNew){
            if(!cas.IsClosed){
                lstId.add(cas.Id);                
            }            
        }
        if(!lstId.isEmpty()){
            DynamicBatchChatterNotification.getDynamicBatchChatterNotification(lstId, 'Case', Label.lblCREATE_CASE);
        }
        
    }
    /**
* Method using to Update rate
* 
*/
    public static void UpdaterateCases(List<Case> lstNew){
        set<id> iOpportuni = new set<Id>();
        for(case cas : lstNew)
            if(cas.opportunity_id__c!=null)
            iOpportuni.add(cas.opportunity_id__c);
        If(!iOpportuni.isempty()){   
            Map<Id,OpportunityLineItem> MAOLI = new Map<Id,OpportunityLineItem>();
            for(OpportunityLineItem OLI : [Select Id,OpportunityId, proposed_fee_per__c   from 
                                           OpportunityLineItem where OpportunityId IN :iOpportuni])
                MAOLI.put(OLI.OpportunityId, OLI); 
            
            for(case cas : lstNew){
                cas.proposed_apr_per__c=MAOLI.get(cas.opportunity_id__c).proposed_fee_per__c;
            }
        }
    }
    
}