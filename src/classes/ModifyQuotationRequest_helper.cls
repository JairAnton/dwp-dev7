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
	public ModifyQuotationRequest_Wrapper inputDataMapping;
	public ModifyQuotationRequest_helper(String oppRecordId, String phaseId, Decimal proposed, String param01, String userCode) {
		List<OpportunityLineItem> lstOli = [SELECT Id, proposed_apr_per__c, price_quote_id__c, price_operation_id__c, Price_rates_create_analyze_Id__c, Opportunity.Loss_Reason__c,
		                                    Opportunity.rejection_winner_entity_name__c, Opportunity.frm_ContractNumber__c, PE_List_Product_mode__c
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

		interestRates.effectiveRates = lstEffectiveRates;
		mapInterestRates.put('interestRates', interestRates);
		mapInterestRates.put('comment', comment);

		String jsonSubstr = parse(mapInterestRates);
		jsonSubstr = jsonSubstr.removeEnd('}');
		jsonSubstr = jsonSubstr.removeStart('{');

		mwrap.jsonStructure = jsonSubstr;
		return mwrap;
	}

	public static ModifyQuotationRequest_Wrapper generateJson02(String phaseId) {
		ModifyQuotationRequest_Wrapper mwrap = new ModifyQuotationRequest_Wrapper();
		mwrap.phaseId = phaseId;
		mwrap.jsonStructure = '';
		return mwrap;
	}

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

		Request_rate rate = new Request_rate();
		//rate.id = lstOli[0].price_rates_calculation_Id__c;
		rate.id = lstOli[0].Price_rates_create_analyze_Id__c;

		interestRates.effectiveRates = lstEffectiveRates;
		mapInterestRates.put('interestRates', interestRates);
		mapInterestRates.put('rate', rate);
		mapInterestRates.put('comment', comment);

		String jsonSubstr = parse(mapInterestRates);
		jsonSubstr = jsonSubstr.removeEnd('}');
		jsonSubstr = jsonSubstr.removeStart('{');

		mwrap.jsonStructure = jsonSubstr;
		return mwrap;
	}

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

	public static ModifyQuotationRequest_Wrapper generateJson05(List<OpportunityLineItem> lstOli, String phaseId, String comment, String ContractNumber) {
		ModifyQuotationRequest_Wrapper mwrap = new ModifyQuotationRequest_Wrapper();
		mwrap.phaseId = phaseId;

		Request_disbursement disbursement = new Request_disbursement();
		Request_relatedContract relatedContract = new Request_relatedContract();
		relatedContract.numberId = (ContractNumber == null ? (lstOli[0].Opportunity.frm_ContractNumber__c == null ? '' : (lstOli[0].Opportunity.frm_ContractNumber__c).replaceAll('-', '')) : ContractNumber.replaceAll('-', ''));
		disbursement.relatedContract = relatedContract;

		Map<String, Object> mapInterestRates = new Map<String, Object>();
		mapInterestRates.put('comment', comment);
		mapInterestRates.put('disbursement', disbursement);
		mapInterestRates.put('relatedContract', relatedContract);

		String jsonSubstr = parse(mapInterestRates);
		jsonSubstr = jsonSubstr.removeEnd('}');
		jsonSubstr = jsonSubstr.removeStart('{');

		mwrap.jsonStructure = jsonSubstr;
		return mwrap;
	}

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

	public static String parse(Object obj_wrapper) {
		String strJson = JSON.serialize(obj_wrapper);
		strJson = strJson.replace('"numberId":', '"number":');
		return strJson;
	}

	public class ModifyQuotationRequest_Wrapper {
		public String phaseId;
		public String jsonStructure;
		public String quotationId;
		public String operationId;
		public String userCode;
	}

	public class Request_rate {
		public String id;   //price_rates_calculation_Id__c
	}

	public class Request_interestRates {
		public Request_effectiveRates[] effectiveRates;
	}

	public class Request_effectiveRates {
		public String id;   //REQUESTED_TEA
		public Decimal percentage;  //proposed_apr_per__c
	}

	public class Request_causeLoss {
		public Integer id;  //1
		public Request_chosenBank chosenBank;
	}

	public class Request_chosenBank {
		public Integer id;  //1
		public Request_effectiveRate effectiveRate;
	}

	public class Request_effectiveRate {
		public String id;   //TEA_BMK
		public Decimal percentage;  //proposed_apr_per__c
	}

	public class Request_disbursement {
		public Request_relatedContract relatedContract;
	}

	public class Request_relatedContract {
		public String numberId; //
	}

	public class Request_businessAgent_reasign {
		public String id;   //P012170
	}

	public static ResponseModifyQuotationRequest_Wrapper responseParse(String json) {
		return (ResponseModifyQuotationRequest_Wrapper) System.JSON.deserialize(json, ResponseModifyQuotationRequest_Wrapper.class);
	}

	//Wrapper class to the response
	public class ResponseModifyQuotationRequest_Wrapper {
		public Response_data data;
	}

	public class Response_data {
		public Response_status status;
		public String id;   //1469800
		public String version;  //1
		public Response_businessAgents[] businessAgents;
		public Response_disbursement disbursement;
	}

	public class Response_status {
		public String id;   //PENDING
		public String description;  //PENDIENTE
	}

	public class Response_businessAgents {
		public String id;   //P012170
		public String firstName;    //CECILIA
		public String lastName; //AGUIRRE
		public String secondLastName;   //GONZALES
		public Response_workTeam workTeam;
		public Response_classification classification;
	}

	public class Response_workTeam {
		public String id;   //EJE_BEC
		public String name; //Ejecutivo BEC
	}

	public class Response_classification {
		public Response_involvements[] involvements;
	}

	public class Response_involvements {
		public Response_involvementType involvementType;
	}

	public class Response_involvementType {
		public String id;   //ASSIGNED
		public String description;  //Usuario asignado a la cotización
	}
    
	public class Response_disbursement {
		public Response_status status;
	}

	private static String getContextUserCode() {
		List<User> lstUser = [SELECT Id, user_id__c FROM User WHERE Id = :UserInfo.getUserId()];
		return (lstUser[0].user_id__c == null || lstUser[0].user_id__c == '' ? '' : lstUser[0].user_id__c);
	}
}