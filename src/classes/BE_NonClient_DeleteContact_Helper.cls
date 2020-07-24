/**
   ----------------------------------------------------------------------------------------------------
   @Name <BE_DeleteNonClientContact_Helper>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2020-05-12
   @Description Class BE_DeleteNonClientContact_Helper
   @Changes
    Date        Author   Email                  Type
    2020-05-12  LMBR     lolo.bravo@bbva.com    Creation
   ----------------------------------------------------------------------------------------------------
 */
public with sharing class BE_NonClient_DeleteContact_Helper {
/** Lang Code */
private static final List<String>LANG_CODE = new List<String> {'es','en_US'};
/** messages */
static Map<String,String> messages;
/** private constructor */
private BE_NonClient_DeleteContact_Helper () {}
/**
   @Description call REST API to delete contact of Non Client
   @param  String accConId
   @return BE_SingleRelatedListCRUD_Cls.Response response
 */
public static BE_SingleRelatedListCRUD_Cls.Response  deleteNonClientContact(String accConId) {
	final Map<String, Object>placeholderMap=new Map<String, Object>();
	messages= new Map<String,String>();
	final BE_SingleRelatedListCRUD_Cls.Response res=new BE_SingleRelatedListCRUD_Cls.Response();
	try {
			final AccountContactRelation nonClientCon=[SELECT Id,Account.non_client_code__c,contact_code__c FROM AccountContactRelation WHERE Id=:accConId];
			placeholderMap.put('nonclientCode',nonClientCon.Account.non_client_code__c);
			placeholderMap.put('contactCode', nonClientCon.contact_code__c);
			final BE_NonClient_DeleteContact_REST request=new BE_NonClient_DeleteContact_REST();
			final System.HttpResponse response=request.invoke(placeholderMap);
			switch on response.getStatusCode() {
				when 204 {
					delete nonClientCon;
					messages.put(LANG_CODE[0], 'Contacto eliminado correctamente');
					messages.put(LANG_CODE[1], 'Contact deleted successfull');
					res.isSuccess=true;
					res.message=messages.get(UserInfo.getLanguage());
				}
				when 500 {
					messages.put(LANG_CODE[0], 'Servicio no disponible, intentar mas tarde porfavor.');
					messages.put(LANG_CODE[1], 'Service not available, try later please.');
					res.isSuccess=false;
					res.message=messages.get(UserInfo.getLanguage());
				}
				when else {
					messages.put(LANG_CODE[0], 'Error al eliminar el contacto');
					messages.put(LANG_CODE[1], 'Error deleting contact');
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
}