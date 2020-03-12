public virtual class BE_SingleRelatedListCRUD_Cls {
    /**RESPONSE */
    Response response;
    public virtual Response createRecords(List<SObject> sObjs){
        response=new Response();
        return response;
    }
    public virtual Response updateRecords(List<SObject> sObjs){
        response=new Response();
        return response;
    }
    public virtual Response deleteRecords(List<SObject> sObjsIds){
        response=new Response();
        return response;
    }
    public virtual Response readRecords(){
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
    public List<SObject>data {set; get;}
  }
}