/**
 * @author Global_HUB developers
 * @date 01-08-2018
 *
 * @group Global_HUB
 *
 * @description Controller class from SanctionPriceDecision_ctrl
 * @Changes
 *  Date        Author   Email                  			Type		Description
 *  2020-11-06  MAMC     martin.mori.contractor@bbva.com	Modify		add method to create quote pdf
 **/
public class ModifyQuotationRequest_helper {
	/** Field */
	public ModifyQuotationRequest_Wrapper inputDataMapping;
	
	/** method */
	public ModifyQuotationRequest_helper(String oppRecordId, String phaseId, Decimal proposed, String param01, String userCode) {
		Final List<OpportunityLineItem> lstOli = [SELECT Id, proposed_apr_per__c, price_quote_id__c, price_operation_id__c, Price_rates_create_analyze_Id__c, Opportunity.Loss_Reason__c,
		                                    Opportunity.rejection_winner_entity_name__c, Opportunity.frm_ContractNumber__c, PE_List_Product_mode__c, price_rates_calculation_Id__c
		                                    FROM OpportunityLineItem WHERE OpportunityId = :oppRecordId];
		if(!lstOli.isEmpty()) {
			switch on phaseId {
				when 'RECOVER' {
					this.inputDataMapping = generateJson02(phaseId);
				} when 'GENERATE_QUOTATION_SHEET' {
					this.inputDataMapping = generateJson01(lstOli, phaseId, 'FINAL_TEA', Label.PriceGenerateQuotationSheetDefaultComment, proposed);
				} when 'RETURN' {
					this.inputDataMapping = generateJson01(lstOli, phaseId, 'AGREED_TEA', Label.PriceReturnQuotationDefaultComment, proposed);
				} when 'APPROVE' {
					this.inputDataMapping = generateJson01(lstOli, phaseId, 'APPROVED_TEA', Label.PriceApproveDefaultComment, proposed);
				} when 'RAISE' {
					this.inputDataMapping = generateJson01(lstOli, phaseId, 'AGREED_TEA', Label.PriceRaiseQuotationDefaultComment, proposed);
				} when 'REASSIGN' {
					this.inputDataMapping = generateJson06(phaseId, userCode);
				} when 'REQUEST_APPROVAL' {
					this.inputDataMapping = generateJson03(lstOli, phaseId, 'REQUESTED_TEA', Label.PriceRequestApprovalQuotationDefaultComment, proposed);
				} when 'REGISTER_LOSS' {
					this.inputDataMapping = generateJson04(lstOli, phaseId, 'TEA_BMK', Label.PriceRegisterQuotationLossDefaultComment, proposed, param01);
				} when 'DISBURSE' {
					this.inputDataMapping = generateJson05(lstOli, phaseId, Label.PriceDisburseQuotationDefaultComment, param01);
				} when else {
					this.inputDataMapping = new ModifyQuotationRequest_Wrapper();
				}
			}
			if(this.inputDataMapping.jsonStructure != '' && this.inputDataMapping.jsonStructure != null) {
				this.inputDataMapping.jsonStructure = ', ' + this.inputDataMapping.jsonStructure;
			}
			this.inputDataMapping.quotationId = (lstOli[0].price_quote_id__c == null ? '' : lstOli[0].price_quote_id__c);
			this.inputDataMapping.operationId = (lstOli[0].price_operation_id__c == null ? '' : lstOli[0].price_operation_id__c);
			this.inputDataMapping.userCode = getContextUserCode();
		}
	}

	//method to convert the input data mapping to a JSON structure
	public String generateJSONRequest() {
		this.inputDataMapping.phaseId = (this.inputDataMapping.phaseId == null ? '' : this.inputDataMapping.phaseId);
		this.inputDataMapping.jsonStructure = (this.inputDataMapping.jsonStructure == null ? '' : this.inputDataMapping.jsonStructure);
		this.inputDataMapping.quotationId = (this.inputDataMapping.quotationId == null ? '' : this.inputDataMapping.quotationId);
		this.inputDataMapping.operationId = (this.inputDataMapping.operationId == null ? '' : this.inputDataMapping.operationId);
		this.inputDataMapping.userCode = (this.inputDataMapping.userCode == null ? '' : this.inputDataMapping.userCode);
		return JSON.serialize(this.inputDataMapping);
	}

	//method to invoke the webservice
	public System.HttpResponse invoke() {
		return iaso.GBL_Integration_GenericService.invoke('ModifyQuotationRequest', generateJSONRequest());
	}
	
	/** method */
	public static ModifyQuotationRequest_Wrapper generateJson01(List<OpportunityLineItem> lstOli, String phaseId, String rateId, String comment, Decimal proposed) {
		ModifyQuotationRequest_Wrapper mwrap = new ModifyQuotationRequest_Wrapper();
		mwrap.phaseId = phaseId;

		Map<String, Object> mapInterestRates = new Map<String, Object>();
		Request_interestRates interestRates = new Request_interestRates();
		List<Request_effectiveRates> lstEffectiveRates = new List<Request_effectiveRates>();
		Request_effectiveRates effRate = new Request_effectiveRates();
		effRate.id = rateId;
		effRate.percentage = (proposed == null ? (lstOli[0].proposed_apr_per__c == null ? null : lstOli[0].proposed_apr_per__c / 100) : proposed / 100);
		lstEffectiveRates.add(effRate);

		Final Request_alanyzeRate analyzeRate = new Request_alanyzeRate();
		analyzeRate.id = lstOli[0].Price_rates_create_analyze_Id__c;

		interestRates.effectiveRates = lstEffectiveRates;
		mapInterestRates.put('interestRates', interestRates);
		mapInterestRates.put('comment', comment);
		mapInterestRates.put('analyzeRate', analyzeRate);

		String jsonSubstr = parse(mapInterestRates);
		jsonSubstr = jsonSubstr.removeEnd('}');
		jsonSubstr = jsonSubstr.removeStart('{');

		mwrap.jsonStructure = jsonSubstr;
		return mwrap;
	}
	
	/** method */
	public static ModifyQuotationRequest_Wrapper generateJson02(String phaseId) {
		ModifyQuotationRequest_Wrapper mwrap = new ModifyQuotationRequest_Wrapper();
		mwrap.phaseId = phaseId;
		mwrap.jsonStructure = '';
		return mwrap;
	}

	/** method */
	public static ModifyQuotationRequest_Wrapper generateJson03(List<OpportunityLineItem> lstOli, String phaseId, String rateId, String comment, Decimal proposed) {
		ModifyQuotationRequest_Wrapper mwrap = new ModifyQuotationRequest_Wrapper();
		mwrap.phaseId = phaseId;

		Map<String, Object> mapInterestRates = new Map<String, Object>();
		Request_interestRates interestRates = new Request_interestRates();
		List<Request_effectiveRates> lstEffectiveRates = new List<Request_effectiveRates>();
		Request_effectiveRates effRate = new Request_effectiveRates();
		effRate.id = rateId;
		effRate.percentage = (proposed == null ? (lstOli[0].proposed_apr_per__c == null ? null : lstOli[0].proposed_apr_per__c / 100) : proposed / 100);
		lstEffectiveRates.add(effRate);

		Final Request_alanyzeRate analyzeRate = new Request_alanyzeRate();
		analyzeRate.id = lstOli[0].Price_rates_create_analyze_Id__c;

		Request_rate rate = new Request_rate();
		rate.id = lstOli[0].price_rates_calculation_Id__c;

		interestRates.effectiveRates = lstEffectiveRates;
		mapInterestRates.put('interestRates', interestRates);
		mapInterestRates.put('rate', rate);
		mapInterestRates.put('comment', comment);
		mapInterestRates.put('analyzeRate', analyzeRate);

		String jsonSubstr = parse(mapInterestRates);
		jsonSubstr = jsonSubstr.removeEnd('}');
		jsonSubstr = jsonSubstr.removeStart('{');

		mwrap.jsonStructure = jsonSubstr;
		return mwrap;
	}

	/** method */
	public static ModifyQuotationRequest_Wrapper generateJson04(List<OpportunityLineItem> lstOli, String phaseId, String rateId, String comment, Decimal proposed, String param01) {
		ModifyQuotationRequest_Wrapper mwrap = new ModifyQuotationRequest_Wrapper();
		mwrap.phaseId = phaseId;
		List<String> lstParams = param01.split(';');

		Map<String, Object> mapInterestRates = new Map<String, Object>();
		Map<String, Web_Service_Value_Mapping__c> mapWsVal = WebServiceUtils.getWebServiceValuesMapping(new List<String> {'REJECTION_REASON', 'REJECTION_WINNER_ENTITY'}, '');

		Request_causeLoss causeLoss = new Request_causeLoss();
		causeLoss.id = (mapWsVal.get('REJECTION_REASON' + String.valueOf(lstParams[0])) != null ? Integer.valueOf(mapWsVal.get('REJECTION_REASON' + String.valueOf(lstParams[0])).web_service_value__c) : null);
		Request_chosenBank chosenBank = new Request_chosenBank();
		chosenBank.Id = (mapWsVal.get('REJECTION_WINNER_ENTITY' + String.valueOf(lstParams[1])) != null ? Integer.valueOf(mapWsVal.get('REJECTION_WINNER_ENTITY' + String.valueOf(lstParams[1])).web_service_value__c) : null);
		Request_effectiveRate effectiveRate = new Request_effectiveRate();
		effectiveRate.id = rateId;
		effectiveRate.percentage = (proposed == null ? (lstOli[0].proposed_apr_per__c == null ? null : lstOli[0].proposed_apr_per__c / 100) : proposed / 100);
		chosenBank.effectiveRate = effectiveRate;
		causeLoss.chosenBank = chosenBank;

		mapInterestRates.put('causeLoss', causeLoss);
		mapInterestRates.put('comment', comment);

		String jsonSubstr = parse(mapInterestRates);
		jsonSubstr = jsonSubstr.removeEnd('}');
		jsonSubstr = jsonSubstr.removeStart('{');

		mwrap.jsonStructure = jsonSubstr;
		return mwrap;
	}

	/** method */
	public static ModifyQuotationRequest_Wrapper generateJson05(List<OpportunityLineItem> lstOli, String phaseId, String comment, String ContractNumber) {
		ModifyQuotationRequest_Wrapper mwrap = new ModifyQuotationRequest_Wrapper();
		mwrap.phaseId = phaseId;

		Request_disbursement disbursement = new Request_disbursement();
		Request_relatedContract relatedContract = new Request_relatedContract();
		relatedContract.numberId = (ContractNumber == null ? (lstOli[0].Opportunity.frm_ContractNumber__c == null ? '' : (lstOli[0].Opportunity.frm_ContractNumber__c).replaceAll('-', '')) : ContractNumber.replaceAll('-', ''));
		disbursement.relatedContract = relatedContract;
        
		Final Request_alanyzeRate analyzeRate = new Request_alanyzeRate();
		analyzeRate.id = lstOli[0].Price_rates_create_analyze_Id__c;

		Map<String, Object> mapInterestRates = new Map<String, Object>();
		mapInterestRates.put('comment', comment);
		mapInterestRates.put('disbursement', disbursement);
		mapInterestRates.put('relatedContract', relatedContract);
		mapInterestRates.put('analyzeRate', analyzeRate);

		String jsonSubstr = parse(mapInterestRates);
		jsonSubstr = jsonSubstr.removeEnd('}');
		jsonSubstr = jsonSubstr.removeStart('{');

		mwrap.jsonStructure = jsonSubstr;
		return mwrap;
	}

	/** method */
	public static ModifyQuotationRequest_Wrapper generateJson06(String phaseId, String newUserCode) {
		ModifyQuotationRequest_Wrapper mwrap = new ModifyQuotationRequest_Wrapper();
		mwrap.phaseId = phaseId;
		String jsonSubstr = '';
		if(newUserCode != null && newUserCode != '') {
			Request_businessAgent_reasign businessAg = new Request_businessAgent_reasign();
			businessAg.id = newUserCode;

			Map<String, Object> mapBusinessAgents = new Map<String, Object>();
			mapBusinessAgents.put('businessAgent', businessAg);

			jsonSubstr = parse(mapBusinessAgents);
			jsonSubstr = jsonSubstr.removeEnd('}');
			jsonSubstr = jsonSubstr.removeStart('{');
		}
		mwrap.jsonStructure = jsonSubstr;
		return mwrap;
	}

	/** method */
	public static String parse(Object obj_wrapper) {
		String strJson = JSON.serialize(obj_wrapper);
		strJson = strJson.replace('"numberId":', '"number":');
		return strJson;
	}

	/** method */
	public class ModifyQuotationRequest_Wrapper {
	
		/** field */
		public String phaseId;
		
		/** field */
		public String jsonStructure;
		
		/** field */
		public String quotationId;
		
		/** field */
		public String operationId;
		
		/** field */
		public String userCode;
	}

	/** class */
	public class Request_rate {
		/** field - price_rates_calculation_Id__c */
		public String id;
	}

	/** class */
	public class Request_interestRates {
		/** field */
		public Request_effectiveRates[] effectiveRates;
	}

	/** class */
	public class Request_effectiveRates {
		/** field - REQUESTED_TEA */
		public String id;
		
		/** field - proposed_apr_per__c*/
		public Decimal percentage;
	}

	/** class */
	public class Request_causeLoss {
		/** field - 1*/
		public Integer id;
		
		/** field */
		public Request_chosenBank chosenBank;
	}

	/** class */
	public class Request_chosenBank {
		/** field */
		public Integer id;  //1
		
			/** field */
		public Request_effectiveRate effectiveRate;
	}

	/** class */
	public class Request_effectiveRate {
		/** field */
		public String id;   //TEA_BMK
		
		/** field */
		public Decimal percentage;  //proposed_apr_per__c
	}

	/** class */
	public class Request_disbursement {
		/** field */
		public Request_relatedContract relatedContract;
	}

	/** class */
	public class Request_relatedContract {
		/** field */
		public String numberId; //
	}

	/** class */
	public class Request_businessAgent_reasign {
		/** field */
		public String id;   //P012170
	}

	/** class */
	public class Request_alanyzeRate {
		/** field */
		public String id;
	}

	/** class */
	public static ResponseModifyQuotationRequest_Wrapper responseParse(String json) {
		return (ResponseModifyQuotationRequest_Wrapper) System.JSON.deserialize(json, ResponseModifyQuotationRequest_Wrapper.class);
	}

	//Wrapper class to the response
	public class ResponseModifyQuotationRequest_Wrapper {
		/** field */
		public Response_data data;
	}

	/** class */
	public class Response_data {
		/** field */
		public Response_status status;
		
		/** field */
		public String id;   //1469800
		
		/** field */
		public String version;  //1
		
		/** field */
		public Response_businessAgents[] businessAgents;
		
		/** field */
		public Response_disbursement disbursement;
	}

	/** class */
	public class Response_status {
		/** field */
		public String id;   //PENDING
		
		/** field */
		public String description;  //PENDIENTE
	}

	/** class */
	public class Response_businessAgents {
		/** field */
		public String id;   //P012170
		
		/** field */
		public String firstName;    //CECILIA
		
		/** field */
		public String lastName; //AGUIRRE
		
		/** field */
		public String secondLastName;   //GONZALES
		
		/** field */
		public Response_workTeam workTeam;
		
		/** field */
		public Response_classification classification;
	}

	/** class */
	public class Response_workTeam {
		/** field */
		public String id;   //EJE_BEC
		
		/** field */
		public String name; //Ejecutivo BEC
	}

	/** class */
	public class Response_classification {
		/** field */
		public Response_involvements[] involvements;
	}

	/** class */
	public class Response_involvements {
		/** field */
		public Response_involvementType involvementType;
	}

	/** class */
	public class Response_involvementType {
		/** field */
		public String id;   //ASSIGNED
		
		/** field */
		public String description;  //Usuario asignado a la cotización
	}
    
	/** class */
	public class Response_disbursement {
		/** field */
		public Response_status status;
	}

	/** class */
	private static String getContextUserCode() {
		/** field */
		List<User> lstUser = [SELECT Id, user_id__c FROM User WHERE Id = :UserInfo.getUserId()];
		
		/** field */
		return (lstUser[0].user_id__c == null || lstUser[0].user_id__c == '' ? '' : lstUser[0].user_id__c);
	}
}