/**
----------------------------------------------------------------------------------------------------
@Name <BE_CreateNonClient_REST>
@Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
@Date 2020-02-24
@Description Class to invoke REST Service called "CreateNonClient"
@Changes
    Date        Author   Email                  Type        
    2020-02-24  LMBR     lolo.bravo@bbva.com    Creation   
----------------------------------------------------------------------------------------------------
 */
public without sharing class BE_NonClient_Create_REST {
    /** nonClientRequest */
    NonClientRequest_Wrapper nonClientRequest {set;get;}
    /**
    @Description public constructor.
    @param Class Param wich contains the mininum information of Non Client
    */
    public BE_NonClient_Create_REST(Params param) {
        nonClientRequest=new NonClientRequest_Wrapper();
        nonClientRequest.legalName=param.acc.Name;
        nonClientRequest.documentNumber=param.acc.AccountNumber;
        nonClientRequest.phoneNumber=(param.acc.phone_area_code__c+param.acc.other_phone_number__c);
    }
    
    /**
    @Description serialize object type NonClientRequest_Wrapper in JSON
    @return JSON
    */
    public String generateJSONRequest() {
        return JSON.serialize(this.nonClientRequest);
    }
    /**
    @Description invoke API REST called "CreateNonClient"
    @return System.HttpResponse
    */
    public System.HttpResponse invoke() {
        return iaso.GBL_Integration_GenericService.invoke('CreateNonClient', generateJSONRequest());
    }
    
    /**
   -------------------------------------------------------------------------------------------------
   @Name <NonClientRequest_Wrapper>
   @Description Wrapper Class for the resquest API REST
   -------------------------------------------------------------------------------------------------
    */
    public class NonClientRequest_Wrapper {
        /** attribute */ public String legalName {set;get;}
        /** attribute */ public String documentNumber {set;get;}
        /** attribute */ public String phoneNumber {set;get;}
        /** public constructor */
        public NonClientRequest_Wrapper() {
            legalName='';
            documentNumber='';
            phoneNumber='';
        }
    }

    /**
   -------------------------------------------------------------------------------------------------
   @Name <NonClientResponse_Wrapper>
   @Description Wrapper Class for the reponse to API REST
   -------------------------------------------------------------------------------------------------
    */
    public class NonClientResponse_Wrapper {
       /** List of messages */
        List<Object> messages {set;get;}
    }
    /**
   -------------------------------------------------------------------------------------------------
   @Name <Params>
   @Description Wrapper Class Params on sObject
   -------------------------------------------------------------------------------------------------
    */
    public class Params {
        /** Account */
        @AuraEnabled
        public Account acc {set;get;}
        /** Contact  */
        @AuraEnabled
        public Contact con {set;get;}
    }
}