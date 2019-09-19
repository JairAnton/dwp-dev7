/**
----------------------------------------------------------------------------------------------------
@Name <BE_TreeGrid_Utils>
@Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
@Date 2019-09-13
@Description Utils Class for generated dynamic Tree Data.
@Changes
Date        Author   Email                  Type        
2019-09-13  LMBR     lolo.bravo@bbva.com    Creation   
----------------------------------------------------------------------------------------------------
 */
public with sharing class BE_TreeGrid_Utils {
    /**
    @Description comma to join fields to SOQL
    */
    final static String COMMMA=',';
    /**
    @Description return a Map of String with type of all fields of sObject.
    */
    private BE_TreeGrid_Utils() {
    }
    /**
    @Description return a Map of String with type of all fields of sObject.
    @param sObjName the ApiName of sObject to be search.
    @return a Map<String,String> with information about the type of sObjectFields.
    */
    public static Map<String,String> getSObjectFields(String sObjName) {
        Map<String,String> sObjFieldsMap= new Map<String,String>();
        final SObjectType sObjType = Schema.getGlobalDescribe().get(sObjName);
        final List<Schema.SObjectField> mfields = sObjType.getDescribe().fields.getMap().values();
        for (Schema.SObjectField sObjFieldDescribe: mfields) {
        final String code=String.valueOf(sObjFieldDescribe.getDescribe().getName());
        final String type=String.valueOf(sObjFieldDescribe.getDescribe().getType()).toLowerCase();
        sObjFieldsMap.put(code, type);
        }
        return sObjFieldsMap;
    }

    /**
    @Description get information about dynamic sObject whith SOQL Dynamic.
    @recordId the recordId to be search or aplicate filter.
    @param sObjName the ApiName of sObject to be search.
    @param sObjFields the ApiName of all fields to be search separate by COMMMA.
    @param filterSQOL filter of query.
    @return a List<sObject> whith information about dynamic sObject.
    */
    public static List<SObject> getSOQLData(String recordId,String sObjName, String sObjFields,String filterSQOL) {
        final String query='SELECT ' +String.escapeSingleQuotes(sObjFields)+ ' FROM '+String.escapeSingleQuotes(sObjName)+' WHERE '+filterSQOL;
        System.debug('query'+query);
        return Database.query(query);
    }

    /**
    @Description  get information about dynamic sObject whith SOQL Dynamic with Group and ROLLSUP.
    @recordId the recordId to be search or aplicate filter.
    @param sObjName the ApiName of sObject to be search.
    @param sObjFields the ApiName of all fields to be search separate by COMMMA.
    @param filterSQOL filter of query
    @return a AggregateResult[] whith information about dynamic sObject.
    */
    public static AggregateResult[] getSOQLGroupData(String recordId,String sObjName, String sObjFields,String filterSQOL) {
        final String query ='SELECT ' +String.escapeSingleQuotes(sObjFields)+ ' FROM '+String.escapeSingleQuotes(sObjName)+' WHERE '+filterSQOL;
        return Database.query(query);
    }

    /**
    @Description  get information about dynamic sObject whith SOQL Dynamic with function IN: .
    @recordId the recordId to be search or aplicate filter.
    @param sObjName the ApiName of sObject to be search.
    @param sObjFields the ApiName of all fields to be search separate by COMMMA.
    @param filterSQOL filter of query.
    @param keyGroup   field to group.
    @param filterSQOLGroup  filter of group quey.
    @param groupLabels List of label of keyGroup.
    @return a List<sObject> whith information about dynamic sObject.
    */
    public static List<SObject> getSOQLDataWithIN(String recordId,String sObjName, String sObjFields,String filterSQOL,String keyGroup,List<Object> groupLabels) {
        final String typeField =String.valueOf(Schema.getGlobalDescribe().get(sObjName).getDescribe().fields.getMap().get(keyGroup).getDescribe().getType()).toLowerCase();
        List<Object> setGroup;
        switch on typeField {
            when 'date' {
                setGroup= new List<Date>();
                for (Object item : groupLabels) {
                    setGroup.add(Date.valueOf(item));
                }
            }
            when 'datetime' {
                setGroup=new List<Datetime>();
                for (Object item : groupLabels) {
                    setGroup.add(Datetime.valueOf(item));
                }
            }
            when 'string' {
                setGroup=new List<String>();
                for (Object item : groupLabels) {
                    setGroup.add(String.valueOf(item));
                }
            }
        }
        final String query='SELECT ' +String.escapeSingleQuotes(sObjFields)+ ' FROM '+String.escapeSingleQuotes(sObjName)+' WHERE '+String.escapeSingleQuotes(keyGroup)+' IN: setGroup'+' AND ' + filterSQOL;
        System.debug('query'+setGroup);
        final List<SObject> sObjectList=Database.query(query);
        return SObjectList;
    }
    
    /**
    @Description  get list of Labels with the keyGroup field.
    @recordId the recordId to be search or aplicate filter.
    @param sObjName the ApiName of sObject to be search.
    @param sObjFields the ApiName of all fields to be search separate by COMMMA.
    @param keyGroup   field to group.
    @param filterSQOLGroup  filter of group quey.
    @param numGroupShow number of group to show.
    @return a List<sObject> whith information about  labels of keyGroup.
    */
    public static List<Object> getGroupLabels(String recordId,String sObjName,String keyGroup,String filterSQOLGroup,Integer numGroupShow) {
        final Boolean isNumGroupShow=numGroupShow>0 && numGroupShow!=null?true:false;
        List<Object> setGroup=new List<Object>();
        final AggregateResult[] groupedResults=getSOQLGroupData(recordId, sObjName, keyGroup, filterSQOLGroup);
        if(isNumGroupShow) {
        final Integer numGShow=numGroupShow>0 && numGroupShow!=null && numGroupShow<=groupedResults.size()?numGroupShow:groupedResults.size();
        Integer count = 0;
        while (count < numGShow) {
                setGroup.add(groupedResults[count].get(keyGroup));
                count++;
        }
        } else {
             for(AggregateResult  aggRes:groupedResults) {
                 setGroup.add(aggRes.get(keyGroup));
             }
        }
        return setGroup;
    }

    /**
    @Description return String whith information about string of dynamic query and prevent SOQL Inyection
    @queryParam the param to aplicate the scope and single quotes
    @return a String with information sObjectField to be search in dynamic SOQL
     */
    public static String joinSobjString(String sObjFields,String sObjField) {
        final String targetField=sObjFields.contains(sObjField)?sObjFields:sObjFields+COMMMA+sObjField;
        return targetField;
    }

    /**
    -------------------------------------------------------------------------------------------------
    @Name <Response>
    @Description Wrapper for params request.  
    -------------------------------------------------------------------------------------------------
     */
    public class Params {
       /** @access:public  */   public String sObjName {set;get;}
       /** @access:public  */   public String sObjFields {set;get;}
       /** @access:public  */   public String keyField {set;get;}
       /** @access:public  */   public String keyParentField {set;get;}
       /** @access:public  */   public String filterSQOL{set;get;}
       /** @access:public  */   public String fieldLevel {set;get;}
       /** @access:public  */   public Boolean isHeaderGroup {set;get;}
       /** @access:public  */   public String keyGroup {set;get;}
       /** @access:public  */   public String filterSQOLGroup {set;get;}
       /** @access:public  */   public String formatDate {set;get;}
       /** @access:public  */   public String fieldsHeaderGroup {set;get;}
       /** @access:public  */   public Integer numGroupShow {set;get;}
       /** @access:public  */   public String fieldOrder   {set;get;}

        /**
        @Description constructor for Params Class.
        @param sObjName the ApiName of sObject to be search.
        @param sObjFields the ApiName of all fields to be search separate by COMMMA.
        @param keyField  the ApiName of the Identifier of the record.
        @param keyParentField the fieldApiName wich contains the code of the parent record.
        @param filterSQOL filter of query.
        @param fieldLevel fieldApiName that contains the level of the data.
        @param keyGroup   field to group.
        @param filterSQOLGroup  filter of group quey.
        @param formatDate the type of format of Date.
        @param fieldsHeaderGroup the ApiName of all fields to be search separate by COMMMA.
        @param numGroupShow size of group labels to show.
        @param fieldOrder the ApiName of field to be order the record.
         */
        public Params(String sObjName, String sObjFields, String keyField, String keyParentField, String filterSQOL, String fieldLevel, Boolean isHeaderGroup,String keyGroup,String filterSQOLGroup,String formatDate,String fieldsHeaderGroup,Integer numGroupShow,String fieldOrder) {
            this.sObjName=sObjName;
            this.sObjFields=sObjFields;
            this.keyField=String.isNotBlank(keyField)?keyField:'Id';
            this.keyParentField=String.isNotBlank(keyParentField)?keyParentField:'';
            this.filterSQOL=String.isNotBlank(filterSQOL)?filterSQOL:'';
            this.fieldLevel=fieldLevel;
            this.isHeaderGroup=isHeaderGroup;
            this.keyGroup=keyGroup;
            this.filterSQOLGroup=filterSQOLGroup;
            this.formatDate=formatDate;
            this.fieldsHeaderGroup=fieldsHeaderGroup;
            this.numGroupShow=numGroupShow;
            this.fieldOrder=fieldOrder;
        }
    }
}