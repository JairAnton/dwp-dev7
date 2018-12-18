global without sharing class Header_helper implements iaso.GBL_Integration_Headers{
    //method to add input information in the header
    global static System.HttpRequest modifyRequest(System.HttpRequest requestWS){
        List<User> lstUser = [SELECT Id, user_id__c FROM User WHERE Id = :UserInfo.getUserId()];
        requestWS.setHeader('back-clientdocument', (lstUser[0].user_id__c!=null?lstUser[0].user_id__c:''));
        return requestWS;
    }
}