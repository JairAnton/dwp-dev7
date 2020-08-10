/**
* @author Martín Mori
* @date 07-07-2020
*
* @group DWP_Peru
*
* @description analyze rate webService class
**/
public with sharing class BE_AnalyzeRate_Rest {
    /* ok code of call webservice */
    final static Integer OKCODE = 200;
    /* variable */
    static String genericError;
    /* variable */
    static Map<String,Object> mapReturn = new Map<String,Object>();
    
    /**
     * constructor of class
     */
    private BE_AnalyzeRate_Rest() {
    }
    
    /**
	 * Method used to call webservice
     */
    public static Map<String,Object> invokeWS(String recordId, List<OpportunityLineItem> olisAux, Decimal teaProposed, Boolean isSimulate) {
        List<OpportunityLineItem> olis = olisAux;
        try {
            olis[0].proposed_apr_per__c = teaProposed;
            //helper to call the service
            final AnalyzeRate_helper prate = new AnalyzeRate_helper(recordId, olis[0].price_rates_calculation_Id__c, teaProposed, isSimulate);
            //invoke the service
            final HttpResponse invoke = prate.invoke();
            //code = 200 OK
            if(invoke.getStatusCode() == OKCODE) {
                final AnalyzeRate_helper.ResponseAnalyzeRate_Wrapper jbody = prate.parse(invoke.getBody());
                //olis = readFees(jbody, olis);
                olis = readIndicators(jbody, olis);
                //olis = readLiqIndicator(jbody, olis);
                mapReturn = readProduct(mapReturn, jbody, recordId);
                mapReturn.put('isOk', true);
                update olis;
            } else {
                final WebServiceUtils.ResponseErrorMessage_Wrapper errorDetails = WebServiceUtils.parse(invoke.getBody());
                mapReturn.put('errorCal', errorDetails.errormessage);
                mapReturn.put('genericError', errorDetails.errormessage);
                mapReturn.put('isOk', false);
            }
        } catch(Exception e) {
            genericError = e.getMessage();
            mapReturn.put('genericError', genericError);
            mapReturn.put('isOk', false);
        }
        return mapReturn;
    }

    /**
     * method to fill map with fees
	*/
    /*public static List<OpportunityLineItem> readFees(AnalyzeRate_helper.ResponseAnalyzeRate_Wrapper jbody, List<OpportunityLineItem> oliAux) {
        final List<OpportunityLineItem> olis = oliAux;
        if(jbody.data != null && jbody.data.fees != null) {
            for(AnalyzeRate_helper.Response_Fees fee : jbody.data.fees) {
                final AnalyzeRate_helper.Response_CalculationType calculationType = fee.feeType;
                switch on calculationType.id {
                    when 'RORC_MODEL' {
                        olis[0].RORC_Model__c = fee.detail.percentage;
                    }
                    when 'RORCAPPROVED' {
                        olis[0].RORC_Approved__c = fee.detail.percentage;
                    }
                }
            }
            mapReturn.put('minimtea', olis[0].minimun_apr_per__c);
            mapReturn.put('sugtea', olis[0].suggested_apr_per__c);
        }
        return olis;
    }*/
    
    /**
     * method to fill map with indicators
	*/
    public static List<OpportunityLineItem> readIndicators(AnalyzeRate_helper.ResponseAnalyzeRate_Wrapper jbody, List<OpportunityLineItem> oliAux) {
        final List<OpportunityLineItem> olis = oliAux;
        olis[0].Liquidity_Margin_Recovered__c = 0.00;
        if(jbody.data != null && jbody.data.indicators != null) {
            List<AnalyzeRate_helper.Response_Indicators> lstIndicators = jbody.data.indicators;
            for(Integer x = 0; x < lstIndicators.size(); x++) {
                if(lstIndicators[x].Id == Label.PriceWSLabel16) {
                    olis[0].RORC_Client__c = (Decimal.valueOf(lstIndicators[x].value)*100).setscale(2);
                } else if(lstIndicators[x].Id == Label.PriceWSLabel17) {
                    olis[0].RORC_Model__c = (Decimal.valueOf(lstIndicators[x].value)*100).setscale(2);
                    olis[0].RORC_Variation__c = (Decimal.valueOf(lstIndicators[x].value)*100).setscale(2);
                } else if(lstIndicators[x].Id == Label.PriceWSLabel18) {
                    olis[0].RORC_Operation__c = (Decimal.valueOf(lstIndicators[x].value)*100).setscale(2);
                } else if(lstIndicators[x].Id == Label.PriceWSLabel19) {
                    olis[0].RORC_Updated__c = (Decimal.valueOf(lstIndicators[x].value)*100).setscale(2);
                } else if(lstIndicators[x].Id == Label.PriceWSLabel20) {
                    olis[0].RAROEC_Operation__c = (Decimal.valueOf(lstIndicators[x].value)*100).setscale(2);
                } else if(lstIndicators[x].Id == Label.PriceWSLabel21) {
                    olis[0].Liquidity_Margin_Lost__c = Decimal.valueOf(lstIndicators[x].value).setscale(2);
                } else if(lstIndicators[x].Id == Label.PriceWSLabel22) {
                    olis[0].Liquidity_Margin_Recovered__c = Decimal.valueOf(lstIndicators[x].value).setscale(2);
                } else if(lstIndicators[x].Id == 'CURRENCY_FINANCIAL_RECOVERY') {
                    olis[0].Liquidity_Margin_Recovered_Currency__c = lstIndicators[x].value;
                }
            }
            mapReturn.put('minimtea', olis[0].minimun_apr_per__c);
            mapReturn.put('sugtea', olis[0].suggested_apr_per__c);
            mapReturn.put('rorcOper', olis[0].RORC_Operation__c);
            mapReturn.put('rorc_client', olis[0].RORC_Client__c);
            mapReturn.put('finMarLost', olis[0].Liquidity_Margin_Lost__c);
            mapReturn.put('finMarLostCur', olis[0].CurrencyIsoCode);
            mapReturn.put('finMarRecover', olis[0].Liquidity_Margin_Recovered__c);
            mapReturn.put('finMarRecoverCur', olis[0].Liquidity_Margin_Recovered_Currency__c);
        }
        return olis;
    }
    
    /**
     * method to fill map with liquidity indicators
	*/
    /*public static List<OpportunityLineItem> readLiqIndicator(AnalyzeRate_helper.ResponseAnalyzeRate_Wrapper jbody, List<OpportunityLineItem> oliAux) {
        final List<OpportunityLineItem> olis = oliAux;
        olis[0].Liquidity_Margin_Recovered__c = 0.00;
        if(jbody.data != null && jbody.data.indicators != null) {
            List<AnalyzeRate_helper.Response_LiquidityIndicators> liqIndicator = jbody.data.liquidityIndicators;
            for(Integer x = 0; x < liqIndicator.size(); x++) {
                if(liqIndicator[x].Id == Label.PriceWSLabel22) {
                    olis[0].Liquidity_Margin_Recovered__c = Decimal.valueOf(liqIndicator[x].detail.amount).setscale(2);
                }
            }
            mapReturn.put('finMarRecover', olis[0].Liquidity_Margin_Recovered__c);
        }
        return olis;
    }*/
    
    /**
     * method to fill map with products
	*/
    public static Map<String,Object> readProduct(Map<String,Object> mapReturnAux, AnalyzeRate_helper.ResponseAnalyzeRate_Wrapper jbody, String recordId) {
        mapReturn = mapReturnAux;
        if(jbody.data != null && jbody.data.products != null) {
            final List<String> commIds = new List<String>();
            final List<String> commProdIds = new List<String>();
            for(Opportunity_Solution_Commitment__c comm : [SELECT id, opp_solution_commitment_id__c, CurrencyIsoCode, opp_solution_commitment_amount__c, opp_soln_comt_expiry_days_number__c FROM Opportunity_Solution_Commitment__c WHERE opportunity_id__c = :recordId]) {
                final String aux = comm.opp_solution_commitment_id__c+comm.CurrencyIsoCode+comm.opp_soln_comt_expiry_days_number__c;
                commIds.add(aux);
                commProdIds.add(comm.opp_solution_commitment_id__c);
            }
            mapReturn.put('commIds', commIds);
            mapReturn.put('commProdIds', commProdIds);
            mapReturn.put('sugCommitments', JSON.serialize(jbody.data.products));
        }
        return mapReturn;
    }
}