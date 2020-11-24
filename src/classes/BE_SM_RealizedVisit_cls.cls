/**
   -------------------------------------------------------------------------------------------------
   @Name BE_SM_RealizedVisit_cls
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-11-11
   @Description
   @Changes
   Date        Author   Email                  				Type
   2020-11-11  MAMCH    martin.mori.contractor@bbva.com    	Creation
   -------------------------------------------------------------------------------------------------
 */
@SuppressWarnings('all')
public with sharing class BE_SM_RealizedVisit_cls extends BE_SingleRelatedListCRUD_Cls {
	/*
	 * @Description  method readRecords
	 */
    public override BE_SingleRelatedListCRUD_Cls.Response readRecords(Map<String,Object> params) {
        return BE_SM_Visit_helper.getSMRealizedVisits(new Set<String>{'04','05','06'}, params);
    }
}