/**
   ----------------------------------------------------------------------------------------------------
   @Name <BE_CreateNonClientContact_Ctr>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2020-02-24
   @Description Class  for Create Contact of Non Client
   @Changes
    Date        Author   Email                  Type
    2020-02-24  LMBR     lolo.bravo@bbva.com    Creation
   ----------------------------------------------------------------------------------------------------
 */
public without sharing class BE_NonClient_CreateContact_Ctr {
/** private constructor */
private BE_NonClient_CreateContact_Ctr () {}
/**
   @Description get Contact in SF.
   @param searchKey to find Contact in SF.
   @return  List<ContactFront> contacts.
 */
@AuraEnabled
public static List<ContactFront> getContacts (String searchKey) {
	final List<List<Contact>>searchList = [FIND :searchKey IN ALL FIELDS RETURNING Contact ( Name,Email,MobilePhone,Account.Name) LIMIT 1000];
	final List<ContactFront>contacts=new List<ContactFront>();
	ContactFront targetCurrent;
	// Create the account URL from the base URL.
	final String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
	for(Contact con : searchList[0]) {
		targetCurrent=new ContactFront();
		targetCurrent.id=con.Id;
		targetCurrent.name=con.Name;
		targetCurrent.nameUrl=sfdcBaseURL+con.Id;
		targetCurrent.accountName=con.Account.Name;
		targetCurrent.accountUrl=sfdcBaseURL+con.AccountId;
		targetCurrent.phone=con.MobilePhone;
		targetCurrent.email=con.Email;
		contacts.add(targetCurrent);
	}
	return contacts;
}
/**
   @Description update Account
   @param  sObjs Account sObject
   @return Object type BE_SingleRelatedListModal_Ctr.Response Class
 */
@AuraEnabled
public static Object createNonClientContact(String sObjs, String sObjType,String recordId) {
	BE_SingleRelatedListCRUD_Cls.Response res= new BE_SingleRelatedListCRUD_Cls.Response();
	System.debug(sObjs);
	switch on sObjType {
		when 'Contact' {
			res=BE_NonClient_CreateContact_Helper.createNonClientContact((Contact)JSON.deserialize(sObjs,Contact.Class),recordId,true);
		}
		when 'AccountContactRelation' {
			res=BE_NonClient_CreateContact_Helper.createNonClientContactRel((AccountContactRelation)JSON.deserialize(sObjs,AccountContactRelation.Class));
		}
	}
	return res;
}
/**
   @Description get Metadata Config
   @param  nameMetadata DeveloperName of Metadata for QuickAction
   @return Map<String,Object>
 */
@AuraEnabled
public static Map<String,Object>getMetadata(String nameMetadata) {
	final Map<String,Object>mapReturn = new Map<String,Object>();
	for(BE_SingleRelatedList_QuickAction__mdt mdt : [SELECT Id, Title__c,CustomFields__c, sObjectType__c, ClassName__c, ModeAction__c FROM BE_SingleRelatedList_QuickAction__mdt WHERE DeveloperName = :nameMetadata]) {
		mapReturn.put('title', mdt.Title__c);
		mapReturn.put('sObjectFields',JSON.deserializeUntyped(mdt.CustomFields__c));
		mapReturn.put('sObjectType', mdt.sObjectType__c);
		mapReturn.put('className', mdt.ClassName__c);
		mapReturn.put('modeAction', mdt.ModeAction__c);
	}
	return mapReturn;
}
/**
   -------------------------------------------------------------------------------------------------
   @Name <ContactFront>
   @Description Wrapper Class ContactFront on Contact
   -------------------------------------------------------------------------------------------------
 */
public class ContactFront {
/** Attribute */
@AuraEnabled
public String id {set; get;}
/** Attribute */
@AuraEnabled
public String name {set; get;}
/** Attribute */
@AuraEnabled
public String email {set; get;}
/** Attribute */
@AuraEnabled
public String phone {set; get;}
/** Attribute */
@AuraEnabled
public String accountName {set; get;}
/** Attribute */
@AuraEnabled
public String nameUrl {set; get;}
/** Attribute */
@AuraEnabled
public String accountUrl {set; get;}
}
}