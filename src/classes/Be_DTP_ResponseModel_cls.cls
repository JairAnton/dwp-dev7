/**
 * Be_DTP_ResponseModel_cls
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		15/05/2020          Original version.<p />
 *
 * @author Diego Carbajal
 */
public virtual class Be_DTP_ResponseModel_cls {
	/**Method getData*/
	public virtual Response getData(String filter) {
		return new Response();
	}

	/**class Response*/
	public with sharing class Response {
		/**Indicate if the transaction is Success*/
		@AuraEnabled
		public Boolean isSuccess {set; get;}
		/**Message to show in the front to final user*/
		@AuraEnabled
		public String message {set; get;}
		/**List of Sobject*/
		@AuraEnabled
		public List<Object> data {set; get;}

		/**Constructor */
        @SuppressWarnings('all')
		public Response() {}
	}
}