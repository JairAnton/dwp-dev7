public class WebServiceUtils {
    
    //Return a map with the key is webServiceVal.field_api_name__c + webServiceVal.value__c
    public static Map<String,Web_Service_Value_Mapping__c> getWebServiceValuesMapping(List<String> webServiceIdentifier, String webServicePricing){
        
        Map<String,Web_Service_Value_Mapping__c> webServiceValuesMapping = new Map<String,Web_Service_Value_Mapping__c>();
        
        List<Web_Service_Value_Mapping__c> lstWebServiceValMapping = [SELECT    Id,
                                                                                label__c, 
                                                                                value__c, 
                                                                                web_service_value__c, 
                                                                                web_service_parameter_id__c, 
                                                                                pricing_model_id__c 
                                                                        FROM Web_Service_Value_Mapping__c
                                                                        WHERE web_service_parameter_id__c IN :webServiceIdentifier
                                                                        AND pricing_model_id__c = :webServicePricing];

        for(Web_Service_Value_Mapping__c webServiceVal : lstWebServiceValMapping){
            webServiceValuesMapping.put(webServiceVal.web_service_parameter_id__c + webServiceVal.value__c, webServiceVal);
        }
        return webServiceValuesMapping;
        
    }
    
    public static String getUrlFromCustomSettings(String customSettingKey){
		iaso__GBL_Rest_Services_Url__c urlObj = null;
        try {
            urlObj = [SELECT name, iaso__Url__c FROM iaso__GBL_Rest_Services_Url__c
               WHERE name = :customSettingKey limit 1];
            return urlObj.iaso__Url__c;
        } catch (Exception e) {
            return '';
        }
	}
    public static ResponseErrorMessage_Wrapper parse(String json){
        json = json.replace('"http-status":', '"status":').replace('"error-code":', '"errorcode":').replace('"error-message":', '"errormessage":').replace('"consumer-request-id":', '"consumerrequestid":').replace('"system-error-code":', '"systemerrorcode":').replace('"system-error-description":', '"systemerrordescription":');        
        return (ResponseErrorMessage_Wrapper) System.JSON.deserialize(json, ResponseErrorMessage_Wrapper.class);
    }
    
    public class ResponseErrorMessage_Wrapper{
        public Integer version;
        public String severity;
        public Integer status;
        public String errorcode;
        public String errormessage;
        public String consumerrequestid;
        public String systemerrorcode;
        public String systemerrordescription;
    }
}