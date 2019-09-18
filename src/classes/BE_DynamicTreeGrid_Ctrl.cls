/**
-------------------------------------------------------------------------------------------------
@Name <BE_DynamicTreeGrid_Ctrl>
@Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
@Date 2019-09-13
@Description Controller Class for generated dynamic tr Data.
@Changes
Date        Author   Email                  Type        
2019-09-13  LMBR     lolo.bravo@bbva.com    Creation   
-------------------------------------------------------------------------------------------------
 */
public with sharing class BE_DynamicTreeGrid_Ctrl {
    /**
    @Description make a Data like a innner Response Class.
    @recordId the recordId to be search or aplicate filter.
    @param sObjName the ApiName of sObject to be search.
    @param sObjFields the ApiName of all fields to be search separate by comma.
    @param keyField  the ApiName of the Identifier of the record.
    @param keyParentField the fieldApiName wich contains the code of the parent record.
    @param filterSQOL filter of query.
    @param fieldLevel fieldApiName that contains the level of the data.
    @param keyGroup   field to group.
    @param filterSQOLGroup  filter of group quey.
    @param formatDate the type of format of Date.
    @param fieldsHeaderGroup the ApiName of all fields to be search separate by comma.
    @param numGroupShow size of group labels to show.
    @param fieldOrder the ApiName of field to be order the record.
    @return a (Object)Response.
    */
    @AuraEnabled(cacheable=true)
    public static Response getDynamicResponse(String recordId, String sObjName, String sObjFields, String keyField, String keyParentField, String filterSQOL, String fieldLevel, Boolean isHeaderGroup,String keyGroup,String filterSQOLGroup,String formatDate,String fieldsHeaderGroup,Integer numGroupShow,String fieldOrder) {
        Response response=new Response();
        try {
            response.IsSuccess=true;
            response.sObjFieldsMap=BE_TreeGrid_Utils.getSObjectFields(sObjName);
            sObjFields=(String.isNotBlank(fieldOrder))?BE_TreeGrid_Utils.joinSobjString(sObjFields, fieldOrder):sObjFields;
             if (isHeaderGroup) {
                final Boolean isNumGroupShow=(numGroupShow>0 && numGroupShow!=null)?true:false;
                response.Periods=BE_TreeGrid_Utils.getGroupLabels(recordId, sObjName,keyGroup, filterSQOLGroup, numGroupShow);
                response.treeGridDataGroup=BE_TreeDataGroup_Helper.getTreeRecordsGroup(recordId, sObjName, sObjFields, keyField, keyParentField, filterSQOL, keyGroup, fieldLevel, filterSQOLGroup, formatDate, fieldsHeaderGroup, isHeaderGroup,isNumGroupShow,response.Periods);
                response.SizeData=response.TreeGridDataGroup.size();
                if (String.isNotBlank(formatDate)) {
                response.Periods=getFormatDate(formatDate, response.Periods);
                }
            } else {
            response.treeGridData=BE_TreeData_Helper.getTreeRecords(recordId, sObjName, sObjFields, keyField, keyParentField, filterSQOL, fieldLevel);
            response.SizeData=response.TreeGridData.size();        
            }
        }
        catch (Exception e) {
            response.IsSuccess=false;
            System.debug('Error'+e.getMessage());
            response.Message='Error';
        }
        return response;
    }

    /**
    @Description formatDate with show in thw front with thw keyGroup field.
    @param formatDate the type of formatDate.
    @param groupLabels List of label of keyGroup.
    @return List<Object> with the GroupLabels was format.
    */
    private  static List<Object> getFormatDate(String formatDate,List<Object> groupLabels) {
        List<Object> targetGroupLabels=new List<Object>();
        for(Object obj: groupLabels) {
            final DateTime currentDate=(DateTime)obj;
            targetGroupLabels.add(currentDate.format(formatDate));
        }
        return targetGroupLabels;
    }

    public with sharing class Response {
        @AuraEnabled
        public Boolean IsSuccess{set;get;}
        @AuraEnabled
        public String Message {set;get;}
        @AuraEnabled
        public List<Object> Periods {set;get;}
        @AuraEnabled
        public Integer SizeData {set;get;}
        @AuraEnabled
        public Map<Integer, Map<String,List<SObject>>> TreeGridDataGroup {set;get;}
        @AuraEnabled
        public Map<Integer, Map<String,SObject>> TreeGridData {set;get;}
        @AuraEnabled
        public Map<String,String> sObjFieldsMap {set;get;}
    }

}