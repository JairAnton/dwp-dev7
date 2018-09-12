public class ProductsQuoteAvailability_helper {
    
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
    
    
    //Wrapper class to map the input values with the input attributes of the webservice 
    public class ProductsQuoteAvailability_Wrapper{
        public String participantId;
        
        public ProductsQuoteAvailability_Wrapper(String participantId){
            this.participantId = (participantId!=null?participantId:'');
        }
    }
 
}