public class CompromiseProducts_helper {

    public RequestCompromiseProducts_Wrapper inputDataMapping;

    public CompromiseProducts_helper(String productModel){
        this.inputDataMapping = new RequestCompromiseProducts_Wrapper(productModel);
    }

    //method to convert the input data mapping to a JSON structure
    public String generateJSONRequest(){
        return JSON.serialize(this.inputDataMapping);
    }
    
    //method to invoke the webservice
    public System.HttpResponse invoke(){
        return iaso.GBL_Integration_GenericService.invoke('CompromiseProducts',generateJSONRequest());
    }

    public ResponseCompromiseProducts_Wrapper parse(String json){
        json = json.replace('"currency":', '"currency_type":');
        return (ResponseCompromiseProducts_Wrapper) System.JSON.deserialize(json, ResponseCompromiseProducts_Wrapper.class);
	}

    //Wrapper class to map the input values with the input attributes of the webservice 
    public class RequestCompromiseProducts_Wrapper{
        public String productModel;
        
        public RequestCompromiseProducts_Wrapper(String productModel){
            this.productModel = (productModel!=null?productModel:'');
        }
    }

    //Wrapper class to the response 
    public class ResponseCompromiseProducts_Wrapper{
        public Response_data[] data;
    }

    public class Response_data{
        public String id;
		public String name;
		public Response_committableData[] committableData;
    }

    public class Response_committableData{
        public String unitType;
		public String description;
		public Integer validityDays;
		public String currency_type;
		public Response_discounts[] discounts;
    }
    
    public class Response_discounts {
		public Response_item item;
		public Integer percentage;
	}

	public class Response_item {
		public String id;
	}

}