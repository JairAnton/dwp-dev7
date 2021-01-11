/**
 * BE_AP_RelatedVisits_helper_cls
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		21/08/2020          Original version.<p />
 *
 * @author Diego Carbajal
 */
public with sharing class BE_AP_RelatedVisits_helper_cls {

    /**@Description Quotes*/
	Final static String QUOTES='\'';
	/**@Description params to quotes*/
    Final static String REFACTORPER='@@';
    /**@Description RT_ECO_GRP for SonarQ*/
    Final static String RT_ECO_GRP = 'Record_Type_Economic_Group';
    /**@Description clientsId for SonarQ*/
    static Set<Id> clientsId;
    
    /*
	 * @Description  private constructor BE_AP_RelatedVisits_helper_cls
	 */
    private BE_AP_RelatedVisits_helper_cls() {}

    /*
	 * @Description  method readVisitRecords
	 */
    public static BE_SingleRelatedListCRUD_Cls.Response readVisitRecords(Map<String, Object> mapParams) {
		Final BE_SingleRelatedListCRUD_Cls.Response res = new BE_SingleRelatedListCRUD_Cls.Response();
		Final BE_SingleRelatedList_Ctr.Params param = new BE_SingleRelatedList_Ctr.Params();
		param.sObjName = (String)mapParams.get('sObjName');
		param.sObjFields = (String)mapParams.get('sObjFields');
		param.filterSQOL = (String)mapParams.get('filterSQOL');
		try {
			Final acpl__Account_Planning__c apRecord = BE_AP_Administration_helper.getAP((String) mapParams.get('recordId'))[0];
			if(apRecord.acpl__participant_id__r.RecordType.DeveloperName == RT_ECO_GRP) {
				res.data = getVisitsGroups(apRecord, param);
			} else {
				res.data = BE_SingleRelatedList_Ctr.getSOQLData(apRecord.acpl__participant_id__c, param);
			}
			res.isSuccess = true;
			res.message = 'Success';
		} catch (Exception e) {
			res.isSuccess = false;
			res.message = 'Error '+ e.getMessage();
		}
		return res;
    }
    
    /*
	 * @Description  method getVisitsGroups
	 */
    private static List<SObject> getVisitsGroups(acpl__Account_Planning__c apRecord, BE_SingleRelatedList_Ctr.Params param) {
		Final Map<Id, Account> mapClients = new Map<Id, Account>([SELECT Id FROM Account WHERE parentId=:apRecord.acpl__participant_id__c]);
        //Use clientsId in query param, don't remove
		clientsId = mapClients.keySet();
		param.filterSQOL = param.filterSQOL.replace('recordId', 'clientsId');
		Final String query = 'SELECT ' +String.escapeSingleQuotes(param.sObjFields)+ ' ,CurrencyIsoCode FROM '+ String.escapeSingleQuotes(param.sObjName) + 
							' WHERE '+String.escapeSingleQuotes(param.filterSQOL).removeEndIgnoreCase('LIKE').replace(REFACTORPER,QUOTES);
		return Database.query(query);
    }
    
}