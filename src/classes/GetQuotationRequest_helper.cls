public without sharing class GetQuotationRequest_helper {

    public GetQuotationRequest_Wrapper inputDataMapping {get; set;} //Yulino 04/12/2018 : Se agrego {get; set;}

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
        public String quotationId {get; set;} //Yulino 04/12/2018 : Se agrego {get; set;}
        
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

		public Response_Data data {get; set;} //Yulino 04/12/2018 : Se agrego {get; set;} en los posteriores lienas
	}
	
	public class Response_Data {
		public String id {get; set;} 
		public Response_Status status {get; set;} 
		public Response_Participant participant {get; set;} 
		public Response_Quotations[] quotations {get; set;} 
	}
	public class Response_status {
		public String id {get; set;} 
		public String description {get; set;} 
	}
	public class Response_participant {
		public String id {get; set;} 
		public Response_IdentityDocuments[] identityDocuments {get; set;}
		public Response_Situation situation {get; set;}
		public Integer totalDaysAsCustomer {get; set;}
		public Response_Bank bank {get; set;}
		public Response_Segment segment {get; set;}
		public Response_Bureau bureau {get; set;}
		public Integer totalBanks {get; set;}
		public Response_Delinquency delinquency {get; set;}
		public String riskTag {get; set;}
		public Response_GrossMargin grossMargin {get; set;}
		public Integer propensityLevel {get; set;}
		public Integer relatedFamilies {get; set;}
		public String membershipDate {get; set;}
		public Response_Detail detail {get; set;}
		public Response_Taxpayer taxpayer {get; set;}
	}
	public class Response_IdentityDocuments {
		public Response_DocumentType documentType {get; set;}
		public String documentNumber {get; set;}
	}
	public class Response_DocumentType {
		public String id {get; set;}
	}
	public class Response_Situation {
		public String id {get; set;}
	}
	public class Response_Bank {
		public Response_branch branch {get; set;}
	}
	public class Response_Branch {
		public String id {get; set;}
		public String name {get; set;}
	}
	public class Response_Segment {
		public Response_SubSegment subSegment {get; set;}
		public String id {get; set;}
		public String name {get; set;}
	}
	public class Response_SubSegment {
		public String id {get; set;}
		public String name {get; set;}
		public Response_Partitions[] partitions {get; set;}
	}
	public class Response_Partitions {
		public String id {get; set;}
		public String value {get; set;}
	}
	public class Response_Bureau {
		public Double score {get; set;}
		public String id {get; set;}
	}
	public class Response_Delinquency {
		public Integer maxOverdueDays {get; set;}
	}
	public class Response_GrossMargin {
		public String percentage {get; set;}
	}
	public class Response_Detail {
		public Double percentage {get; set;}
	}
	public class Response_BankingData {
		public Response_Classification classification {get; set;}
		public Response_AdjustedBanking adjustedBanking {get; set;}
		public String id {get; set;}
		public String name {get; set;}
	}
	public class Response_Classification {
		public Response_Involvements[] involvements {get; set;}
	}
	public class Response_AdjustedBanking {
		public String id {get; set;}
		public String name {get; set;}
	}
	public class Response_FinancialGroup {
		public String id {get; set;}
	}
	public class Response_RiskAssessment {
		public String tag {get; set;}
	}
	public class Response_FinancialStatement {
		public String tag {get; set;}
	}
	public class Response_Liabilities {
		public String id {get; set;}
		public Integer amount {get; set;}
		public String currency_code {get; set;}
	}
	public class Response_Transactionalflows {
		public Response_Collections[] collections {get; set;}
		public Response_Payments[] payments {get; set;}
	}
	public class Response_Collections {
		public String amount {get; set;}
		public String currency_code {get; set;}
	}
	public class Response_Payments {
		public String amount {get; set;}
		public String currency_code {get; set;}
	}
	public class Response_Taxpayer {
		public Response_TaxpayerType taxpayerType {get; set;}
	}
	public class Response_TaxpayerType {
		public String id {get; set;}
	}
	public class Response_Quotations {
		public Response_Status status {get; set;}
		public String validityDate {get; set;}
		public String id {get; set;}
		public String version {get; set;}
		public Response_InterestRates interestRates {get; set;}
		public String comment {get; set;}
		public Response_Product product {get; set;}
		public Response_BusinessAgents[] businessAgents {get; set;}
		public Response_Bank bank {get; set;}
		public Response_Disbursement disbursement {get; set;}
		public Response_ProfitabilityIndicators[] profitabilityIndicators {get; set;}
		public Response_LiquidityIndicators[] liquidityIndicators {get; set;}
		public Response_Fees[] fees {get; set;}
		public Response_Model model {get; set;}
		public String creationDate {get; set;}
		public Response_FinancialIndicators[] financialIndicators {get; set;}
	}
	public class Response_InterestRates {
		public Response_EffectiveRates[] effectiveRates{ get; set; } //Yulino 29/11/2018 : se agregó el get y set
	}
	public class Response_EffectiveRates {
		public String id {get; set;}
		public Double percentage {get; set;}
	}
	public class Response_Product {
		public String id {get; set;}
		public Response_RequestedAmount requestedAmount {get; set;}
		public String name {get; set;}
		public Response_Guarantee guarantee {get; set;}
		public Response_ContractingModality contractingModality {get; set;}
		public Response_Term term {get; set;}
	}
	public class Response_RequestedAmount {
		public String amount {get; set;}
		public String currency_code {get; set;}
	}
	public class Response_Guarantee {
		public Decimal coverage {get; set;}
		public Response_Classification classification {get; set;}
	}
	public class Response_ContractingModality {
		public String id {get; set;}
		public String name {get; set;}
	}
	public class Response_Term {
		public Response_Frequency frequency {get; set;}
		public Integer termNumber {get; set;}
	}
	public class Response_Frequency {
		public String id {get; set;}
		public String name {get; set;}
	}
	public class Response_BusinessAgents {
		public Response_Position position {get; set;}
		public String id {get; set;}
		public String firstName {get; set;}
		public String lastName {get; set;}
		public String secondLastName {get; set;}
		public Response_WorkTeam workTeam {get; set;}
		public Response_Classification classification {get; set;}
	}
	public class Response_Position {
		public String id {get; set;}
		public String name {get; set;}
	}
	public class Response_WorkTeam {
		public String id {get; set;}
		public String name {get; set;}
	}
	public class Response_Involvements {
		public Response_InvolvementType involvementType {get; set;}
	}
	public class Response_InvolvementType {
		public String id {get; set;}
		public String description {get; set;}
	}
	public class Response_Disbursement {
		public Response_Status status {get; set;}
	}
	public class Response_ProfitabilityIndicators {
		public String id {get; set;}
		public Double percentage {get; set;}
	}
	public class Response_LiquidityIndicators {
		public String id {get; set;}
		public Response_Detail detail {get; set;}
	}
	public class Response_Fees {
		public Response_FeeType feeType {get; set;}
		public Response_Detail detail {get; set;}
	}
	public class Response_FeeType {
		public String id {get; set;}
	}
	public class Response_Model {
		public String id {get; set;}
	}
	public class Response_FinancialIndicators {
		public String id {get; set;}
		public String value {get; set;}
	}
	public static ResponseGetQuotationRequest_Wrapper parse(String json){
        json = json.replace('"currency":','"currency_code":');
		return (ResponseGetQuotationRequest_Wrapper) System.JSON.deserialize(json, ResponseGetQuotationRequest_Wrapper.class);
	}
}