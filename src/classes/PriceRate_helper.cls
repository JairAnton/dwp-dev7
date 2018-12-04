public without sharing class PriceRate_helper {
    
    public RequestPriceRate_Wrapper inputDataMapping{ get; set; } //Ernesto 04/12/2018 : se agregó el get y set
    public Boolean isSimulate{ get; set; } //Ernesto 04/12/2018 : se agregó el get y set
    //method use to get input information
    public PriceRate_helper(String oppRecordId, Boolean isSimulate){
        this.isSimulate = isSimulate;
        String branchcode = '';
        List<Opportunity> lstOpp = [SELECT 	Account.main_code_id__c, 
                                    Account.AccountNumber, 
                                    Branch_id__r.branch_id__c, 
                                    (SELECT 	Id, 
                                     unitprice, 
                                     Product2.price_approval_web_service_id__c, 
                                     gipr_Plazo__c, 
                                     gipr_Periodicidad__c, 
                                     gipr_Tipo_Garantia__c,
                                     gipr_Cobertura__c,
                                     pricing_model_id__c,
                                     PE_List_Product_mode__c,
                                     CurrencyIsoCode
                                     FROM OpportunityLineItems) 
                                    FROM Opportunity  WHERE Id = :oppRecordId];
        
        if(!lstOpp.isEmpty()){
            //Map with values
            Map<String,Web_Service_Value_Mapping__c> mapWsVal = WebServiceUtils.getWebServiceValuesMapping(new List<String>{'TERM_PERIOCITY','GUARANTEE_CLASSIFICATION', 'CONTRACT_MODALITY'}, lstOpp[0].OpportunityLineItems[0].pricing_model_id__c);
            //map the input values with the input attributes of the webservice
            if(lstOpp[0].Branch_id__r.branch_id__c!=null){
                branchcode =+ String.valueOf(lstOpp[0].Branch_id__r.branch_id__c).right(4);
            }
            RequestPriceRate_Wrapper requestWrapper = new RequestPriceRate_Wrapper(
                lstOpp[0].Account.main_code_id__c, 
                lstOpp[0].Account.AccountNumber, 
                String.valueOf(lstOpp[0].OpportunityLineItems[0].unitprice), 
                (mapWsVal.get('TERM_PERIOCITY' + String.valueOf(lstOpp[0].OpportunityLineItems[0].gipr_Periodicidad__c)) != null ? mapWsVal.get('TERM_PERIOCITY' + String.valueOf(lstOpp[0].OpportunityLineItems[0].gipr_Periodicidad__c)).web_service_value__c : null),
                String.valueOf(lstOpp[0].OpportunityLineItems[0].gipr_Plazo__c),
                (mapWsVal.get('GUARANTEE_CLASSIFICATION' + String.valueOf(lstOpp[0].OpportunityLineItems[0].gipr_Tipo_Garantia__c))!=null? mapWsVal.get('GUARANTEE_CLASSIFICATION' + String.valueOf(lstOpp[0].OpportunityLineItems[0].gipr_Tipo_Garantia__c)).web_service_value__c : null), 
                branchcode,
                (mapWsVal.get('CONTRACT_MODALITY' + String.valueOf(lstOpp[0].OpportunityLineItems[0].PE_List_Product_mode__c))!=null? mapWsVal.get('CONTRACT_MODALITY' + String.valueOf(lstOpp[0].OpportunityLineItems[0].PE_List_Product_mode__c)).web_service_value__c : null), 
                lstOpp[0].OpportunityLineItems[0].CurrencyIsoCode,
                String.valueOf(lstOpp[0].OpportunityLineItems[0].Product2.price_approval_web_service_id__c),
                (lstOpp[0].OpportunityLineItems[0].gipr_Cobertura__c==null?'':String.valueOf((lstOpp[0].OpportunityLineItems[0].gipr_Cobertura__c) / 100) ) );
            this.inputDataMapping = requestWrapper;
        }
    }
    
    //method to convert the input data mapping to a JSON structure
    public String generateJSONRequest(){
        return JSON.serialize(this.inputDataMapping);
    }
    
    //method to invoke the webservice 
    public System.HttpResponse invoke(){
        return iaso.GBL_Integration_GenericService.invoke((isSimulate?'SimulateRate':'CalculateRate'),generateJSONRequest());
    }
    
    
    //Wrapper class to map the input values with the input attributes of the webservice 
    public class RequestPriceRate_Wrapper{
        public String participantId{ get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public String participantDocumentNumber{ get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public String amount{ get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public String termId{ get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public String termNumber{ get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public String guaranteeId{ get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public String branch{ get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public String contractingModality{ get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public String currencyCode{ get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public String productId{ get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public String guaranteeCoverage{ get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        
        public RequestPriceRate_Wrapper(String participantId, String participantDocumentNumber, String amount, String termId, String termNumber, String guaranteeId, String branch, String contractingModality, String currencyCode, String productId, String guaranteeCoverage){
            
            this.participantId = (participantId!=null?participantId:'');
            this.participantDocumentNumber = (participantDocumentNumber!=null?participantDocumentNumber:'');
            this.amount = (amount!=null?amount:'');
            this.termId = (termId!=null?termId:'');
            this.termNumber = (termNumber!=null?termNumber:'');
            this.guaranteeId = (guaranteeId!=null?guaranteeId:'');
            this.branch = (branch!=null?branch:'');
            this.contractingModality = (contractingModality!=null?contractingModality:'');
            this.currencyCode = (currencyCode!=null?currencyCode:'');
            this.productId = (productId!=null?productId:'');
            this.guaranteeCoverage = (guaranteeCoverage!=null?', "coverage":"' + guaranteeCoverage + '"':'');
        }
    }
    
    public ResponseSimulateRate_Wrapper parse(String json){
        json = json.replace('"currency":', '"currency_type":');        
        return (ResponseSimulateRate_Wrapper) System.JSON.deserialize(json, ResponseSimulateRate_Wrapper.class);
    }
    //Wrapper class to the response
    public class ResponseSimulateRate_Wrapper{
        public Response_data data { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
    }
    
    public class Response_data{
        public Response_CalculationType calculationType { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public Response_CalculationType model { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public Response_BusinessAgent businessAgent { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public Response_Participant participant { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public Response_Product product { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public Response_Summary[] summary { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
    }
    public class Response_BusinessAgent {
    }
    public class Response_Product {
        public Response_BusinessAgent requestedAmount { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public Response_BusinessAgent term { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public Response_BusinessAgent guarantee { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
    }
    public class Response_Fees {
        public Response_CalculationType feeType { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public Response_Detail detail { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
    }
    
    public class Response_Segment {
        public Response_SubSegment subSegment { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
    }
    
    public class Response_IdentityDocuments {
        public Response_BusinessAgent documentType { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
    }
    
    public class Response_FinancialIndicators {
        public String id { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public String value { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
    }
    
    public class Response_Participant {
        public Response_IdentityDocuments[] identityDocuments { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public Response_BusinessAgent bank { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public Response_Segment segment { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public Response_Delinquency delinquency { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public Response_BusinessAgent[] strategicRelationships { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public Response_BusinessAgent[] riskLevel { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
    }
    
    public class Response_CalculationType {
        public String id { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
    }
    
    public class Response_SubSegment {
        public Response_BusinessAgent[] partitions { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
    }
    
    public class Response_LiquidityIndicators {
        public String id { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public Response_Detail detail { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        
    }
    
    public class Response_Summary {
        public String calculationId { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public Response_FinancialIndicators[] financialIndicators { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public Response_InterestRates interestRates { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public Response_Fees[] fees { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public Response_LiquidityIndicators[] liquidityIndicators { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
    }
    public class Response_InterestRates {
        public Response_EffectiveRates[] effectiveRates { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
    }
    public class Response_EffectiveRates {
        public String id { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public Double percentage { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
    }
    public class Response_Delinquency {
        public Response_BehaviorDebts behaviorDebts { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
    }
    public class Response_BehaviorDebts {
        public Response_BusinessAgent[] tacticalVariable { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
    }
    public class Response_Detail {
        public Double percentage { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public Double amount { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public String currency_type { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
    }
}