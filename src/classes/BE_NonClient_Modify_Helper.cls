/**
   ----------------------------------------------------------------------------------------------------
   @Name <BE_ModifyNonClient_Helper>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2020-02-24
   @Description Class BE_ModifyNonClient_Helper
   @Changes
    Date        Author   Email                  Type
    2020-02-24  LMBR     lolo.bravo@bbva.com    Creation
   ----------------------------------------------------------------------------------------------------
 */
public without sharing class BE_NonClient_Modify_Helper {
/** Non Client Exist in Alpha Code */
private static final String EXIST_CODE = 'EXISTENOCLIENTE';
/** Lang Code */
private static final List<String> LANG_CODE = new List<String> {'es','en_US'};
/** private constructor */
private BE_NonClient_Modify_Helper () {}
/**
   @Description call REST API to modify NonClient
   @param  Account acc
   @return Object type BE_SingleRelatedListModal_Ctr.Response Class
 */
public static BE_SingleRelatedListCRUD_Cls.Response  modifyNonClient(Account acc) {
	final Map<String,String>messages= new Map<String,String>();
	final BE_SingleRelatedListCRUD_Cls.Response res=new BE_SingleRelatedListCRUD_Cls.Response();
	final String nonClientCode=[SELECT non_client_code__c FROM Account WHERE Id=:acc.Id].non_client_code__c;
	if(EXIST_CODE.equals(nonClientCode)) {
		try {
			update acc;
			messages.put(LANG_CODE[0], 'No cliente actualizado correctamente');
			messages.put(LANG_CODE[1], 'Non Client updated successfull');
			res.isSuccess=true;
			res.message=messages.get(UserInfo.getLanguage());
		} catch (DmlException ex) {
			res.isSuccess=false;
			res.message=ex.getDmlMessage(0);
		}
	} else {
		final Map<String, Object>placeholderMap = placeholderGenerator(acc);
		final BE_NonClient_Modify_REST request=new BE_NonClient_Modify_REST();
		final System.HttpResponse response=request.invoke(placeholderMap);
		switch on response.getStatusCode() {
			when 204 {
				try {
					update acc;
					messages.put(LANG_CODE[0], 'No cliente actualizado correctamente');
					messages.put(LANG_CODE[1], 'Non Client updated successfull');
					res.isSuccess=true;
					res.message=messages.get(UserInfo.getLanguage());
				} catch (Exception ex) {
					messages.put(LANG_CODE[0], 'Error al actualizar, por favor revise los datos ingresados');
					messages.put(LANG_CODE[1], 'Error when try to update,please review the values inputted');
					res.isSuccess=false;
					res.message=messages.get(UserInfo.getLanguage());
				}
			}
			when 500 {
				messages.put(LANG_CODE[0], 'Servicio no disponible, intentar mas tarde.');
				messages.put(LANG_CODE[1], 'Service not available, try later please');
				res.isSuccess=false;
				res.message=messages.get(UserInfo.getLanguage());
			}
			when 400 {
				messages.put(LANG_CODE[0], 'Error al actualizar, por favor revise los datos ingresados');
				messages.put(LANG_CODE[1], 'Error when try to update,please review the values inputted');
				res.isSuccess=false;
				res.message=messages.get(UserInfo.getLanguage());
			}
			when else {
				messages.put(LANG_CODE[0], 'Error inesperado');
				messages.put(LANG_CODE[1], 'Error not expected');
				res.isSuccess=false;
				res.message=messages.get(UserInfo.getLanguage());
			}
		}
	}
	return res;
}
/**
   @Description update Account
   @param  Account acc
   @return Map<String, Object> with the nonClient
 */
private static Map<String, Object>placeholderGenerator (Account acc) {
	final String nonClientCode=[SELECT non_client_code__c FROM Account WHERE Id=:acc.Id].non_client_code__c;
	final Map<String, Object>placeholderMap=new Map<String, Object>();
	placeholderMap.put('nonClientCode', nonClientCode);
	final BE_NonClient_Modify_REST.NonClient nonClient=new BE_NonClient_Modify_REST.NonClient();
	/** LEGAL NAME */
	nonClient.legalName=acc.Name;
	/** BUSINESS DOCUMENT */
	final BE_NonClient_Modify_REST.BusinessDocuments ruc=new  BE_NonClient_Modify_REST.BusinessDocuments();
	ruc.businessDocumentType.id='RUC';
	ruc.documentNumber=acc.AccountNumber;
	ruc.isVerified=true;
	nonClient.businessDocuments.add(ruc);
	/** EMAIL */
	if(String.isNotBlank(acc.email__c)) {
		final BE_NonClient_Modify_REST.ContactDetails email=new  BE_NonClient_Modify_REST.ContactDetails();
		email.contact.contactDetailType='EMAIL';
		email.contact.address=acc.email__c;
		email.contact.receivesNotifications=true;
		nonClient.contactDetails.add(email);
	}
	/** EMAIL */
	if(String.isNotBlank(acc.Website)) {
		final BE_NonClient_Modify_REST.ContactDetails website=new  BE_NonClient_Modify_REST.ContactDetails();
		website.contact.contactDetailType='WEBSITE';
		website.contact.address=acc.Website;
		nonClient.contactDetails.add(website);
	}
	/** LAND LINE */
	if(String.isNotBlank(acc.other_phone_number__c)) {
		final BE_NonClient_Modify_REST.ContactDetails landLine=new  BE_NonClient_Modify_REST.ContactDetails();
		landLine.isPreferential=true;
		landLine.contact.contactDetailType='LANDLINE';
		landLine.contact.regionalCode=acc.phone_area_code__c;
		landLine.contact.numberSF=acc.other_phone_number__c;
		nonClient.contactDetails.add(landLine);
	}
	/**ADDRESS*/
	if(String.isNotBlank(acc.BillingStreet) && String.isNotBlank(acc.BillingCity) && String.isNotBlank(acc.BillingCountry)) {
		final BE_NonClient_Modify_REST.Addresses address=new  BE_NonClient_Modify_REST.Addresses();
		address.addressType.id='LEGAL';
		address.location.formattedAddress= acc.BillingStreet+acc.BillingCity+ acc.BillingCountry;
		nonClient.addresses.add(address);
	}
	final String jsonNonClient =JSON.serialize(nonClient, true);
	placeholderMap.put('nonClient', jsonNonClient);
	return placeholderMap;
}
}