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
    
}