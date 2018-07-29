public class ReasignButtonClass {
    @AuraEnabled
    public static User start( Id recordId) {
        User lstUser = new User();
        try{
            Case cas = [Select Id, OwnerId from Case where Id =: recordId];
            
            lstUser = [Select id, Name from User where Id =: UserInfo.getUserId() AND Profile.Name =: Label.lblAnalistaProf AND  Id !=: cas.OwnerId];
        }catch(Exception e){
            return null;
        }
        return lstUser;
    }
    @AuraEnabled
    public static List <User> fetchUser(String searchKeyWord, Id recordId) {
        String searchKey = searchKeyWord + '%';
        Case cas = [Select Id, OwnerId from Case where Id =: recordId];
        List <User> returnList = new List <User> ();
        List <User> lstUser = [Select id, Name from User where Name LIKE: searchKey AND Profile.Name =: Label.lblAnalistaProf AND Id !=: cas.OwnerId order by Name DESC limit 5];
        
        for (User usr: lstUser) {
            returnList.add(usr);
        }
        return returnList;        
    }
    @auraenabled
    public static String reasignown (String IdCase, User recorduser){
        try{
            Case cas = [Select Id, OwnerId from Case where Id =: IdCase];
            if(recorduser!=null){
                cas.OwnerId = recorduser.Id;
                update cas;               
            }
            return 'Updated';
        }catch(Exception e){
            return e.getMessage(); 
        }        
    }
    
}