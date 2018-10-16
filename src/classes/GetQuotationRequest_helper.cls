public class GetQuotationRequest_helper {

    public GetQuotationRequest_Wrapper inputDataMapping;

    // Method use to get input information
    public GetQuotationRequest_helper(String oppRecordId){
        
        List<OpportunityLineItem> oppLineItemList = [SELECT price_quote_id__c FROM OpportunityLineItem WHERE OpportunityId = :oppRecordId];
        
        if(!oppLineItemList.isEmpty()){
            // Map the input values with the input attributes of the webservice 
            GetQuotationRequest_Wrapper requestWrapper = new GetQuotationRequest_Wrapper(oppLineItemList[0].price_quote_id__c);
			this.inputDataMapping = requestWrapper;
        }
        
    }
    
    //Wrapper class to map the input values with the input attributes of the webservice 
    public class GetQuotationRequest_Wrapper{
        public String quotationId;
        
        public GetQuotationRequest_Wrapper(String quotationId){
            this.quotationId = (quotationId!=null?quotationId:'');
        }
    }
    
    //method to convert the input data mapping to a JSON structure
    public String generateJSONRequest(){
        return JSON.serialize(this.inputDataMapping);
    }
    
    // Method to invoke the webservice
    public System.HttpResponse invoke(){
        return iaso.GBL_Integration_GenericService.invoke('GetQuotationRequest',generateJSONRequest());
    }
    
    /*********************************************************************************************************
     * Wrapper classes to process the ws response
     ********************************************************************************************************/
    public class ResponseGetQuotationRequest_Wrapper{

		public Response_Data data;
	}
	
	public class Response_Data {
		public String id;
		public Response_Status status;
		public Response_Participant participant;
		public Response_Quotations[] quotations;
	}
	public class Response_status {
		public String id;
		public String description;
	}
	public class Response_participant {
		public String id;
		public Response_IdentityDocuments[] identityDocuments;
		public Response_Situation situation;
		public Integer totalDaysAsCustomer;
		public Response_Bank bank;
		public Response_Segment segment;
		public Response_Bureau bureau;
		public Integer totalBanks;
		public Response_Delinquency delinquency;
		public String riskTag;
		public Response_GrossMargin grossMargin;
		public Integer propensityLevel;
		public Integer relatedFamilies;
		public String membershipDate;
		public Response_Detail detail;
		public Response_Taxpayer taxpayer;
	}
	public class Response_IdentityDocuments {
		public Response_DocumentType documentType;
		public String documentNumber;
	}
	public class Response_DocumentType {
		public String id;
	}
	public class Response_Situation {
		public String id;
	}
	public class Response_Bank {
		public Response_branch branch;
	}
	public class Response_Branch {
		public String id;
		public String name;
	}
	public class Response_Segment {
		public Response_SubSegment subSegment;
		public String id;
		public String name;
	}
	public class Response_SubSegment {
		public String id;
		public String name;
		public Response_Partitions[] partitions;
	}
	public class Response_Partitions {
		public String id;
		public String value;
	}
	public class Response_Bureau {
		public Double score;
		public String id;
	}
	public class Response_Delinquency {
		public Integer maxOverdueDays;
	}
	public class Response_GrossMargin {
		public String percentage;
	}
	public class Response_Detail {
		public Double percentage;
	}
	public class Response_BankingData {
		public Response_Classification classification;
		public Response_AdjustedBanking adjustedBanking;
		public String id;
		public String name;
	}
	public class Response_Classification {
		public Response_Involvements[] involvements;
	}
	public class Response_AdjustedBanking {
		public String id;
		public String name;
	}
	public class Response_FinancialGroup {
		public String id;
	}
	public class Response_RiskAssessment {
		public String tag;
	}
	public class Response_FinancialStatement {
		public String tag;
	}
	public class Response_Liabilities {
		public String id;
		public Integer amount;
		public String currency_code;
	}
	public class Response_Transactionalflows {
		public Response_Collections[] collections;
		public Response_Payments[] payments;
	}
	public class Response_Collections {
		public String amount;
		public String currency_code;
	}
	public class Response_Payments {
		public String amount;
		public String currency_code;
	}
	public class Response_Taxpayer {
		public Response_TaxpayerType taxpayerType;
	}
	public class Response_TaxpayerType {
		public String id;
	}
	public class Response_Quotations {
		public Response_Status status;
		public String validityDate;
		public String id;
		public String version;
		public Response_InterestRates interestRates;
		public String comment;
		public Response_Product product;
		public Response_BusinessAgents[] businessAgents;
		public Response_Bank bank;
		public Response_Disbursement disbursement;
		public Response_ProfitabilityIndicators[] profitabilityIndicators;
		public Response_LiquidityIndicators[] liquidityIndicators;
		public Response_Fees[] fees;
		public Response_Model model;
		public String creationDate;
		public Response_FinancialIndicators[] financialIndicators;
	}
	public class Response_InterestRates {
		public Response_EffectiveRates[] effectiveRates;
	}
	public class Response_EffectiveRates {
		public String id;
		public Double percentage;
	}
	public class Response_Product {
		public String id;
		public Response_RequestedAmount requestedAmount;
		public String name;
		public Response_Guarantee guarantee;
		public Response_ContractingModality contractingModality;
		public Response_Term term;
	}
	public class Response_RequestedAmount {
		public String amount;
		public String currency_code;
	}
	public class Response_Guarantee {
		public Integer coverage;
		public Response_Classification classification;
	}
	public class Response_ContractingModality {
		public String id;
		public String name;
	}
	public class Response_Term {
		public Response_Frequency frequency;
		public Integer termNumber;
	}
	public class Response_Frequency {
		public String id;
		public String name;
	}
	public class Response_BusinessAgents {
		public Response_Position position;
		public String id;
		public String firstName;
		public String lastName;
		public String secondLastName;
		public Response_WorkTeam workTeam;
		public Response_Classification classification;
	}
	public class Response_Position {
		public String id;
		public String name;
	}
	public class Response_WorkTeam {
		public String id;
		public String name;
	}
	public class Response_Involvements {
		public Response_InvolvementType involvementType;
	}
	public class Response_InvolvementType {
		public String id;
		public String description;
	}
	public class Response_Disbursement {
		public Response_Status status;
	}
	public class Response_ProfitabilityIndicators {
		public String id;
		public Double percentage;
	}
	public class Response_LiquidityIndicators {
		public String id;
		public Response_Detail detail;
	}
	public class Response_Fees {
		public Response_FeeType feeType;
		public Response_Detail detail;
	}
	public class Response_FeeType {
		public String id;
	}
	public class Response_Model {
		public String id;
	}
	public class Response_FinancialIndicators {
		public String id;
		public String value;
	}
	public static ResponseGetQuotationRequest_Wrapper parse(String json){
        json = json.replace('"currency":','"currency_code":');
		return (ResponseGetQuotationRequest_Wrapper) System.JSON.deserialize(json, ResponseGetQuotationRequest_Wrapper.class);
	}
}