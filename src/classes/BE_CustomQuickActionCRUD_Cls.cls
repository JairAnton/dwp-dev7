/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_CustomQuickActionCRUD_Cls>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2020-09-03
   @Description Interfase BE_CustomQuickActionCRUD_Cls
   @Changes
   Date        Author   Email                  Type
   2020-09-03  LMBR     lolo.bravo@bbva.com    Creation
   -------------------------------------------------------------------------------------------------
 */
public virtual class BE_CustomQuickActionCRUD_Cls {
    /**RESPONSE */
    Response response;
    /**
    @Description virtual Method
    @param List<SObject> sObjs
    @return Response class
    */
    public virtual Response createRecord(SObject sObj) {
        response=new Response();
        return response;
    }
    /**
    @Description virtual Method
    @param List<SObject> sObjs
    @return Response class
    */
    public virtual Response updateRecord(SObject sObj) {
        response=new Response();
        return response;
    }
    /**
    @Description virtual Method
    @param List<SObject> sObjs
    @return Response class
    */
    public virtual Response deleteRecord(SObject sObjIds) {
        response=new Response();
        return response;
    }
    /**
    @Description virtual Method
    @param Map<String,Object> params
    @return Response class
    */
    public virtual Response readRecord(Map<String,Object> params) {
        response=new Response();
        return response;
    }
      /**
   -------------------------------------------------------------------------------------------------
   @Name <Response>
   @Description Wrapper Class for the reponse to lwc.
   -------------------------------------------------------------------------------------------------
 */
  public with sharing class Response {
        /**Indicate if the transaction is Success*/
        @AuraEnabled
        public Boolean isSuccess {set; get;}
        /**Message to show in the front to final user*/
        @AuraEnabled
        public String message {set; get;}
        /**List of Sobject*/
        @AuraEnabled
        public SObject data {set; get;}
    
        /**Constructor */
        public Response () {}
        /**Constructor */
        public Response (Boolean isSuccess, String message) {
          this.isSuccess = isSuccess;
          this.message = message;
        }
  }
}
