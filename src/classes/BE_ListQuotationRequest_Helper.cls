/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_ListQuotationRequest_Helper>
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2021-02-16
   @Description Class used to call ListQuotationRequest method
   @Changes
   Date        Author   Email                  				Type		Description
   2021-02-16  MAMC     martin.mori.contractor@bbva.com    	Creation
   -------------------------------------------------------------------------------------------------
 */
 public with sharing class BE_ListQuotationRequest_Helper {
	/* variable request wrapper */
	public ListQuotationRequest_Wrapper inputDataMapping {get; set;}

	// Method use to get input information
	public BE_ListQuotationRequest_Helper(String participantId, String paginationKey, String pageSize) {
        ListQuotationRequest_Wrapper requestWrapper = new ListQuotationRequest_Wrapper(participantId, paginationKey, pageSize);
        this.inputDataMapping = requestWrapper;
    }

	//Wrapper class to map the input values with the input attributes of the webservice
	public class ListQuotationRequest_Wrapper {
		/* variable participantId */
		public String participantId {get; set;}
        /* variable paginationKey */
		public String paginationKey {get; set;}
        /* variable pageSize */
		public String pageSize {get; set;}
        
		/* constructor method */
		public ListQuotationRequest_Wrapper(String participantId, String paginationKey, String pageSize) {
			this.participantId = (participantId != null ? participantId : '');
            this.paginationKey = (paginationKey != null ? paginationKey : '1');
            this.pageSize = (pageSize != null ? pageSize : '10');
		}
	}

	//method to convert the input data mapping to a JSON structure
	public String generateJSONRequest() {
		return JSON.serialize(this.inputDataMapping);
	}

	// Method to invoke the webservice
	public System.HttpResponse invoke() {
		return iaso.GBL_Integration_GenericService.invoke('ListQuotationRequests', generateJSONRequest());
	}
}