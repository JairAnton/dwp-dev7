public without sharing class BE_NotUIAPIForm_Ctr {
    //Get Lookup Records
    @AuraEnabled(cacheable=true)
    public static List<sObject> findLookupRecords(String searchTerm, string myObject, String filter) {
        String myQuery = null;
        if(filter != null && filter != ''){
            myQuery = 'Select Id, Name from '+myObject+' Where Name Like  \'%' + searchTerm + '%\' AND '+filter+' LIMIT  5';
        }
        else {
            if(searchTerm == null || searchTerm == ''){
                myQuery = 'Select Id, Name from '+myObject+' Where LastViewedDate != NULL ORDER BY LastViewedDate DESC LIMIT  5';
            }
            else {
                myQuery = 'Select Id, Name from '+myObject+' Where Name Like  \'%' + searchTerm + '%\' LIMIT  5';
            }
        }
        List<sObject> lookUpList = database.query(myQuery);
        return lookUpList;
    }
    //Get Record By Id
    @AuraEnabled(cacheable=false)
    public static SObject lookUpById(String recordId, string objName, String fields) {
        Integer limitNum = 20;
        String finalQuery = 'SELECT ' + fields + ' FROM ' + objName;
        finalQuery += ' WHERE Id =  \'' + recordId + '\'';
        List<SObject> lookUpList = database.query(finalQuery);
        return lookUpList[0];  
    }
    //Get Record By Id
    @AuraEnabled(cacheable=true)
    public static List<List<SObject>> findRelatedToLookup(String searchTerm, string filters) {
        Integer limitNum = 10;
        String query = 'FIND \'' + searchTerm + '*\' RETURNING ' + filters + ' LIMIT ' + limitNum;
        List<List <SObject>> searchList = search.query(query);
        return searchList;
    }
}