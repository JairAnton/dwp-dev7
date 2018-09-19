/**
* @author Global_HUB developers
* @date 01-08-2018
*
* @group Global_HUB
*
* @description Controller class from SanctionPrice_cmp
**/
public with sharing class SanctionPrice_ctrl {    
    static String idOli;
    static Map<String,Object> mapReturn = new Map<String,Object>();
    static Double minimtea;
    static Double sugtea;
    static Double spread;
    static String genericError;
    static String calculationid;
    @AuraEnabled
    public static Map<String,Object> getInfo(String recordId){
        
        List<Opportunity> lstOpp = [SELECT  Id,
                                    AccountId,
                                    Account.segment_desc__c,
                                    (SELECT     Id, 
                                     product_price_approval_method__c, 
                                     product_price_approval_indicator__c,
                                     minimun_apr_per__c, 
                                     suggested_apr_per__c, 
                                     spread_per__c,
                                     price_rates_calculation_Id__c,
                                     proposed_apr_per__c,
                                     Product2Id 
                                     FROM OpportunityLineItems) 
                                    FROM Opportunity 
                                    WHERE Id = :recordId];
        try{
            //If opportunity has opportunityLineItems
            if(lstOpp[0].OpportunityLineItems.size()>0){
                mapReturn.put('IdOppLineItem',lstOpp[0].OpportunityLineItems[0].Id);
                mapReturn.put('approvalMethod',lstOpp[0].OpportunityLineItems[0].product_price_approval_method__c);
                //If product_price_approval_method__c == Tarifario and has a OLI
                if(lstOpp[0].OpportunityLineItems[0].product_price_approval_method__c == 'Tarifario'){
                    String strSegment = (lstOpp[0].Account.segment_desc__c == null?'':lstOpp[0].Account.segment_desc__c);
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
                                                      AND calc_account_segment_desc__c = :strSegment.toUpperCase()];
                    //get minimun_fee_per__c
                    if(!lstOpp.isEmpty() && !lstPriceFee.isEmpty()){
                        mapReturn.put('dynamicValue',lstPriceFee[0].minimun_fee_per__c);
                    }
                    //If product_price_approval_method__c == Web and has a OLI    
                }else if(lstOpp[0].OpportunityLineItems[0].product_price_approval_method__c == 'Web'){
                    SanctionPrice_ctrl.invokeWS(recordId);
                    if(lstOpp[0].OpportunityLineItems[0].proposed_apr_per__c!=null){
                    mapReturn.put('proposed',lstOpp[0].OpportunityLineItems[0].proposed_apr_per__c);
                    }else{
                        mapReturn.put('proposed','');
                    }
                }
                mapReturn.put('hasOLI',true);
                mapReturn.put('priceIndicator',lstOpp[0].OpportunityLineItems[0].product_price_approval_indicator__c);
                //If opportunity hasn't opportunityLineItems
            }else{
                mapReturn.put('hasOLI',false);
            }     
            
        }catch(Exception e){
            genericError = e.getMessage();
        }
        mapReturn.put('genericError',genericError);
        return mapReturn; 
    }
    // update OpportunityLineItem fields
    public static void updateOLI(Double teasug, Double teaminim, Double spread, String calculation, String oppId){
        OpportunityLineItem oli =[Select Id, Name, minimun_apr_per__c, suggested_apr_per__c, spread_per__c, price_rates_calculation_Id__c
                                  from OpportunityLineItem where OpportunityId = : oppId];
        oli.minimun_apr_per__c = teaminim;
        oli.suggested_apr_per__c = teasug;
        oli.spread_per__c = spread;
        oli.price_rates_calculation_Id__c = calculation;
        update oli;
    }
    public static void invokeWS (String recordId){
        //helper to call the service
        PriceRate_helper prate = new PriceRate_helper(recordId, false);
        //invoke the service
        HttpResponse invoke = prate.invoke();
        //get json body
        PriceRate_helper.ResponseSimulateRate_Wrapper jbody = prate.parse(invoke.getBody());
        //code = 200 OK
        if(invoke.getStatusCode() == 200){
            //get min TEA and Suggested TEA
            if(jbody.data != null && jbody.data.summary != null && jbody.data.summary[0].interestRates != null &&
               jbody.data.summary[0].interestRates.EffectiveRates != null){
                   calculationid = jbody.data.summary[0].calculationId;
                   List<PriceRate_helper.Response_EffectiveRates> lsttea = jbody.data.summary[0].interestRates.EffectiveRates;               
                   for (Integer i = 0; i<lsttea.size(); i++){
                       
                       if (lsttea[i].id == Label.MinTEA){
                           minimtea = lsttea[i].percentage*100;
                       } else if (lsttea[i].id == Label.SuggTEA){
                           sugtea = lsttea[i].percentage*100;
                       }                   
                   }             
               }
            //get Spread
            if(jbody.data != null && jbody.data.summary != null && jbody.data.summary[0].LiquidityIndicators !=null){
                List<PriceRate_helper.Response_LiquidityIndicators> lstspread = jbody.data.summary[0].LiquidityIndicators;
                calculationid = jbody.data.summary[0].calculationId;
                for(Integer x =0; x<lstspread.size(); x++){
                    if (lstspread[x].id == Label.commSpread){
                        spread = lstspread[x].detail.percentage*100;
                    }
                }
            }
            SanctionPrice_ctrl.updateOLI(sugtea, minimtea, spread, calculationid, recordId);
            //get error message with code 409
        } else if (invoke.getStatusCode() == 409){
            WebServiceUtils.ResponseErrorMessage_Wrapper jerror = WebServiceUtils.parse(invoke.getBody());
            genericError = jerror.errormessage;
            //get error message generic
        } else{
            genericError = Label.GenericError;
        }
        mapReturn.put('minimtea', minimtea);
        mapReturn.put('sugtea',sugtea);
        mapReturn.put('spread',spread);
    }
    
    @AuraEnabled
    public static Map<String,Object> getInfoWithoutDefaultValues(String recordId){
        
        List<Opportunity> lstOpp = [SELECT  Id,
                                    AccountId,
                                    Account.segment_desc__c,
                                    (SELECT     Id, 
                                     product_price_approval_method__c, 
                                     product_price_approval_indicator__c
                                     FROM OpportunityLineItems) 
                                    FROM Opportunity 
                                    WHERE Id = :recordId];
        try{
            //If opportunity has opportunityLineItems
            if(lstOpp[0].OpportunityLineItems.size()>0){
                mapReturn.put('IdOppLineItem',lstOpp[0].OpportunityLineItems[0].Id);
                mapReturn.put('approvalMethod',lstOpp[0].OpportunityLineItems[0].product_price_approval_method__c);
                mapReturn.put('hasOLI',true);
                mapReturn.put('priceIndicator',lstOpp[0].OpportunityLineItems[0].product_price_approval_indicator__c);
                //If opportunity hasn't opportunityLineItems
            }else{
                mapReturn.put('hasOLI',false);
            }     
            
        }catch(Exception e){
            genericError = e.getMessage();
        }
        mapReturn.put('genericError',genericError);
        return mapReturn; 
    }
}