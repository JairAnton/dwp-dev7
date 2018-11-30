public without sharing class ProductsQuoteAvailability_helper {
    
    public ProductsQuoteAvailability_Wrapper inputDataMapping;
    
    //method use to get input information
    public ProductsQuoteAvailability_helper(String oppRecordId){
        
        List<Opportunity> lstOpp = [SELECT Account.main_code_id__c FROM Opportunity WHERE Id = :oppRecordId];
        
        if(!lstOpp.isEmpty()){
            //map the input values with the input attributes of the webservice 
            ProductsQuoteAvailability_Wrapper requestWrapper = new ProductsQuoteAvailability_Wrapper(lstOpp[0].Account.main_code_id__c);
			this.inputDataMapping = requestWrapper;
        }
        
    }
    
    //method to convert the input data mapping to a JSON structure
    public String generateJSONRequest(){
        return JSON.serialize(this.inputDataMapping);
    }
    
    //method to invoke the webservice
    public System.HttpResponse invoke(){
        return iaso.GBL_Integration_GenericService.invoke('ProductsQuoteAvailability',generateJSONRequest());//{'participantId':'P4355'}
    }

    public static ResponseProductsQuoteAvailability_Wrapper parse(String json){
		return (ResponseProductsQuoteAvailability_Wrapper) System.JSON.deserialize(json, ResponseProductsQuoteAvailability_Wrapper.class);
	}
    
    
    //Wrapper class to map the input values with the input attributes of the webservice 
    public class ProductsQuoteAvailability_Wrapper{
        public String participantId;
        
        public ProductsQuoteAvailability_Wrapper(String participantId){
            this.participantId = (participantId!=null?participantId:'');
        }
    }

    //Wrapper class to map the json response
    public class ResponseProductsQuoteAvailability_Wrapper{
        public Response_data[] data;
    }

    public class Response_data {
		public String id;
		public String name;
		public Response_productType productType;
		public Response_pricing pricing;
	}
    public class Response_productType {
		public String id;
	}
	public class Response_pricing {
		public String id;
	}
 
}