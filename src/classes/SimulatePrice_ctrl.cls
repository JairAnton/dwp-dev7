/**
 * @author Global_HUB developers
 * @date 14-08-2018
 *
 * @group Global_HUB
 *
 * @description Controller class from SimulatePrice_cmp
 * @HIstorial de cambios:
    - Actualización del web service de la version v0 a la v1
 *****************************
    Modificaciones:

    Martín Alejandro Mori Chávez  04-11-2019
 **/
public with sharing class SimulatePrice_ctrl {
	static String idOli;
	/* variable use for indicate to next action */
	static Boolean validParams = false;
	/* variable use for show error */
	static String genericError;
	@AuraEnabled
	//getInfo with the id of Opportunity
	public static Map<String, Object> getInfo(String recordId) {
		Map<String, Object> mapReturn = new Map<String, Object>();
		Double sugtea, spread, minimspread, addspread, expected, efficiency, financystock, fundingadj, regulatory, addcapital, capitalamount;
		Double minimtea = 0, fundingcost = 0, calculateSpread = 0;
		String currencyid;
		List<OpportunityLineItem> oli = [Select Id, Name, minimun_apr_per__c, suggested_apr_per__c, spread_per__c,
		                                 additional_capital_per__c, additional_apread_per__c, capital_amount__c, capital_currency_id__c, efficiency_cost__c,
		                                 expected_loss_per__c, financing_cost_stockholder_per__c, funding_cost_per__c, funding_cost_adjusted_per__c,
		                                 minimum_spread_per__c, regulatory_capital_per__c, pricing_model_id__c, CurrencyIsoCode, tcf_type_beneficiary__c,
		                                 tcf_Periodicity_commission__c, tcf_type_bail_letter__c from OpportunityLineItem where OpportunityId = : recordId];
		validParameters(oli);
		if(validParams) {
			try {
				//helper to call the service
				PriceRate_helper prate = new PriceRate_helper(recordId, true);
				//invoke the service
				HttpResponse invoke = prate.invoke();
				//get json body
				PriceRate_helper.ResponseSimulateRate_Wrapper jbody = prate.parse(invoke.getBody());
				//get values if statuscode=200
				if(invoke.getStatusCode() == 200) {
					if(!oli.isEmpty()) {
						if(jbody.data != null && jbody.data.summary != null && jbody.data.summary[0].interestRates != null &&
						   jbody.data.summary[0].interestRates.EffectiveRates != null) {
							List<PriceRate_helper.Response_EffectiveRates> lsttea = jbody.data.summary[0].interestRates.EffectiveRates;
							for(Integer i = 0; i < lsttea.size(); i++) {
								if(lsttea[i].id == Label.MinTEA) {
									minimtea = lsttea[i].percentage * 100;
								} else if(lsttea[i].id == Label.SuggTEA) {
									sugtea = lsttea[i].percentage * 100;
								}
							}
						}

						if(jbody.data != null && jbody.data.summary != null && jbody.data.summary[0].LiquidityIndicators != null) {
							List<PriceRate_helper.Response_LiquidityIndicators> lstspread = jbody.data.summary[0].LiquidityIndicators;
							for(Integer x = 0; x < lstspread.size(); x++) {
								if(lstspread[x].id == Label.commSpread) {
									spread = lstspread[x].detail.percentage * 100;
								} else if(lstspread[x].id == Label.PriceWSLabel02) {
									addspread = lstspread[x].detail.percentage * 100;
								} else if(lstspread[x].id == Label.PriceWSLabel01) {
									minimspread = lstspread[x].detail.percentage * 100;
								}
							}
						}
						if(jbody.data != null && jbody.data.summary != null && jbody.data.summary[0].fees != null) {
							List<PriceRate_helper.Response_Fees> lstfees = jbody.data.summary[0].fees;
							system.debug('lstfees' + lstfees);
							for(Integer x = 0; x < lstfees.size(); x++) {
								if(lstfees[x].feeType.Id == Label.PriceWSLabel10) {
									expected = lstfees[x].detail.percentage * 100;
								} else if(lstfees[x].feeType.Id == Label.PriceWSLabel09) {
									fundingcost = lstfees[x].detail.percentage * 100;
								} else if(lstfees[x].feeType.Id == Label.PriceWSLabel08) {
									efficiency = lstfees[x].detail.percentage * 100;
								} else if(lstfees[x].feeType.Id == Label.PriceWSLabel07) {
									financystock = lstfees[x].detail.percentage * 100;
								} else if(lstfees[x].feeType.Id == Label.PriceWSLabel06) {
									fundingadj = lstfees[x].detail.percentage * 100;
								} else if(lstfees[x].feeType.Id == Label.PriceWSLabel05) {
									regulatory = lstfees[x].detail.percentage * 100;
								} else if(lstfees[x].feeType.Id == Label.PriceWSLabel04) {
									addcapital = lstfees[x].detail.percentage * 100;
								} else if(lstfees[x].feeType.Id == Label.PriceWSLabel03) {
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
				} else if(invoke.getStatusCode() == 409) {
					WebServiceUtils.ResponseErrorMessage_Wrapper jerror = WebServiceUtils.parse(invoke.getBody());
					genericError = jerror.errormessage;
				} else {
					genericError = Label.GenericError;
				}
			} catch(Exception e) {
				genericError = e.getMessage();
			}
		}

		mapReturn.put('oli', idOli);
		mapReturn.put('minimtea', minimtea);
		mapReturn.put('sugtea', sugtea);
		mapReturn.put('spread', calculateSpread);
		mapReturn.put('genericError', genericError);

		return mapReturn;
	}

	/**
	 * Method validate if the combination parameters is correct and call webservice
	 */
	public static void validParameters(List<OpportunityLineItem> olis) {
		Boolean validPeriod = true;
		Boolean validBail = true;
		if(!olis.isEmpty() && olis[0].pricing_model_id__c == '11') {
			validBail = false;
			validPeriod = false;
			for(BE_BailLetterCombination__c bailLetterComb : [SELECT Id, Name, UniqueId__c, Currency__c, Beneficiary__c, BailObject__c, Period__c FROM BE_BailLetterCombination__c LIMIT 10000]) {
				if(bailLetterComb.UniqueId__c == olis[0].CurrencyIsoCode + olis[0].tcf_type_beneficiary__c + olis[0].tcf_type_bail_letter__c + olis[0].tcf_Periodicity_commission__c) {
					validPeriod = true;
					validBail = true;
					break;
				} else if(validBail == false && bailLetterComb.UniqueId__c.subString(0, 7) == olis[0].CurrencyIsoCode + olis[0].tcf_type_beneficiary__c + olis[0].tcf_type_bail_letter__c) {
					validBail = true;
				}
			}
		}
		returnError(validPeriod, validBail);
	}

	/**
	 * Method for return error of the validation bail letter
	 */
	public static void returnError(Boolean validPeriod, Boolean validBail) {
		if(validBail == false) {
			genericError = 'El "tipo carta fianza" elegido no es válido en combinación con el "tipo de moneda" y "tipo de benenficiario" seleccionados. Por favor eliga otro "tipo carta fianza".';
		} else if(validPeriod == false) {
			genericError = 'La "periodicidad comisión" elegida no es válida en combinación con el "tipo de moneda", "tipo carta fianza" y "tipo de benenficiario" seleccionados. Por favor eliga otra "periodicidad comisión".';
		} else if(validPeriod) {
			validParams = true;
		}
	}
}
