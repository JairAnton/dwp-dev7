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
/** Response */
private static  BE_SingleRelatedListCRUD_Cls.Response res;
/** Message */
static Map<String,String> messages;
/** */
private static List<String> listMessages=new List<String>{'Contacto eliminado correctamente','Contact deleted successfull'}; 
/** private constructor */
private BE_NonClient_DeleteContact_Helper () {}
	/**
	  @Description call REST API to delete contact of Non Client
	  @param  String accConId
	  @return BE_SingleRelatedListCRUD_Cls.Response response
	*/
	public static BE_SingleRelatedListCRUD_Cls.Response  deleteNonClientContact(String accConId, Boolean isDML) {
		final Map<String, Object> placeholderMap=new Map<String, Object>();
		messages = new Map<String,String>();
		res=new BE_SingleRelatedListCRUD_Cls.Response();
		try {
				final AccountContactRelation nonClientCon=[SELECT Id,Account.non_client_code__c,contact_code__c,Account.RecordTypeId FROM AccountContactRelation WHERE Id=:accConId];
				final List<String> sObjNames=new List<String> {'Account'};
				final Map<String,Schema.RecordTypeInfo> recordType =BE_General_Utils.getRecordTypeInfo(sObjNames);
				final String rtNonClientId = recordType.get('Record_Type_Non_Client').getRecordTypeId();
				if(rtNonClientId.equals(nonClientCon.Account.RecordTypeId)) {
					placeholderMap.put('nonclientCode',nonClientCon.Account.non_client_code__c);
					placeholderMap.put('contactCode', nonClientCon.contact_code__c);
					final BE_NonClient_DeleteContact_REST request=new BE_NonClient_DeleteContact_REST();
					final System.HttpResponse response=request.invoke(placeholderMap);
					res=manageResponse(response,nonClientCon,isDML);
				} else {
					messages.put(LANG_CODE[0], listMessages[0]);
					messages.put(LANG_CODE[1], listMessages[1]);
					res.isSuccess=true;
					res.message=messages.get(UserInfo.getLanguage());
					delete nonClientCon;
				}
		} catch (DmlException ex) {
			res.isSuccess=false;
			res.message=ex.getDmlMessage(0);
		}
		return res;
	}
	/** manageResponse */
	private static BE_SingleRelatedListCRUD_Cls.Response manageResponse(System.HttpResponse response,AccountContactRelation nonClientCon,Boolean isDML) {
		messages= new Map<String,String>();
		res=new BE_SingleRelatedListCRUD_Cls.Response();
		switch on response.getStatusCode() {
			when 204 {
				if(isDML) {
					delete nonClientCon;
				}
				messages.put(LANG_CODE[0], listMessages[0]);
				messages.put(LANG_CODE[1], listMessages[1]);
				res.isSuccess=true;
				res.message=messages.get(UserInfo.getLanguage());
			}
			when 500 {
				messages.put(LANG_CODE[0], 'Servicio no disponible, intentar mas tarde porfavor.');
				messages.put(LANG_CODE[1], 'Service not available, try later please.');
				res.isSuccess=false;
				res.message=messages.get(UserInfo.getLanguage());
			}
			when 400 {
				final String responsewarning=response.getHeader('responsewarningdescription');
				if(isDML && responsewarning=='NO EXISTE EL CONTACTO') {
					delete nonClientCon;
					messages.put(LANG_CODE[0], listMessages[0]);
					messages.put(LANG_CODE[1], listMessages[1]);
					res.isSuccess=true;
					res.message=messages.get(UserInfo.getLanguage());
				} else if(responsewarning=='NO EXISTE EL CONTACTO' && isDML==false) {
					messages.put(LANG_CODE[0], listMessages[0]);
					messages.put(LANG_CODE[1], listMessages[1]);
					res.isSuccess=true;
					res.message=messages.get(UserInfo.getLanguage());
				} else {
					messages.put(LANG_CODE[0], 'Error al eliminar el contacto');
					messages.put(LANG_CODE[1], 'Error deleting contact');
					res.isSuccess=false;
					res.message=messages.get(UserInfo.getLanguage());
				}
			}
			when else {
				messages.put(LANG_CODE[0], 'Error al eliminar el contacto');
				messages.put(LANG_CODE[1], 'Error deleting contact');
				res.isSuccess=false;
				res.message=messages.get(UserInfo.getLanguage());
			}
		}
		return res;
	}
}
