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
     * This method is used to get information from a specific object
     * @param recordId This is id of record that will get information
     * @param uniqueNameTable This is unique id of the form table
     * @param isOkLabel Label of map
     * @return Map<String,Object> This returns map with result of operation.
     */
 	@AuraEnabled
    public static Map<String,Object> getInfo(String recordId, String isOkLabel) {
        Final Map<String,Object> mapReturn = new Map<String,Object>();
        Final List<String> values = new List<String>();
        OpportunityLineItem oli = new OpportunityLineItem();
        try {
        	oli = [SELECT Id,Name,Product2.Name,CurrencyIsoCode,UnitPrice,cpliq_Commission__c,cpliq_Fecha_Vencimiento__c,cpliq_Emission__c,cpliq_Negotiation__c,cpliq_Payment_Dif__c,cpliq_Extension__c,cpliq_Increase__c,cpliq_BBVA__c,cpliq_Bco_Correspondent__c,cpliq_Total__c FROM OpportunityLineItem WHERE Id = :recordId][0];
            values.add(String.valueOf(oli.UnitPrice.setScale(2)));
            values.add(oli.Product2.Name);
            switch on oli.cpliq_Commission__c {
                when '02' {
                    if(oli.cpliq_Fecha_Vencimiento__c!=null) {
                        Final DateTime dateExpired = DateTime.newInstance(oli.cpliq_Fecha_Vencimiento__c.year(), oli.cpliq_Fecha_Vencimiento__c.month(), oli.cpliq_Fecha_Vencimiento__c.day());
                        values.add(dateExpired.format('dd/MM/yyyy'));
                    }
                }
                when '03' {
                    values.add(String.valueOf(oli.cpliq_Emission__c.setScale(2)));
                    values.add(String.valueOf(oli.cpliq_Negotiation__c.setScale(2)));
                    values.add(String.valueOf(oli.cpliq_Payment_Dif__c.setScale(2)));
                    values.add(String.valueOf(oli.cpliq_Extension__c.setScale(2)));
                    values.add(String.valueOf(oli.cpliq_Increase__c.setScale(2)));
                }
                when '04' {
                    values.add(String.valueOf(oli.cpliq_BBVA__c.setScale(2)));
                    values.add(String.valueOf(oli.cpliq_Bco_Correspondent__c.setScale(2)));
                }
                when '05'{
                    values.add(String.valueOf(oli.cpliq_BBVA__c.setScale(2)));
                    values.add(String.valueOf(oli.cpliq_Bco_Correspondent__c.setScale(2)));
                    values.add(String.valueOf(oli.cpliq_Total__c.setScale(2)));
                }
            }
            mapReturn.put('values',values);
            mapReturn.put(isOkLabel,true);
        } catch (Exception e) {
            mapReturn.put('values',values);
            mapReturn.put(isOkLabel,false);
            mapReturn.put('errorMessage',e.getMessage());
        }
        return mapReturn;
    }
    
    /**
     * This method is used to change status type to 11 in opportunity
     * @param recordId This is Opportunity Id that will update
     * @param isOkLabel Label of map
     * @return Map<String,Object> This returns map with result of operation.
     */
    @AuraEnabled
    public static Map<String,Object> doSave(String recordId, String storeHtml, String isOkLabel) {
        Final Map<String,Object> mapReturn = new Map<String,Object>();
        Final List<dwp_cvad__Action_Audit__c> lstAudit = new List<dwp_cvad__Action_Audit__c>();
        Final List<dwp_cvad__Action_Audit_Detail__c> lstDetails = new List<dwp_cvad__Action_Audit_Detail__c>();
        Opportunity opp = new Opportunity();
        opp.Id = recordId;
        opp.opportunity_status_type__c = '11';
        opp.isProcess__c = true;
        
        try {
            update opp;
            opp.isProcess__c = false;
            update opp;
            
            lstAudit.add(Action_Audit_Helper.getAudit(Label.OppStatusLabel11, 'Opportunity', recordId, DateTime.now(), Label.AuditPriceApproval, UserInfo.getUserId(), 'approveTop', null, false));
            insert lstAudit;
            
            lstDetails.add(Action_Audit_Helper.getAuditDetail(lstAudit[0].Id, storeHtml, 1, '', 'Embedded'));
            insert lstDetails;
            
            mapReturn.put(isOkLabel,true);
        } catch (Exception e) {
            mapReturn.put(isOkLabel,false);
            mapReturn.put('errorMessage',e.getMessage());
        }
        return mapReturn;
    }
}