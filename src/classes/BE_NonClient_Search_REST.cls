/**
----------------------------------------------------------------------------------------------------
@Name <BE_SearchNonClient_REST>
@Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
@Date 2020-02-24
@Description Class to invoke REST Service called "ListNonBusiness"
@Changes
    Date        Author   Email                  Type        
    2020-07-21  LMBR     lolo.bravo@bbva.com    Creation   
----------------------------------------------------------------------------------------------------
*/
public without sharing  class BE_NonClient_Search_REST {
        /**
    @Description call REST API to modify NonClient
    @param  Map<String, Object> placeholderMap 
    @return System.HttpResponse response
    */
    public System.HttpResponse invoke(Map<String, Object> placeholderMap) {
        return iaso.GBL_Integration_GenericService.invoke('ListNonClient', placeholderMap);
    }

    /**
    @Description parse the response of API REST when it's success
    @param json wich contains the body response of API REST
    @return  ClientResponseSuccess_Wrapper
    */
    public Data_Wrapper parseSuccess(String json) { 
        return (Data_Wrapper) System.JSON.deserialize(json, Data_Wrapper.Class);
    }

    /**
    @Description parse the response of API REST when it's error
    @param json wich contains the body response of API REST
    @return  ClientResponseError_Wrapper
    */
    public ResponseError_Wrapper parseError(String json) {
        return (ResponseError_Wrapper) System.JSON.deserialize(json, ResponseError_Wrapper.Class);
    }
    public class Data_Wrapper {
        public List<Data> data;
    }
	
	public class Data {
		public String id;
		public String legalName;
		public String creationDate;
		public BusinessDocuments businessDocuments;
    }
    
    public class BusinessDocumentType {
		public String id;
	}

	public class BusinessDocuments {
		public String documentNumber;
		public BusinessDocumentType businessDocumentType;
	}

    public class ResponseError_Wrapper {
        /** attribute */ public Integer version {set;get;}
        /** attribute */ public String severity {set;get;}
        /** attribute */ public Integer httpstatus {set;get;}
        /** attribute */ public String errorcode {set;get;}
        /** attribute */ public String errormessage {set;get;}
        /** attribute */ public String consumerrequestid {set;get;}
        /** attribute */ public String systemerrorcode {set;get;}
        /** attribute */ public String systemerrordescription {set;get;}
        /** attribute */ public String systemerrorcause {set;get;}
    }
}