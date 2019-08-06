/**
* @author Global_HUB developers
* @date 14-08-2018
*
* @group Global_HUB
*
* @description Controller class from SimulatePrice_cmp
**/
public with sharing class SimulatePrice_ctrl {
    static String idOli;
    @AuraEnabled
    //getInfo with the id of Opportunity
    public static Map<String,Object> getInfo(String recordId) {
        Map<String,Object> mapReturn = new Map<String,Object>();
        Double sugtea, spread, minimspread, addspread, expected, efficiency, financystock, fundingadj, regulatory, addcapital, capitalamount;
        Double minimtea=0, fundingcost=0, calculateSpread=0;
        String genericError, currencyid;
        try{
            
            //helper to call the service
            PriceRate_helper prate = new PriceRate_helper(recordId, true);
            //invoke the service
            HttpResponse invoke = prate.invoke();
            //get json body
            PriceRate_helper.ResponseSimulateRate_Wrapper jbody = prate.parse(invoke.getBody());
            //get values if statuscode=200
            if(invoke.getStatusCode() == 200) {
                
                List<OpportunityLineItem> oli =[Select Id, Name, minimun_apr_per__c, suggested_apr_per__c, spread_per__c, 
                                                additional_capital_per__c,additional_apread_per__c,capital_amount__c,capital_currency_id__c, efficiency_cost__c,
                                                expected_loss_per__c, financing_cost_stockholder_per__c, funding_cost_per__c, funding_cost_adjusted_per__c,
                                                minimum_spread_per__c, regulatory_capital_per__c from OpportunityLineItem where OpportunityId = : recordId];
                if(!oli.isEmpty()) {
                    if(jbody.data != null && jbody.data.summary != null && jbody.data.summary[0].interestRates != null &&
                       jbody.data.summary[0].interestRates.EffectiveRates != null) {
                           List<PriceRate_helper.Response_EffectiveRates> lsttea = jbody.data.summary[0].interestRates.EffectiveRates;               
                           for (Integer i = 0; i<lsttea.size(); i++) {                           
                               if (lsttea[i].id == Label.MinTEA) {
                                   minimtea = lsttea[i].percentage*100;
                               } else if (lsttea[i].id == Label.SuggTEA) {
                                   sugtea = lsttea[i].percentage*100;
                               }                   
                           }             
                       }
                    
                    if(jbody.data != null && jbody.data.summary != null && jbody.data.summary[0].LiquidityIndicators !=null) {
                        List<PriceRate_helper.Response_LiquidityIndicators> lstspread = jbody.data.summary[0].LiquidityIndicators;
                        for(Integer x =0; x<lstspread.size(); x++) {
                            if (lstspread[x].id == Label.commSpread) {
                                spread = lstspread[x].detail.percentage*100;
                            } else if (lstspread[x].id == Label.PriceWSLabel02) {
                                addspread = lstspread[x].detail.percentage*100;
                            } else if (lstspread[x].id == Label.PriceWSLabel01) {
                                minimspread = lstspread[x].detail.percentage*100;
                            }
                        }
                    }
                    if(jbody.data != null && jbody.data.summary != null && jbody.data.summary[0].fees != null) {
                        List<PriceRate_helper.Response_Fees> lstfees = jbody.data.summary[0].fees;
                        system.debug('lstfees'+lstfees);
                        for(Integer x =0; x<lstfees.size(); x++) {
                            if (lstfees[x].feeType.Id == Label.PriceWSLabel10) {
                                expected = lstfees[x].detail.percentage*100;                                
                            } else if (lstfees[x].feeType.Id == Label.PriceWSLabel09) {
                                fundingcost = lstfees[x].detail.percentage*100;
                            } else if (lstfees[x].feeType.Id == Label.PriceWSLabel08) {
                                efficiency = lstfees[x].detail.percentage*100;
                            } else if (lstfees[x].feeType.Id == Label.PriceWSLabel07) {
                                financystock = lstfees[x].detail.percentage*100;
                            } else if (lstfees[x].feeType.Id == Label.PriceWSLabel06) {
                                fundingadj = lstfees[x].detail.percentage*100;
                            } else if (lstfees[x].feeType.Id == Label.PriceWSLabel05) {
                                regulatory = lstfees[x].detail.percentage*100;
                            } else if (lstfees[x].feeType.Id == Label.PriceWSLabel04) {
                                addcapital = lstfees[x].detail.percentage*100;
                            } else if (lstfees[x].feeType.Id == Label.PriceWSLabel03) {
                                capitalamount = lstfees[x].detail.amount;
                                currencyid = lstfees[x].detail.currency_type;
                            }
                        }                        
                    }                    
                    oli[0].minimun_apr_per__c = minimtea;
                    oli[0].suggested_apr_per__c = sugtea;
                    oli[0].spread_per__c = spread;
                    //Spread = Min TEA - DI
                    //oli[0].spread__c = minimtea - fundingcost;
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
                    idOli = oli[0].Id;
                    update oli;
                    //Recalculate Spread
                    calculateSpread = [Select calculated_spread__c FROM OpportunityLineItem WHERE Id =: oli[0].Id].calculated_spread__c;
                    //get errors
                }
            } else if (invoke.getStatusCode() == 409) {
                WebServiceUtils.ResponseErrorMessage_Wrapper jerror = WebServiceUtils.parse(invoke.getBody());
                genericError = jerror.errormessage;
            } else {
                genericError = Label.GenericError;
            }
        } catch(Exception e) {
            genericError = e.getMessage();
        }
        mapReturn.put('oli',idOli);
        mapReturn.put('minimtea', minimtea);
        mapReturn.put('sugtea',sugtea);
        mapReturn.put('spread', calculateSpread);
        System.debug('spread '+calculateSpread);
        mapReturn.put('genericError',genericError);
        
        return mapReturn;
    }
}