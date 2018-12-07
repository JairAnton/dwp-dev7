public class CompromiseProducts_helper {

    public RequestCompromiseProducts_Wrapper inputDataMapping{get; set;} //Ernesto 07/12/2018 : se agregó el get y set

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
        final String v_json = json.replace('"currency":', '"currency_type":');//Yulino 06/12/2018 : Se agrego la variable
        return (ResponseCompromiseProducts_Wrapper) System.JSON.deserialize(v_json, ResponseCompromiseProducts_Wrapper.class);
	}

    //Wrapper class to map the input values with the input attributes of the webservice 
    public class RequestCompromiseProducts_Wrapper{
        public String productModel { get; set; } //Yulino 29/11/2018 : se agregó el get y set
        
        public RequestCompromiseProducts_Wrapper(String productModel){
            this.productModel = (productModel!=null?productModel:'');
        }
    }

    //Wrapper class to the response 
    public class ResponseCompromiseProducts_Wrapper{
        public Response_data[] data { get; set; } //Yulino 29/11/2018 : se agregó el get y set
    }

    public class Response_data{
        public String id { get; set; } //Yulino 29/11/2018 : se agregó el get y set
		public String name { get; set; } //Yulino 29/11/2018 : se agregó el get y set
		public Response_committableData[] committableData{ get; set; } //Yulino 29/11/2018 : se agregó el get y set
    }

    public class Response_committableData{
        public String unitType { get; set; } //Yulino 29/11/2018 : se agregó el get y set
		public String description { get; set; } //Yulino 29/11/2018 : se agregó el get y set
		public Integer validityDays { get; set; } //Yulino 29/11/2018 : se agregó el get y set
		public String currency_type { get; set; } //Yulino 29/11/2018 : se agregó el get y set
		public Response_discounts[] discounts { get; set; } //Yulino 29/11/2018 : se agregó el get y set
    }
    
    public class Response_discounts {
		public Response_item item { get; set; } //Yulino 29/11/2018 : se agregó el get y set
		public Integer percentage { get; set; } //Yulino 29/11/2018 : se agregó el get y set
	}

	public class Response_item {
		public String id { get; set; } //Yulino 29/11/2018 : se agregó el get y set
	}

}