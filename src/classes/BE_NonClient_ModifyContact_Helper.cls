/**
   ----------------------------------------------------------------------------------------------------
   @Name <BE_ModifyNonClientContact_Helper>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2020-05-12
   @Description Class BE_ModifyNonClientContact_Helper
   @Changes
    Date        Author   Email                  Type
    2020-05-12  LMBR     lolo.bravo@bbva.com    Creation
   ----------------------------------------------------------------------------------------------------
 */
public without sharing class BE_NonClient_ModifyContact_Helper {
/** Lang Code */
private static final List<String> LANG_CODE = new List<String> {'es','en_US'};
/** messages */
static Map<String,String> messages;
/** private constructor */
private BE_NonClient_ModifyContact_Helper () {
}
/**
   @Description call REST API to modify NonClientContact
   @param  SObject sObj
   @return BE_SingleRelatedListCRUD_Cls.Response response
 */
public static BE_SingleRelatedListCRUD_Cls.Response  modifyNonClientContact(SObject sObj) {
	final BE_SingleRelatedListCRUD_Cls.Response res=new BE_SingleRelatedListCRUD_Cls.Response();
	messages= new Map<String,String>();
	try {
		final Map<String, Object>placeholderMap= placeholderGenerator((AccountContactRelation)sObj);
		final BE_NonClient_ModifyContact_REST request=new BE_NonClient_ModifyContact_REST();
		final System.HttpResponse response=request.invoke(placeholderMap);
			switch on response.getStatusCode() {
				when 204 {
					update sObj;
					messages.put(LANG_CODE[0], 'Contacto actualizado correctamente');
					messages.put(LANG_CODE[1], 'Contact updated successfull');
					res.isSuccess=true;
					res.message=messages.get(UserInfo.getLanguage());
				}
				when 500 {
					messages.put(LANG_CODE[0], 'Servicio no disponible intentar mas tarde.');
					messages.put(LANG_CODE[1], 'Service not available, try later please.');
					res.isSuccess=false;
					res.message=messages.get(UserInfo.getLanguage());
				}
				when else {
					messages.put(LANG_CODE[0], 'Error al modificar el contacto');
					messages.put(LANG_CODE[1], 'Error when modified the contact');
					res.isSuccess=false;
					res.message=messages.get(UserInfo.getLanguage());
				}
			}
	} catch (DmlException ex) {
		res.isSuccess=false;
		res.message=ex.getDmlMessage(0);
	}
	return res;
}
/**
   @Description placeholderGenerator to organize params.
   @param  AccountContactRelation nonClientCon
   @return Map<String, Object> placeholderMap
 */
private static Map<String, Object>placeholderGenerator(AccountContactRelation nonClientCon) {
	final BE_NonClient_ModifyContact_REST.Params param=new BE_NonClient_ModifyContact_REST.Params();
	final AccountContactRelation nonClientConSOQL=[SELECT Contact.FirstName,Contact.LastName,Account.non_client_code__c,contact_code__c FROM AccountContactRelation WHERE Id=:nonClientCon.Id];
	final Map<String, Object>placeholderMap=new Map<String, Object>();
	placeholderMap.put('nonclientCode', nonClientConSOQL.Account.non_client_code__c);
	placeholderMap.put('contactCode', nonClientConSOQL.contact_code__c);
	/** ROLES */
	param.roleType.id='OTHERS';
	/** PHONE */
	final BE_NonClient_ModifyContact_REST.ContactDetails contactPhone=new  BE_NonClient_ModifyContact_REST.ContactDetails();
	contactPhone.contact.contactDetailType='MOBILE';
	contactPhone.contact.numberSF=nonClientCon.MobilePhone__c;
	contactPhone.contact.receivesNotifications=true;
	contactPhone.isPreferential=true;
	param.contactDetails.add(contactPhone);
	/** EMAIL */
	final BE_NonClient_ModifyContact_REST.ContactDetails contactEmail=new  BE_NonClient_ModifyContact_REST.ContactDetails();
	contactEmail.contact.contactDetailType='EMAIL';
	contactEmail.contact.address=nonClientCon.email__c;
	contactEmail.contact.receivesNotifications=true;
	param.contactDetails.add(contactEmail);
	/**LANDLINECONTACT ONE */
	if(String.isNotEmpty(nonClientCon.phone_1__c)) {
		final BE_NonClient_ModifyContact_REST.ContactDetails contactLandOne=new  BE_NonClient_ModifyContact_REST.ContactDetails();
		contactLandOne.contact.contactDetailType='LANDLINE';
		contactLandOne.contact.regionalCode=nonClientCon.phone_1_area_code__c;
		contactLandOne.contact.numberSF=nonClientCon.phone_1__c;
		param.contactDetails.add(contactLandOne);
	}
	/**LANDLINECONTACT ONE*/
	if(String.isNotEmpty(nonClientCon.phone_2__c)) {
		final BE_NonClient_ModifyContact_REST.ContactDetails contactLandTwo=new  BE_NonClient_ModifyContact_REST.ContactDetails();
		contactLandTwo.contact.contactDetailType='LANDLINE';
		contactLandTwo.contact.regionalCode=nonClientCon.phone_2_area_code__c;
		contactLandTwo.contact.numberSF=nonClientCon.phone_2__c;
		param.contactDetails.add(contactLandTwo);
	}
	/** Map placeholderMap */
	placeholderMap.put('firstName', nonClientConSOQL.Contact.FirstName);
	placeholderMap.put('lastName', nonClientConSOQL.Contact.LastName);
	placeholderMap.put('roleType',JSON.serialize(param.roleType,true));
	placeholderMap.put('contactDetails',JSON.serialize(param.contactDetails,true).replaceAll('numberSF', 'number'));
	return placeholderMap;
}
}