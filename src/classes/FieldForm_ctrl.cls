/**
 * @author Global_HUB developers
 * @date 01-08-2018
 *
 * @group Global_HUB
 *
 * @description Controller class from FieldForm_ctrl
 **/
public with sharing class FieldForm_ctrl {
	@AuraEnabled
	public static Map<String, Object> getInfo(String recordId, String uniqueNameTable) {
		Map<String, Object> mapReturn = new Map<String, Object>();
		try {
			List<Field_form__mdt> lstFieldForm = [SELECT Id,
			                                      DeveloperName,
			                                      object_api_name__c,
			                                      unique_id__c,
			                                      (SELECT Id,
			                                       default_value__c,
			                                       field_api_name__c,
			                                       field_form__c,
			                                       is_readonly__c,
			                                       order__c,
			                                       is_required__c
			                                       FROM Fields__r ORDER BY order__c)
			                                      FROM Field_form__mdt WHERE unique_id__c = :uniqueNameTable];
			Set<String> setFields = new Set<String>();
			Map<String, Object> mapField = new Map<String, Object>();
			for(Field__mdt field : lstFieldForm[0].Fields__r) {
				mapField.put(field.field_api_name__c, field);
				setFields.add(field.field_api_name__c);
			}
			List<String> lstField = new List<String>(setFields);
			List<Object> lstRecord = Database.query('SELECT ' + String.join(lstField, ',') + ' FROM ' + lstFieldForm[0].object_api_name__c + ' WHERE Id = \'' + recordId + '\'');
			Map<String, Map<String, String>> mapSchemaInfo = getInfoSchema(setFields, lstFieldForm[0].object_api_name__c);
			Final Map<String, String> mapFormula = mapSchemaInfo.get('mapFormula');
			Map<String, String> mapType = mapSchemaInfo.get('mapType');
			for(String apiName:mapFormula.keySet()) {
				mapType.put(apiName, mapFormula.get(apiName));
			}
			mapReturn.put('mapLabel', mapSchemaInfo.get('mapLabel'));
			//mapReturn.put('mapType',mapSchemaInfo.get('mapType'));
			mapReturn.put('mapType', mapType);
			mapReturn.put('isOk', true);
			mapReturn.put('record', lstRecord[0]);
			mapReturn.put('setFields', setFields);
			mapReturn.put('fieldForm', lstFieldForm[0]);
			mapReturn.put('mapField', mapField);
		} catch(Exception e) {
			mapReturn.put('isOk', false);
		}

		return mapReturn;
	}

	@AuraEnabled
	public static Map<String, Object> doSave(String recordId, String objectApiName, List<String> lstApiField, List<Object> lstValue) {
		Map<String, Object> mapReturn = new Map<String, Object>();
		List<sObject> lstRecord = Database.query('SELECT Id FROM ' + objectApiName + ' WHERE Id = \'' + recordId + '\'');
		//lstRecord[0].put('dlf_Portfolio_effectiveness__c',23);
		Set<String> setApiFields = new Set<String>(lstApiField);
		Map<String, Map<String, String>> mapSchemaInfo = getInfoSchema(setApiFields, objectApiName);
		Map<String, String> mapType = mapSchemaInfo.get('mapType');
		Integer pos = 0;
		for(String strApiName : setApiFields) {
			switch on mapType.get(strApiName) {
				when 'PERCENT' {
					if(String.valueOf(lstValue[pos]) != '') {
						lstRecord[0].put(strApiName, Double.valueOf(lstValue[pos]));
					} else {
						lstRecord[0].put(strApiName, null);
					}
				}
				when 'DOUBLE' {
					if(String.valueOf(lstValue[pos]) != '') {
						lstRecord[0].put(strApiName, Double.valueOf(lstValue[pos]));
					} else {
						lstRecord[0].put(strApiName, null);
					}
				}
				when 'BOOLEAN' {
					lstRecord[0].put(strApiName, Boolean.valueOf(lstValue[pos]));
				}
				when 'DATE' {
					if(String.valueOf(lstValue[pos]) != null) {
						List<String> lstStringDate = String.valueOf(lstValue[pos]).split('-');
						lstRecord[0].put(strApiName, Date.parse(lstStringDate[2] + '/' + lstStringDate[1] + '/' + lstStringDate[0]));
					} else {
						lstRecord[0].put(strApiName, null);
					}
				}
				when 'STRING' {
					lstRecord[0].put(strApiName, String.valueOf(lstValue[pos]));
				}
				when else {
					System.debug('lstValue[' + pos + '] => ' + String.valueOf(lstValue[pos]));
					System.debug('mapType.get(strApiName) => ' + mapType.get(strApiName));
				}
			}
			pos++;
		}
		try {
			update lstRecord[0];
			mapReturn.put('isOk', true);
		} catch(Exception e) {
			mapReturn.put('isOk', false);
			mapReturn.put('errorMessage', e.getMessage());
		}
		return mapReturn;
	}

	public static Map<String, Map<String, String>> getInfoSchema(Set<String> setApiName, String strApiName) {
		Map<String, Map<String, String>> mapReturn = new Map<String, Map<String, String>>();
		Map<String, String> mapLabelSchema = new Map<String, String>();
		Map<String, String> mapTypeSchema = new Map<String, String>();
		Map<String, String> mapFormulaSchema = new Map<String, String>();
		String strType = strApiName;
		Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
		Schema.SObjectType leadSchema = schemaMap.get(strType);
		Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
		for(String fieldName: setApiName) {
			mapLabelSchema.put(fieldName, fieldMap.get(fieldName).getDescribe().getLabel());
			mapTypeSchema.put(fieldName, String.valueOf(fieldMap.get(fieldName).getDescribe().getType()));
			if(fieldMap.get(fieldName).getDescribe().isCalculated()) {
				mapTypeSchema.put(fieldName, 'FORMULA');
				mapFormulaSchema.put(fieldName, String.valueOf(fieldMap.get(fieldName).getDescribe().getType()));
			}
		}
		mapReturn.put('mapLabel', mapLabelSchema);
		mapReturn.put('mapType', mapTypeSchema);
		mapReturn.put('mapFormula', mapFormulaSchema);
		return mapReturn;
	}
}
