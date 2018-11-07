public class CreateQuotationRequest_helper {

    public CreateQuotationRequest_Wrapper inputDataMapping;
    
    //Method use to get input information
    public CreateQuotationRequest_helper(String oppRecordId){
        //Retrieve product´s conditions and price rates information
        List<OpportunityLineItem> oppProductList = [SELECT price_rates_calculation_Id__c, proposed_apr_per__c, gipr_Garantia__c
                                     FROM OpportunityLineItem
                                     WHERE OpportunityId = :oppRecordId];
        
        // Retrieve relevant ws parameters mapping values
        Map<String,Web_Service_Value_Mapping__c> mapWsVal = WebServiceUtils.getWebServiceValuesMapping(new List<String>{'GUARANTEE_TYPE'},'');
    
        if(!oppProductList.isEmpty()){
            
            // Map the imput information
            String calculationRatesId = oppProductList[0].price_rates_calculation_Id__c;
            String proposedAPR = String.valueOf((oppProductList[0].proposed_apr_per__c!=null?oppProductList[0].proposed_apr_per__c/100:oppProductList[0].proposed_apr_per__c));
            String requestComment = Label.PriceCreateQuotationRequestDefaultComment;
            String guaranteeType = (mapWsVal.get('GUARANTEE_TYPE' + String.valueOf(oppProductList[0].gipr_Garantia__c)) != null ? mapWsVal.get('GUARANTEE_TYPE' + String.valueOf(oppProductList[0].gipr_Garantia__c)).web_service_value__c : null);
            CreateQuotationRequest_Wrapper imputDataMappingRequest = new CreateQuotationRequest_Wrapper(calculationRatesId, proposedAPR, requestComment, guaranteeType);  	
			this.inputDataMapping = imputDataMappingRequest;
        }
    }
    
    //method to convert the input data mapping to a JSON structure
    public String generateJSONRequest(){
        return JSON.serialize(this.inputDataMapping);
    }
    
    //method to invoke the webservice 
    public System.HttpResponse invoke(){
        return iaso.GBL_Integration_GenericService.invoke('CreateQuotationRequest',generateJSONRequest());
    }
    
    // Wrapper class to map the input values with the input attributes of the webservice 
    public class CreateQuotationRequest_Wrapper{
    	public String calculationRatesId;
        public String proposedAPRpercent;
        public String requestComment;
        public String guaranteeType;
        
        public CreateQuotationRequest_Wrapper(String calculationRatesId, String proposedAPR, String requestComment, String guaranteeType){
            this.calculationRatesId = (calculationRatesId!=null?calculationRatesId:'');
            this.proposedAPRpercent = (proposedAPR!=null?proposedAPR:'""');
            this.requestComment = (requestComment!=null?requestComment:'');
            this.guaranteeType = (guaranteeType!=null?',"product": {"guarantee": {"id": "' + guaranteeType + '"}}':'');
        }
    }
    
    //Wrapper classes for the web service response
    public class ResponseCreateQuotationRequest_Wrapper {
		public Response_Data data;
    }

	public class Response_Status {
		public String id;
		public String name;
	}

	public class Response_InvolvementType {
		public String id;
		public String description;
	}

	public class Response_Involvements {
		public Response_InvolvementType involvementType;
	}

	public class Response_Quotations {
		public Response_Status status;
		public String id;
		public String version;
		public List<Response_BusinessAgents> businessAgents;
		public Response_Disbursement disbursement;
	}

	public class Response_Classification {
		public List<Response_Involvements> involvements;
	}

	public class Response_Data {
		public String id;
		public Response_Status status;
		public List<Response_Quotations> quotations;
	}

	public class Response_BusinessAgents {
		public String id;
		public String firstName;
		public String lastName;
		public String secondLastName;
		public Response_Status workTeam;
		public Response_Classification classification;
	}

	public class Response_Disbursement {
		public Response_InvolvementType status;
	}

	public static ResponseCreateQuotationRequest_Wrapper parse(String json) {
		return (ResponseCreateQuotationRequest_Wrapper) System.JSON.deserialize(json, ResponseCreateQuotationRequest_Wrapper.class);
	}
}