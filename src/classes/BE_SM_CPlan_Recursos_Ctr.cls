/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_SM_CPlan_Recursos_Ctr>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2020-11-15
   @Description 
   @Changes
   Date        Author   Email                  Type
   2020-11-15  LMBR     lolo.bravo@bbva.com    Creation
   -------------------------------------------------------------------------------------------------
 */
public with sharing class BE_SM_CPlan_Recursos_Ctr  extends BE_SingleRelatedListCRUD_Cls {
    /** PRODUCT_TYPE */
    final static String PRODUCT_FAMILY='Recursos';
    /**
    @Description createRecords
    @param  List<SObject> sObjs
    @return BE_SingleRelatedListCRUD_Cls.Response response
    */
    public override BE_SingleRelatedListCRUD_Cls.Response readRecords(Map<String,Object> params) {
        return BE_SM_CPlan_Helper.getOpportunities(BE_SM_CPlan_Helper.getOppIds(params,PRODUCT_FAMILY), params);
    }
}