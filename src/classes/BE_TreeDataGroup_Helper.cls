/**
----------------------------------------------------------------------------------------------------
@Name <BE_TreeDataGroup_Helper>
@Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
@Date 2019-09-13
@Description Helper Class for generated dynamic Tree Data.
@Changes
   Date        Author   Email                  Type        
   2019-09-13  LMBR     lolo.bravo@bbva.com    Creation   
----------------------------------------------------------------------------------------------------
 */
public with sharing class BE_TreeDataGroup_Helper {
    
    /**
    @Description make a Data in Map according the level.
    @param SObjectList the list of sObject to be structure.
    @param sObjDataMap the Map of structure Date in cluster according the level.
    @param keyField fieldApiName wich contains the code or Id of the record.
    @param keyParentField fieldApiName wich contains the code of the parent record.
    @param fieldLevel fieldApiName that contains the level of the data.
    @return a Map<Integer, Map<String,List<SObject>>> whith information about Data in cluster in levels.
    */
    public static Map<Integer, Map<String,List<SObject>>> getTreeRecordsGroup(String recordId,String sObjName,String  sObjFields,String keyField,String keyParentField,String filterSQOL,String keyGroup,String fieldLevel,String filterSQOLDate,String formatDate,String fieldsHeaderGroup, Boolean isHeaderGroup,Boolean isNumGroupShow,List<Object> groupLabels) {
        final String defaultApiName='Id';
        final List<SObject> SObjectList;
        Map<Integer, Map<String,List<SObject>>> treeGridData=new Map<Integer, Map<String,List<SObject>>>();
        keyField=String.isNotBlank(keyField)?keyField:defaultApiName;
        filterSQOL=String.isNotBlank(filterSQOL)?filterSQOL:'';
        sObjFields=String.isNotBlank(sObjFields)?sObjFields:defaultApiName;
        keyParentField=String.isNotBlank(keyParentField)?keyParentField:null;
        sObjFields=BE_TreeGrid_Utils.joinSobjString(sObjFields, keyField);
        sObjFields=BE_TreeGrid_Utils.joinSobjString(sObjFields, keyParentField);
        sObjFields=BE_TreeGrid_Utils.joinSobjString(sObjFields, keyGroup);
        sObjFields=BE_TreeGrid_Utils.joinSobjString(sObjFields, fieldsHeaderGroup);
        sObjFields=String.isNotBlank(fieldLevel)?BE_TreeGrid_Utils.joinSobjString(sObjFields, fieldLevel):sObjFields;
        if(isNumGroupShow) {
            SObjectList=BE_TreeGrid_Utils.getSOQLDataWithIN(recordId, sObjName, sObjFields, filterSQOL, keyGroup,groupLabels);
        } else {
            SObjectList=BE_TreeGrid_Utils.getSOQLData(recordId, sObjName, sObjFields, filterSQOL);
        }
        final Map<String, List<SObject>> dataMap=getMapRecords(SObjectList,keyGroup);
        for (String codeKey : dataMap.keySet()) {
               treeGridData=makeStructureDataGroup(dataMap.get(codeKey),treeGridData,keyField,fieldLevel,keyParentField);
        }
        return treeGridData;
    }

    /**
    @Description make a Data in Map according the level.
    @param SObjectList the list of sObject to be structure.
    @param sObjDataMap the Map of structure Date in cluster according the level.
    @param keyField fieldApiName wich contains the code or Id of the record.
    @param keyParentField fieldApiName wich contains the code of the parent record.
    @param fieldLevel fieldApiName that contains the level of the data.
    @return a Map<Integer, Map<String,List<SObject>>> whith information about Data in cluster in levels.
    */
    private static Map<Integer, Map<String,List<SObject>>> makeStructureDataGroup(List<SObject> SObjectList,Map<Integer, Map<String,List<SObject>>> sObjDataMap,String keyField,String fieldLevel,String keyParentField) {
        Map<String,List<SObject>> sObjMap;
        List<SObject> sObjLst;
        for(SObject item:SObjectList) {
            final Integer level=String.isNotBlank(fieldLevel)?Integer.valueOf(item.get(fieldLevel)):(String.isNotBlank((String)item.get(keyParentField)))?1:0;
            final String code =(String)item.get(keyField);
            if(sObjDataMap.containsKey(level)) {
                if(sObjDataMap.get(level).containsKey(code)) {
                    sObjDataMap.get(level).get(code).add(item);
                } else {
                    sObjLst=new List<SObject>();
                    sObjLst.add(item);
                    sObjDataMap.get(level).put(code,sObjLst);
                }
            } else {
              sObjMap=new  Map<String,List<SObject>>();
              sObjLst=new List<SObject>();
              sObjLst.add(item);
              sObjMap.put(code, sObjLst);
              sObjDataMap.put(level,sObjMap); 
            }
        }
        return sObjDataMap;
    }

    /**
    @Description get Map<String,List<SObject>> 
    @param SObjectList List<SObject> to be process and group.
    @param keyGroup fieldApiName wich data was group.
    @return a Map<String, List<SObject>> whith information about List of record group according the code.
    */
    private static   Map<String, List<SObject>> getMapRecords(List<SObject> SObjectList,String keyGroup) {
        Map<String, List<SObject>> dataMap=new  Map<String, List<SObject>>();
            for (SObject sObj : SObjectList) {
                   String code=String.valueOf(sObj.get(keyGroup));
                   if (dataMap.containsKey(code)) {
                        dataMap.get(code).add(sObj);
                   } else {
                       List<SObject> sOjList=new  List<SObject>();
                        sOjList.add(sObj);
                        dataMap.put(code,sOjList);
                   }
        } 
        return dataMap;
    } 

}