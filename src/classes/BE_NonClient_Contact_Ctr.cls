/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_NonClient_Contact_Ctr>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2020-05-12
   @Description BE_NonClientContact_Ctr class
   @Changes
   Date        Author   Email                  Type
   2020-05-12  LMBR     lolo.bravo@bbva.com    Creation
   -------------------------------------------------------------------------------------------------
 */
public without sharing class BE_NonClient_Contact_Ctr  extends BE_SingleRelatedListCRUD_Cls {

    /**
    @Description createRecords
    @param  List<SObject> sObjs
    @return BE_SingleRelatedListCRUD_Cls.Response response
    */
    public override BE_SingleRelatedListCRUD_Cls.Response createRecords(List<SObject> sObjs) {
      return BE_NonClient_CreateContact_Helper.createNonClientContactRel((AccountContactRelation)sObjs[0]);
    }

    /**
    @Description deleteRecords
    @param  List<SObject> sObjs
    @return BE_SingleRelatedListCRUD_Cls.Response response
    */
    public override BE_SingleRelatedListCRUD_Cls.Response deleteRecords(List<SObject> sObjs) {
      return BE_NonClient_DeleteContact_Helper.deleteNonClientContact(sObjs[0].Id);
    }

    /**
    @Description updateRecords
    @param  List<SObject> sObjs
    @return BE_SingleRelatedListCRUD_Cls.Response response
    */
    public override BE_SingleRelatedListCRUD_Cls.Response updateRecords(List<SObject> sObjs) {
      return BE_NonClient_ModifyContact_Helper.modifyNonClientContact(sObjs[0]);
    }
}