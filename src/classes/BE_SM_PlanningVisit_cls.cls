/**
   -------------------------------------------------------------------------------------------------
   @Name BE_SM_PlanningVisit_cls
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-11-11
   @Description
   @Changes
   Date        Author   Email                  				Type
   2020-11-11  MAMCH    martin.mori.contractor@bbva.com    	Creation
   -------------------------------------------------------------------------------------------------
 */
@SuppressWarnings('all')
public with sharing class BE_SM_PlanningVisit_cls extends BE_SingleRelatedListCRUD_Cls {
	/*
	 * @Description  method readRecords
	 */
	public override BE_SingleRelatedListCRUD_Cls.Response readRecords(Map<String,Object> params) {
        return BE_SM_Visit_helper.getSMPlanningVisits(new Set<String>{'01','02','03'}, params);
    }
}