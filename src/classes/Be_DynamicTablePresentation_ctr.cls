/**
 * ------------------------------------------------------------------------------------------------
 * @Name Be_DynamicTablePresentation_ctr
 * @Author Diego Carbajal diego.carbajal@bbva.com
 * @Date Created: 2020-05-01
 * @Group
 * @Description Controller class Be_DynamicTablePresentation_ctr
 */
@SuppressWarnings('PMD.CyclomaticComplexity')
public without sharing class Be_DynamicTablePresentation_ctr {
    /** @Description  DEVELOPER_NAME*/
    private static Final String DEVELOPER_NAME = 'developerName';
    /** @Description  SOBJ_TYPE*/
    private static Final String SOBJ_TYPE = 'sobjectType';
	/** @Description  Be_DynamicTablePresentation_ctr*/
	private Be_DynamicTablePresentation_ctr() {}

	/*
	 * @Description  getFilters
	 */
	@AuraEnabled
	public static String getFilters(String config) {
		Final List<Be_Dynamic_Table_Presentation__mdt> mdtDTP = (List<Be_Dynamic_Table_Presentation__mdt>) getConfig(config);
		Final Integer mdtDTPSize = mdtDTP.size();
		String jsonFilters = mdtDTP[0].Filters__c;
		if(mdtDTPSize > 0 && String.isNotBlank(jsonFilters)) {
            Final List<Object> lstFilters = (List<Object>) JSON.deserializeUntyped(mdtDTP[0].Filters__c);
            Final Map<String, Set<String>> mapLVConfig = getLVConfigs(lstFilters);
            Final Set<String> devNameLV = mapLVConfig.get('devNameLV');
        	Final Set<String> sObjLV = mapLVConfig.get('sObjLV');
			for(ListView lView:[SELECT Id, developerName, SObjectType FROM ListView WHERE developerName IN:devNameLV AND SObjectType IN:sObjLV]) {
				for(Object filters:lstFilters) {//mapFilter put new values in filters
					Final Map<String, Object> mapFilter = (Map<String, Object>)filters;
					if(mapFilter.containsKey(DEVELOPER_NAME) && mapFilter.get(DEVELOPER_NAME) == lView.developerName &&
					   mapFilter.containsKey(SOBJ_TYPE) && mapFilter.get(SOBJ_TYPE) == lView.SObjectType) {
						mapFilter.put('id', lView.Id);
					}
				}
			}
			jsonFilters = JSON.serialize(lstFilters);
		}
		return mdtDTPSize > 0 ? jsonFilters : 'empty';
	}

    /*
	 * @Description  getLVConfigs
	 */
    private static Map<String, Set<String>> getLVConfigs(List<Object> lstFilters) {
        Final Set<String> devNameLV = new Set<String>();
        Final Set<String> sObjLV = new Set<String>();
        for(Object filters:lstFilters) {
            Final Map<String, Object> mapFilter = (Map<String, Object>)filters;
            if(mapFilter.containsKey(DEVELOPER_NAME) && mapFilter.containsKey(SOBJ_TYPE)) {
                devNameLV.add((String) mapFilter.get(DEVELOPER_NAME));
                sObjLV.add((String) mapFilter.get(SOBJ_TYPE));
            }
        }
        return new  Map<String, Set<String>>{'devNameLV' => devNameLV, 'sObjLV' => sObjLV};
    }
	/*
	 * @Description  getValues
	 */
	@AuraEnabled
	public static Map<String, Object> getValues(String config, String mode, String filter) {
		Final Map<String, Object> mapRes = new Map<String, Object>();
		Final List<Be_Dynamic_Table_Presentation__mdt> mdtDTP = (List<Be_Dynamic_Table_Presentation__mdt>) getConfig(config);
		if(String.isNotBlank(mdtDTP[0].ClassName__c)) {
			try {
				Final Be_DTP_ResponseModel_cls singleClass = (Be_DTP_ResponseModel_cls)Type.forName(mdtDTP[0].ClassName__c).newInstance();
				Final Be_DTP_ResponseModel_cls.Response response = singleClass.getData(filter);
				mapRes.put('isSuccess', response.isSuccess);
				mapRes.put('message', response.message);
				if(response.isSuccess) {
					Final List<Column> columns = getColumnsType(filter, mdtDTP[0]);
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
		return [SELECT Id, Columns_Table_Configuration__c, ClassName__c, Filters__c FROM Be_Dynamic_Table_Presentation__mdt 
                WHERE DeveloperName = : config];
	}

	/*
	 * @Description  convertPersonalizedValues
	 */
	public static List<Object> convertPersonalizedValues(List<Object> res, List<Column> columns, Be_Dynamic_Table_Presentation__mdt mdtDTP) {
		Final List<Map<String, Object>> newValues = new List<Map<String, Object>>();
		Map<String, Object> value;
		List<Map<String, Object>> record;
		Map<String, Object> row;
        Final String[] lstDataTypes = new String[] {'Boolean', 'Date', 'Date-local', 'Percent', 'Number', 'Text', 'Email', 'Url', 'Phone'};
		for(Map<String, Object> data: (List<Map<String, Object>>) res) {
			value = new Map<String, Object> {'key' => data.get('Id')};
			record = new List<Map<String, Object>>();
			for(Column column: columns) {
                row = getRow(data, column, lstDataTypes);
				record.add(row);
				value.put('record', record);
			}
			newValues.add(value);
		}
		return newValues;
	}

    private static Map<String, Object> getRow(Map<String, Object> data, Column column, String[] lstDataTypes) {
        Final Map<String, Object> row = new Map<String, Object> {'label' => column.label, 'value' => data.get(column.fieldName)};
		Final String typeCol = column.type.toLowerCase();
        for(String dataTypes: lstDataTypes) {
            row.put('is' + dataTypes, dataTypes.toLowerCase() == typeCol);
        }
        switch on typeCol {
            when 'url' {
                Final Label label = column.typeAttributes.label;
                row.put('urlLabel', data.get(label.fieldName));
                row.put('target', '_self');
            }
            when 'number', 'currency', 'percent' {
                row.put('formatStyle', column.typeAttributes.formatStyle);
                row.put('currencyCode', column.typeAttributes.currencyCode);
            }
            when 'date-local' {
                row.put('isDate-local', false);
                row.put('isDate', true);
            }
        }
        return row;
    }
	/*
	 * @Description  getColumnsType
	 */
	public static List<Column> getColumnsType(String filter, Be_Dynamic_Table_Presentation__mdt mdtDTP) {
		Final Object objColumns = (Object)JSON.deserializeUntyped(mdtDTP.Columns_Table_Configuration__c);
		Final Map<String, Object> mapColumns = (Map<String, Object>) objColumns;
		Final List<Object> lstColumn = (List<Object>)mapColumns.get(filter);
		return (List<Column>)JSON.deserialize(JSON.serialize(lstColumn), List<Column>.class);
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
		/**type*/
		@AuraEnabled
		public String type {set; get;}
        /**TypeAttributes*/
		@AuraEnabled
		public TypeAttributes typeAttributes {set; get;}
	}

	/*
	 * @Description  TypeAttributes
	 */
	public with sharing class TypeAttributes {
        /**label*/
		@AuraEnabled
		public Label label {set; get;}
        /**formatStyle*/
		@AuraEnabled
		public String formatStyle {set; get;}
        /**currencyCode*/
		@AuraEnabled
		public String currencyCode {set; get;}
	}

    /*
	 * @Description  Label
	 */
	public with sharing class Label {
        /**fieldName*/
		@AuraEnabled
		public String fieldName {set; get;}
	}
}