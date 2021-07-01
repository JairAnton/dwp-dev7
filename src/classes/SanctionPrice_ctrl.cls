/**
 * @author Global_HUB developers
 * @date 01-08-2018
 *
 * @group Global_HUB
 *
 * @description Controller class from SanctionPrice_cmp
 * @HIstorial de cambios:
    - Actualización del web service de la version v0 a la v1
	- Agregación de los indicadores de RORC RAROEC
 *****************************
    Modificaciones:

    Martín Alejandro Mori Chávez  02-12-2019
	Martín Alejandro Mori Chávez  07-07-2020
 **/
public with sharing class SanctionPrice_ctrl {    
    static String idOli;
    static Map<String,Object> mapReturn = new Map<String,Object>();
    /* variable */
    static String genericError;
    /*Spread calculado desde campo formula*/
    static Double calculateSpread;
    /* ok code of call webservice */
    final static Integer OKCODE = 200;
    /* Wrapper of fields*/
    static List<BE_OutputField_Wrapper> fields = new List<BE_OutputField_Wrapper>();
    /* string error */
    final static String STRINGERROR = 'genericError';
    /* string priceIndicator */
    final static String STRINGPRICEIND = 'priceIndicator';
    /* string proposed */
    final static String STRINGPROPOSED = 'proposed';
    /* string approvalmethod */
    final static String STRAPPRMET = 'approvalMethod';
    /* string idopplineitem */
    final static String STRIDOLI = 'IdOppLineItem';
    
    /**
     * Method used to calculate rate
	 */
    @AuraEnabled
    public static Map<String,Object> calculateRate(String recordId) {
        List<Opportunity> lstOpp = [SELECT Id, AccountId, Account.commercial_strategy__c, Account.segment_desc__c,
                                    (SELECT Id, OpportunityId, product_price_approval_method__c, product_price_approval_indicator__c, minimun_apr_per__c, 
                                     suggested_apr_per__c, spread_per__c, price_rates_calculation_Id__c, proposed_apr_per__c, 
                                     additional_capital_per__c, additional_apread_per__c, capital_amount__c, capital_currency_id__c, 
                                     efficiency_cost__c, expected_loss_per__c, financing_cost_stockholder_per__c, funding_cost_per__c, 
                                     funding_cost_adjusted_per__c, minimum_spread_per__c, regulatory_capital_per__c, Product2Id, 
                                     product2.Type_of_quote__c, pricing_model_id__c, CurrencyIsoCode, tcf_type_beneficiary__c, 
                                     tcf_Periodicity_commission__c, tcf_type_bail_letter__c, hasCommissions__c FROM OpportunityLineItems) 
                                    FROM Opportunity WHERE Id = :recordId];
        try {
            //If opportunity has opportunityLineItems
            if(lstOpp[0].OpportunityLineItems.size()>0) {
                mapReturn.put(STRIDOLI,lstOpp[0].OpportunityLineItems[0].Id);
                mapReturn.put(STRAPPRMET,lstOpp[0].OpportunityLineItems[0].product_price_approval_method__c);
                mapReturn.put('pricingModelId', lstOpp[0].OpportunityLineItems[0].pricing_model_id__c);
                mapReturn.put('AccId',lstOpp[0].AccountId);
                mapReturn.put('type_of_quote',lstOpp[0].OpportunityLineItems[0].product2.Type_of_quote__c);
                mapReturn.put('commercial_strategy',lstOpp[0].Account.commercial_strategy__c);
                mapReturn.put('hasCommission',lstOpp[0].OpportunityLineItems[0].hasCommissions__c);
                //If product_price_approval_method__c == Tarifario and has a OLI
                if(lstOpp[0].OpportunityLineItems[0].product_price_approval_method__c == 'Tarifario') {
                    String strSegment = (lstOpp[0].Account.segment_desc__c == null?'':lstOpp[0].Account.segment_desc__c);
                    final List<Price_Fee__c> lstPriceFee = [SELECT Id, validity_start_date__c, validity_end_date__c, product_id__c,
                                                      minimun_fee_per__c, account_segment_id__c, account_segment_desc__c, calc_account_segment_desc__c
                                                      FROM Price_Fee__c WHERE validity_start_date__c <= TODAY AND validity_end_date__c >= TODAY 
                                                      AND product_id__c = :lstOpp[0].OpportunityLineItems[0].Product2Id
                                                      AND calc_account_segment_desc__c = :strSegment.toUpperCase(UserInfo.getLocale())];//Yuliño 11/12/2018 : Agregando el lenguaje local
                    //get minimun_fee_per__c
                    if(!lstOpp.isEmpty() && !lstPriceFee.isEmpty()) {
                        mapReturn.put('dynamicValue',lstPriceFee[0].minimun_fee_per__c);
                    }
                    //If product_price_approval_method__c == Web and has a OLI    
                } else if(lstOpp[0].OpportunityLineItems[0].product_price_approval_method__c == 'Web') {
                    callWSCalculateRate(lstOpp[0].OpportunityLineItems);
                    mapReturn.put(STRINGPROPOSED, (lstOpp[0].OpportunityLineItems[0].proposed_apr_per__c == null ? '' : String.valueOf(lstOpp[0].OpportunityLineItems[0].proposed_apr_per__c)));
                }
                mapReturn.put('hasOLI',true);
                mapReturn.put(STRINGPRICEIND,lstOpp[0].OpportunityLineItems[0].product_price_approval_indicator__c);
                //If opportunity hasn't opportunityLineItems
            } else {
                mapReturn.put('hasOLI',false);
            }
        } catch(Exception e) {
            genericError = e.getMessage();
            mapReturn.put(STRINGERROR, genericError);
        }
        return mapReturn;
    }
    
    /**
	 * Method call calculateRate method of webservice 
     */
    public static void callWSCalculateRate(List<OpportunityLineItem> olis) {
        genericError = BE_PriceRate_Rest.invokeWS(olis, false);
        if(String.isNotBlank(genericError)) {
            genericError = genericError.replaceAll('BENEFICIARIO', '"tipo de beneficiario"');
            genericError = genericError.replaceAll('OBJETO FIANZA', '"tipo carta fianza"');
            genericError = genericError.replaceAll('MONEDA', '"moneda"');
            genericError = genericError.replaceAll('El PERIODO DE PAGO elegido no es válido', 'La "periodicidad comisión" elegida no es válida');
            genericError = genericError.replaceAll('otro PERIODO DE PAGO', 'otra "periodicidad comisión"');
            genericError = genericError.replaceAll('el PERIODO DE PAGO', 'la "periodicidad comisión"');
            mapReturn.put(STRINGERROR, genericError);
        }
    }
    
    @AuraEnabled
    public static Map<String,Object> getInfoAnalist(String recordId) {
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
        try {
            //If opportunity has opportunityLineItems
            if(lstOpp[0].OpportunityLineItems.size()>0) {
                mapReturn.put(STRIDOLI,lstOpp[0].OpportunityLineItems[0].Id);
                mapReturn.put(STRAPPRMET,lstOpp[0].OpportunityLineItems[0].product_price_approval_method__c);
                mapReturn.put('AccId',lstOpp[0].AccountId);
                mapReturn.put('type_of_quote',lstOpp[0].OpportunityLineItems[0].product2.Type_of_quote__c);
                mapReturn.put('commercial_strategy',lstOpp[0].Account.commercial_strategy__c);
                //If product_price_approval_method__c == Tarifario and has a OLI
                if(lstOpp[0].OpportunityLineItems[0].product_price_approval_method__c == 'Tarifario') {
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
                    if(!lstOpp.isEmpty() && !lstPriceFee.isEmpty()) {
                        mapReturn.put('dynamicValue',lstPriceFee[0].minimun_fee_per__c);
                    }
                    //If product_price_approval_method__c == Web and has a OLI    
                } else if(lstOpp[0].OpportunityLineItems[0].product_price_approval_method__c == 'Web') {
                    if(lstOpp[0].OpportunityLineItems[0].proposed_apr_per__c!=null) {
                        mapReturn.put(STRINGPROPOSED,lstOpp[0].OpportunityLineItems[0].proposed_apr_per__c);
                    } else {
                        mapReturn.put(STRINGPROPOSED,'');
                    }
                }
                mapReturn.put('hasOLI',true);
                mapReturn.put(STRINGPRICEIND,lstOpp[0].OpportunityLineItems[0].product_price_approval_indicator__c);
                //If opportunity hasn't opportunityLineItems
            } else {
                mapReturn.put('hasOLI',false);
            }     
            
        } catch(Exception e) {
            genericError = e.getMessage();
            mapReturn.put(STRINGERROR, genericError);
        }
        return mapReturn; 
    }
    
    @AuraEnabled
    public static Map<String,Object> getInfoWithoutDefaultValues(String recordId) {
        List<Opportunity> lstOpp = [SELECT  Id,
                                    AccountId,
                                    Account.segment_desc__c,
                                    (SELECT     Id, 
                                     product_price_approval_method__c, 
                                     product_price_approval_indicator__c
                                     FROM OpportunityLineItems) 
                                    FROM Opportunity 
                                    WHERE Id = :recordId];
        try {
            //If opportunity has opportunityLineItems
            if(lstOpp[0].OpportunityLineItems.size()>0) {
                mapReturn.put(STRIDOLI,lstOpp[0].OpportunityLineItems[0].Id);
                mapReturn.put(STRAPPRMET,lstOpp[0].OpportunityLineItems[0].product_price_approval_method__c);
                mapReturn.put('hasOLI',true);
                mapReturn.put(STRINGPRICEIND,lstOpp[0].OpportunityLineItems[0].product_price_approval_indicator__c);
                //If opportunity hasn't opportunityLineItems
            } else {
                mapReturn.put('hasOLI',false);
            }     
            
        } catch(Exception e) {
            genericError = e.getMessage();
            mapReturn.put(STRINGERROR, genericError);
        }
        return mapReturn; 
    }
    
    @AuraEnabled
    public static Map<String,Object> getInfo(String recordId) {
        List<OpportunityLineItem> olis = [SELECT Id, product_price_approval_method__c, Opportunity.AccountId, Product2.Type_of_quote__c,
                                          Opportunity.Account.commercial_strategy__c, suggested_apr_per__c, minimun_apr_per__c, calculated_spread__c,
                                          price_rates_calculation_Id__c, proposed_apr_per__c, product_price_approval_indicator__c, pricing_model_id__c,
                                          RORC_Client__c, RORC_Operation__c, RAROEC_Operation__c, RORC_Updated__c, RORC_Variation__c,
                                          RORC_Model__c, RORC_Approved__c, Liquidity_Margin_Lost__c, CurrencyIsoCode, Liquidity_Margin_Recovered_Currency__c
                                          FROM OpportunityLineItem WHERE OpportunityId = :recordId];
        try {
            final Decimal teaProposed = (olis[0].proposed_apr_per__c == null ? olis[0].suggested_apr_per__c : olis[0].proposed_apr_per__c);
            mapReturn = BE_AnalyzeRate_Rest.invokeWS(recordId, olis, teaProposed, false);
            mapReturn.put(STRIDOLI, olis[0].Id);
            mapReturn.put(STRAPPRMET, olis[0].product_price_approval_method__c);
            mapReturn.put('pricingModelId', olis[0].pricing_model_id__c);
            mapReturn.put('AccId', olis[0].Opportunity.AccountId);
            mapReturn.put('type_of_quote', olis[0].Product2.Type_of_quote__c);
            mapReturn.put('commercial_strategy', olis[0].Opportunity.Account.commercial_strategy__c);
            mapReturn.put(STRINGPROPOSED, String.valueOf(teaProposed));
            mapReturn.put('hasOLI',true);
            mapReturn.put(STRINGPRICEIND,olis[0].product_price_approval_indicator__c);
            
            if(String.isNotBlank(genericError) == false) {
                final Map<String, Schema.SObjectField> fieldMap = OpportunityLineItem.sObjectType.getDescribe().fields.getMap();
                for(Field__mdt fieldmdt : [SELECT Id, field_api_name__c, default_value__c, is_readonly__c, is_required__c, order__c
                                           FROM Field__mdt WHERE field_form__r.unique_id__c = 'Web_CalculateRate' ORDER BY order__c]) {
                                               fields.add(new BE_OutputField_Wrapper(fieldmdt.field_api_name__c, fieldMap.get(fieldmdt.field_api_name__c).getDescribe().getLabel(), String.valueOf(fieldMap.get(fieldmdt.field_api_name__c).getDescribe().getType()), String.valueOf(olis[0].get(fieldmdt.field_api_name__c))));
                                           }
            }
            mapReturn.put('fields', JSON.serialize(fields));
        } catch(Exception e) {
            genericError = e.getMessage();
            mapReturn.put(STRINGERROR, genericError);
        }
        return mapReturn; 
    }
    
    /**
     * method used to call quotation methods of webservice 
     */
    @AuraEnabled
    public static Map<String,Object> requestQuote(String recordId) {
        mapReturn.put('nextCallout',false);
		final List<OpportunityLineItem> oliList = [SELECT price_quote_id__c, price_quote_owner_id__c, Liquidity_Margin_Lost__c
											FROM OpportunityLineItem WHERE OpportunityId = :recordId];
		if(oliList.isEmpty() == false) {
            // Check if there is already a price quotation request for the oportunity
			if(String.isNotBlank(oliList[0].price_quote_id__c)) {
				// Check if the context user is the same user that owns the price quotation request
				if(oliList[0].price_quote_owner_id__c == UserInfo.getUserId()) {
					// Invoke web service to request quotation approval
					mapReturn = BE_Quotation_Rest.invokeApprovalQuo(recordId);
				} else {
					// Invoke web service to recover quotation 
					mapReturn = BE_Quotation_Rest.invokeRecoverQuo(recordId); 
					mapReturn.put('nextCallout',true);
				}
			} else {
                // Invoke web service to create quotation
				mapReturn = BE_Quotation_Rest.invokeCreateQuo(recordId);
			}
            if(oliList[0].Liquidity_Margin_Lost__c<=0 || oliList[0].Liquidity_Margin_Lost__c==null) {
                delete [SELECT Id FROM Opportunity_Solution_Commitment__c WHERE opportunity_id__c = :recordId];
            }
		}
        return mapReturn; 
    }
}