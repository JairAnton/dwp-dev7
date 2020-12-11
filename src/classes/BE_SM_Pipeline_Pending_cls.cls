/**
   -------------------------------------------------------------------------------------------------
   @Name BE_SM_Pipeline_Pending_cls
   @Author Diego Carbajal Pastor (diego.carbajal@bbva.com)
   @Date 2020-11-04
   @Description
   @Changes
   Date        Author   Email                  Type
   2020-11-06  DCP     diego.carbajal@bbva.com    Creation
   -------------------------------------------------------------------------------------------------
 */
public with sharing class BE_SM_Pipeline_Pending_cls extends BE_SingleRelatedListCRUD_Cls {
    
    /*
	 * @Description  method readRecords
	 */
    public override BE_SingleRelatedListCRUD_Cls.Response readRecords(Map<String,Object> params) {
        return BE_SM_Opportunity_helper.getSMPipeline(new Set<String>{'02'}, params);
    }
}