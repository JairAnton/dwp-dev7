/**
   ----------------------------------------------------------------------------------------------------
   @Name <BE_TreeData_Helper>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2019-09-13
   @Description Helper Class for generated dynamic 3w Data.
   @Changes
    Date        Author   Email                  Type
    2019-09-13  LMBR     lolo.bravo@bbva.com    Creation
   ----------------------------------------------------------------------------------------------------
 */
public with sharing class BE_TreeData_Helper {
	/**CurrencyIsoCode ApiName*/
	final static String CURRENCYISOCODE = 'CurrencyIsoCode';
	/**
	   @Description privet constructor.
	 */
	private BE_TreeData_Helper() {
	}
	/**
	   @Description get information about dynamic sObject whith SOQL Dynamic.
	   @param recordId to be search.
	   @param params Object wich contains parameters.
	   @return a Map<Integer, Map<String,SObject>> whith information about Data in cluster in levels without group.
	 */
	public static Map<Integer, Map<String, SObject>> getTreeRecords(String recordId, BE_TreeGrid_Utils.Params param) {
		param.sObjFields = assingSObjFields(param);
		final List<SObject> sObjectList = BE_TreeGrid_Utils.getSOQLData(recordId, param);
		return makeStructureData(sObjectList, param);
	}

	/**
	   @Description get information make a Data in Map according the level.
	   @param SObjectList the list of sObject to be structure.
	   @param params Object wich contains parameters.
	   @return a Map<Integer, Map<String,List<SObject>>> whith information about Data in cluster in levels.
	 */
	private static Map<Integer, Map<String, SObject>> makeStructureData(List<SObject> sObjectList, BE_TreeGrid_Utils.Params params) {
		Map<Integer, Map<String, SObject>> sObjDataMap = new  Map<Integer, Map<String, SObject>>();
		Map<String, SObject> sObjMap;
		for(SObject item:sObjectList) {
			final Integer level = String.isNotBlank(params.fieldLevel) ? Integer.valueOf(item.get(params.fieldLevel)) : (String.isNotBlank((String)item.get(params.keyParentField))) ? 1 : 0;
			final String code = (String)item.get(params.keyField);
			if(sObjDataMap.containsKey(level)) {
				sObjDataMap.get(level).put(code, item);
			} else {
				sObjMap = new  Map<String, SObject>();
				sObjMap.put(code, item);
				sObjDataMap.put(level, sObjMap);
			}
		}
		return sObjDataMap;
	}

	/**
	   @Description get information make a Data in Map according the level.
	   @param params Object wich contains parameters.
	   @return a Map<Integer, Map<String,List<SObject>>> whith information about Data in cluster levels.
	 */
	private static String assingSObjFields(BE_TreeGrid_Utils.Params param) {
		String targetSObjFields = param.sObjFields;
		targetSObjFields = BE_TreeGrid_Utils.joinSobjString(targetSObjFields, CURRENCYISOCODE);
		targetSObjFields = BE_TreeGrid_Utils.joinSobjString(targetSObjFields, param.keyField);
		targetSObjFields = BE_TreeGrid_Utils.joinSobjString(targetSObjFields, param.keyParentField);
		targetSObjFields = String.isNotBlank(param.fieldLevel) ? BE_TreeGrid_Utils.joinSobjString(targetSObjFields, param.fieldLevel) : targetSObjFields;
		return targetSObjFields;
	}
}
