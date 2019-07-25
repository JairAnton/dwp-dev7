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
    static Double minimspread;
    static Double addspread;
    static Double expected;
    static Double fundingcost;
    static Double efficiency;
    static Double financystock;
    static Double fundingadj;
    static Double regulatory;
    static Double addcapital;
    static Double capitalamount;
    static String genericError;
    static String calculationid;
    static String currencyid;
    static Double calculateSpread;
    @AuraEnabled
    public static Map<String,Object> getInfo(String recordId){
        
        List<Opportunity> lstOpp = [SELECT  Id,
                                    AccountId,
                                    Account.commercial_strategy__c,
                                    Account.segment_desc__c,
                                    (SELECT     Id, 
                                     product_price_approval_method__c, 
                                     product_price_approval_indicator__c,
                                     minimun_apr_per__c, 
                                     suggested_apr_per__c, 
                                     spread_per__c,
                                     price_rates_calculation_Id__c,
                                     proposed_apr_per__c,
                                     additional_capital_per__c,additional_apread_per__c,
                                     capital_amount__c,capital_currency_id__c, efficiency_cost__c,
                                     expected_loss_per__c, financing_cost_stockholder_per__c, 
                                     funding_cost_per__c, funding_cost_adjusted_per__c,
                                     minimum_spread_per__c, regulatory_capital_per__c,
                                     Product2Id,product2.Type_of_quote__c
                                     FROM OpportunityLineItems) 
                                    FROM Opportunity 
                                    WHERE Id = :recordId];
        try{
            //If opportunity has opportunityLineItems
            if(lstOpp[0].OpportunityLineItems.size()>0){
                mapReturn.put('IdOppLineItem',lstOpp[0].OpportunityLineItems[0].Id);
                mapReturn.put('approvalMethod',lstOpp[0].OpportunityLineItems[0].product_price_approval_method__c);
                mapReturn.put('AccId',lstOpp[0].AccountId);
                mapReturn.put('type_of_quote',lstOpp[0].OpportunityLineItems[0].product2.Type_of_quote__c);
                mapReturn.put('commercial_strategy',lstOpp[0].Account.commercial_strategy__c);
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
                                                      AND calc_account_segment_desc__c = :strSegment.toUpperCase(UserInfo.getLocale())];//Yuliño 11/12/2018 : Agregando el lenguaje local
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
    @AuraEnabled
    public static Map<String,Object> getInfoAnalist(String recordId){
        
        List<Opportunity> lstOpp = [SELECT  Id,
                                    AccountId,
                                    Account.commercial_strategy__c,
                                    Account.segment_desc__c,
                                    (SELECT     Id, 
                                     product_price_approval_method__c, 
                                     product_price_approval_indicator__c,
                                     minimun_apr_per__c, 
                                     suggested_apr_per__c, 
                                     spread_per__c,
                                     price_rates_calculation_Id__c,
                                     proposed_apr_per__c,
                                     additional_capital_per__c,additional_apread_per__c,
                                     capital_amount__c,capital_currency_id__c, efficiency_cost__c,
                                     expected_loss_per__c, financing_cost_stockholder_per__c, 
                                     funding_cost_per__c, funding_cost_adjusted_per__c,
                                     minimum_spread_per__c, regulatory_capital_per__c,
                                     Product2Id,product2.Type_of_quote__c
                                     FROM OpportunityLineItems) 
                                    FROM Opportunity 
                                    WHERE Id = :recordId];
        try{
            //If opportunity has opportunityLineItems
            if(lstOpp[0].OpportunityLineItems.size()>0){
                mapReturn.put('IdOppLineItem',lstOpp[0].OpportunityLineItems[0].Id);
                mapReturn.put('approvalMethod',lstOpp[0].OpportunityLineItems[0].product_price_approval_method__c);
                mapReturn.put('AccId',lstOpp[0].AccountId);
                mapReturn.put('type_of_quote',lstOpp[0].OpportunityLineItems[0].product2.Type_of_quote__c);
                mapReturn.put('commercial_strategy',lstOpp[0].Account.commercial_strategy__c);
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
                                                      AND calc_account_segment_desc__c = :strSegment.toUpperCase(UserInfo.getLocale())]; //Yulino 11/12/2018 : Agregando el lenguaje local
                    //get minimun_fee_per__c
                    if(!lstOpp.isEmpty() && !lstPriceFee.isEmpty()){
                        mapReturn.put('dynamicValue',lstPriceFee[0].minimun_fee_per__c);
                    }
                    //If product_price_approval_method__c == Web and has a OLI    
                }else if(lstOpp[0].OpportunityLineItems[0].product_price_approval_method__c == 'Web'){
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
                    } else if (lstspread[x].id == Label.PriceWSLabel02){
                        addspread = lstspread[x].detail.percentage*100;
                    } else if (lstspread[x].id == Label.PriceWSLabel01){
                        minimspread = lstspread[x].detail.percentage*100;
                    }
                }
            }
            if(jbody.data != null && jbody.data.summary != null && jbody.data.summary[0].fees != null){
                List<PriceRate_helper.Response_Fees> lstfees = jbody.data.summary[0].fees;
                for(Integer x =0; x<lstfees.size(); x++){
                    if (lstfees[x].feeType.Id == Label.PriceWSLabel10){
                        expected = lstfees[x].detail.percentage*100;                                
                    } else if (lstfees[x].feeType.Id == Label.PriceWSLabel09){
                        fundingcost = lstfees[x].detail.percentage*100;
                    } else if (lstfees[x].feeType.Id == Label.PriceWSLabel08){
                        efficiency = lstfees[x].detail.percentage*100;
                    } else if (lstfees[x].feeType.Id == Label.PriceWSLabel07){
                        financystock = lstfees[x].detail.percentage*100;
                    } else if (lstfees[x].feeType.Id == Label.PriceWSLabel06){
                        fundingadj = lstfees[x].detail.percentage*100;
                    } else if (lstfees[x].feeType.Id == Label.PriceWSLabel05){
                        regulatory = lstfees[x].detail.percentage*100;
                    } else if (lstfees[x].feeType.Id == Label.PriceWSLabel04){
                        addcapital = lstfees[x].detail.percentage*100;
                    } else if (lstfees[x].feeType.Id == Label.PriceWSLabel03){
                        capitalamount = lstfees[x].detail.amount;
                        currencyid = lstfees[x].detail.currency_type;
                    }
                }                        
            }
            List<OpportunityLineItem> oli =[Select Id, Name, price_rates_calculation_Id__c, minimun_apr_per__c, suggested_apr_per__c, spread_per__c, calculated_spread__c, 
                                            additional_capital_per__c,additional_apread_per__c,capital_amount__c,capital_currency_id__c, efficiency_cost__c,
                                            expected_loss_per__c, financing_cost_stockholder_per__c, funding_cost_per__c, funding_cost_adjusted_per__c,
                                            minimum_spread_per__c, regulatory_capital_per__c from OpportunityLineItem where OpportunityId = : recordId];
            oli[0].minimun_apr_per__c = minimtea;
            oli[0].suggested_apr_per__c = sugtea;
            oli[0].spread_per__c = spread;
            oli[0].additional_apread_per__c = addspread;
            oli[0].minimum_spread_per__c = minimspread;
            oli[0].expected_loss_per__c = expected;
            oli[0].funding_cost_per__c = fundingcost;
            oli[0].efficiency_cost__c = efficiency;
            oli[0].financing_cost_stockholder_per__c = financystock;
            oli[0].funding_cost_adjusted_per__c = fundingadj;
            oli[0].regulatory_capital_per__c = regulatory;
            oli[0].additional_capital_per__c = addcapital;
            oli[0].capital_amount__c = capitalamount;
            oli[0].capital_currency_id__c = currencyid;
            oli[0].price_rates_calculation_Id__c = calculationid;
            //Spread = Min TEA - DI
            //oli[0].calculated_spread__c = minimtea - fundingcost;
            update oli;
            //Recalculate Spread
            calculateSpread = [Select calculated_spread__c FROM OpportunityLineItem WHERE Id =: oli[0].Id].calculated_spread__c;
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
        mapReturn.put('spread',calculateSpread);
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