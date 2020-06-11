/**
 * BE_AP_OpportunityInProgress_cls
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		08/06/2020          Original version.<p />
 *
 * @author Diego Carbajal
 */
public with sharing class BE_AP_OpportunityInProgress_cls extends BE_SingleRelatedListCRUD_Cls {
	/*
	 * @Description  method constructor
	 */
	private BE_AP_OpportunityInProgress_cls() {
	}

	/*
	 * @Description  method readRecords
	 */
	public override BE_SingleRelatedListCRUD_Cls.Response readRecords(Map<String, Object> mapParams) {
		Final BE_SingleRelatedListCRUD_Cls.Response res = new BE_SingleRelatedListCRUD_Cls.Response();
		Final BE_SingleRelatedList_Ctr.Params param = new BE_SingleRelatedList_Ctr.Params();
		param.sObjName = (String)mapParams.get('sObjName');
		param.sObjFields = (String)mapParams.get('sObjFields');
		param.filterSQOL = (String)mapParams.get('filterSQOL');
		Final Id accId = BE_AP_Administration_helper.getAP((String) mapParams.get('recordId'))[0].acpl__participant_id__c;
		res.isSuccess = true;
		res.message = 'Success';
		res.data = BE_SingleRelatedList_Ctr.getSOQLData(accId, param);
		return res;
	}
}
