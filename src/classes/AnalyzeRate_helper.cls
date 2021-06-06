/**
 * 
 * @author Global hub
 * @date 06-11-2018 
 *
 * @group Global_HUB
 *
 * @description Wrapper class to map the input values with the input attributes of the webservice
 * @HIstorial de cambios:
	- Actualización del web service de la version v0 a la v1
	- Actualización RORC y RAROEC
	*****************************
	Modificaciones:
	Martín Alejandro Mori Chávez  07-07-2019
	Martín Alejandro Mori Chávez  12-08-2019
**/
public without sharing class AnalyzeRate_helper {
    /* variable request wrapper */
    public RequestAnalyzeRate_Wrapper inputDataMapping { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
    /* variable boolean is simulate call*/
    public Boolean isSimulate { get; set; }

    /**
     * constructor of class
     */
    public AnalyzeRate_helper(String recordId, String calculationId, Decimal tea, Boolean isSimulate) {
        this.isSimulate = isSimulate;
        inputDataMapping = new RequestAnalyzeRate_Wrapper();
            
        final List<Request_effectiveRates> ltsEffectiveRates = new List<Request_effectiveRates>();
        final Request_effectiveRates effectiveRates = new Request_effectiveRates();
        effectiveRates.id = 'REQUESTED_TEA';
        effectiveRates.percentage = tea/100.00;
        ltsEffectiveRates.add(effectiveRates);
        inputDataMapping.ltsEffectiveRates = JSON.serialize(ltsEffectiveRates);
        inputDataMapping.calculationRatesId = calculationId;
        
        final List<Request_fees> ltsFees = new List<Request_fees>();
        inputDataMapping.lstFees = JSON.serialize(ltsFees);

        List<OpportunityLineItem> oli = [SELECT Id, hasCommissions__c FROM OpportunityLineItem WHERE Opportunity.Id = :recordId];
        inputDataMapping.lstCalculatedFees = '';
        System.debug('CALCULATE FEES:'+oli[0].hasCommissions__c+'   '+recordId+'   '+oli[0].Id);
        if(oli[0].hasCommissions__c) {
            inputDataMapping.lstCalculatedFees = '"calculatedFees":[';
            for(Product_Commission__c commission : [SELECT Id, Commission_Calculation_Id__c, Commission_Calculation_Version__c FROM Product_Commission__c WHERE Opportunity_Product__c = :oli[0].Id ])
            {
                System.debug('CALCULATE FEES (commissions):'+commission);
                inputDataMapping.lstCalculatedFees = inputDataMapping.lstCalculatedFees + '{"id":"'+commission.Commission_Calculation_Id__c+'","version":'+commission.Commission_Calculation_Version__c+'}';
                inputDataMapping.lstCalculatedFees = inputDataMapping.lstCalculatedFees + ',';
            }
            inputDataMapping.lstCalculatedFees = inputDataMapping.lstCalculatedFees + ']';
            inputDataMapping.lstCalculatedFees = inputDataMapping.lstCalculatedFees.replaceAll('},]', '}],');
        }

        
        final List<Request_products> ltsReqProd = new List<Request_products>();
        final List<Opportunity_Solution_Commitment__c> lstCommitments = [SELECT Id, opp_solution_commitment_id__c,
                                                                   opp_solution_commitment_amount__c,
                                                                   opp_soln_comt_expiry_days_number__c,
                                                                   opp_solution_comt_product_name__c,
                                                                   CurrencyIsoCode
                                                                   FROM Opportunity_Solution_Commitment__c
                                                                   WHERE opportunity_id__c = :recordId AND opp_solution_commitment_amount__c >= 0];
        for(Opportunity_Solution_Commitment__c oppSolComm : lstCommitments) {
            final Request_products products = new Request_products();
            products.id = oppSolComm.opp_solution_commitment_id__c;
            final Request_committedData commData = new Request_committedData();
            final Request_unitValue unitValue = new Request_unitValue();
            unitValue.amount = oppSolComm.opp_solution_commitment_amount__c;
            unitValue.currencyType = oppSolComm.CurrencyIsoCode;
            final Request_effectiveTime effectiveTime = new Request_effectiveTime();
            effectiveTime.unit = 'DAY';
            effectiveTime.numberValue = Integer.valueOf(oppSolComm.opp_soln_comt_expiry_days_number__c);
            commData.unitValue = unitValue;
            commData.effectiveTime = effectiveTime;
            products.committedData = commData;
            
            ltsReqProd.add(products);
        }
        inputDataMapping.lstProducts = JSON.serialize(ltsReqProd);
    }

    /**
     * method used to create json request
     */
    public String generateJSONRequest() {
        String json = JSON.serialize(this.inputDataMapping);
        json = json.replace('currencyType', 'currency');
        json = json.replace('numberValue', 'number');
        return json;
    }

    /**
     * method to invoke the webservice
     */
    public System.HttpResponse invoke() {
        return iaso.GBL_Integration_GenericService.invoke((isSimulate ? 'AnalyzeRateSimulate' : 'AnalyzeRate'), generateJSONRequest());
    }

    /**
     * Wrapper class to the request
     */
    public class RequestAnalyzeRate_Wrapper {
        /* Variable request Wrapper */
        public String ltsEffectiveRates { get; set; }
        /* Variable request Wrapper */
        public String calculationRatesId { get; set; }
        /* Variable request Wrapper */
        public String lstFees { get; set; }
        /* Variable request Wrapper */
        public String lstProducts { get; set; }
        /* Variable request Wrapper */
        public String lstCalculatedFees {get;set; }
    }
    
    /**
     * Request_effectiveRates class to the request
     */
    public class Request_effectiveRates {
        /* Variable request */
		public String id { get; set; }
        /* Variable request */
		public Double percentage { get; set; }
	}
    
    /**
     * Request_fees class to the request
     */
    public class Request_fees {
        /* Variable request */
		public Request_detail detail { get; set; }
        /* Variable request */
		public Request_feeType feeType { get; set; }
	}
    
    /**
     * Request_detail class to the request
     */
    public class Request_detail {
        /* Variable request */
		public String percentage { get; set; }
	}
    
    /**
     * Request_feeType class to the request
     */
    public class Request_feeType {
        /* Variable request */
		public String id { get; set; }
	}
    
    /**
     * Request_products class to the request
     */
    public class Request_products {
        /* Variable request */
		public String id { get; set; }
        /* Variable request */
		public Request_committedData committedData { get; set; }
	}
    
    /**
     * Request_committedData class to the request
     */
    public class Request_committedData {
        /* Variable request */
		public Request_unitValue unitValue { get; set; }
        /* Variable request */
		public Request_effectiveTime effectiveTime { get; set; }
	}
	
    /**
     * Request_unitValue class to the request
     */
    public class Request_unitValue {
        /* Variable request */
		public Double amount { get; set; }
        /* Variable request */
		public String currencyType { get; set; }
	}
    
    /**
     * Request_effectiveTime class to the request
     */
    public class Request_effectiveTime {
        /* Variable request */
		public String unit { get; set; }
        /* Variable request */
		public Integer numberValue { get; set; }
	}
    
    /**
     * Calculated_fees class to the request
     */
    public class Calculated_fees  {
        /* Variable request */
        public String id {get; set; }
        /* Variable request */
        public Integer version {get; set;}
    }
    
    
    /**
     * Method used of parse json to ResponseAnalyzeRate_Wrapper class
     * @param json This is string of response webservice
     */
    public ResponseAnalyzeRate_Wrapper parse(String json) {
        String vjson = json.replace('"currency":', '"currencyType":');
        vjson = vjson.replace('"number":', '"numberValue":');
        return (ResponseAnalyzeRate_Wrapper) System.JSON.deserialize(vjson, ResponseAnalyzeRate_Wrapper.class);
    }

    /**
     * Wrapper class to the response
     */
    public class ResponseAnalyzeRate_Wrapper {
        /* Variable response Wrapper */
        public Response_data data { get; set; }
    }
    
    /**
     * Data class to the response
     */
    public class Response_data {
        /* Variable response */
        public string id { get; set; }
        /* Variable response */
        public Response_InterestRates interestRates { get; set; }
        /* Variable response */
        public Response_FinancialIndicators[] financialIndicators { get; set; }
        /* Variable response */
        public Response_LiquidityIndicators[] liquidityIndicators { get; set; }
        /* Variable response */
        public Response_Fees[] fees { get; set; }
        /* Variable response */
        public Response_Products[] products { get; set; }
        /* Variable response */
        public Boolean isCoveredMinimunEvaluated { get; set; }
        /* Variable response */
        public Response_Indicators[] indicators { get; set; }
    }
    
    /**
     * InterestRates class to the response
     */
    public class Response_InterestRates {
        /* Variable response */
        public Response_EffectiveRates[] effectiveRates { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
    }
    
	/**
     * EffectiveRates class to the response
     */
    public class Response_EffectiveRates {
        /* Variable response */
        public String id { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        /* Variable response */
        public Double percentage { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
    }
    
    /**
     * FinancialIndicators class to the response
     */
    public class Response_FinancialIndicators {
        /* Variable response */
        public String id { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        /* Variable response */
        public String value { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
    }
    
    /**
     * LiquidityIndicators class to the response
     */
    public class Response_LiquidityIndicators {
        /* Variable response */
        public String id { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        /* Variable response */
        public Response_Detail detail { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
    }
    
    /**
     * Fees class to the response
     */
    public class Response_Fees {
        /* Variable response */
        public Response_CalculationType feeType { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        /* Variable response */
        public Response_Detail detail { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
    }
    
    /**
     * CalculationType class to the response
     */
    public class Response_CalculationType {
        /* Variable response */
        public String id { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
    }
    
    /**
     * Detail class to the response
     */
    public class Response_Detail {
        /* Variable response */
        public Double percentage { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        /* Variable response */
        public Double amount { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        /* Variable response */
        public String currencyType { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
    }
    
    /**
     * FinancialIndicators class to the response
     */
    public class Response_Indicators {
        /* Variable response */
        public String id { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        /* Variable response */
        public String value { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
    }
    
    /**
     * CommittedData class to the response
     */
    public class Response_Products {
        /* Variable response */
		public String id { get; set; }
        /* Variable response */
        public String name { get; set; }
        /* Variable response */
		public Response_CommittedData committedData { get; set; }
	}
    
    /**
     * CommittedData class to the response
     */
    public class Response_CommittedData {
        /* Variable response */
        public String description { get; set; }
        /* Variable response */
        public Response_UnitValue unitValue { get; set; }
        /* Variable response */
		public Response_EffectiveTime effectiveTime { get; set; }
        /* Variable response */
        public String classification { get; set; }
	}
    
	/**
     * UnitValue class to the response
     */
    public class Response_UnitValue {
        /* Variable response */
		public Double amount { get; set; }
        /* Variable response */
		public String currencyType { get; set; }
        /* Variable response */
        public String unitValueDetailType { get; set; }
	}
    
    /**
     * EffectiveTime class to the response
     */
    public class Response_EffectiveTime {
        /* Variable response */
		public String unit { get; set; }
        /* Variable response */
		public Integer numberValue { get; set; }
	}
}