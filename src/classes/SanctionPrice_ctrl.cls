/**
* @author Global_HUB developers
* @date 01-08-2018
*
* @group Global_HUB
*
* @description Controller class from SanctionPrice_cmp
**/
public with sharing class SanctionPrice_ctrl {
 	@AuraEnabled
    public static Map<String,Object> getInfo(String recordId){
        Map<String,Object> mapReturn = new Map<String,Object>();
        List<Opportunity> lstOpp = [SELECT  Id,
                                            AccountId,
                                            Account.segment_desc__c,
                                            (SELECT     Id, 
                                                        product_price_approval_method__c, 
                                                        product_price_approval_indicator__c,
                                                        Product2Id 
                                            FROM OpportunityLineItems) 
                                    FROM Opportunity 
                                    WHERE Id = :recordId];
        if(lstOpp[0].OpportunityLineItems.size()>0){
            mapReturn.put('IdOppLineItem',lstOpp[0].OpportunityLineItems[0].Id);
            mapReturn.put('approvalMethod',lstOpp[0].OpportunityLineItems[0].product_price_approval_method__c);
            if(lstOpp[0].OpportunityLineItems[0].product_price_approval_method__c == 'Tarifario'){
                List<Price_Fee__c> lstPriceFee = [SELECT    Id,
                                        validity_start_date__c,
                                        validity_end_date__c, 
                                        product_id__c,
                                        minimun_fee_per__c,
                                        account_segment_id__c,
                                        account_segment_desc__c,
                                        calc_account_segment_desc__c
                                FROM Price_Fee__c 
                                WHERE validity_start_date__c <= TODAY 
                                AND validity_end_date__c >= TODAY 
                                AND product_id__c = :lstOpp[0].OpportunityLineItems[0].Product2Id
                                AND calc_account_segment_desc__c = :lstOpp[0].Account.segment_desc__c.toUpperCase()];
                if(!lstOpp.isEmpty() && !lstPriceFee.isEmpty()){
                    mapReturn.put('dynamicValue',lstPriceFee[0].minimun_fee_per__c);
                }
            }
            mapReturn.put('hasOLI',true);
            mapReturn.put('priceIndicator',lstOpp[0].OpportunityLineItems[0].product_price_approval_indicator__c);
        }else{
            mapReturn.put('hasOLI',false);
        }
        return mapReturn; 
    }
}