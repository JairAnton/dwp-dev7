/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_DynamicRelatedList_Ctr>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2019-01-13
   @Description Controller Class for generated dynamic Related List.
   @Changes
   Date        Author   Email                  Type
   2019-01-13  LMBR     lolo.bravo@bbva.com    Creation
   -------------------------------------------------------------------------------------------------
 */
public without sharing class BE_SingleRelatedList_Ctr {
/**@Description Quotes*/
final static String QUOTES='\'';
/**@Description params to quotes*/
final static String REFACTORPER='@@';
/**
   @Description privet constructor.
 */
private BE_SingleRelatedList_Ctr () {
}
/**
   @Description return a Map of String with type of all fields of sObject.
   @param sObjName the ApiName of sObject to be search.
   @return a Map<String,String> with information about the type of sObjectFields.
 */
@AuraEnabled(cacheable=false)
public static Object getDynamicResponse(String recordId,Params param) {
	BE_SingleRelatedListCRUD_Cls.Response res=new BE_SingleRelatedListCRUD_Cls.Response();
	try {
		if(String.isNotBlank((String)param.settings.get('readClassName'))) {
			final BE_SingleRelatedListCRUD_Cls singleClas=(BE_SingleRelatedListCRUD_Cls)Type.forName((String)param.settings.get('readClassName')).newInstance();
			final Map<String,Object>mapParams=new Map<String,Object> {'recordId'=>recordId,'sObjName'=>param.sObjName,'sObjFields'=>param.sObjFields,'filterSQOL'=>param.filterSQOL};
			res=singleClas.readRecords(mapParams);
		} else {
			res.isSuccess=true;
			res.message='Success';
			res.data=getSOQLData(recordId, param);
		}
	} catch (Exception e) {
		res.isSuccess=false;
		res.message='Error'+e.getMessage();
	}
	return res;
}
/**
   @Description return a Map of String with type of all fields of sObject.
   @param sObjName the ApiName of sObject to be search.
   @return a Map<String,String> with information about the type of sObjectFields.
 */
public static List<SObject>getSOQLData(String recordId,Params param) {
	final String query='SELECT ' +String.escapeSingleQuotes(param.sObjFields)+ ' ,CurrencyIsoCode FROM '+String.escapeSingleQuotes(param.sObjName)+' WHERE '+String.escapeSingleQuotes(param.filterSQOL).removeEndIgnoreCase('LIKE').replace(REFACTORPER,QUOTES);
	return Database.query(query);
}
/**
   @Description return a Map of String with type of all fields of sObject.
   @param sObjName the ApiName of sObject to be search.
   @return a Map<String,String> with information about the type of sObjectFields.
 */
@AuraEnabled
public static Object updateRecords(String recordId, List<SObject> sObjs,String className) {
	BE_SingleRelatedListCRUD_Cls.Response res=new BE_SingleRelatedListCRUD_Cls.Response();
	System.debug('sObjs');
	System.debug(sObjs);
	if(String.isNotBlank(className)) {
		final BE_SingleRelatedListCRUD_Cls singleClas=(BE_SingleRelatedListCRUD_Cls)Type.forName(className).newInstance();
		res=singleClas.updateRecords(sObjs);
	} else {
		try {
			update sObjs;
			res.isSuccess=true;
			res.message='Successfull';
			res.data=sObjs;
		} catch (Exception ex) {
			res.isSuccess=false;
			res.message=ex.getMessage();
		}
	}
	return res;
}
/**
   @Description return a Map of String with type of all fields of sObject.
   @param sObjName the ApiName of sObject to be search.
   @return a Map<String,String> with information about the type of sObjectFields.
 */
public static Map<String,String>getSObjectFields(String sObjName) {
	final Map<String,String>sObjFieldsMap= new Map<String,String>();
	final Schema.SObjectType sObjType = Schema.getGlobalDescribe().get(sObjName);
	final List<Schema.SObjectField>mfields = sObjType.getDescribe().fields.getMap().values();
	for(Schema.SObjectField sObjFieldDescribe: mfields) {
		final String code=String.valueOf(sObjFieldDescribe.getDescribe().getName());
		final String type=String.valueOf(sObjFieldDescribe.getDescribe().getType()).toLowerCase();
		final String typeFinal=(type=='double') ? 'number' : type;
		sObjFieldsMap.put(code, typeFinal);
	}
	return sObjFieldsMap;
}
/**
   @Description return about setting metadata
   @param nameMetaData developerName
   @return a List<SObject> with information setting metadata
 */
@AuraEnabled(cacheable=true)
public static Object getConfigMeta(String nameMetaData) {
	return [SELECT Id,sObjectApiName__c,Columns__c,HeadActions__c,FieldsQuery__c,Filter__c,NumberRows__c,Settings__c FROM BE_SingleRelatedList_Setting__mdt WHERE DeveloperName=: nameMetaData];
}
/**
   -------------------------------------------------------------------------------------------------
   @Name <Response>
   @Description Wrapper Class for the reponse to lwc.
   -------------------------------------------------------------------------------------------------
 */
public without sharing class Response {
/**Indicate if the transaction is Success*/
@AuraEnabled
public Boolean isSuccess {set; get;}
/**Message to show in the front to final user*/
@AuraEnabled
public String message {set; get;}
/**List of Sobject*/
@AuraEnabled
public List<SObject>data {set; get;}
/**Map of sObjFields type*/
@AuraEnabled
public Map<String,String>sObjFieldsMap {set; get;}
}
/**
   -------------------------------------------------------------------------------------------------
   @Name <Params>
   @Description Wrapper for params request.
   -------------------------------------------------------------------------------------------------
 */
public class Params {
/** sObjName the ApiName of sObject to be search.*/
@AuraEnabled public String sObjName {set; get;}
/** sObjFields the ApiName of all fields to be search separate by COMMMA.*/
@AuraEnabled public String sObjFields {set; get;}
/**filterSQOL filter of query. */
@AuraEnabled public String filterSQOL {set; get;}
/* Extra Settings */
@AuraEnabled public Map<String,Object>settings {set; get;}
}
}