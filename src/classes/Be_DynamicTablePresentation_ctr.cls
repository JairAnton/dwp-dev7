/**
 * ------------------------------------------------------------------------------------------------
 * @Name Be_DynamicTablePresentation_ctr
 * @Author Diego Carbajal diego.carbajal@bbva.com
 * @Date Created: 2020-05-01
 * @Group
 * @Description Controller class Be_DynamicTablePresentation_ctr
 */
public without sharing class Be_DynamicTablePresentation_ctr {

    /** @Description  BASIC*/
    static Final String BASIC = 'Basic';
    
	/** @Description  Be_DynamicTablePresentation_ctr*/
	private Be_DynamicTablePresentation_ctr() {}

	/*
	 * @Description  Obtain filters in metadata
	 */
	@AuraEnabled
	public static String getFilters(String config) {
		Final List<Be_Dynamic_Table_Presentation__mdt> mdtDTP = getConfig(config);
		String jsonFilters = 'empty';
		if(!mdtDTP.isEmpty() && String.isNotBlank(mdtDTP[0].Filters__c)) {
			Final List<BE_DTP_FilterParser_cls.Filter> lstFilters = (List<BE_DTP_FilterParser_cls.Filter>) BE_DTP_FilterParser_cls.parseRecords(mdtDTP[0].Filters__c);
			jsonFilters = putFiltersId(lstFilters);
		}
		return jsonFilters;
	}

	/** @Description  Put ListView Id for standard ListView*/
	private static String putFiltersId(List<BE_DTP_FilterParser_cls.Filter> lstFilters) {
		Final Set<String> setDevName = new Set<String>();
		Final Set<String> setSObjt = new Set<String>();
		for(BE_DTP_FilterParser_cls.Filter filter:lstFilters) {
			if(String.isNotBlank(filter.sObjectType) && String.isNotBlank(filter.developerName)) {
				setDevName.add(filter.developerName);
				setSObjt.add(filter.sObjectType);
			}
		}
		for(ListView lView:[SELECT Id, developerName, SObjectType FROM ListView WHERE developerName IN:setDevName AND SObjectType IN:setSObjt]) {
			for(BE_DTP_FilterParser_cls.Filter filter:lstFilters) {
				if(filter.developerName == lView.developerName && filter.sObjectType == lView.SObjectType) {
					filter.filterId =  lView.Id;
				}
			}
		}
		return JSON.serialize(lstFilters);
	}

	/** @Description  getValues */
	@AuraEnabled
	public static Be_DTP_ResponseModel_cls.Response getValues(Map<String, String> mapConfigs, String filter) {
		Be_DTP_ResponseModel_cls.Response response = new Be_DTP_ResponseModel_cls.Response(false);
		try {
			Final List<Be_Dynamic_Table_Presentation__mdt> mdtDTP = getConfig(mapConfigs.get('config'));
            Final Integer mdtDTPSize = mdtDTP.size();
			if(mdtDTPSize > 0) {
				//If need to replace a field from another object lstReplaceValues will be contain values for specific field
				Final List<String> replaceField = Be_DynamicTablePresentation_helper.doReplaceQuery(mdtDTP[0], filter, mapConfigs.get('recordId'));
				////Reusable variables for columns and params in custom or configuration form
				List<BE_DTP_ColumnParser_cls.Column> columnsAux;
				Final Map<String, String> mapParams = new Map<String, String>{'filterCode' => filter, 'recordId' => mapConfigs.get('recordId')};
				//If className is empty call records by configurations, else get records by custom class
				if(String.isBlank(mdtDTP[0].ClassName__c)) {
					response.data = Be_DynamicTablePresentation_helper.getData(mdtDTP[0], mapParams, replaceField);
					response.isSuccess = true;
					response.columns = mdtDTP[0].Columns_Table_Configuration__c;
					//Adapt records from DataTable to Title form
					columnsAux = BE_DTP_ColumnParser_cls.getColumnsType(filter, mdtDTP[0].Columns_Table_Configuration__c);
					response.data = convertValues(response.data, columnsAux, mapConfigs.get('mode'));
				} else {
					Final Be_DTP_ResponseModel_cls helperClass = (Be_DTP_ResponseModel_cls)Type.forName(mdtDTP[0].ClassName__c).newInstance();
					response = helperClass.getData(mapParams, mdtDTP[0].Columns_Table_Configuration__c, replaceField);
					//Adapt records from DataTable to Title form if result isSuccess
					columnsAux = response.isSuccess ? BE_DTP_ColumnParser_cls.getColumnsType(filter, response.columns) : 
														BE_DTP_ColumnParser_cls.getColumnsType(filter, mdtDTP[0].Columns_Table_Configuration__c);
					response.data = response.isSuccess ? convertValues(response.data, columnsAux, mapConfigs.get('mode')) : new List<Object>();
				}
			} else {
				response.message = 'No se ha encontrado metadata valida.';
			}
		} catch (Exception e) {
			System.debug('Be_DynamicTablePresentation_ctr.getValues');
			System.debug('e.getMessage() => '+e.getMessage());
			response.message = e.getMessage();
		}
		return response;
	}

	/** @Description  getConfig*/
	@AuraEnabled(cacheable = true)
	public static List<Be_Dynamic_Table_Presentation__mdt> getConfig(String config) {
		return [SELECT Id, Columns_Table_Configuration__c, ClassName__c, Filters__c, Replace_Fields_Configuration__c 
					FROM Be_Dynamic_Table_Presentation__mdt WHERE DeveloperName =: config LIMIT 1];
	}

	/** @Description  convertValues */
	private static List<Object> convertValues(List<Object> res, List<BE_DTP_ColumnParser_cls.Column> columns, String mode) {
		List<Object> lstObj;
		if(mode == BASIC) {
			lstObj = res;
		} else {
			lstObj = convertPersonalizedValues(res, columns, null);
		}
		return lstObj;
	}

	/** @Description  convertPersonalizedValues */
	public static List<Object> convertPersonalizedValues(List<Object> res, List<BE_DTP_ColumnParser_cls.Column> columns, Be_Dynamic_Table_Presentation__mdt mdtDTP) {
		Final List<Map<String, Object>> newValues = new List<Map<String, Object>>();
		Map<String, Object> value;
		List<Map<String, Object>> record;
		Map<String, Object> row;
        Final String[] lstDataTypes = new String[] {'Boolean', 'Date', 'Date-local', 'Percent', 'Number', 'Text', 'Email', 'Url', 'Phone', 'Currency'};
		for(Map<String, Object> data: (List<Map<String, Object>>) res) {
			value = new Map<String, Object> {'key' => data.get('Id')};
			record = new List<Map<String, Object>>();
			for(BE_DTP_ColumnParser_cls.Column column: columns) {
                row = getRow(data, column, lstDataTypes);
				record.add(row);
				value.put('record', record);
			}
			newValues.add(value);
		}
		return newValues;
	}

	/** @Description  getRow */
    private static Map<String, Object> getRow(Map<String, Object> data, BE_DTP_ColumnParser_cls.Column column, String[] lstDataTypes) {
        Final Map<String, Object> row = new Map<String, Object> {'label' => column.label, 'value' => data.get(column.fieldName)};
		Final String typeCol = column.type.toLowerCase();
        for(String dataTypes: lstDataTypes) {
            row.put('is' + dataTypes, dataTypes.toLowerCase() == typeCol);
        }
        switch on typeCol {
            when 'url' {
                Final BE_DTP_ColumnParser_cls.Label label = column.typeAttributes.label;
                row.put('urlLabel', data.get(label.fieldName));
                row.put('target', '_self');
            }
            when 'number', 'currency', 'percent' {
                row.put('formatStyle', column.typeAttributes.formatStyle);
				row.put('currencyCode', column.typeAttributes.currencyCode);
				row.put('currencyIsoCode', data.get('CurrencyIsoCode'));
				row.put('currencyDisplayAs', column.typeAttributes.currencyDisplayAs);
            }
            when 'date-local' {
                row.put('isDate-local', false);
                row.put('isDate', true);
            }
        }
        return row;
    }

}