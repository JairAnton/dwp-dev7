/**
 * BE_AP_NextVisits_cls
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		08/06/2020          Original version.<p />
 *
 * @author Diego Carbajal
 */
public with sharing class BE_AP_NextVisits_cls extends BE_SingleRelatedListCRUD_Cls {
	/*
	 * @Description  method readRecords
	 */
	public override BE_SingleRelatedListCRUD_Cls.Response readRecords(Map<String, Object> mapParams) {
		return BE_AP_RelatedVisits_helper_cls.readVisitRecords(mapParams);
	}
}