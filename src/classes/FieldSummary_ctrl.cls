/**
* @author Global_HUB developers
* @date 12-06-2019
*
* @group Global_HUB
*
* @description Controller class from FieldSummary_ctrl
**/
public with sharing class FieldSummary_ctrl {
    
    /**
     * This is the method constructor of the class
     */
    private FieldSummary_ctrl() {
        
    }
    
    /**
     * This method is used to change status type to 11 in opportunity
     * @param recordId This is Opportunity Id that will update
     * @return Map<String,Object> This returns map with result of operation.
     */
    @AuraEnabled
    public static Map<String,Object> doSave(String recordId, string storeHtml) {
        Final Map<String,Object> mapReturn = new Map<String,Object>();
        Final Opportunity opp = new Opportunity();
        opp.Id = recordId;
        opp.opportunity_status_type__c = '11';
        opp.isProcess__c = true;
        try {
            update opp;
            opp.isProcess__c=false;
            update opp;
            
            List<dwp_cvad__Action_Audit__c> lstAudit = new List<dwp_cvad__Action_Audit__c>();
            lstAudit.add(Action_Audit_Helper.getAudit('Price approved', 'Opportunity', recordId, DateTime.now(), label.AuditPriceApproval, UserInfo.getUserId(), 'approveTop', null, false));
            insert lstAudit;
            
            List<dwp_cvad__Action_Audit_Detail__c> lstDetails = new List<dwp_cvad__Action_Audit_Detail__c>();
            lstDetails.add(Action_Audit_Helper.getAuditDetail(lstAudit[0].Id, storeHtml, 1, '', 'Embedded'));
            insert lstDetails;
            
            mapReturn.put('isOk',true);
        } catch (Exception e) {
            mapReturn.put('isOk',false);
            mapReturn.put('errorMessage',e.getMessage());
        }
        return mapReturn;
    }
}