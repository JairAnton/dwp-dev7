/**
   ----------------------------------------------------------------------------------------------------
   @Name <BE_CreateNonClient_Helper>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2020-02-24
   @Description Class helper to make logic wich call Class BE_CreateNonClient_REST and make
             logic for Non Client in Salesforce
   @Changes
    Date        Author   Email                  Type
    2020-02-24  LMBR     lolo.bravo@bbva.com    Creation
   ----------------------------------------------------------------------------------------------------
 */
public without sharing class BE_NonClient_Create_Helper {
/** key Header wich contains the code of NonClient */
private final static Map<String,String> KEY_HEADERS = new  Map<String,String> {'location'=>'location','warning' => 'responsewarningdescription'};
/** response */
static Response res;
/** private constructor */
private BE_NonClient_Create_Helper () {}
/**
   @Description create NonClient in API REST "CreateNonBusiness"
   @param  nonClient is record of NonClient type BE_CreateNonClient_REST.Params Class
   @return Response Class  with Non Client Record (Account) and state
 */
public static Response createNonClient(BE_NonClient_Create_REST.Params nonClient) {
	res=new Response();
	res.isExistNonClient=false;
	final BE_NonClient_Create_REST nonClientSrv=new BE_NonClient_Create_REST(nonClient);
	final System.HttpResponse response=nonClientSrv.invoke();
	System.debug(response.getBody());
    switch on response.getStatusCode() {
			when 204 {
				res.codeTrx=response.getHeader(KEY_HEADERS.get('location'));
				res.codeTrx=res.codeTrx.substringAfterLast('/');
				final Account acc=nonClient.acc;
				acc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Record_Type_Non_Client').getRecordTypeId();
				acc.OwnerId=UserInfo.getUserId();
				acc.non_client_code__c=res.codeTrx;
				res.isSuccess=true;
      }
      when 400 {
        res.isSuccess=false;
      }
      when 500 {
        res.isSuccess=false;
      }
    }
	return res;
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
/** Code Trx */
@AuraEnabled
public String codeTrx {set; get;}
/** AccountId */
@AuraEnabled
public String accId {set; get;}
}
}
