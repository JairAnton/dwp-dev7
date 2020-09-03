/**
   ----------------------------------------------------------------------------------------------------
   @Name <BE_NonClient_CreateContact_Helper>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2020-05-12
   @Description Class BE_NonClient_CreateContact_Helper
   @Changes
    Date        Author   Email                  Type
    2020-05-12  LMBR     lolo.bravo@bbva.com    Creation
   ----------------------------------------------------------------------------------------------------
 */
public without sharing class BE_NonClient_CreateContact_Helper {
/**key Header wich contains the code of Contact*/
final static String KEY_HEADER='location';
/** contactDetailType LANDLINE */
private static final String DETAIL_TYPELAN='LANDLINE';
/** Lang Code */
private static final List<String> LANG_CODE = new List<String> {'es','en_US'};
/** messages */
static Map<String,String> messages ;
/** private constructor */
private BE_NonClient_CreateContact_Helper () {
}
/**
   @Description call REST API to create contact of Non Client
   @param  AccountContactRelation nonClientCon
   @return BE_SingleRelatedListCRUD_Cls.Response response
 */
public static BE_SingleRelatedListCRUD_Cls.Response  createNonClientContactRel(AccountContactRelation nonClientCon) {
	final BE_SingleRelatedListCRUD_Cls.Response res=new BE_SingleRelatedListCRUD_Cls.Response();
	final Map<String, Object> placeholderMap=placeholderGeneratorAccConRel(nonClientCon);
    System.debug('##placeholderMap##'+placeholderMap);
	messages= new Map<String,String>();
	final Integer existCounter=[SELECT COUNT() FROM AccountContactRelation WHERE AccountId=:nonClientCon.AccountId AND ContactId=:nonClientCon.ContactId];
	if(existCounter==0) {
		final List<String> sObjNames=new List<String> {'Account'};
		final Map<String,Schema.RecordTypeInfo> recordType =BE_General_Utils.getRecordTypeInfo(sObjNames);
		final String rtNonClientId = recordType.get('Record_Type_Non_Client').getRecordTypeId();
		final Account nonClient=[SELECT RecordTypeId,Account.non_client_code__c FROM Account WHERE Id=:nonClientCon.AccountId];
		if(rtNonClientId.equals(nonClient.RecordTypeId)) {
			final BE_NonClient_CreateContact_REST request=new BE_NonClient_CreateContact_REST();
			final System.HttpResponse response=request.invoke(placeholderMap);
			switch on response.getStatusCode() {
				when 204  {
					try {
						final String contactCode=response.getHeader(KEY_HEADER);
						nonClientCon.contact_code__c=contactCode.substringAfterLast('/');
						insert nonClientCon;
						messages.put(LANG_CODE[0], 'Contacto creado correctamente');
						messages.put(LANG_CODE[1], 'Contact created successfully');
						res.isSuccess=true;
						res.message=messages.get(UserInfo.getLanguage());
						res.data.add(nonClientCon);
					} catch (DmlException ex) {
						res.isSuccess=false;
						res.message=ex.getDmlMessage(0);
					}
				}
				when 500 {
					messages.put(LANG_CODE[0], 'Servicio no disponible, intentar mas tarde.');
					messages.put(LANG_CODE[1], 'Service not available, try later please.');
					res.isSuccess=false;
					res.message=messages.get(UserInfo.getLanguage());
				}
				when else {
					messages.put(LANG_CODE[0], 'Error al crear la relación del contacto con el no cliente en la base de datos');
					messages.put(LANG_CODE[1], 'Error when creating contact in the data base.');
					res.isSuccess=false;
					res.message=messages.get(UserInfo.getLanguage());
				}
			}
		} else {
			insert nonClientCon;
			messages.put(LANG_CODE[0], 'Contacto creado correctamente');
			messages.put(LANG_CODE[1], 'Contact created successfully');
			res.isSuccess=true;
			res.message=messages.get(UserInfo.getLanguage());
			res.data.add(nonClientCon);	
		}
	} else {
		messages.put(LANG_CODE[0], 'El no cliente ya tiene una relación con el contacto');
		messages.put(LANG_CODE[1], 'There are relationship with the contact');
		res.isSuccess=false;
		res.message=messages.get(UserInfo.getLanguage());
	}
	return res;
}
/**
   @Description call REST API to modify NonClientContact
   @param  SObject sObj
   @return BE_SingleRelatedListCRUD_Cls.Response response
 */
public static BE_SingleRelatedListCRUD_Cls.Response  createNonClientContact(Contact contact,String accId, Boolean isDML) {
	final BE_SingleRelatedListCRUD_Cls.Response res=new BE_SingleRelatedListCRUD_Cls.Response();
	messages= new Map<String,String>();
	try {
			final Map<String, Object> placeholderMap=placeholderGeneratorContact(contact,accId);
			final BE_NonClient_CreateContact_REST request=new BE_NonClient_CreateContact_REST();
			final System.HttpResponse response=request.invoke(placeholderMap);
        	System.debug('###response###'+response);
			switch on response.getStatusCode() {
				when 204  {
					final String contactCode=response.getHeader(KEY_HEADER);
					contact.AccountId=accId;
					contact.contact_code__c=contactCode.substringAfterLast('/');
					if(isDML) {
						insert contact;
					}
					messages.put(LANG_CODE[0], 'Contacto creado correctamente');
					messages.put(LANG_CODE[1], 'Contact created successfully');
					res.isSuccess=true;
					res.message=messages.get(UserInfo.getLanguage());
					res.data.add(contact);
				}
				when 500 {
					messages.put(LANG_CODE[0], 'Servicio no disponible, intentar mas tarde.');
					messages.put(LANG_CODE[1], 'Service not available, try later please.');
					res.isSuccess=false;
					res.message=messages.get(UserInfo.getLanguage());
				}
				when else {
					messages.put(LANG_CODE[0], 'Error al crear el contacto en la base de datos');
					messages.put(LANG_CODE[1], 'Error when creating contact in the data base');
					res.isSuccess=false;
					res.message=messages.get(UserInfo.getLanguage());
				}
			}
	} catch (DMLException ex) {
		res.isSuccess=false;
		res.message=ex.getDmlMessage(0);
        System.debug('Exception'+ex.getDmlMessage(0));
	}
	return res;
}
    
/**
   @Description placeholderGenerator to organize params.
   @param  AccountContactRelation nonClientCon
   @return Map<String, Object> placeholderMap
 */
private static Map<String, Object> placeholderGeneratorAccConRel(AccountContactRelation nonClientCon) {
	final Account nonClient=[SELECT Account.non_client_code__c FROM Account WHERE Id=:nonClientCon.AccountId];
	final Contact con=[SELECT LastName, FirstName FROM Contact WHERE Id=:nonClientCon.ContactId];
	final BE_NonClient_CreateContact_REST.Params param=new BE_NonClient_CreateContact_REST.Params();
	/** ROLES */
	param.roleType.id='OTHERS';
	/** PHONE */
	final BE_NonClient_CreateContact_REST.ContactDetails contactPhone=new  BE_NonClient_CreateContact_REST.ContactDetails();
	contactPhone.contact.contactDetailType='MOBILE';
	contactPhone.contact.numberSF=nonClientCon.MobilePhone__c;
	contactPhone.contact.receivesNotifications=true;
	contactPhone.isPreferential=true;
	param.contactDetails.add(contactPhone);
	/** EMAIL */
	final BE_NonClient_CreateContact_REST.ContactDetails contactEmail=new  BE_NonClient_CreateContact_REST.ContactDetails();
	contactEmail.contact.contactDetailType='EMAIL';
	contactEmail.contact.address=nonClientCon.email__c;
	contactEmail.contact.receivesNotifications=true;
	param.contactDetails.add(contactEmail);
	/**LANDLINECONTACT ONE */
	if(String.isNotEmpty(nonClientCon.phone_1__c)) {
		final BE_NonClient_CreateContact_REST.ContactDetails contactLandOne=new  BE_NonClient_CreateContact_REST.ContactDetails();
		contactLandOne.contact.contactDetailType=DETAIL_TYPELAN;
		contactLandOne.contact.regionalCode=nonClientCon.phone_1_area_code__c;
		contactLandOne.contact.numberSF=nonClientCon.phone_1__c;
		param.contactDetails.add(contactLandOne);
	}
	/**LANDLINECONTACT ONE*/
	if(String.isNotEmpty(nonClientCon.phone_2__c)) {
		final BE_NonClient_CreateContact_REST.ContactDetails contactLandTwo=new  BE_NonClient_CreateContact_REST.ContactDetails();
		contactLandTwo.contact.contactDetailType=DETAIL_TYPELAN;
		contactLandTwo.contact.regionalCode=nonClientCon.phone_2_area_code__c;
		contactLandTwo.contact.numberSF=nonClientCon.phone_2__c;
		param.contactDetails.add(contactLandTwo);
	}
	/** Map placeholderMap */
	final Map<String, Object>placeholderMap=new Map<String, Object>();
	placeholderMap.put('nonclientCode', nonClient.non_client_code__c);
	placeholderMap.put('firstName', con.FirstName);
	placeholderMap.put('lastName', con.LastName);
	placeholderMap.put('roleType',JSON.serialize(param.roleType,true));
	placeholderMap.put('contactDetails',JSON.serialize(param.contactDetails,true).replaceAll('numberSF', 'number'));
	return placeholderMap;
}
/**
   @Description placeholderGenerator to organize params.
   @param  Contact contact
   @param  String accId
   @return Map<String, Object> placeholderMap
 */
private static Map<String, Object> placeholderGeneratorContact(Contact contact,String accId) {
	final Account nonClient=[SELECT Account.non_client_code__c FROM Account WHERE Id=:accId];
	final BE_NonClient_CreateContact_REST.Params param=new BE_NonClient_CreateContact_REST.Params();
	/** ROLES */
	param.roleType.id='OTHERS';
	/** PHONE */
	final BE_NonClient_CreateContact_REST.ContactDetails contactPhone=new  BE_NonClient_CreateContact_REST.ContactDetails();
	contactPhone.contact.contactDetailType='MOBILE';
	contactPhone.contact.numberSF=contact.Phone;
	contactPhone.contact.receivesNotifications=true;
	contactPhone.isPreferential=true;
	param.contactDetails.add(contactPhone);
	/** EMAIL */
	final BE_NonClient_CreateContact_REST.ContactDetails contactEmail=new  BE_NonClient_CreateContact_REST.ContactDetails();
	contactEmail.contact.contactDetailType='EMAIL';
	contactEmail.contact.address=contact.Email;
	contactEmail.contact.receivesNotifications=true;
	param.contactDetails.add(contactEmail);
	/**LANDLINECONTACT ONE */
	if(String.isNotEmpty(contact.phone_1__c)) {
		final BE_NonClient_CreateContact_REST.ContactDetails contactLandOne=new  BE_NonClient_CreateContact_REST.ContactDetails();
		contactLandOne.contact.contactDetailType=DETAIL_TYPELAN;
		contactLandOne.contact.regionalCode=contact.phone_1_area_code__c;
		contactLandOne.contact.numberSF=contact.phone_1__c;
		param.contactDetails.add(contactLandOne);
	}
	/**LANDLINECONTACT ONE*/
	if(String.isNotEmpty(contact.phone_2__c)) {
		final BE_NonClient_CreateContact_REST.ContactDetails contactLandTwo=new  BE_NonClient_CreateContact_REST.ContactDetails();
		contactLandTwo.contact.contactDetailType=DETAIL_TYPELAN;
		contactLandTwo.contact.regionalCode=contact.phone_2_area_code__c;
		contactLandTwo.contact.numberSF=contact.phone_2__c;
		param.contactDetails.add(contactLandTwo);
	}
	/** Map placeholderMap */
	final Map<String, Object>placeholderMap=new Map<String, Object>();
	placeholderMap.put('nonclientCode', nonClient.non_client_code__c);
	placeholderMap.put('firstName', contact.FirstName);
	placeholderMap.put('lastName', contact.LastName);
	placeholderMap.put('roleType',JSON.serialize(param.roleType,true));
	placeholderMap.put('contactDetails',JSON.serialize(param.contactDetails,true).replaceAll('numberSF', 'number'));
	return placeholderMap;
}
}