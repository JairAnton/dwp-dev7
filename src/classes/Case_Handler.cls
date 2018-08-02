public with sharing class Case_Handler {
    public void caseAfterUpdate(List<Case> lstNew, Map<Id,Case> mpOld){
        Case_Helper.updateCaseNotification(lstNew,mpOld);
    }
    public void caseAfterInsert(List<Case> lstNew){
        Case_Helper.insertCaseNotification(lstNew);        
    }
}