/**
 * 
 * @author Jose Rodriguez Paredes
 * @date 06-11-2018 
 *
 * @group Global_HUB
 *
 * @description Wrapper class to map the input values with the input attributes of the webservice
 * @HIstorial de cambios:
	- Actualización del web service de la version v0 a la v1
	*****************************
	Modificaciones:

	Martín Alejandro Mori Chávez  04-11-2019
**/
public without sharing class PriceRate_helper {
    
    public RequestPriceRate_Wrapper inputDataMapping { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
    public Boolean isSimulate { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
    /* variable use for return webservice value*/
    static String valueMap;
    
	/**
	 * Method constructor of the class use to get input information
     * @param oppRecordId This is id of opportunity
     * @param isSimulate This is boolean indicator of call simulate service
     */
    public PriceRate_helper(String oppRecordId, Boolean isSimulate) {
        this.isSimulate = isSimulate;
        final List<Opportunity> lstOpp = [SELECT Account.main_code_id__c, Account.AccountNumber, Branch_id__r.branch_id__c, 
                                    (SELECT Id, unitprice, Product2.price_approval_web_service_id__c, gipr_Plazo__c, 
                                     gipr_Periodicidad__c, gipr_Tipo_Garantia__c, gipr_Cobertura__c, pricing_model_id__c,
                                     PE_List_Product_mode__c, CurrencyIsoCode, gipr_Garantia__c, gipr_Payment_Method__c,
                                     tcf_type_beneficiary__c, tcf_Periodicity_commission__c, tcf_type_bail_letter__c
                                     FROM OpportunityLineItems) FROM Opportunity WHERE Id = :oppRecordId];
        if(!lstOpp.isEmpty()) {
            this.inputDataMapping = setValuesMapping(lstOpp);
        }
    }
    
    /**
	 * Method to convert the input data mapping to a JSON structure
     */
    private static RequestPriceRate_Wrapper setValuesMapping(List<Opportunity> lstOpp) {
        //Map with values
        Final Map<String,Web_Service_Value_Mapping__c> mapWsVal = WebServiceUtils.getWebServiceValuesMapping(new List<String>{'TERM_PERIOCITY', 'GUARANTEE_CLASSIFICATION', 'CONTRACT_MODALITY'}, lstOpp[0].OpportunityLineItems[0].pricing_model_id__c);
        Final Map<String,Web_Service_Value_Mapping__c> mapWsValParams = WebServiceUtils.getWebServiceValuesMapping(new List<String>{'GUARANTEE_TYPE', 'PAYMENT_METHOD_CODE', 'BENEFICIARY_CODE', 'PAYMENT_PERIOD_CODE', 'BAIL_OBJECT_CODE'},'');
        //map the input values with the input attributes of the webservice
        String branchcode = '';
        if(lstOpp[0].Branch_id__r.branch_id__c!=null) {
            branchcode =+ lstOpp[0].Branch_id__r.branch_id__c.right(4);
        }
        Final List<String> ltsValues = new List<String>();
        ltsValues.add(lstOpp[0].Account.main_code_id__c);
        ltsValues.add(lstOpp[0].Account.AccountNumber);
        ltsValues.add(String.valueOf(lstOpp[0].OpportunityLineItems[0].unitprice));
        ltsValues.add(webServiceValue(mapWsVal, 'TERM_PERIOCITY' + lstOpp[0].OpportunityLineItems[0].gipr_Periodicidad__c));
        ltsValues.add(String.valueOf(lstOpp[0].OpportunityLineItems[0].gipr_Plazo__c));
        ltsValues.add(webServiceValue(mapWsVal, 'GUARANTEE_CLASSIFICATION' + lstOpp[0].OpportunityLineItems[0].gipr_Tipo_Garantia__c));
        ltsValues.add(branchcode);
        ltsValues.add(webServiceValue(mapWsVal, 'CONTRACT_MODALITY' + lstOpp[0].OpportunityLineItems[0].PE_List_Product_mode__c));
        ltsValues.add(lstOpp[0].OpportunityLineItems[0].CurrencyIsoCode);
        ltsValues.add(lstOpp[0].OpportunityLineItems[0].Product2.price_approval_web_service_id__c);
        ltsValues.add(String.valueOf((lstOpp[0].OpportunityLineItems[0].gipr_Cobertura__c == null ? 0 : lstOpp[0].OpportunityLineItems[0].gipr_Cobertura__c) / 100));
        ltsValues.add(webServiceValue(mapWsValParams, 'GUARANTEE_TYPE' + lstOpp[0].OpportunityLineItems[0].gipr_Garantia__c));
        ltsValues.add(webServiceValue(mapWsValParams, 'PAYMENT_METHOD_CODE' + lstOpp[0].OpportunityLineItems[0].gipr_Payment_Method__c));
        ltsValues.add(webServiceValue(mapWsValParams, 'BENEFICIARY_CODE' + lstOpp[0].OpportunityLineItems[0].tcf_type_beneficiary__c));
        ltsValues.add(webServiceValue(mapWsValParams, 'PAYMENT_PERIOD_CODE' + lstOpp[0].OpportunityLineItems[0].tcf_Periodicity_commission__c));
        ltsValues.add(webServiceValue(mapWsValParams, 'BAIL_OBJECT_CODE' + lstOpp[0].OpportunityLineItems[0].tcf_type_bail_letter__c));
        return new RequestPriceRate_Wrapper(ltsValues);
    }
    
    /**
	 * Method to return web service mapping
     */
    private static String webServiceValue(Map<String,Web_Service_Value_Mapping__c> mapWs, String key) {
        if(mapWs.containsKey(key)) {
            valueMap = mapWs.get(key).web_service_value__c;
        }
        return valueMap;
    }
    
    /**
	 * Method to convert the input data mapping to a JSON structure
     */
    public String generateJSONRequest() {
        return JSON.serialize(this.inputDataMapping);
    }
    
    /**
	 * Method to invoke the webservice 
     */
    public System.HttpResponse invoke() {
        return iaso.GBL_Integration_GenericService.invoke((isSimulate ? 'SimulateRate' : 'CalculateRate'), generateJSONRequest());
    }
    
    /**
     * Wrapper class to map the input values with the input attributes of the webservice
     */
    public class RequestPriceRate_Wrapper {
        /*
         * participantId is param value of request 
         */
        public String participantId { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        /*
         * participantDocumentNumber is param value of request 
         */
        public String participantDocumentNumber { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        /*
         * amount is param value of request 
         */
        public String amount { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        /*
         * termId is param value of request 
         */
        public String termId { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        /*
         * termNumber is param value of request 
         */
        public String termNumber { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        /*
         * guaranteeId is param value of request 
         */
        public String guaranteeId { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        /*
         * branch is param value of request 
         */
        public String branch { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        /*
         * contractingModality is param value of request 
         */
        public String contractingModality { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        /*
         * currencyCode is param value of request 
         */
        public String currencyCode { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        /*
         * productId is param value of request 
         */
        public String productId { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        /*
         * guaranteeCoverage is param value of request 
         */
        public String guaranteeCoverage { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        /*
         * guaranteeType is param value of request 
         */
        public String guaranteeType { get; set; }
        /*
         * paymentMethodCode is param value of request 
         */
        public String paymentMethodCode { get; set; }
        /*
         * beneficiaryCode is param value of request 
         */
        public String beneficiaryCode { get; set; }
        /*
         * paymentPeriodCode is param value of request 
         */
        public String paymentPeriodCode { get; set; }
        /*
         * bailObjectCode is param value of request 
         */
        public String bailObjectCode { get; set; }
        
        /**
     	 * Method constructor of the class
     	 * @param ltsValues This is list of string that contains input values of webservice
     	 */
        public RequestPriceRate_Wrapper(List<String> ltsValues) {
            this.participantId = resultValue(ltsValues.get(0), null);
            this.participantDocumentNumber = resultValue(ltsValues.get(1), null);
            this.amount = resultValue(ltsValues.get(2), null);
            this.termId = resultValue(ltsValues.get(3), null);
            this.termNumber = resultValue(ltsValues.get(4), null);
            this.guaranteeId = resultValue(ltsValues.get(5), null);
            this.branch = resultValue(ltsValues.get(6), null);
            this.contractingModality = resultValue(ltsValues.get(7), null);
            this.currencyCode = resultValue(ltsValues.get(8), null);
            this.productId = resultValue(ltsValues.get(9), null);
            this.guaranteeCoverage = resultValue(ltsValues.get(10), ', "coverage":"');
            this.guaranteeType = resultValue(ltsValues.get(11), null);
            this.paymentMethodCode = resultValue(ltsValues.get(12), null);
            this.beneficiaryCode = resultValue(ltsValues.get(13), null);
            this.paymentPeriodCode = resultValue(ltsValues.get(14), null);
            this.bailObjectCode = resultValue(ltsValues.get(15), null);
        }
    }
    
    /**
    * Method used for set values
    * @param value This is string of evaluate
    * @param str This is string of coverage
    */
    private static String resultValue(String value, String str) {
        String returnValue = '';
        if(value==null) {
            returnValue = '';
        } else {
            if(str==null) {
                returnValue = value;
            } else {
                returnValue = str + value + '"';
            }
        }
        return returnValue;
    }
    
    /**
     * Method used of parse json to ResponseSimulateRate_Wrapper class
     * @param json This is string of response webservice
     */
    public ResponseSimulateRate_Wrapper parse(String json) {
		final String v_json = json.replace('"currency":', '"currency_type":');        
        return (ResponseSimulateRate_Wrapper) System.JSON.deserialize(v_json, ResponseSimulateRate_Wrapper.class);
    }
    
	/**
     * Wrapper class to the response
     */
    public class ResponseSimulateRate_Wrapper {
        public Response_data data { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
    }
    
    /**
     * Data class to the response
     */
    public class Response_data {
        public Response_CalculationType calculationType { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public Response_CalculationType model { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public Response_BusinessAgent businessAgent { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public Response_Participant participant { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public Response_Product product { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public Response_Summary[] summary { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
    }
    
	/**
     * BusinessAgent class to the response
     */
    public class Response_BusinessAgent {
    }
    
	/**
     * Product class to the response
     */
    public class Response_Product {
        public Response_BusinessAgent requestedAmount { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public Response_BusinessAgent term { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public Response_BusinessAgent guarantee { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
    }
    
	/**
     * Fees class to the response
     */
    public class Response_Fees {
        public Response_CalculationType feeType { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public Response_Detail detail { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
    }
    
    /**
     * Segment class to the response
     */
    public class Response_Segment {
        public Response_SubSegment subSegment { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
    }
    
    /**
     * IdentityDocuments class to the response
     */
    public class Response_IdentityDocuments {
        public Response_BusinessAgent documentType { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
    }
    
    /**
     * FinancialIndicators class to the response
     */
    public class Response_FinancialIndicators {
        public String id { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public String value { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
    }
    
    /**
     * Participant class to the response
     */
    public class Response_Participant {
        public Response_IdentityDocuments[] identityDocuments { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public Response_BusinessAgent bank { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public Response_Segment segment { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public Response_Delinquency delinquency { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public Response_BusinessAgent[] strategicRelationships { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public Response_BusinessAgent[] riskLevel { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
    }
    
    /**
     * CalculationType class to the response
     */
    public class Response_CalculationType {
        public String id { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
    }
    
    /**
     * SubSegment class to the response
     */
    public class Response_SubSegment {
        public Response_BusinessAgent[] partitions { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
    }
    
    /**
     * LiquidityIndicators class to the response
     */
    public class Response_LiquidityIndicators {
        public String id { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public Response_Detail detail { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        
    }
    
    /**
     * Summary class to the response
     */
    public class Response_Summary {
        public String calculationId { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public Response_FinancialIndicators[] financialIndicators { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public Response_InterestRates interestRates { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public Response_Fees[] fees { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public Response_LiquidityIndicators[] liquidityIndicators { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
    }
    
	/**
     * InterestRates class to the response
     */
    public class Response_InterestRates {
        public Response_EffectiveRates[] effectiveRates { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
    }
    
	/**
     * EffectiveRates class to the response
     */
    public class Response_EffectiveRates {
        public String id { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public Double percentage { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
    }
    
	/**
     * Delinquency class to the response
     */
    public class Response_Delinquency {
        public Response_BehaviorDebts behaviorDebts { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
    }
    
	/**
     * BehaviorDebts class to the response
     */
    public class Response_BehaviorDebts {
        public Response_BusinessAgent[] tacticalVariable { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
    }
    
	/**
     * Detail class to the response
     */
    public class Response_Detail {
        public Double percentage { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public Double amount { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public String currency_type { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
    }
}