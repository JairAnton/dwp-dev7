/**
 * ------------------------------------------------------------------------------------------------
 * @Name Be_DynamicTablePresentation_helper
 * @Author Diego Carbajal diego.carbajal@bbva.com
 * @Date Created: 2020-08-25
 * @Group
 * @Description Controller class Be_DynamicTablePresentation_helper
 */
public with sharing class Be_DynamicTablePresentation_helper {

    /**@Description Quotes for replace*/
    Final static String QUOTES='\'';
    /**@Description REFACTORPER for replace*/
    Final static String REFACTORPER='@@';
    /**@Description USER_ID for dynamic query*/
    Final static Id USER_ID = UserInfo.getUserId();
    /**@Description USER_PROFILE for dynamic query*/
    Final static String USER_PROFILE = [SELECT Id, Name FROM Profile WHERE Id =: UserInfo.getProfileId()].Name;
    /**@Description USER_ROLE for dynamic query*/
    Final static String USER_ROLE = (String.isNotBlank(UserInfo.getUserRoleId()) ? [SELECT Id, Name, DeveloperName FROM UserRole WHERE 
                                    Id =: UserInfo.getUserRoleId()].DeveloperName : '');
    /**@Description STR_URL*/
    static Final String STR_URL = 'url';

    /** @Description  private Constructor e_DynamicTablePresentation_helper*/
    private Be_DynamicTablePresentation_helper() {}

    /** @Description  getData: return records from Main Query for LWC View*/
    public static List<Map<String, Object>> getData(Be_Dynamic_Table_Presentation__mdt mdt, Map<String, String> mapParams, List<String> replaceField) {
        Final List<Map<String, Object>> lstMapData = new List<Map<String, Object>>();
        Final String filterCode = mapParams.get('filterCode');
        Final String recordId = mapParams.get('recordId');
        replaceField.add(recordId);
        Final Map<String, BE_DTP_FilterParser_cls.Filter> mapFilters = BE_DTP_FilterParser_cls.getMapRecords(mdt);
        if(mapFilters.containsKey(filterCode)) {
            Final BE_DTP_FilterParser_cls.Filter filtro = mapFilters.get(filterCode);
            Final List<BE_DTP_ColumnParser_cls.Column> lstColumn = BE_DTP_ColumnParser_cls.getColumnsType(filterCode, mdt.Columns_Table_Configuration__c);
            Final Set<String> urlFields = getURLFields(lstColumn);
            //Generate JSON for convert type: Filter to ReplaceConfig for dynamic query
            Final String queryParamsJSON = JSON.serialize(filtro);
            Final BE_DTP_ReplaceConfigParser_cls.ReplaceConfig queryParams = (BE_DTP_ReplaceConfigParser_cls.ReplaceConfig) BE_DTP_ReplaceConfigParser_cls.parseRecord(queryParamsJSON);
            Final List<Object> lstObjData = doQuery(queryParams, recordId, replaceField);
            Final List<String> queryFields = getQueryColumnsFields(filtro.queryFields);
            for(Object obj:lstObjData) {
                //Replace SObject into Map Record
                Final Map<String, Object> mapRecordAux = replaceFields(queryFields, (Map<String, Object>) obj);
                //Convert field in to URL
                for(String str:urlFields) {
                    mapRecordAux.put('URL__' + str, URL.getSalesforceBaseUrl().toExternalForm() + '/' + mapRecordAux.get(str));
                }
                lstMapData.add(mapRecordAux);
            }
        }
        return lstMapData;
    }

    /**@Description SubQuery for replace value if need*/
	public static List<String> doReplaceQuery(Be_Dynamic_Table_Presentation__mdt mdtDTP, String filterCode, String recordId) {
		Final List<String> lstReplacedValues = new List<String>();
		if(String.isNotBlank(mdtDTP.Replace_Fields_Configuration__c)) {
			Final Map<String, BE_DTP_ReplaceConfigParser_cls.ReplaceConfig> mapReplaceConfig = BE_DTP_ReplaceConfigParser_cls.getMapRecords(mdtDTP);
			if(mapReplaceConfig.containsKey(filterCode)) {
				Final BE_DTP_ReplaceConfigParser_cls.ReplaceConfig queryParams = mapReplaceConfig.get(filterCode);
				Final List<Object> lstObjData = doQuery(queryParams, recordId, null);
                Final List<String> queryFields = getQueryColumnsFields(queryParams.queryFields);
				for(Object obj:lstObjData) {
					Final Map<String, Object> mapRecordAux = replaceFields(queryFields, (Map<String, Object>) obj);
					lstReplacedValues.add((String)mapRecordAux.get(queryParams.replaceField));
				}
			}
		}
		return lstReplacedValues;
	}

    /**@Description do Query with dynamic attributes and convert into Object*/
    public static List<Object> doQuery(BE_DTP_ReplaceConfigParser_cls.ReplaceConfig queryParams, String recordId, List<String> replaceField) {
        String query = 'SELECT Id, CurrencyIsoCode, '+String.escapeSingleQuotes(queryParams.queryFields) + ' FROM ' + 
                        String.escapeSingleQuotes(queryParams.sObjectType);
        query += (String.isBlank(queryParams.queryFilters) ? '' : ' WHERE ' + 
                String.escapeSingleQuotes(queryParams.queryFilters).removeEndIgnoreCase('LIKE').replace(REFACTORPER,QUOTES));
        return (List<Object>) JSON.deserializeUntyped(JSON.serialize(Database.query(query)));
    }

    /**@Description get fields from columns*/
    public static List<String> getQueryColumnsFields(String queryFields) {
        Final String queryFieldsClean = queryFields.remove('toLabel(').remove(')');
        Final List<String> columnsFields = new List<String>{'Id', 'CurrencyIsoCode'};
        columnsFields.addAll(String.escapeSingleQuotes(queryFieldsClean).deleteWhitespace().split(','));
        return columnsFields;
    }

    /**@Description Obtain only queryFields values*/
    private static Map<String, Object> replaceFields(List<String> queryFields, Map<String, Object> mapObj) {
        Final Map<String, Object> mapRecord = new Map<String, Object>();
        for(String field: queryFields) {
            if(field.contains('.')) {
                Final List<String> lstFields = field.split('\\.');
                Final Integer size = lstFields.size();
                Map<String, Object> fieldValue = (Map<String, Object>) mapObj.get(lstFields[0]);
                for(Integer i = 1; i < size; i++) {
                    if(i == (size - 1) && fieldValue != null) {
                        mapRecord.put(field, fieldValue.get(lstFields[i]));
                    } else if(fieldValue != null) {
                        fieldValue = (Map<String, Object>) fieldValue.get(lstFields[i]);
                    }
                }
            } else {
                mapRecord.put(field, mapObj.get(field));
            }
        }
        return mapRecord;
    }

    /**@Description Obtain urlFields*/
    private static Set<String> getURLFields(List<BE_DTP_ColumnParser_cls.Column> lstColumn) {
        Final Set<String> urlFields = new Set<String>();
        for(BE_DTP_ColumnParser_cls.Column columnAux:lstColumn) {
            if(columnAux.type == STR_URL) {
                urlFields.add(columnAux.fieldName.replace('URL__', ''));
            }
        }
        return urlFields;
    }

}