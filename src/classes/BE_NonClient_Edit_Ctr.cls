/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_EditNonClient_Ctr>
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-03-13
   @Description constructor for BE_EditNonClient_Cmp component
   @Changes
   Date        Author   Email                  				Type
   2020-03-13  MAMC     martin.mori.contractor@bbva.com    	Creation
   -------------------------------------------------------------------------------------------------
 */
public without sharing class BE_NonClient_Edit_Ctr {
/** mapReturn */
static Map<String,Object>mapReturn = new Map<String,Object>();
/** constructor */
private BE_NonClient_Edit_Ctr () {}
/**
   @Description get Metadata Config
   @param  nameMetadata DeveloperName of Metadata for QuickAction
   @return Map<String,Object>
 */
@AuraEnabled
public static Map<String,Object>getFields(String nameMetadata) {
	for(BE_SingleRelatedList_QuickAction__mdt mdt : [SELECT Id, Title__c,CustomFields__c, sObjectType__c, ClassName__c, ModeAction__c FROM BE_SingleRelatedList_QuickAction__mdt WHERE DeveloperName = :nameMetadata]) {
		mapReturn.put('title', mdt.Title__c);
		mapReturn.put('sObjectFields', JSON.deserializeUntyped(mdt.CustomFields__c));
		mapReturn.put('sObjectType', mdt.sObjectType__c);
		mapReturn.put('className', mdt.ClassName__c);
		mapReturn.put('modeAction', mdt.ModeAction__c);
	}
	return mapReturn;
}
/**
   @Description get Account
   @param  accId Id of the Account
   @param  sObjFields fields to Query
   @return Account
 */
@AuraEnabled
public static Account getNonClient(String accId, List<String>sObjFields) {
	final String query= 'SELECT '+ String.join(sObjFields, ',') + ' FROM Account WHERE Id=:accId';
	return Database.query(String.escapeSingleQuotes(query));
}
/**
   @Description update Account
   @param  sObjs Account sObject
   @return Object type BE_SingleRelatedListModal_Ctr.Response Class
 */
@AuraEnabled
public static Object updateNonClient(String sObjs) {
	final Account acc = (Account) JSON.deserialize(sObjs, Account.class);
	return BE_NonClient_Modify_Helper.modifyNonClient(acc);
}
}