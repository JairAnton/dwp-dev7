/**
----------------------------------------------------------------------------------------------------
@Name <BE_NonClient_Ctr>
@Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
@Date 2020-02-24
@Description Class Controller for Validate and create NonClient with global Cmp NonClient
@Changes
    Date        Author   Email                  Type        
    2020-02-24  LMBR     lolo.bravo@bbva.com    Creation   
----------------------------------------------------------------------------------------------------
*/
global without sharing class BE_NonClient_Ctr implements nonc.NonClient_interface_prospect {
    
    /**
    @Description search NonClient in Salesforce (DWP-PE) with similar RUC
    @param  strSearchName is Non Client Name
    @param  strFieldNameCode is ApiName of Extrafield Validation (AccountNumber=RUC)
    @param  strFielValueCode is Value of Extrafield Validation (RUC)
    @return String  with List<WrapperAccount>
    */
    global static String checkDuplicateNonClients(String strSearchName,String strFieldNameCode,String strFielValueCode) {
        final BE_SearchClient_Helper.Response resClient=BE_SearchClient_Helper.searchClienteSF(strFielValueCode);
        List<WrapperAccount> lWrapper = new List<WrapperAccount>();
        if(resClient.isSuccess) {
            WrapperAccount wrpAcc=new WrapperAccount((String)resClient.acc.Id, resClient.acc.Name,(String)resClient.acc.OwnerId);
            wrpAcc.clientType=resClient.acc.AccountNumber;
            wrpAcc.code=resClient.acc.AccountNumber;
            wrpAcc.ownerName=resClient.acc.Owner.Name;
            lWrapper.add(wrpAcc);
        }
        return JSON.serialize(lWrapper);
    }
    
    /**
    -------------------------------------------------------------------------------------------------
    @Name <WrapperAccount>
    @Description Wrapper Class for duplicate NonClients
    -------------------------------------------------------------------------------------------------
    */
    global without sharing class  WrapperAccount {
       /** ownerName */
       public String ownerName  {set;get;}
       /** ownerLink */
       public String ownerLink  {set;get;}
       /** clientName */
       public String clientName {set;get;}
       /** clientLink */
       public String clientLink {set;get;}
       /** clientType */
       public String clientType {set;get;}
       /** country */
       public String country    {set;get;}
       /** code */
       public String code       {set;get;}

       /* Constructor */
       global WrapperAccount () {
            System.debug('Empty constructor');
       }

       /* Constructor whith params */
        global WrapperAccount (String clientID, String clientName, String ownerID) {
            this.clientLink   = '/lightning/r/Account/' + clientID + '/view';
            this.ownerLink    = '/lightning/r/User/' + ownerID + '/view';
            this.clientName   = clientName;
      }
    }
    
    /**
    @Description validate non client before save in Alpha DB and Salesforce.
    call API REST: ListBusiness,ListNonBusiness and CreateNonBusiness
    @param client sObject type Account wich contains the minimum information of NonClient
    @return  String type objRespuesta Class
    */
    @AuraEnabled
    global static String validateNonCliente(Account client) {
        Boolean isRucValid=BE_SearchClient_Helper.validateRUC(client.AccountNumber);
        ResultValidation objRespuesta =new ResultValidation();
        if(isRucValid) {
            objRespuesta.status='success';
            objRespuesta.message='The Non Client create successfull';
        } else {
            objRespuesta.status='error';
            objRespuesta.message='Please input a correct RUC format';
        }
        System.debug('JSON.serialize(objRespuesta)');
        System.debug(JSON.serialize(objRespuesta));
       return JSON.serialize(objRespuesta);
    }

    /** METHOD WITH CALL REST API */
    /*
    @AuraEnabled
    global static String validateNonCliente(Account client) {
        Boolean isRucValid=BE_SearchClient_Helper.validateRUC(client.AccountNumber);
        ResultValidation objRespuesta =new ResultValidation();
        if(isRucValid){
        final BE_SearchClient_Helper.Response resClient=BE_SearchClient_Helper.searchCliente(client);
        System.debug('resClient');
        System.debug(resClient);
        if(resClient.isExistNonClient==true && resClient.isSuccess){
            objRespuesta.status='warning';
            objRespuesta.message='Actualmente ya es un cliente';
        }else if (resClient.isExistNonClient==false && resClient.isSuccess) {
                BE_CreateNonClient_REST.Params param=new BE_CreateNonClient_REST.Params();
                param.acc=client;
                BE_CreateNonClient_Helper.Response res=BE_CreateNonClient_Helper.createNonClient(param);
                if(res.isSuccess){
                    objRespuesta.status='success';
                    objRespuesta.message='The Non Client create successfull';
                } else {
                    objRespuesta.status='error';
                    objRespuesta.message='Error when create Non Client, please try later or comunicate with your administrator';
                }
        }else{
            objRespuesta.status='error';
            objRespuesta.message='Error please try later';    
        }
        }else {
            objRespuesta.status='error';
            objRespuesta.message='Please input a correct RUC format';
        }
       return JSON.serialize(objRespuesta);
    }
    */
    /** wrapper to validate to validateNonCliente method and send response */
     global class ResultValidation {
       @AuraEnabled
       public String status                                  { get; set; }
       @AuraEnabled
       public String message                                 { get; set; }
     }
     /** lProspect has accounts on salforces database with equal unique identifier, mapUniqueIDAccount is a map with the unique identifier as a key and the client with the same identifier as the prospect */
     @AuraEnabled
     public static String checkConvertedClients(List<Account> lProspect, Map<String, Account> mapUniqueIDAccount){
       return '';
     }
}