public with sharing class Hangout_ctrl {
    @AuraEnabled
    public static Map<String, String> getHangoutId() {
        Map<String, String> mapHangoutId = new Map<String, String>();
        //First, get the user's email
        String userEmail = UserInfo.getUserEmail();
        //Then find the '@' and put the domain away
        String userIdTag = userEmail.substring(0, userEmail.indexOf('@'));
        //After that, replace '.' with '_'
        userIdTag = userIdTag.replace('.', '_');
        //Add the Hangouts user name to the map
        mapHangoutId.put('HangoutId', userIdTag.left(15));

        //Finally, return the map to the Aura Component
        return mapHangoutId;
    }
}