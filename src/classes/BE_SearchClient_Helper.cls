/**
----------------------------------------------------------------------------------------------------
@Name <BE_SearchClient_Helper>
@Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
@Date 2020-02-24
@Description Class for logic in Salesforce when Call API REST called "ListBusiness".
@Changes
    Date        Author   Email                  Type        
    2020-02-24  LMBR     lolo.bravo@bbva.com    Creation   
----------------------------------------------------------------------------------------------------
*/
public without sharing class BE_SearchClient_Helper {
    /** response */
    static Response res;
    /**
    @Description search NonClient in Salesforce (DWP-PE) with similar RUC
    @param  accNumber is Non Client RUC
    @return Response Class  with Non Client Record (Account)
    */
    public static Response searchClienteSF(String accNumber){
        res=new Response();
        final List<Account> accLst=[SELECT Id,Name,RecordType.Name,OwnerId,Owner.Name,AccountNumber FROM ACCOUNT WHERE  AccountNumber=:accNumber];
        if(accLst.size()>0){
            res.acc=accLst[0];
            res.isSuccess=true;
        }
        return res;
    }
    
    /**
    @Description search NonClient in API REST "ListBusiness"
    @param  acc is Non Client record
    @return Response Class  with Non Client Record (Account)
    public static Response searchCliente(Account acc) {
        final String ERROR_EXIST_ACC='PERSONA INEXISTENTE';
        res=new Response();
    	BE_SearchClient_REST.Params paramClient=new BE_SearchClient_REST.Params();
    	paramClient.documentType='RUC';
    	paramClient.documentNumber=acc.AccountNumber;
    	BE_SearchClient_REST clientSrv=new BE_SearchClient_REST(paramClient);
        System.HttpResponse response=clientSrv.invoke();
        System.debug('CLIENT RESPONSE');
        System.debug(response.getBody());
        final String json=response.getBody();
    	if(response.getStatusCode()==409) {
            BE_SearchClient_REST.ClientResponseError_Wrapper error=clientSrv.parseError(json.replace('-', ''));
            System.debug('error.errormessage');
            System.debug(error.errormessage.trim());
            res.isSuccess=(error.errormessage==ERROR_EXIST_ACC)?true:false;
            res.isExistNonClient=false;
        }else if (response.getStatusCode()==200) {
            BE_SearchClient_REST.ClientResponseSuccess_Wrapper data=clientSrv.parseSuccess(json);
            res.acc=new Account(Name=data.data[0].legalName);
            res.isExistNonClient=true;
            res.isSuccess=true;
            System.debug('DATA');
            System.debug(res);
        }
        return res;
    }
    */
    
    /**
    @Description validate RUC of NonClient
    @param  accNumber is RUC of NonClient 
    @return Boolean (is valid or not)
    */
    public static Boolean validateRUC(String accNumber){
        Boolean isRucValid=false;
        //Integer currentNumber=Integer.valueOf(accNumber);
        List<String> rucTypes=new List<String>{'10','15','16','17','20'};
        for(String itemRuc : rucTypes) {
            isRucValid=(itemRuc.startsWithIgnoreCase(itemRuc))?true:false;
        }
        isRucValid=(isRucValid==true && accNumber.length()==11 && accNumber.isNumeric())?true:false;
        System.debug('RUC');
        System.debug(isRucValid);
        return isRucValid;
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
        public Response () {
            this.isExistNonClient=false;
            this.isSuccess=false;
        }
    }
}