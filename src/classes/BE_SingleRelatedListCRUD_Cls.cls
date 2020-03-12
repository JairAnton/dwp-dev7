/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_SingleRelatedList_Tst>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2020-03-03
   @Description virtual Class BE_SingleRelatedListCRUD_Cls for custom CRUD and Callout Service
   @Changes
   Date        Author   Email                  Type
   2020-03-03  LMBR     lolo.bravo@bbva.com    Creation
   -------------------------------------------------------------------------------------------------
 */
public virtual class BE_SingleRelatedListCRUD_Cls {
    /**RESPONSE */
    Response response;
    /** create record */
    public virtual Response createRecords(List<SObject> sObjs) {
        response=new Response();
        return response;
    }
    /** update record */
    public virtual Response updateRecords(List<SObject> sObjs) {
        response=new Response();
        return response;
    }
    /** delete record */
    public virtual Response deleteRecords(List<SObject> sObjsIds) {
        response=new Response();
        return response;
    }
    /** read record */
    public virtual Response readRecords() {
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
