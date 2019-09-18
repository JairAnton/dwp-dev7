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

    /**
    @Description get information about dynamic sObject whith SOQL Dynamic.
    @recordId the recordId to be search or aplicate filter.
    @param sObjName the ApiName of sObject to be search.
    @param sObjFields the ApiName of all fields to be search separate by comma.
    @param keyField the a fieldApiName wich contains the code of the record.
    @param keyParentField the fieldApiName wich contains the code of the parent code.
    @param fieldLevel the fieldApiName wich contains the level of the record.
    @param filterSQOL filter of query.
    @return a Map<Integer, Map<String,SObject>> whith information about Data in cluster in levels without group.
    */
    public  static Map<Integer, Map<String,SObject>> getTreeRecords(String recordId,String sObjName,String  sObjFields,String keyField,String keyParentField,String filterSQOL,String fieldLevel) {
        final String defaultApiName='Id';
        Map<Integer, Map<String,SObject>> treeGridData=new Map<Integer, Map<String,SObject>>();
        List<String> sObjFieldsLst=new List<String>();
        keyField=String.isNotBlank(keyField)?keyField:defaultApiName;
        filterSQOL=String.isNotBlank(filterSQOL)?filterSQOL:'';
        sObjFields=String.isNotBlank(sObjFields)?sObjFields:defaultApiName;
        keyParentField=String.isNotBlank(keyParentField)?keyParentField:'';
        sObjFields=BE_TreeGrid_Utils.joinSobjString(sObjFields, keyField);
        sObjFields=BE_TreeGrid_Utils.joinSobjString(sObjFields, keyParentField);
        sObjFields=String.isNotBlank(fieldLevel)?BE_TreeGrid_Utils.joinSobjString(sObjFields, fieldLevel):sObjFields;
        final List<SObject> SObjectList=BE_TreeGrid_Utils.getSOQLData(recordId,sObjName,sObjFields,filterSQOL);
        treeGridData=makeStructureData(SObjectList, keyField, fieldLevel,keyParentField);
        return treeGridData;
    }

    /**
    @Description get information make a Data in Map according the level.
    @param SObjectList the list of sObject to be structure.
    @param keyField fieldApiName wich contains the code or Id of the record.
    @param keyParentField fieldApiName wich contains the code of the parent record.
    @param fieldLevel fieldApiName that contains the level of the data.
    @return a Map<Integer, Map<String,List<SObject>>> whith information about Data in cluster in levels.
    */
    private static Map<Integer, Map<String,SObject>> makeStructureData(List<SObject> SObjectList,String keyField,String fieldLevel,String keyParentField) {
        Map<Integer, Map<String,SObject>> sObjDataMap=new  Map<Integer, Map<String,SObject>>();
        Map<String,SObject> sObjMap;
        for(SObject item:SObjectList) {
            final Integer level=String.isNotBlank(fieldLevel)?Integer.valueOf(item.get(fieldLevel)):(String.isNotBlank((String)item.get(keyParentField)))?1:0;
            final String code =(String)item.get(keyField);
            if(sObjDataMap.containsKey(level)) {
                    sObjDataMap.get(level).put(code,item);
            } else {
                  sObjMap=new  Map<String,SObject>();
                  sObjMap.put(code, item);
                  sObjDataMap.put(level,sObjMap); 
            }
        }
        return sObjDataMap;
    }
}