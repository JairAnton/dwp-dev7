public with sharing class AssistantSection_ctrl {
 	@AuraEnabled
    public static Map<String,Object> getInfoContainer(String recordId){
        Map<String,Object> mapReturn = new Map<String,Object>();
        mapReturn.put('showSection',false);
        List<User> lstUser = [SELECT    Id,
                                        ProfileId 
                                FROM User
                                WHERE Id = :recordId];
        List<Profile> lstProfile = [SELECT Id FROM Profile WHERE Name = 'Ejecutivo'];
        mapReturn.put('showSection',lstProfile[0].Id != lstUser[0].ProfileId);
        return mapReturn;
    }
    @AuraEnabled
    public static Map<String,Object> getInfo(String recordId){
        Map<String,Object> mapReturn = new Map<String,Object>(); 
        List<User_Assistant_Team__c> lstAssistant = [SELECT    Id, 
                                                                user_id__c, 
                                                                assistant_id__c, 
                                                                assistant_id__r.Name
                                                        FROM User_Assistant_Team__c 
                                                        WHERE user_id__c = :recordId];
        List<DataTable_wrapper> lstInfo = new List<DataTable_wrapper>();
        for(User_Assistant_Team__c assistant : lstAssistant){
            lstInfo.add(new DataTable_wrapper(assistant.assistant_id__c, assistant.assistant_id__r.Name, assistant.Id));
        }
        mapReturn.put('info',JSON.serialize(lstInfo));
        return mapReturn;
    }
    @AuraEnabled
    public static List <User> fetchUser(String searchKeyWord, Id recordId) {
        String searchKey = searchKeyWord + '%';
        List <User> returnList = new List <User> ();
        List <User> lstUser = [Select id, Name from User where Name LIKE: searchKey order by Name DESC limit 5];
        
        for (User usr: lstUser) {
            returnList.add(usr);
        }
        return returnList;        
    }

    @AuraEnabled
    public static Map<String,Object> deleteUsersAccount(List<String> lstIds){
        Map<String,Object> mapReturn = new Map<String,Object>();
        System.debug(lstIds);
        delete [SELECT    Id FROM User_Assistant_Team__c WHERE Id IN :lstIds]; 
        mapReturn.put('isOk',true);
        return mapReturn;
    }

    @AuraEnabled
    public static Map<String,Object> saveAll(String recordId, List<String> lstNewAssistant, List<String> lstDeleteAssistant){

        Map<String,Object> mapReturn = new Map<String,Object>();

        List<User_Assistant_Team__c> lstDelete = [SELECT Id FROM User_Assistant_Team__c WHERE Id IN :lstDeleteAssistant];
        if(!lstDelete.isEmpty())delete lstDelete;
        List<User_Assistant_Team__c> lstInsert = new List<User_Assistant_Team__c>();
        for(String assistantNew : lstNewAssistant){
            User_Assistant_Team__c userAssistant = new User_Assistant_Team__c();
            userAssistant.user_id__c=recordId;
            userAssistant.assistant_id__c=assistantNew;
            lstInsert.add(userAssistant);
        }

        if(!lstInsert.isEmpty())insert lstInsert;
        mapReturn.put('isOk',true);
        return mapReturn;
    }

    public class DataTable_wrapper{
        
        public String userId;
        public String userName;
        public String recordId;
        
        public DataTable_wrapper (String userId, String userName, String recordId){
            this.userId = '/' + userId;
            this.userName = userName;
            this.recordId = recordId;
        }
        
    }
}