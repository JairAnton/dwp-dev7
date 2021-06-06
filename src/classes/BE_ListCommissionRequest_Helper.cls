/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_ListCommissionRequest_Helper>
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2021-03-17
   @Description Class used to call ListCommissionRequest method
   @Changes
   Date        Author   Email                  				Type		Description
   2021-03-17  MAMC     martin.mori.contractor@bbva.com    	Creation
   -------------------------------------------------------------------------------------------------
 */
 public with sharing class BE_ListCommissionRequest_Helper {
	/* variable request wrapper */
	public ListCommissionRequest_Wrapper inputDataMapping {get; set;}

	/* Method use to get input information */
	public BE_ListCommissionRequest_Helper(String productModelCode, String modalityCode, String guarantyCode, String currencyCode) {
        Final ListCommissionRequest_Wrapper requestWrapper = new ListCommissionRequest_Wrapper(productModelCode, modalityCode, guarantyCode, currencyCode);
        this.inputDataMapping = requestWrapper;
    }

	/* Wrapper class to map the input values with the input attributes of the webservice */
	public class ListCommissionRequest_Wrapper {
		/* variable product model code */
		public String productModelCode {get; set;}
        /* variable modality code of product */
		public String modalityCode {get; set;}
        /* variable guarantee code of product */
		public String guarantyCode {get; set;}
        /* variable currency code of product */
		public String currencyCode {get; set;}
        
		/* constructor method */
		public ListCommissionRequest_Wrapper(String productModelCode, String modalityCode, String guarantyCode, String currencyCode) {
			this.productModelCode = (productModelCode == null ? '' : productModelCode);
            this.modalityCode = (modalityCode == null ? '' : modalityCode);
            this.guarantyCode = (guarantyCode == null ? '' : guarantyCode);
            this.currencyCode = (currencyCode == null ? '' : currencyCode);
		}
	}

	/* method to convert the input data mapping to a JSON structure */
	public String generateJSONRequest() {
		return JSON.serialize(this.inputDataMapping);
	}

	/* Method to invoke the webservice */
	public System.HttpResponse invoke() {
		return iaso.GBL_Integration_GenericService.invoke('ListCommissionRequests', generateJSONRequest());
	}
}