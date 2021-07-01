/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_AnalyzeRate_ctrl>
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-08-10
   @Description Class ctrl from sanction price
   @Changes
   Date        Author   Email                  				Type		Description
   2020-08-10  MAMC     martin.mori.contractor@bbva.com    	Creation
   -------------------------------------------------------------------------------------------------
 */
@SuppressWarnings('PMD.AuraEnabledWithoutCatchBlock')
public with sharing class BE_AnalyzeRate_ctrl {
    /* Map that contains return values*/
    static Map<String,Object> mapReturn = new Map<String,Object>();
    /* String of error message*/
    static String errorCal;
    /* Wrapper of fields*/
    static List<BE_OutputField_Wrapper> fields = new List<BE_OutputField_Wrapper>();
    /* ok code of call webservice */
    final static Integer OKCODE = 200;
    /* string isOk */
    final static String STROK = 'isOk';
    
    /*
     * constructor of class
	*/
    private BE_AnalyzeRate_ctrl() {
    }
    
    /*
     * Method used to calculate indicators of RORC
	*/
    @AuraEnabled
    public static Map<String,Object> getInfoRORC(String recordId, String tea, String vdata, Boolean hasCommissions) {
        if(String.isNotBlank(vdata)) {
            fields = (List<BE_OutputField_Wrapper>)JSON.deserialize(vdata, List<BE_OutputField_Wrapper>.class);
        }
        if(tea=='' || tea==null) {
            mapReturn.put(STROK, false);
            errorCal = 'Es necesario ingresar una tasa';
        } else {
            List<OpportunityLineItem> olis = [SELECT Id, OpportunityId, minimun_apr_per__c, price_rates_calculation_Id__c, funding_cost_per__c, calculated_spread__c,
                                              RORC_Client__c, RORC_Operation__c, RAROEC_Operation__c, RORC_Updated__c, RORC_Variation__c, CurrencyIsoCode,
                                              RORC_Model__c, RORC_Approved__c, Liquidity_Margin_Lost__c, Liquidity_Margin_Recovered__c, Liquidity_Margin_Recovered_Currency__c, 
                                              suggested_apr_per__c, proposed_apr_per__c FROM OpportunityLineItem WHERE Id = :recordId];
            try {
                //helper to call the service
                final AnalyzeRate_helper prate = new AnalyzeRate_helper(olis[0].OpportunityId, olis[0].price_rates_calculation_Id__c, Decimal.valueOf(tea), false);
                prate.hasCommissions = hasCommissions;
                System.debug('COMISIONS RECEIVED'+hasCommissions);
                System.debug('COMMISSOION SETTED'+prate.hasCommissions);
                //invoke the service
                final HttpResponse invoke = prate.invoke();
                //code = 200 OK
                if(invoke.getStatusCode() == OKCODE) {
                    mapReturn.put(STROK, true);
                    final AnalyzeRate_helper.ResponseAnalyzeRate_Wrapper jbody = prate.parse(invoke.getBody());
                    olis[0].hasCommissions__c = hasCommissions;
                    //olis = BE_AnalyzeRate_Rest.readFees(jbody, olis);
                    olis = BE_AnalyzeRate_Rest.readIndicators(jbody, olis);
                    //olis = BE_AnalyzeRate_Rest.readLiqIndicator(jbody, olis);
                    mapReturn = BE_AnalyzeRate_Rest.readProduct(mapReturn, jbody, olis[0].OpportunityId);
                    olis[0].proposed_apr_per__c = Decimal.valueOf(tea);
                    mapReturn.put('rorcOper', olis[0].RORC_Operation__c);
                    mapReturn.put('finMarLost', olis[0].Liquidity_Margin_Lost__c);
                    mapReturn.put('finMarLostCur', olis[0].CurrencyIsoCode);
                    mapReturn.put('finMarRecover', olis[0].Liquidity_Margin_Recovered__c);
                    mapReturn.put('finMarRecoverCur', olis[0].Liquidity_Margin_Recovered_Currency__c);
                    update olis;
                } else {
                    mapReturn.put(STROK, false);
                    final WebServiceUtils.ResponseErrorMessage_Wrapper errorDetails = WebServiceUtils.parse(invoke.getBody());
                    errorCal = errorDetails.errormessage;
                }
                Formula.recalculateFormulas(new List<OpportunityLineItem>{olis[0]});
                for(BE_OutputField_Wrapper fielAux : fields) {
                    fielAux.valueField = String.valueOf(olis[0].get(fielAux.apiName));
                }
            } catch(Exception e) {
                mapReturn.put(STROK, false);
                errorCal = e.getMessage();
            }
        }
        mapReturn.put('errorCal',errorCal);
        mapReturn.put('fields', JSON.serialize(fields));
        return mapReturn; 
    }

    /*
     * Method used to calculate indicators of RORC
	*/
    @AuraEnabled
    public static void setHasCommission(Boolean hasCommission, String recordId) {
        if(recordId != null && recordId != '') {
        try {
            
                OpportunityLineItem oli = [SELECT Id, hasCommissions__c FROM OpportunityLineItem WHERE Id = :recordId];
                oli.hasCommissions__c = hasCommission;
                update oli;
            
        } catch(Exception e) { 
            mapReturn.put(STROK, false);
            errorCal = e.getMessage();
        }
    }
    }
}