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
    /**Varible to storage List<Sobject>*/
    static List<SObject> sObjectList;
    /**CurrencyIsoCode ApiName*/
    final static String CURRENCYISOCODE='CurrencyIsoCode';
    /**@Description private constructor.*/
    private BE_TreeDataGroup_Helper() {
    }
    
    /**
    @Description make a Data in Map according the level.
    @param recordId to be search.
    @param params Object wich contains parameters.
    @param groupLabels List of labels to the group field.
    @return a Map<Integer, Map<String,List<SObject>>> whith information about Data in cluster in levels.
    */
    public static Map<Integer, Map<String,List<SObject>>> getTreeRecordsGroup(String recordId,BE_TreeGrid_Utils.Params params,Boolean isNumGroupShow, List<Object> groupLabels) {
        Map<Integer, Map<String,List<SObject>>> treeGridData=new Map<Integer, Map<String,List<SObject>>>();
        params.sObjFields=assingSObjFields(params);
        if(isNumGroupShow) {
            sObjectList=BE_TreeGrid_Utils.getSOQLDataWithIN(recordId, params,groupLabels);
        } else {
            sObjectList=BE_TreeGrid_Utils.getSOQLData(recordId,params);
        }
        final Map<String, List<SObject>> dataMap=getMapRecords(sObjectList,params.keyGroup);
        for (String codeKey : dataMap.keySet()) {
               treeGridData=makeStructureDataGroup(dataMap.get(codeKey),treeGridData,params);
        }
        return treeGridData;
    }

    /**
    @Description make a Data in Map according the level.
    @param SObjectList the list of sObject to be structure.
    @param sObjDataMap the Map of structure Date in cluster according the level.
    @param params Object wich contains parameters.
    @return a Map<Integer, Map<String,List<SObject>>> whith information about Data in cluster in levels.
    */
    private static Map<Integer, Map<String,List<SObject>>> makeStructureDataGroup(List<SObject> sObjectList,Map<Integer, Map<String,List<SObject>>> sObjDataMap,BE_TreeGrid_Utils.Params params) {
        Map<String,List<SObject>> sObjMap;
        List<SObject> sObjLst;
        for(SObject item:sObjectList) {
            final Integer level=String.isNotBlank(params.fieldLevel)?Integer.valueOf(item.get(params.fieldLevel)):(String.isNotBlank((String)item.get(params.keyParentField)))?1:0;
            final String code =(String)item.get(params.keyField);
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
    private static   Map<String, List<SObject>> getMapRecords(List<SObject> sObjectList,String keyGroup) {
        Map<String, List<SObject>> dataMap=new  Map<String, List<SObject>>();
            for (SObject sObj : sObjectList) {
                   final String code=String.valueOf(sObj.get(keyGroup));
                   if (dataMap.containsKey(code)) {
                        dataMap.get(code).add(sObj);
                   } else {
                        final List<SObject> sOjList=new  List<SObject>();
                        sOjList.add(sObj);
                        dataMap.put(code,sOjList);
                   }
        } 
        return dataMap;
    } 
    
    /**
    @Description get information make a Data in Map according the level.
    @param params Object wich contains parameters.
    @return a Map<Integer, Map<String,List<SObject>>> whith information about Data in cluster in levels.
    */
    private static String assingSObjFields(BE_TreeGrid_Utils.Params param) {
        String targetSObjFields=param.sObjFields;
        targetSObjFields=BE_TreeGrid_Utils.joinSobjString(targetSObjFields,CURRENCYISOCODE);
        targetSObjFields=BE_TreeGrid_Utils.joinSobjString(targetSObjFields, param.keyField);
        targetSObjFields=BE_TreeGrid_Utils.joinSobjString(targetSObjFields, param.keyParentField);
        targetSObjFields=BE_TreeGrid_Utils.joinSobjString(targetSObjFields, param.keyGroup);
        targetSObjFields=BE_TreeGrid_Utils.joinSobjString(targetSObjFields, param.fieldsHeaderGroup);
        targetSObjFields=String.isNotBlank(param.fieldLevel)?BE_TreeGrid_Utils.joinSobjString(targetSObjFields, param.fieldLevel):targetSObjFields;
        return targetSObjFields;
    }

}