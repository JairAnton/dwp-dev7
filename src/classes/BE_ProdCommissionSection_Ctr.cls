/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_ProdCommissionSection_Ctr>
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2021-03-12
   @Description Controller class of BE_ProdCommissionSection_Lwc
   @Changes
   Date        Author   Email                  				    Type		Description
   2021-03-12  MAMC     martin.mori.contractor@bbva.com    	    Creation
   2021-03-12  MAMC    luis.vargas.matute.contractor@bbva.com   Creation
   -------------------------------------------------------------------------------------------------
 */
public with sharing class BE_ProdCommissionSection_Ctr {
    /* constructor of class */
    private BE_ProdCommissionSection_Ctr() {}
    
    /**Method used to get quotes **/
	@AuraEnabled
    public static List<Product_Commission__c> getCommissions(String recordId, Boolean negotiables) {
        return BE_CalculateCommission_Ctr.getCommissions(recordId, negotiables);
    }

    /**Method used to save answers of questions **/
    @AuraEnabled
    public static void calculateRate(String commissionId, String status) {
        
        Final Product_Commission__c currentCommission = [SELECT Opportunity_Product__r.unitprice, Opportunity_Product__r.gipr_Plazo__c, Opportunity_Product__r.gipr_Periodicidad__c, Opportunity_Product__r.CurrencyIsoCode, Code__c, Term_Frequency_Id__c, Term_Number__c, Suggested_Rate_Type__c, Sugested_Rate_Percentage__c, Requested_Rate_Value__c, Authorized_Rate_Value__c, (SELECT Code__c, Input_Value__c, Answer__c FROM Commission_Questions__r) FROM Product_Commission__c WHERE Id = :commissionId];
        List<Product_Commission__c> commissionsAsoRequest = new List<Product_Commission__c>();
        system.debug('1: ');
        Final BE_CalculateCommissionRequest_Helper listCommissionHelper = new BE_CalculateCommissionRequest_Helper(currentCommission,status);
        system.debug('2: ');
        Final System.HttpResponse invoke = listCommissionHelper.invoke();
        system.debug('3: ');
        switch on invoke.getStatusCode() {
            when 200 {
                system.debug('response: '+ invoke.getBody());
                
                Product_Commission__c commission = new Product_Commission__c();
                Final Map<String, Object> response = (Map<String, Object>) JSON.deserializeUntyped(invoke.getBody());
                Final Map<String, Object> commissionResp = (Map<String, Object>) response.get('data');
                
                commission.Id = commissionId;
                
                Final Map<String, Object> fixedFee = (Map<String, Object>) commissionResp.get('fixedFee');
                commission.Commission_Calculation_Code__c = String.valueOf(fixedFee.get('id'));
                
                Final Map<String, Object> calculatedFee = (Map<String, Object>) commissionResp.get('calculatedFee');
                commission.Commission_Calculation_Id__c = String.valueOf(calculatedFee.get('id'));
                commission.Commission_Calculation_Version__c = Integer.valueOf(calculatedFee.get('version'));
                
                Final Map<String, Object> calculatedAmount = (Map<String, Object>) calculatedFee.get('calculatedAmount');
                commission.Commission_Calculation_Amount__c = Double.valueOf(calculatedAmount.get('amount'));
                commission.CurrencyIsoCode = String.valueOf(calculatedFee.get('currency'));
                commissionsAsoRequest.add(commission);
            }
        }
        System.debug('REQUESTED DATA-----Result:'+commissionsAsoRequest);
        update commissionsAsoRequest;
        System.debug('REQUESTED DATA-----saved!:');        
    }

    /** Save Commission rates and answers */
    @AuraEnabled
    public static void saveCommissions(String rawCommission, String recordId){
        try {
            ProductWrapper c = (ProductWrapper) JSON.deserializeStrict(rawCommission, ProductWrapper.class);
            List<Commission_Question__c> questions = new List<Commission_Question__c>();
            for(Product_Commission__c cm : c.rawCommission) {
                for(Commission_Question__c question : cm.Commission_Questions__r) {
                    questions.add(question);
                }
            }
            OpportunityLineItem oli = [SELECT Id, hasCommissions__c FROM OpportunityLineItem WHERE Id = :recordId];

            oli.hasCommissions__c = true;
            update oli;
            update c.rawCommission;
            update questions;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /** --------------------------------
     *           Utilities Class
     **--------------------------------*/


    /** --------------------------------
     *           Wrapper Class
     **--------------------------------*/
    /** class wrapper */
    public class ProductWrapper {
        List<Product_Commission__c> rawCommission {get; set;}
    }
}