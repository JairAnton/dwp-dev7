public with sharing class Case_Helper {
    
    public static void updateCaseNotification(List<Case> lstNew, Map<Id,Case> mapOld) {
        Final String rtId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Formalization'].Id;
        List <Id> lstId = new List <Id>();
        for (Case casnew : lstNew) {
            Case oldRecord = mapOld.get(casnew.Id);
            if(!casnew.IsClosed && casnew.OwnerId!=oldRecord.OwnerId && casnew.recordTypeId != rtId) {
                lstId.add(casnew.Id);                
            }            
        }
        if(!lstId.isEmpty()) {
            DynamicBatchChatterNotification.getDynamicBatchChatterNotification(lstId, 'Case', Label.lblREASIGN_CASE);
        }       
    }
    
    public static void insertCaseNotification(List<Case> lstNew) {
        Final String rtId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Formalization'].Id;
        List <Id> lstId = new List <Id>();
        for (Case cas : lstNew) {
            if(!cas.IsClosed && cas.recordTypeId != rtId) {
                lstId.add(cas.Id);                
            }            
        }
        if(!lstId.isEmpty()) {
            DynamicBatchChatterNotification.getDynamicBatchChatterNotification(lstId, 'Case', Label.lblCREATE_CASE);
        }
    }
    
    /**
* Method using to Update rate
* 

    public static void UpdaterateCases(List<Case> lstNew){
        set<id> iOpportuni = new set<Id>();
        for(case cas : lstNew)
            if(cas.opportunity_id__c!=null)
            iOpportuni.add(cas.opportunity_id__c);
        If(!iOpportuni.isempty()){   
            Map<Id,OpportunityLineItem> MAOLI = new Map<Id,OpportunityLineItem>();
            for(OpportunityLineItem OLI : [Select Id,OpportunityId, proposed_fee_per__c,proposed_apr_per__c   from 
                                           OpportunityLineItem where OpportunityId IN :iOpportuni 
                                           order by createdDate asc])
                MAOLI.put(OLI.OpportunityId, OLI); 
            
            for(case cas : lstNew){
                if(!String.isBlank(String.valueOf(MAOLI.get(cas.opportunity_id__c).proposed_fee_per__c)))
                cas.proposed_apr_per__c=MAOLI.get(cas.opportunity_id__c).proposed_fee_per__c;
                else
                cas.proposed_apr_per__c=MAOLI.get(cas.opportunity_id__c).proposed_apr_per__c;
            }
        }
    }*/
}