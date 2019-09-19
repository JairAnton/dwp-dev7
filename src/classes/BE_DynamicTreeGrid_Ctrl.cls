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
    @Description privet constructor.
    */
    private BE_DynamicTreeGrid_Ctrl() {
    }
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
        final Response response=new Response();
        final BE_TreeGrid_Utils.Params param=new BE_TreeGrid_Utils.Params(sObjName,sObjFields,keyField,keyParentField,filterSQOL,fieldLevel,isHeaderGroup,keyGroup, filterSQOLGroup, formatDate, fieldsHeaderGroup, numGroupShow, fieldOrder);
        try {
            response.isSuccess=true;
            response.sObjFieldsMap=BE_TreeGrid_Utils.getSObjectFields(param.sObjName);
            param.sObjFields=String.isNotBlank(param.fieldOrder)?BE_TreeGrid_Utils.joinSobjString(param.sObjFields, param.fieldOrder):param.sObjFields;
             if (isHeaderGroup) {
                final Boolean isNumGroupShow=param.numGroupShow>0 && param.numGroupShow!=null?true:false;
                response.periods=BE_TreeGrid_Utils.getGroupLabels(recordId, param.sObjName,param.keyGroup, param.filterSQOLGroup, param.numGroupShow);
                response.treeGridDataGroup=BE_TreeDataGroup_Helper.getTreeRecordsGroup(recordId,param,isNumGroupShow,response.periods);
                response.sizeData=response.TreeGridDataGroup.size();
                if (String.isNotBlank(param.formatDate)) {
                response.periods=getFormatDate(param.formatDate, response.periods);
                }
            } else {
            response.treeGridData=BE_TreeData_Helper.getTreeRecords(recordId, param);
            response.sizeData=response.treeGridData.size();        
            }
            System.debug('response'+response);
        } catch (Exception e) {
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

    /**
    -------------------------------------------------------------------------------------------------
    @Name <Response>
    @Description Wrapper Class for the reponse to lwc.  
    -------------------------------------------------------------------------------------------------
     */
    public with sharing class Response {
        /**Indicate if the transaction is Success*/
        @AuraEnabled
        public Boolean isSuccess {set;get;}
        /**Message to show in the front to final user*/
        @AuraEnabled
        public String message {set;get;}
        /**List of group Labels*/
        @AuraEnabled
        public List<Object> periods {set;get;}
        /**Size of the records*/
        @AuraEnabled
        public Integer sizeData {set;get;}
        /**Tree Data Group*/
        @AuraEnabled
        public Map<Integer, Map<String,List<SObject>>> treeGridDataGroup {set;get;}
        /**Tree Data without group*/
        @AuraEnabled
        public Map<Integer, Map<String,SObject>> treeGridData {set;get;}
        @AuraEnabled
        /**Map of sObjFields type*/
        public Map<String,String> sObjFieldsMap {set;get;}
    }
}