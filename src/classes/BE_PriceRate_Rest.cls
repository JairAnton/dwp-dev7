/**
* @author Martín Mori
* @date 07-07-2020
*
* @group DWP_Peru
*
* @description price rate webService class
**/
public with sharing class BE_PriceRate_Rest {
    /* variable */
    static Map<String,Double> mapValues = new Map<String,Double>();
    /* variable */
    static String calculationid;
    /* variable */
    static String currencyid;
    /* variable */
    static String genericError;
    /*Spread calculado desde campo formula*/
    static Double calculateSpread;
    /* ko code of call webservice */
    final static Integer KOCODE = 409;
    /* ok code of call webservice */
    final static Integer OKCODE = 200;
    
	/**
     * constructor of class
     */
    private BE_PriceRate_Rest() {
    }
    
    /**
	 * Method used to call webservice
     */
    public static String invokeWS(List<OpportunityLineItem> olis, Boolean isSimulate) {
        //helper to call the service
        final PriceRate_helper prate = new PriceRate_helper(olis[0].OpportunityId, isSimulate);
        //invoke the service
        final HttpResponse invoke = prate.invoke();
        //code = 200 OK
        if(invoke.getStatusCode() == OKCODE) {
            //get json body
            final PriceRate_helper.ResponseSimulateRate_Wrapper jbody = prate.parse(invoke.getBody());
            //get min TEA and Suggested TEA
            readInterestRate(jbody);
            //get Spread
            readLiqIndicator(jbody);
            //fees
            readFee(jbody);
            
            final OpportunityLineItem oli = new OpportunityLineItem(Id=olis[0].Id);
            oli.minimun_apr_per__c = mapValues.get('minimtea');
            oli.suggested_apr_per__c = mapValues.get('sugtea');
            oli.spread_per__c = mapValues.get('spread');
            oli.additional_apread_per__c = mapValues.get('addspread');
            oli.minimum_spread_per__c = mapValues.get('minimspread');
            oli.expected_loss_per__c = mapValues.get('expected');
            oli.funding_cost_per__c = mapValues.get('fundingcost');
            oli.efficiency_cost__c = mapValues.get('efficiency');
            oli.financing_cost_stockholder_per__c = mapValues.get('financystock');
            oli.funding_cost_adjusted_per__c = mapValues.get('fundingadj');
            oli.regulatory_capital_per__c = mapValues.get('regulatory');
            oli.additional_capital_per__c = mapValues.get('addcapital');
            oli.capital_amount__c = mapValues.get('capitalamount');
            oli.capital_currency_id__c = currencyid;
            oli.price_rates_calculation_Id__c = calculationid;
            //Spread = Min TEA - DI
            //oli[0].calculated_spread__c = minimtea - fundingcost;
            update oli;
            //Recalculate Spread
            calculateSpread = oli.minimun_apr_per__c - oli.funding_cost_per__c;
            //get error message with code 409
        } else if(invoke.getStatusCode() == KOCODE) {
            final WebServiceUtils.ResponseErrorMessage_Wrapper jerror = WebServiceUtils.parse(invoke.getBody());
            genericError = jerror.errormessage;
            //get error message generic
        } else {
            genericError = Label.GenericError;
        }
        return genericError;
    }
    
    /**
     * method to fill map with interest rates
	*/
    public static void readInterestRate(PriceRate_helper.ResponseSimulateRate_Wrapper jbody) {
        if(jbody.data != null && jbody.data.summary != null && jbody.data.summary[0].interestRates != null &&
           jbody.data.summary[0].interestRates.EffectiveRates != null) {
               calculationid = jbody.data.summary[0].calculationId;
               final List<PriceRate_helper.Response_EffectiveRates> lsttea = jbody.data.summary[0].interestRates.EffectiveRates;               
               for (Integer i = 0; i<lsttea.size(); i++) {
                   if(lsttea[i].id == Label.MinTEA) {
                       mapValues.put('minimtea',lsttea[i].percentage*100);
                   } else if(lsttea[i].id == Label.SuggTEA) {
                       mapValues.put('sugtea',lsttea[i].percentage*100);
                   }                   
               }             
           }
    }
    
    /**
     * method to fill map with liquidity indicators
	*/
    public static void readLiqIndicator(PriceRate_helper.ResponseSimulateRate_Wrapper jbody) {
        if(jbody.data != null && jbody.data.summary != null && jbody.data.summary[0].LiquidityIndicators !=null) {
            final List<PriceRate_helper.Response_LiquidityIndicators> lstspread = jbody.data.summary[0].LiquidityIndicators;
            calculationid = jbody.data.summary[0].calculationId;
            for(Integer x =0; x<lstspread.size(); x++) {
                if(lstspread[x].id == Label.commSpread) {
                    mapValues.put('spread',lstspread[x].detail.percentage*100);
                } else if(lstspread[x].id == Label.PriceWSLabel02) {
                    mapValues.put('addspread',lstspread[x].detail.percentage*100);
                } else if(lstspread[x].id == Label.PriceWSLabel01) {
                    mapValues.put('minimspread',lstspread[x].detail.percentage*100);
                }
            }
        }
    }
    
    /**
     * method to fill map with fees
	*/
    public static void readFee(PriceRate_helper.ResponseSimulateRate_Wrapper jbody) {
        if(jbody.data != null && jbody.data.summary != null && jbody.data.summary[0].fees != null) {
            final List<PriceRate_helper.Response_Fees> lstfees = jbody.data.summary[0].fees;
            for(Integer x=0; x<lstfees.size(); x++) {
                if(lstfees[x].feeType.Id == Label.PriceWSLabel10) {
                    mapValues.put('expected',lstfees[x].detail.percentage*100);                                
                } else if(lstfees[x].feeType.Id == Label.PriceWSLabel09) {
                    mapValues.put('fundingcost',lstfees[x].detail.percentage*100);
                } else if(lstfees[x].feeType.Id == Label.PriceWSLabel08) {
                    mapValues.put('efficiency',lstfees[x].detail.percentage*100);
                } else if(lstfees[x].feeType.Id == Label.PriceWSLabel07) {
                    mapValues.put('financystock',lstfees[x].detail.percentage*100);
                } else if(lstfees[x].feeType.Id == Label.PriceWSLabel06) {
                    mapValues.put('fundingadj',lstfees[x].detail.percentage*100);
                } else if(lstfees[x].feeType.Id == Label.PriceWSLabel05) {
                    mapValues.put('regulatory',lstfees[x].detail.percentage*100);
                } else if(lstfees[x].feeType.Id == Label.PriceWSLabel04) {
                    mapValues.put('addcapital',lstfees[x].detail.percentage*100);
                } else if(lstfees[x].feeType.Id == Label.PriceWSLabel03) {
                    mapValues.put('capitalamount',lstfees[x].detail.amount);
                    currencyid = lstfees[x].detail.currency_type;
                }
            }
        }
    }
}