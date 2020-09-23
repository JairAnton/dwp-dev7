/**
----------------------------------------------------------------------------------------------------
@Name <BE_NonClient_Search_Helper>
@Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
@Date 2020-02-24
@Description Class "BE_NonClient_Search_Helper"
@Changes
    Date        Author   Email                  Type        
    2020-07-21  LMBR     lolo.bravo@bbva.com    Creation   
----------------------------------------------------------------------------------------------------
*/
public with sharing class BE_NonClient_Search_Helper {
    /** StatusCode Code */
    private static final List<String> VISIT_LANGUAGE = new List<String> {'es','en_US'};
	/** messages */
    static Map<String,String> messages;
    /** private constructor*/
    private BE_NonClient_Search_Helper () {}
    /**
   @Description search NonClient in API REST "ListBusiness"
   @param  acc is Non Client record
   @return Response Class  with Non Client Record (Account)
    */
    public static Response searchNonClient(Account acc) {
        messages = new Map<String,String>();
        final Response res=new Response();
        //final BE_SearchNonClient_REST.Params paramClient=new BE_SearchClient_REST.Params();
        final Map<String, Object> placeholderMap = placeholderGenerator(acc);
        final BE_NonClient_Search_REST clientSrv=new BE_NonClient_Search_REST();
        final System.HttpResponse response=clientSrv.invoke(placeholderMap);
        System.debug('###responseNonsearchCliente####'+response);
        System.debug('###responseNonsearchBody####'+response.getBody());
        switch on response.getStatusCode() {
            when 200 {
                final BE_NonClient_Search_REST.Data dataRes = clientSrv.parseSuccess(response.getBody()).data[0];
                System.debug('####dataRes##'+dataRes);
                final Account nonClient=new Account(Name=dataRes.legalName,accountNumber=dataRes.businessDocuments.documentNumber,non_client_code__c=dataRes.id);
                res.isExistNonClient=true;
                res.isSuccess=true;
                res.acc=nonClient;
                messages.put(VISIT_LANGUAGE[0], 'No Cliente consultado correctamente');
            	messages.put(VISIT_LANGUAGE[1], 'Non Client searched successfull.');
                res.message=messages.get(UserInfo.getLanguage());
            }
            when 400 {
                res.isExistNonClient=false;
                res.isSuccess=true;         }
            when 500 {
               	messages.put(VISIT_LANGUAGE[0], 'Servicio no disponible');
            	messages.put(VISIT_LANGUAGE[1], 'Service not available');
                res.isExistNonClient=false;
                res.isSuccess=false;
                res.message=messages.get(UserInfo.getLanguage());
            }
            when else {
                messages.put(VISIT_LANGUAGE[0], 'Error inesperado');
            	messages.put(VISIT_LANGUAGE[1], 'Error not found');
                res.isExistNonClient=false;
                res.isSuccess=false;
                res.message=messages.get(UserInfo.getLanguage());
            }
        }
        return res;
    }

    /**
    @Description update Account
    @param  Account acc
    @return Map<String, Object> with the nonClient
    */
    private static Map<String, Object> placeholderGenerator (Account acc) {
	final Map<String, Object>placeholderMap=new Map<String, Object>();
    placeholderMap.put('documentNumber', acc.AccountNumber); 
    return placeholderMap;
    }
    /**
   -------------------------------------------------------------------------------------------------
   @Name <Response>
   @Description Wrapper Class for Response
   -------------------------------------------------------------------------------------------------
    */
    public without sharing class Response {
        /**Indicate if the transaction is Success*/
        @AuraEnabled
        public Boolean isSuccess {set; get;}
        /**Message to show in the front to final user*/
        @AuraEnabled
        public String message {set; get;}
        /**is Non Client exist in Salesforce, Altamira o Alpha */
        @AuraEnabled
        public Boolean isExistNonClient {set; get;}
        /**is Non Client exist in Salesforce, Altamira o Alpha */
        @AuraEnabled
        public Account acc {set; get;}
        /** public constructor */
        public Response () {
        	this.isExistNonClient=false;
        	this.isSuccess=false;
        }
    }
}