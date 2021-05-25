/**
   -------------------------------------------------------------------------------------------------
   @Name BE_SM_WonAlerts_cls
   @Author Gerson R. Díaz Alvarado (gerson.diaz@bbva.com)
   @Date 2021-05-13
   @Description
   @Changes
   Date        Author   Email                  				Type
   2021-05-13  GRDA     gerson.diaz@bbva.com   			 	Creation
   -------------------------------------------------------------------------------------------------
 */
@SuppressWarnings('all')
public with sharing class BE_SM_WonAlerts_cls extends BE_SingleRelatedListCRUD_Cls {
	/*
	 * @Description  method readRecords 
	 */
	public override BE_SingleRelatedListCRUD_Cls.Response readRecords(Map<String,Object> params) {
        return BE_SM_Alerts_helper.getSMAlerts(new Set<String>{'03'}, params);
    }
}