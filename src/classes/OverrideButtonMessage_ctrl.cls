public with sharing class OverrideButtonMessage_ctrl {
	@AuraEnabled
	public static Map<String, Object> getInfo(String sObjectStr) {
		Map<String, Object> mapReturn = new Map<String, Object>();
		mapReturn.put('data', [SELECT Id,
		                       Body_Label_API__c,
		                       Title_Label_API__c,
		                       Button_Label_API_Agree__c,
		                       Button_Label_API_Cancel__c,
		                       Object_Api_Name_to_Redirect__c,
		                       DeveloperName,
		                       object_api_name__c
		                       FROM Override_Standard_Button_Message__mdt
		                       WHERE object_api_name__c = : sObjectStr]);
		return mapReturn;
	}
}
