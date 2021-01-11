/**
   -------------------------------------------------------------------------------------------------
   @Name BE_NotUIAPIForm_Ctr
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2021-01-08
   @Description
   @Changes
   Date        Author   Email                  				Type
   2021-01-08  MAMCH    martin.mori.contractor@bbva.com    	Creation
   -------------------------------------------------------------------------------------------------
 */
public without sharing class BE_NotUIAPIForm_Ctr {
    /**
    @Description return list record to search.
    @param String searchTerm text to search.
    @param String objName sObject to search.
    @param String filter filter of query.
    @return List<sObject> list of record.
    */
    @AuraEnabled(cacheable=true)
    public static List<sObject> findLookupRecords(String searchTerm, string objName) {
        String myQuery = null;
        if(searchTerm == null || searchTerm == ''){
            myQuery = 'Select Id, Name from '+String.escapeSingleQuotes(objName)+' Where LastViewedDate != NULL ORDER BY LastViewedDate DESC LIMIT  5';
        }
        else {
            myQuery = 'Select Id, Name from '+String.escapeSingleQuotes(objName)+' Where Name Like  \'%' + String.escapeSingleQuotes(searchTerm) + '%\' LIMIT  5';
        }
        final List<sObject> lookUpList = database.query(myQuery);
        return lookUpList;
    }
    
    /**
    @Description return record to search.
    @param String recordId id to search.
    @param String objName sObject to search.
    @param String fields fields to return.
    @return sObject record.
    */
    @AuraEnabled(cacheable=false)
    public static SObject lookUpById(String recordId, string objName, String fields) {
        final String finalQuery = 'SELECT ' + fields + ' FROM ' + objName + ' WHERE Id = :recordId';
        final List<SObject> lookUpList = database.query(String.escapeSingleQuotes(finalQuery));
        return lookUpList[0];  
    }
    
    /**
    @Description return list record to search.
    @param String searchTerm text to search.
    @param String filters sObjects to search.
    @return List<List<SObject>> list of records.
    */
    @AuraEnabled(cacheable=true)
    public static List<List<SObject>> findRelatedToLookup(String searchTerm, string filters) {
        final String query = 'FIND \'' + String.escapeSingleQuotes(searchTerm) + '*\' RETURNING ' + String.escapeSingleQuotes(filters) + ' LIMIT 10';
        final List<List <SObject>> searchList = search.query(query);
        return searchList;
    }
}