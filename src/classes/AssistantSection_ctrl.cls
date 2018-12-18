public with sharing class AssistantSection_ctrl {
 	@AuraEnabled
    public static Map<String,Object> getInfoContainer(String recordId){
        Map<String,Object> mapReturn = new Map<String,Object>();
        mapReturn.put('showSection',false);
        List<User> lstUser = [SELECT    Id,
                                        ProfileId,
                                        Profile.Name,
                                        prof_position_id__c
                                FROM User
                                WHERE Id = :recordId];
        List<User_Position_Mapping__mdt> lstPositionMapping = [SELECT   Id, 
                                                                        prof_position_id__c, 
                                                                        dwp_role__c, 
                                                                        profile__c 
                                                                FROM User_Position_Mapping__mdt 
                                                                WHERE dwp_role__c = 'Assistant' 
                                                                AND profile__c = 'Ejecutivo'
                                                                AND prof_position_id__c = :lstUser[0].prof_position_id__c];
        mapReturn.put('showSection','Ejecutivo' == lstUser[0].Profile.Name && lstPositionMapping.isEmpty());
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
        List<User_Position_Mapping__mdt> lstPositionMapping = [SELECT   Id, 
                                                                        prof_position_id__c, 
                                                                        dwp_role__c, 
                                                                        profile__c 
                                                                FROM User_Position_Mapping__mdt 
                                                                WHERE dwp_role__c = 'Assistant' 
                                                                AND profile__c = 'Ejecutivo'];
        List<User_Branch__c> lstUserBranch = [SELECT Id, branch_name__c FROM User_Branch__c WHERE User__c = :recordId];
        Set<String> setIdBranchs = new Set<String>();
        for(User_Branch__c branch : lstUserBranch){
            setIdBranchs.add(branch.branch_name__c);
        }


        Set<String> setCodePosition = new Set<String>();
        for(User_Position_Mapping__mdt posMap : lstPositionMapping){
            setCodePosition.add(posMap.prof_position_id__c);
        }
        String searchKey = searchKeyWord + '%';
        List <User> returnList = new List <User> ();
        List <User> lstUser = [SELECT   id, 
                                        Name,
                                        prof_position_id__c,
                                        Profile.Name,
                                        (SELECT Id, branch_name__c FROM Users_Branches__r)
                                FROM User 
                                WHERE Name LIKE: searchKey 
                                AND Profile.Name = 'Ejecutivo'
                                ORDER BY Name DESC];
        Integer limitList = 0;
        for(Integer i = 0; i<lstUser.size() && limitList<5; i++){
            User usr = lstUser[i];
            if(setCodePosition.contains(usr.prof_position_id__c)){
                Boolean flag = true;
                for(Integer j = 0; j<usr.Users_Branches__r.size() && flag; j++){
                    if(setIdBranchs.contains(usr.Users_Branches__r[j].branch_name__c)){
                        returnList.add(usr);
                        limitList++;
                        flag = false;
                    }
                }
            }
        }
        return returnList;        
    }

    @AuraEnabled
    public static Map<String,Object> saveAll(String recordId, List<String> lstNewAssistant, List<String> lstDeleteAssistant){

        Map<String,Object> mapReturn = new Map<String,Object>();

        if(!lstDeleteAssistant.isEmpty()){
            List<User_Assistant_Team__c> lstDelete = [SELECT Id FROM User_Assistant_Team__c WHERE Id IN :lstDeleteAssistant];
            if(!lstDelete.isEmpty())delete lstDelete;
        }
        
        if(!lstNewAssistant.isEmpty()){
            List<User_Assistant_Team__c> lstNow = [SELECT Id, user_id__c, assistant_id__c FROM User_Assistant_Team__c WHERE user_id__c = :recordId];
            Set<String> setIdAssistants = new Set<String>();
            for(User_Assistant_Team__c ustNow : lstNow){
                setIdAssistants.add(ustNow.assistant_id__c);
            }
            List<User_Assistant_Team__c> lstInsert = new List<User_Assistant_Team__c>();
            for(String assistantNew : lstNewAssistant){
                if(!setIdAssistants.contains(assistantNew)){
                    User_Assistant_Team__c userAssistant = new User_Assistant_Team__c();
                    userAssistant.user_id__c=recordId;
                    userAssistant.assistant_id__c=assistantNew;
                    lstInsert.add(userAssistant);
                    setIdAssistants.add(assistantNew);
                }
            }

            if(!lstInsert.isEmpty())insert lstInsert;
        }
        
        mapReturn.put('isOk',true);
        return mapReturn;
    }

    public class DataTable_wrapper{
        
        private String userId { get; set; }//Yulino 29/11/2018 : Se agregó el get y set
        private String userName { get; set; }//Yulino 29/11/2018 : Se agregó el get y set
        private String recordId { get; set; }//Yulino 29/11/2018 : Se agregó el get y set
        
        public DataTable_wrapper (String userId, String userName, String recordId){
            this.userId = '/' + userId;
            this.userName = userName;
            this.recordId = recordId;
        }
        
    }
    
    public AssistantSection_ctrl(){ //Yulino 29/11/2018 : Se agregó el constructor
    }
    
}