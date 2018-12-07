public without sharing class PriceRate_helper {
    
    public RequestPriceRate_Wrapper inputDataMapping;
    public Boolean isSimulate;
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
        public String participantId;
        public String participantDocumentNumber;
        public String amount;
        public String termId;
        public String termNumber;
        public String guaranteeId;
        public String branch;
        public String contractingModality;
        public String currencyCode;
        public String productId;
        public String guaranteeCoverage;
        
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
        final String v_json = json.replace('"currency":', '"currency_type":'); //Yulino 06/12/2018 : Se agrego la variable local       
        return (ResponseSimulateRate_Wrapper) System.JSON.deserialize(v_json, ResponseSimulateRate_Wrapper.class); //Yulino 06/12/2018 : Se modificó de json a v_json
    }
    //Wrapper class to the response
    public class ResponseSimulateRate_Wrapper{
        public Response_data data;
    }
    
    public class Response_data{
        public Response_CalculationType calculationType;
        public Response_CalculationType model;
        public Response_BusinessAgent businessAgent;
        public Response_Participant participant;
        public Response_Product product;
        public Response_Summary[] summary;
    }
    public class Response_BusinessAgent {
    }
    public class Response_Product {
        public Response_BusinessAgent requestedAmount;
        public Response_BusinessAgent term;
        public Response_BusinessAgent guarantee;
    }
    public class Response_Fees {
        public Response_CalculationType feeType;
        public Response_Detail detail;
    }
    
    public class Response_Segment {
        public Response_SubSegment subSegment;
    }
    
    public class Response_IdentityDocuments {
        public Response_BusinessAgent documentType;
    }
    
    public class Response_FinancialIndicators {
        public String id;
        public String value;
    }
    
    public class Response_Participant {
        public Response_IdentityDocuments[] identityDocuments;
        public Response_BusinessAgent bank;
        public Response_Segment segment;
        public Response_Delinquency delinquency;
        public Response_BusinessAgent[] strategicRelationships;
        public Response_BusinessAgent[] riskLevel;
    }
    
    public class Response_CalculationType {
        public String id;
    }
    
    public class Response_SubSegment {
        public Response_BusinessAgent[] partitions;
    }
    
    public class Response_LiquidityIndicators {
        public String id;
        public Response_Detail detail;
        
    }
    
    public class Response_Summary {
        public String calculationId;
        public Response_FinancialIndicators[] financialIndicators;
        public Response_InterestRates interestRates;
        public Response_Fees[] fees;
        public Response_LiquidityIndicators[] liquidityIndicators;
    }
    public class Response_InterestRates {
        public Response_EffectiveRates[] effectiveRates;
    }
    public class Response_EffectiveRates {
        public String id;
        public Double percentage;
    }
    public class Response_Delinquency {
        public Response_BehaviorDebts behaviorDebts;
    }
    public class Response_BehaviorDebts {
        public Response_BusinessAgent[] tacticalVariable;
    }
    public class Response_Detail {
        public Double percentage;
        public Double amount;
        public String currency_type;
    }
}