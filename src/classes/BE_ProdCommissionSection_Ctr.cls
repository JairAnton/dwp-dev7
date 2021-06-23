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
    /* Map that contains return values*/
    static Map<String,Object> mapReturn = new Map<String,Object>();
    /* constructor of class */
    private BE_ProdCommissionSection_Ctr() {}

    /* exception of class */
    public class ApplicationException extends Exception {}
    
    /**Method used to get quotes **/
	@AuraEnabled
    public static Map<String,Object> getCommissions(String recordId, Boolean negotiables, Boolean requestDataToAso) {
        return BE_CalculateCommission_Ctr.getCommissions(recordId, negotiables, requestDataToAso);
    }

    /**Method used to save answers of questions **/
    @AuraEnabled
    public static Map<String,Object> calculateRate(String rawCommission, String recordId, String status) {
        //public static Product_Commission__c calculateRate(String rawCommission, String recordId, String status) {
        Final Product_Commission__c currentdbComm = [SELECT Opportunity_Product__r.unitprice, Opportunity_Product__r.gipr_Plazo__c, Opportunity_Product__r.gipr_Periodicidad__c, Opportunity_Product__r.CurrencyIsoCode, Code__c, Term_Frequency_Id__c, Term_Number__c, Suggested_Rate_Type__c, Requested_Rate_Value__c, Authorized_Rate_Value__c, CurrencyIsoCode, Commission_Calculation_Amount__c, Suggested_Rate__c, (SELECT Code__c, Input_Value__c, Answer__c FROM Commission_Questions__r) FROM Product_Commission__c WHERE Id = :recordId];
        Final Product_Commission__c commission = parseCommission(rawCommission, currentdbComm, status);
        Final BE_CalculateCommissionRequest_Helper listComHelper = new BE_CalculateCommissionRequest_Helper(commission,status);
        Final System.HttpResponse invoke = listComHelper.invoke();
        mapReturn = new Map<String,Object>();
        mapReturn.put('error',false);

        switch on invoke.getStatusCode() {
            when 200 {
                Final Map<String, Object> response = (Map<String, Object>) JSON.deserializeUntyped(invoke.getBody());
                Final Map<String, Object> commissionResp = (Map<String, Object>) response.get('data');
                
                Final Map<String, Object> fixedFee = (Map<String, Object>) commissionResp.get('fixedFee');
                commission.Commission_Calculation_Code__c = String.valueOf(fixedFee.get('id'));
                
                Final Map<String, Object> calculatedFee = (Map<String, Object>) commissionResp.get('calculatedFee');
                commission.Commission_Calculation_Id__c = String.valueOf(calculatedFee.get('id'));
                commission.Commission_Calculation_Version__c = Integer.valueOf(calculatedFee.get('version'));
                
                Final Map<String, Object> calculatedAmount = (Map<String, Object>) calculatedFee.get('calculatedAmount');
                commission.Commission_Calculation_Amount__c = Double.valueOf(calculatedAmount.get('amount'));
                commission.CurrencyIsoCode = String.valueOf(calculatedAmount.get('currency'));
            } when else {
                mapReturn.put('error',true);
                mapReturn.put('responseCode',invoke.getStatusCode());
                mapReturn.put('errorBody',invoke.getBody());
            }
        }
        update commission;
        if(commission.Commission_Questions__r.size() > 0) {
            update commission.Commission_Questions__r;
        }
        mapReturn.put('commission',commission);
        return mapReturn;
    }

    /** Save Commission rates and answers */
    public static Product_Commission__c parseCommission(String rawCommission, Product_Commission__c currentDbComm, String status) {
        Final ProductWrapper comData = (ProductWrapper) JSON.deserializeStrict(rawCommission, ProductWrapper.class);
        Final Map<String,SObject> result = new Map<String,SObject>();
        Product_Commission__c commission = new Product_Commission__c();
        Commission_Question__c question = new Commission_Question__c ();

        Map<String,String> mpStatus = new Map<String,String>{'19'  => ' ', '09'  => ' ', '11'  => ' ', '08'  => ' ', '10' => ' '};
        commission = currentDbComm;
        commission.Authorized_Rate_Value__c = comData.rawCommission.Authorized_Rate_Value__c;
        commission.Requested_Rate_Value__c = comData.rawCommission.Requested_Rate_Value__c;

        if(comData.rawCommission.Authorized_Rate_Value__c == null && mpStatus.containsKey(status) ) {
            commission.Authorized_Rate_Value__c = commission.Requested_Rate_Value__c;
            if(currentDbComm.Suggested_Rate_Type__c.toUpperCase() == 'PERCENTAGE' ) {
                commission.Authorized_Rate_Value__c = commission.Requested_Rate_Value__c * 100;
            }
        }

        if(comData.rawCommission.Requested_Rate_Value__c == null) {
            commission.Requested_Rate_Value__c = 0;
            if(commission.Suggested_Rate__c != null) {
                commission.Requested_Rate_Value__c = Decimal.valueOf(commission.Suggested_Rate__c);
            }
            if(currentDbComm.Suggested_Rate_Type__c.toUpperCase() == 'PERCENTAGE') {
                commission.Requested_Rate_Value__c = Decimal.valueOf(commission.Suggested_Rate__c) * 100;
            }
        }
        for(Commission_Question__c currentQuestion : commission.Commission_Questions__r) {
            for(Commission_Question__c receivedQuestion : comData.rawCommission.Commission_Questions__r) {
                if(receivedQuestion.Id == currentQuestion.Id) {
                    currentQuestion.Answer__c = String.valueOf(receivedQuestion.Answer__c);
                    question = receivedQuestion;
                }
            }
        }
        result.put('questions',question);
        result.put('commission', commission);
        System.debug('   Final Commission: '+commission.Commission_Questions__r);
        return commission;
    }

    /** --------------------------------
     *           Utilities Class
     **--------------------------------*/


    /** --------------------------------
     *           Wrapper Class
     **--------------------------------*/
    /** class wrapper */
    public class ProductWrapper {
        /* rawCommision Data */
        Product_Commission__c rawCommission {get; set; }
    }
}