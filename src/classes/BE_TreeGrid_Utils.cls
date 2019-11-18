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
    /**@Description comma to join fields to SOQL*/
    final static String COMMMA=',';
    /**@Description Quotes*/
    final static String QUOTES='\'';
    /**@Description params to quotes*/
    final static String REFACTORPER='@@';
        
    
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
        final Map<String,String> sObjFieldsMap= new Map<String,String>();
        final SObjectType sObjType = Schema.getGlobalDescribe().get(sObjName);
        final List<Schema.SObjectField> mfields = sObjType.getDescribe().fields.getMap().values();
        for (Schema.SObjectField sObjFieldDescribe: mfields) {
        final String code=String.valueOf(sObjFieldDescribe.getDescribe().getName());
        final String type=String.valueOf(sObjFieldDescribe.getDescribe().getType()).toLowerCase();
        final String typeFinal=(type=='double')?'number':type;
        sObjFieldsMap.put(code, typeFinal);
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
    public static List<SObject> getSOQLData(String recordId,Params param) {
        final String query='SELECT ' +String.escapeSingleQuotes(param.sObjFields)+ ' FROM '+String.escapeSingleQuotes(param.sObjName)+' WHERE '+String.escapeSingleQuotes(param.filterSQOL).removeEndIgnoreCase('LIKE').replace(REFACTORPER,QUOTES);
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
    public static AggregateResult[] getSOQLGroupData(String recordId,Params params) {
        final String query='SELECT ' +String.escapeSingleQuotes(params.sObjFields)+ ' FROM '+String.escapeSingleQuotes(params.sObjName)+' WHERE '+String.escapeSingleQuotes(params.filterSQOL).removeEndIgnoreCase('LIKE').replace(REFACTORPER,QUOTES);
        System.debug('query'+query);
        return (AggregateResult[])Database.query(query);
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
    public static List<SObject> getSOQLDataWithIN(String recordId,Params params,List<Object> groupLabels) {
        final String typeField =String.valueOf(Schema.getGlobalDescribe().get(params.sObjName).getDescribe().fields.getMap().get(params.keyGroup).getDescribe().getType()).toLowerCase();
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
        final String query='SELECT ' +String.escapeSingleQuotes(params.sObjFields)+ ' FROM '+String.escapeSingleQuotes(params.sObjName)+' WHERE '+String.escapeSingleQuotes(params.keyGroup)+' IN: setGroup'+' AND ' +String.escapeSingleQuotes(params.filterSQOL).removeEndIgnoreCase('LIKE').replace(REFACTORPER,QUOTES);
        System.debug('query'+setGroup);
        return Database.query(query);
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
    public static List<Object> getGroupLabels(String recordId,Params params) {
        final Boolean isNumGroupShow=params.numGroupShow>0 && params.numGroupShow!=null?true:false;
        final List<Object> setGroup=new List<Object>();
        final Params paramSOQLGroup= new Params(params.sObjName, params.keyGroup,params.filterSQOLGroup);
        final AggregateResult[] groupedResults=getSOQLGroupData(recordId,paramSOQLGroup);
        if(isNumGroupShow) {
        final Integer numGShow=params.numGroupShow>0 && params.numGroupShow!=null && params.numGroupShow<=groupedResults.size()?params.numGroupShow:groupedResults.size();
        Integer count = 0;
        while (count < numGShow) {
                setGroup.add(groupedResults[count].get(params.keyGroup));
                count++;
        }
        } else {
             for(AggregateResult  aggRes:groupedResults) {
                 setGroup.add(aggRes.get(params.keyGroup));
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
        return sObjFields.contains(sObjField)?sObjFields:sObjFields+COMMMA+sObjField;
    }
    /**
    -------------------------------------------------------------------------------------------------
    @Name <Response>
    @Description Wrapper for params request.  
    -------------------------------------------------------------------------------------------------
     */
    public class Params {
        
       /** sObjName the ApiName of sObject to be search.*/ 
       @AuraEnabled public String sObjName {set;get;}
       /** sObjFields the ApiName of all fields to be search separate by COMMMA.*/   
       @AuraEnabled public String sObjFields {set;get;}
       /**keyField  the ApiName of the Identifier of the record.*/   
       @AuraEnabled public String keyField {set;get;}
       /**keyParentField the fieldApiName wich contains the code of the parent record.*/
       @AuraEnabled public String keyParentField {set;get;}
        /**filterSQOL filter of query. */
       @AuraEnabled public String filterSQOL {set;get;}
       /**fieldLevel fieldApiName that contains the level of the data. */
       @AuraEnabled public String fieldLevel {set;get;}
       /**field indicate request with dataGroup.*/
       @AuraEnabled public Boolean isHeaderGroup {set;get;}
       /** keyGroup   field to group.*/
       @AuraEnabled public String keyGroup {set;get;}
       /**filterSQOLGroup  filter of group query*/
       @AuraEnabled public String filterSQOLGroup {set;get;}
       /** formatDate the type of format of Date.*/
       @AuraEnabled public String formatDate {set;get;}
       /**fieldsHeaderGroup the ApiName of all fields to be search separate by COMMMA.*/
       @AuraEnabled public String fieldsHeaderGroup {set;get;}
       /**numGroupShow size of group labels to show.*/
       @AuraEnabled public Integer numGroupShow {set;get;}
       /**fieldOrder the ApiName of field to be order the record.*/
       @AuraEnabled public String fieldOrder {set;get;}
       /**public constructor without parametres*/
       public Params(String sObjName, String sObjFields,String filterSQOL) {
            this.sObjName=sObjName;
            this.sObjFields=sObjFields;
            this.filterSQOL=String.isNotBlank(filterSQOL)?filterSQOL:'';
        }
        
       /**public constructor without parametres*/
        public Params()	{
             this.keyField='Id';
             this.keyParentField='';
             this.filterSQOL='';
        }
    }
}