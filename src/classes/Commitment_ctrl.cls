/**
 * @author Global_HUB developers
 * @date 01-08-2018
 *
 * @group Global_HUB
 *
 * @description Controller class from Commitment_cmp
 * @HIstorial de cambios:
    - Actualización del web service de la version v0 a la v1
 *****************************
    Modificaciones:

    Martín Alejandro Mori Chávez  02-12-2019
 **/
public with sharing class Commitment_ctrl {
	/* type commitment */
	final static String STRAMOUNT = 'AMOUNT';
    /* string ok */
    final static String STRISOK = 'isOK';

	/*
	 * Method used to return compromises available
	 */
	@AuraEnabled
	public static Map<String, Object> getInfo(String quoteType, String pricingModel) {
		Map<String, Object> mapReturn = new Map<String, Object>();
		List<Commitment_Value__c> lstCommitmentValues = [SELECT Id,
		                                                 commitment_product_name__c,
		                                                 commitment_unit_type__c,
		                                                 web_product_code__c,
		                                                 commitment_expiry_days_number__c,
		                                                 commitment_stay_days_number__c,
		                                                 CurrencyIsoCode,
		                                                 quote_type__c,
		                                                 commitment_id__c
		                                                 FROM Commitment_Value__c
		                                                 WHERE quote_type__c = :quoteType AND pricing_model_id__c = :pricingModel
		                                                                                                            ORDER BY commitment_product_name__c];
		mapReturn.put('lstCommitments', lstCommitmentValues);
		Set<String> setApiName = new Set<String>();
		setApiName.add('opp_solution_commitment_amount__c');
		setApiName.add('opp_soln_comt_expiry_days_number__c');
		setApiName.add('opp_solution_comt_product_name__c');
		setApiName.add('opp_solution_commitment_number__c');
		setApiName.add('CurrencyIsoCode');
		mapReturn.put('schemaSetup', FieldForm_ctrl.getInfoSchema(setApiName, 'Opportunity_Solution_Commitment__c'));
		return mapReturn;
	}

	/*
     * Method used to get commitments
	*/
    @AuraEnabled
	public static Map<String, Object> getInfoTable(String recordId) {
		Map<String, Object> mapReturn = new Map<String, Object>();
        List<Opportunity_Solution_Commitment__c> lstCommitments = [SELECT Id,
                                                                   opp_solution_commitment_amount__c,
                                                                   opp_soln_comt_expiry_days_number__c,
                                                                   opp_soln_comt_stay_days_number__c,
                                                                   opp_solution_comt_product_name__c,
                                                                   opp_solution_commitment_number__c,
                                                                   CurrencyIsoCode
                                                                   FROM Opportunity_Solution_Commitment__c
                                                                   WHERE opportunity_id__c = :recordId];
        for(Opportunity_Solution_Commitment__c oppSolComm : lstCommitments) {
			if(oppSolComm.opp_solution_commitment_amount__c == null) {
				oppSolComm.CurrencyIsoCode = '';
			}
		}
		mapReturn.put('lstCommitments', lstCommitments);
		Set<String> setApiName = new Set<String>();
		setApiName.add('opp_solution_commitment_amount__c');
		setApiName.add('opp_soln_comt_expiry_days_number__c');
		setApiName.add('opp_solution_comt_product_name__c');
		setApiName.add('opp_solution_commitment_number__c');
		setApiName.add('CurrencyIsoCode');
		mapReturn.put('schemaSetup', FieldForm_ctrl.getInfoSchema(setApiName, 'Opportunity_Solution_Commitment__c'));
		return mapReturn;
	}

	/*
	 * Method used to save compromises
	 */
	@AuraEnabled
	public static Map<String, Object> saveCommitment(String recordId, List<Object> lstData, String oppLineItem, String unitType) {
		Map<String,Object> mapReturn = new Map<String,Object>();
        Opportunity_Solution_Commitment__c oppSolCommitment = new Opportunity_Solution_Commitment__c();
        if(lstData[4]==null) {
            oppSolCommitment.opp_solution_comt_product_name__c = String.valueOf(lstData[0]);
            oppSolCommitment.CurrencyIsoCode = String.valueOf(lstData[1]);
            oppSolCommitment.opp_soln_comt_expiry_days_number__c = Double.valueOf(lstData[2]);
            oppSolCommitment.opp_solution_commitment_id__c = String.valueOf(lstData[5]);
            oppSolCommitment.price_quotation_method__c = String.valueOf(lstData[6]);
        } else {
            oppSolCommitment.Id = String.valueOf(lstData[4]);
        }
        if(unitType==STRAMOUNT) {
            oppSolCommitment.opp_solution_commitment_amount__c = Double.valueOf(lstData[3]);
        } else {
            oppSolCommitment.opp_solution_commitment_number__c = Double.valueOf(lstData[3]);
        }
        oppSolCommitment.opportunity_id__c = recordId;
        oppSolCommitment.opp_solution_id__c = oppLineItem;
        upsert oppSolCommitment;
        mapReturn.put(STRISOK, true);
        return mapReturn;
	}

	/*
     * Method used to delete compromises
	*/
    @AuraEnabled
	public static Map<String, Object> deleteCommitment(String recordId) {
		Map<String, Object> mapReturn = new Map<String, Object>();
		Opportunity_Solution_Commitment__c oppSolCommitment = new Opportunity_Solution_Commitment__c();
		oppSolCommitment.Id = recordId;
		delete oppSolCommitment;
		mapReturn.put(STRISOK, true);
		return mapReturn;
	}
    
    /*
     * Method used to create commitment
	*/
 	@AuraEnabled
    public static Map<String,Object> changeCommitment(String recordId, List<Object> lstData, String oppLineItem) {
        Map<String,Object> mapReturn = new Map<String,Object>();
        final Opportunity_Solution_Commitment__c oppSolCommitment = new Opportunity_Solution_Commitment__c();
        oppSolCommitment.opp_solution_commitment_id__c = String.valueOf(lstData[0]);
        oppSolCommitment.opp_solution_comt_product_name__c = String.valueOf(lstData[1]);
        oppSolCommitment.CurrencyIsoCode = String.valueOf(lstData[2]);
        oppSolCommitment.opp_solution_commitment_amount__c = Double.valueOf(lstData[3]);
        oppSolCommitment.opp_soln_comt_expiry_days_number__c = Double.valueOf(lstData[4]);
        oppSolCommitment.price_quotation_method__c = 'Web';
        oppSolCommitment.opportunity_id__c = recordId;
        oppSolCommitment.opp_solution_id__c = oppLineItem;
        insert oppSolCommitment;
        mapReturn.put(STRISOK, true);
        return mapReturn;
    }
    
    /*
     * Method used to call AnalyzeRate webservice
	*/
 	@AuraEnabled
    public static Map<String,Object> infoAnalyzeRate(String idOli, String tea) {
        Map<String,Object> mapReturn = new Map<String,Object>();
		OpportunityLineItem oli = [SELECT Id, hasCommissions__c From OpportunityLineItem WHERE Id = :idOli];
        mapReturn = BE_AnalyzeRate_ctrl.getInfoRORC(idOli, tea, '', oli.hasCommissions__c);
        mapReturn.put(STRISOK, true);
        return mapReturn;
    }

	/*
     * Method used to call Quotation webservice
	*/
    @AuraEnabled
	public static Map<String, Object> requestQuote(String recordId) {
		Map<String, Object> mapReturn = new Map<String, Object>();
		mapReturn.put('nextCallout', false);
		// Retrieve the opportunity product conditions, price calculation rates information and price quotation request information
		List<OpportunityLineItem> oliList = [SELECT price_quote_id__c, price_quote_owner_id__c, proposed_apr_per__c, price_rates_calculation_Id__c, gipr_Garantia__c
		                                     FROM OpportunityLineItem WHERE OpportunityId = :recordId];
		if(!oliList.isEmpty()) {
			// Check if there is already a price quotation request for the oportunity
			if(oliList[0].price_quote_id__c != '' && oliList[0].price_quote_id__c != null) {
				// Check if the context user is the same user that owns the price quotation request
				if(oliList[0].price_quote_owner_id__c == UserInfo.getUserId()) {
					// Invoke web service to request quotation approval
					mapReturn = BE_Quotation_Rest.invokeApprovalQuo(recordId);
					createQuotationCommitments(recordId);
				} else {
					// Invoke web service to recover quotation
					mapReturn = BE_Quotation_Rest.invokeRecoverQuo(recordId);
					mapReturn.put('nextCallout', true);
				}
			} else {
				// Invoke web service to create quotation
				mapReturn = BE_Quotation_Rest.invokeCreateQuo(recordId);
				createQuotationCommitments(recordId);
			}
		}
        return mapReturn;
	}

	/*
     * Method used to prepare call create Commitment webservice
	*/
    public static void createQuotationCommitments(String recordId) {
		List<Opportunity_Solution_Commitment__c> lstCommitments = [SELECT Id,
		                                                           opp_solution_id__c
		                                                           FROM Opportunity_Solution_Commitment__c
		                                                           WHERE opportunity_id__c = :recordId];
		if(!lstCommitments.isEmpty()) {
			for(Opportunity_Solution_Commitment__c osc : lstCommitments) {
				requestQuotationCommitments(osc.Id, osc.opp_solution_id__c);
			}
		}
	}

	/*
     * Method used to call Commitment webservice
	*/
    @future(callout = true)
	public static void requestQuotationCommitments(String commitmentRecordId, String strOliId) {
		Opportunity_Solution_Commitment__c commitmentRecord = new Opportunity_Solution_Commitment__c();
		List<OpportunityLineItem> lstOli = [SELECT Id,
		                                    price_quote_id__c
		                                    FROM OpportunityLineItem
		                                    WHERE Id = :strOliId];
		commitmentRecord.Id = commitmentRecordId;
		commitmentRecord.price_quotation_id__c = (!lstOli.isEmpty() ? lstOli[0].price_quote_id__c : '');
		try {
			CreateQuotationCommitment_helper createQCom = new CreateQuotationCommitment_helper(commitmentRecord.Id);
			HttpResponse createRequestResponse = createQCom.invoke();
			if(createRequestResponse.getStatusCode() == 200) {
				commitmentRecord.added_to_price_quotation__c = true;
			} else {
				commitmentRecord.added_to_price_quotation__c = false;
			}
		} catch(Exception e) {
			commitmentRecord.added_to_price_quotation__c = false;
		}
		update commitmentRecord;
	}
}
