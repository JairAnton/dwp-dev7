/**
 * ------------------------------------------------------------------------------------------------
 * @Name Be_DynamicTablePresentation_ctr
 * @Author Diego Carbajal diego.carbajal@bbva.com
 * @Date Created: 2020-05-01
 * @Group
 * @Description Controller class Be_DynamicTablePresentation_ctr
 *
 */
public without sharing class Be_DynamicTablePresentation_ctr {
	/*
	 * @Description  Be_DynamicTablePresentation_ctr
	 */
	public Be_DynamicTablePresentation_ctr() {
	}

	/*
	 * @Description  getFilters
	 */
	@AuraEnabled
	public static String getFilters(String config) {
		List<Be_Dynamic_Table_Presentation__mdt> mdtDTP = (List<Be_Dynamic_Table_Presentation__mdt>) getConfig(config);
		Final Integer mdtDTPSize = mdtDTP.size();
		String jsonFilters = mdtDTP[0].Filters__c;
		if(mdtDTPSize > 0 && mdtDTP[0].Filters__c != null) {
			List<Object> lstFilters = (List<Object>) JSON.deserializeUntyped(mdtDTP[0].Filters__c);
			Set<String> devNameLV = new Set<String>();
			Set<String> sObjLV = new Set<String>();
			for(Object filters:lstFilters) {
				Map<String, Object> mapFilter = (Map<String, Object>)filters;
				if(mapFilter.containsKey('developerName') && mapFilter.containsKey('sobjectType')) {
					devNameLV.add((String) mapFilter.get('developerName'));
					sObjLV.add((String) mapFilter.get('sobjectType'));
				}
			}
			for(ListView lv:[SELECT Id, developerName, SObjectType FROM ListView WHERE developerName IN:devNameLV AND SObjectType IN:sObjLV]) {
				for(Object filters:lstFilters) {
					Map<String, Object> mapFilter = (Map<String, Object>)filters;
					if(mapFilter.containsKey('developerName') && mapFilter.get('developerName') == lv.developerName &&
					   mapFilter.containsKey('sobjectType') && mapFilter.get('sobjectType') == lv.SObjectType) {
						mapFilter.put('id', lv.Id);
					}
				}
			}
			jsonFilters = JSON.serialize(lstFilters);
		}
		return mdtDTPSize > 0 ? jsonFilters : 'empty';
	}

	/*
	 * @Description  getValues
	 */
	@AuraEnabled
	public static Map<String, Object> getValues(String config, String mode, String filter) {
		Map<String, Object> mapRes = new Map<String, Object>();
		Be_DTP_ResponseModel_cls.Response response = new Be_DTP_ResponseModel_cls.Response();
		List<Be_Dynamic_Table_Presentation__mdt> mdtDTP = (List<Be_Dynamic_Table_Presentation__mdt>) getConfig(config);
		if(String.isNotBlank(mdtDTP[0].ClassName__c)) {
			try {
				Be_DTP_ResponseModel_cls singleClass = (Be_DTP_ResponseModel_cls)Type.forName(mdtDTP[0].ClassName__c).newInstance();
				response = singleClass.getData(filter);
				mapRes.put('isSuccess', response.isSuccess);
				mapRes.put('message', response.message);
				if(response.isSuccess) {
					List<Column> columns = getColumnsType(filter, mdtDTP[0]);
					mapRes.put('data', mode == 'Basic' ? response.data : convertPersonalizedValues(response.data, columns, mdtDTP[0]));
					mapRes.put('columns', mdtDTP[0].Columns_Table_Configuration__c);
				}
			} catch(Exception e) {
				mapRes.put('isSuccess', false);
				mapRes.put('message', e.getMessage());
			}
		} else {
			mapRes.put('isSuccess', false);
			mapRes.put('message', 'Ha ocurrido un error, por favor contactese con su administrador.');
		}
		return mapRes;
	}

	/*
	 * @Description  getConfig
	 */
	@AuraEnabled(cacheable = true)
	public static Object getConfig(String config) {
		return [SELECT Id, Columns_Table_Configuration__c, ClassName__c,
		        Filters__c FROM Be_Dynamic_Table_Presentation__mdt WHERE DeveloperName = : config];
	}

	/*
	 * @Description  convertPersonalizedValues
	 */
	public static List<Object> convertPersonalizedValues(List<Object> res, List<Column> columns, Be_Dynamic_Table_Presentation__mdt mdtDTP) {
		List<Map<String, Object>> lstData = (List<Map<String, Object>>) res;
		List<Map<String, Object>> newValues = new List<Map<String, Object>>();
		Map<String, Object> value;
		List<Map<String, Object>> record;
		Map<String, Object> row;
		for(Map<String, Object> data: lstData) {
			value = new Map<String, Object> {'key' => data.get('Id')};
			record = new List<Map<String, Object>>();
			for(Column column: columns) {
				row = new Map<String, Object> {'label' => column.label, 'value' => data.get(column.fieldName)};
				Final String[] lstDataTypes = new String[] {'Boolean', 'Date', 'Date-local', 'Percent', 'Number',
					                                        'Text', 'Email', 'Url', 'Phone'};
				String typeCol = column.type.toLowerCase();
				for(String dataTypes: lstDataTypes) {
					row.put('is' + dataTypes, dataTypes.toLowerCase() == typeCol);
				}
				TypeAttributes typeAttributes = column.typeAttributes;
				switch on typeCol {
					when 'url' {
						Label label = typeAttributes.label;
						row.put('urlLabel', data.get(label.fieldName));
						row.put('target', '_self');
					}
					when 'number', 'currency', 'percent' {
						row.put('formatStyle', typeAttributes.formatStyle);
						row.put('currencyCode', typeAttributes.currencyCode);
					}
					when 'date-local' {
						row.put('isDate-local', false);
						row.put('isDate', true);
					}
				}
				record.add(row);
				value.put('record', record);
			}
			newValues.add(value);
		}
		return newValues;
	}

	/*
	 * @Description  getColumnsType
	 */
	public static List<Column> getColumnsType(String filter, Be_Dynamic_Table_Presentation__mdt mdtDTP) {
		Object objColumns = (Object)JSON.deserializeUntyped(mdtDTP.Columns_Table_Configuration__c);
		Map<String, Object> mapColumns = (Map<String, Object>) objColumns;
		List<Object> lstColumn = (List<Object>)mapColumns.get(filter);
		String strColumn = JSON.serialize(lstColumn);
		List<Column> column = (List<Column>)JSON.deserialize(strColumn, List<Column>.class);
		return column;
	}

	/*
	 * @Description  Column
	 */
	public with sharing class Column {
		/**Indicate if the transaction is Success*/
		@AuraEnabled
		public String label {set; get;}
		/**Message to show in the front to final user*/
		@AuraEnabled
		public String fieldName {set; get;}
		/**List of Sobject*/
		@AuraEnabled
		public String type {set; get;}
		@AuraEnabled
		public TypeAttributes typeAttributes {set; get;}
	}

	/*
	 * @Description  TypeAttributes
	 */
	public with sharing class TypeAttributes {
		@AuraEnabled
		public Label label {set; get;}
		@AuraEnabled
		public String formatStyle {set; get;}
		@AuraEnabled
		public String currencyCode {set; get;}
	}

	public with sharing class Label {
		@AuraEnabled
		public String fieldName {set; get;}
	}
}
