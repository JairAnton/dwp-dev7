/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_ButtonsBarCRUD_cls>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2020-11-15
   @Description
   @Changes
   Date        Author   Email                  Type
   2020-11-15  LMBR     lolo.bravo@bbva.com    Creation
   -------------------------------------------------------------------------------------------------
 */
public virtual class BE_ButtonsBarCRUD_cls {
    /**RESPONSE */
    Response response;
    /**
    @Description virtual Method
    @param Map<String,Object> params
    @return Response class
    */
    public virtual Response readRecords(Map<String,Object> params) {
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
    public Object data {set; get;}

    /**Constructor */
    public Response () {}
    /**Constructor */
    public Response (Boolean isSuccess, String message) {
      this.isSuccess = isSuccess;
      this.message = message;
    }
  }
}