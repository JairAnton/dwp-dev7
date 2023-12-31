public class SanctionPriceAnalistWeb_ctrl {
	@AuraEnabled
	public static Map<String, Object> getInfo(String oppId) {
		Map<String, Object> mpReturn = new Map<String, Object>();
		String errorMessage;
		List<OpportunityLineItem> lstOLI;
		try {
			lstOLI = [Select Id, price_quote_id__c, product_price_approval_method__c, proposed_apr_per__c, validityDate__c, RORC_Client__c,
                      RORC_Operation__c, RORC_Model__c, RORC_Approved__c, RAROEC_Operation__c, hasCommissions__c, RORC_Updated__c from OpportunityLineItem where OpportunityId =:oppId];
			if(!lstOLI.isEmpty()) {
				mpReturn.put('oliId', lstOLI[0].Id);
				mpReturn.put('hasCommissions', lstOLI[0].hasCommissions__c);
				mpReturn.put('proposed', lstOli[0].proposed_apr_per__c);
				mpReturn.put('RORC_Client',lstOli[0].RORC_Client__c);
                mpReturn.put('RAROEC',lstOli[0].RAROEC_Operation__c);
                mpReturn.put('rorcmodel',lstOli[0].RORC_Model__c);
                mpReturn.put('rorcreq',lstOli[0].RORC_Operation__c);
                mpReturn.put('rorcapp',lstOli[0].RORC_Approved__c);
				mpReturn.put('rorcupdated',lstOLI[0].RORC_Updated__c);
                //Call a RECOVER Service One product
				if(lstOLI[0].price_quote_id__c != '' && lstOLI[0].product_price_approval_method__c == 'Web') {
					//helper to call the service
					GetQuotationRequest_helper getquoteHelper = new GetQuotationRequest_helper(oppId);
					//invoke the service
					System.HttpResponse invoke = getquoteHelper.invoke();
					//get json body
					GetQuotationRequest_helper.ResponseGetQuotationRequest_Wrapper jbody = GetQuotationRequest_helper.parse(invoke.getBody());
					switch on invoke.getStatusCode() {
						when 200 {
							if(jbody.data != null && jbody.data.quotations != null && jbody.data.quotations[0].interestRates != null && jbody.data.quotations[0].interestRates.effectiveRates != null) {
								mpReturn.put('validityDate', (jbody.data.quotations[0].validityDate == null ? lstOLI[0].validityDate__c : Date.valueOf(jbody.data.quotations[0].validityDate.substring(0, 10))));
								List<GetQuotationRequest_helper.Response_EffectiveRates> lsteffec = jbody.data.quotations[0].interestRates.effectiveRates;
								for(Integer x = 0; x < lsteffec.size(); x++) {
									switch on lsteffec[x].id {
										when 'MINIMUM_TEA' {
											mpReturn.put('teamodel', (lsteffec[x].percentage) * 100);
										}
										when 'TEA_OF_AUTONOMY' {
											mpReturn.put('teaminim', (lsteffec[x].percentage) * 100);
										}
										when 'REQUESTED_TEA' {
											mpReturn.put('teareq', (lsteffec[x].percentage) * 100);
										}
										when 'APPROVED_TEA' {
											mpReturn.put('teaapp', (lsteffec[x].percentage) * 100);
										}
									}
								}
							}
							if(jbody.data != null && jbody.data.quotations != null && jbody.data.quotations[0].fees != null) {
								List<GetQuotationRequest_helper.Response_Fees> lstfees = jbody.data.quotations[0].fees;
								for(Integer x = 0; x < lstfees.size(); x++) {
									switch on lstfees[x].feeType.id {
										when 'FUNDING_COST_ADJUSTED' {
											mpReturn.put('DI', (lstfees[x].detail.percentage) * 100);
										}
										when 'EXPECTED_LOSS' {
											mpReturn.put('PE', (lstfees[x].detail.percentage) * 100);
										}
										when 'EFFICIENCY_COST' {
											mpReturn.put('CE', (lstfees[x].detail.percentage) * 100);
										}
										when 'REGULATORY_CAPITAL' {
											mpReturn.put('CR', (lstfees[x].detail.percentage) * 100);
										}
										when 'FUNDING_COST' {
											mpReturn.put('DI_FC', (lstfees[x].detail.percentage) * 100);
										}
									}
								}
							}
							if(jbody.data != null && jbody.data.quotations != null && jbody.data.quotations[0].liquidityIndicators != null) {
								List<GetQuotationRequest_helper.Response_LiquidityIndicators> lstliquid = jbody.data.quotations[0].liquidityIndicators;
								for(Integer x = 0; x < lstliquid.size(); x++) {
									switch on lstliquid[x].id {
										when 'SPREAD_OF_OPERATION' {
											mpReturn.put('spreadmodel', (lstliquid[x].detail.percentage) * 100);
										}
										when 'SPREAD_OF_REQUESTED_TEA' {
											mpReturn.put('spreadreq', (lstliquid[x].detail.percentage) * 100);
										}
										when 'SPREAD_OF_APPROVED_TEA' {
											mpReturn.put('spreadapp', (lstliquid[x].detail.percentage) * 100);
										}
									}
								}
							}
							if(jbody.data != null && jbody.data.quotations != null && jbody.data.quotations[0].profitabilityIndicators != null) {
								List<GetQuotationRequest_helper.Response_ProfitabilityIndicators> lstprof = jbody.data.quotations[0].profitabilityIndicators;
								for(Integer x = 0; x < lstprof.size(); x++) {
									switch on lstprof[x].id {
										when 'BENEFIT_BEFORE_TAX_OF_MINIMUM_TEA' {
											mpReturn.put('baiminim', (lstprof[x].percentage) * 100);
										}
										when 'BENEFIT_BEFORE_TAX_OF_OPERATION' {
											mpReturn.put('baimodel', (lstprof[x].percentage) * 100);
										}
										when 'BENEFIT_BEFORE_TAX_OF_REQUESTED_TEA' {
											mpReturn.put('baireq', (lstprof[x].percentage) * 100);
										}
										when 'BENEFIT_BEFORE_TAX_OF_APPROVED_TEA' {
											mpReturn.put('baiapp', (lstprof[x].percentage) * 100);
										}
									}
								}
							}
							if(mpReturn.containsKey('DI')) {
								lstOLI[0].funding_cost_adjusted_per__c = (Decimal) mpReturn.get('DI');
								update lstOLI;
							}
							if(mpReturn.containsKey('DI_FC')) {
								Final Decimal fundingCost = (Decimal) mpReturn.get('DI_FC');
								lstOLI[0].funding_cost_per__c = fundingCost;
								Final Decimal proposed = (Decimal) mpReturn.get('proposed');
								mpReturn.put('SPREAD', (proposed - fundingCost).setScale(2));
							}
						} when 409 {
							WebServiceUtils.ResponseErrorMessage_Wrapper jerror = WebServiceUtils.parse(invoke.getBody());
							errorMessage = Label.PriceGetQuotationRequestKnownError + ' ' + jerror.errormessage;
						} when 500 {
							errorMessage = Label.PriceGetQuotationRequestUnknownError;
						} when else {
							errorMessage = Label.PriceGetQuotationRequestUnknownError;
						}
					}
				}
			}
		} catch(Exception e) {
			errorMessage = Label.PriceGetQuotationRequestUnknownError;
		}
		mpReturn.put('errormessage', errorMessage);
		List<String> lstHeaders = new List<String>();
		lstHeaders.add(Label.lblMini);
		lstHeaders.add(Label.lblModel);
		lstHeaders.add(Label.lblReq);
		lstHeaders.add(Label.lblAuth);
		mpReturn.put('headers', lstHeaders);

		return mpReturn;
	}
    
	@AuraEnabled
	public static Map<String, Object> calculate(String oppId, decimal tea) {
		Map<String, Object> mpReturn = new Map<String, Object>();
		String errorMessage;
		List<OpportunityLineItem> lstOLI = new List<OpportunityLineItem>();
		try {
			lstOLI = [Select Id, price_quote_id__c, product_price_approval_method__c, proposed_apr_per__c, funding_cost_per__c, price_rates_calculation_Id__c, hasCommissions__c from OpportunityLineItem where OpportunityId =:oppId];
			if(lstOLI[0].price_quote_id__c != '' && lstOLI[0].product_price_approval_method__c == 'Web') {
				//helper to call the service
				Final AnalyzeRate_helper analyzerateHelper = new AnalyzeRate_helper(oppId, lstOLI[0].price_rates_calculation_Id__c, tea, false);
				analyzerateHelper.hasCommissions = lstOLI[0].hasCommissions__c;
				//invoke the service
				Final System.HttpResponse invoke = analyzerateHelper.invoke();
				//get json body
				mpReturn.put('body', invoke.getBody());
				mpReturn.put('state', invoke.getStatusCode());
				mpReturn.put('SPREAD', (tea - lstOLI[0].funding_cost_per__c).setScale(2));
			}
		} catch(Exception e) {
			errorMessage = e.getMessage();
		}
		mpReturn.put('errormessage', errorMessage);
		return mpReturn;
	}
}