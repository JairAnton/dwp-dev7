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
    
    /** Data Class */
    public class Data_Wrapper {
        /** attribute */ public List<Data> data {set;get;}
    }
    
	/** Data Class */
	public class Data {
		/** attribute */ public String id {set;get;}
		/** attribute */ public String legalName {set;get;}
		/** attribute */ public String creationDate {set;get;}
		/** attribute */ public BusinessDocuments businessDocuments {set;get;}
    }
    
    /** BusinessDocumentType Class*/
    public class BusinessDocumentType {
		/** attribute */ public String id {set;get;}
	}
    
	/** BusinessDocuments Class */
	public class BusinessDocuments {
		/** attribute */ public String documentNumber {set;get;}
		/** attribute */ public BusinessDocumentType businessDocumentType {set;get;}
	}
}


