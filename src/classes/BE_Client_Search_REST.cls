/**
----------------------------------------------------------------------------------------------------
@Name <BE_SearchClient_REST>
@Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
@Date 2020-02-24
@Description Class to invoke REST Service called "ListBusiness"
@Changes
    Date        Author   Email                  Type        
    2020-02-24  LMBR     lolo.bravo@bbva.com    Creation   
----------------------------------------------------------------------------------------------------
*/
public without sharing class BE_Client_Search_REST {
    
    /** clientRequest variable */
    ClientRequest_Wrapper clientRequest {set;get;}
    /**
    @Description privet constructor.
    @param Class Param wich contains the mininum information of Non Client
    */
    public BE_Client_Search_REST(Params param) {
        clientRequest=new ClientRequest_Wrapper(param);
    }

    /**
    @Description serialize object type ClientRequest_Wrapper in JSON
    @return JSON
    */
    public String generateJSONRequest() {
        return JSON.serialize(this.clientRequest);
    }

    /**
    @Description invoke API REST called "ListBusiness"
    @return System.HttpResponse
    */
    public System.HttpResponse invoke() {
        return iaso.GBL_Integration_GenericService.invoke('ListClients', generateJSONRequest());
    }

    /**
    @Description parse the response of API REST when it's success
    @param json wich contains the body response of API REST
    @return  ClientResponseSuccess_Wrapper
    */
    public ClientResponseSuccess_Wrapper parseSuccess(String json) {
        return (ClientResponseSuccess_Wrapper) System.JSON.deserialize(json, ClientResponseSuccess_Wrapper.Class);
    }

    /**
    @Description parse the response of API REST when it's error
    @param json wich contains the body response of API REST
    @return  ClientResponseError_Wrapper
    */
    public ClientResponseError_Wrapper parseError(String json) {
        return (ClientResponseError_Wrapper) System.JSON.deserialize(json, ClientResponseError_Wrapper.Class);
    }

    /**
    -------------------------------------------------------------------------------------------------
    @Name <ClientRequest_Wrapper>
    @Description Wrapper Class for the resquest API REST
    -------------------------------------------------------------------------------------------------
     */
    public class ClientRequest_Wrapper {
        /** attribute */
        public String documentType {set;get;}
        /** attribute */
        public String documentNumber {set;get;}
        /** constructor */
        public ClientRequest_Wrapper(Params param) {
            documentType=param.documentType;
            documentNumber=param.documentNumber;
        }
    }
    
    /**
    -------------------------------------------------------------------------------------------------
    @Name <ClientResponseSuccess_Wrapper>
    @Description Wrapper Class for the reponse to API REST when it's success
    -------------------------------------------------------------------------------------------------
    */
    public class ClientResponseSuccess_Wrapper {
        /** List Data */
        public List<Data> data {set;get;}
    }
    /**
    -------------------------------------------------------------------------------------------------
    @Name <ClientResponseSuccess_Wrapper>
    @Description Wrapper Class for the reponse to API REST when it's error
    -------------------------------------------------------------------------------------------------
    */
    public class ClientResponseError_Wrapper {
        /** attribute */ public Integer version {set;get;}
        /** attribute */ public String severity {set;get;}
        /** attribute */ public Integer httpstatus {set;get;}
        /** attribute */ public String errorcode {set;get;}
        /** attribute */ public String errormessage {set;get;}
        /** attribute */ public String consumerrequestid {set;get;}
        /** attribute */ public String systemerrorcode {set;get;}
        /** attribute */ public String systemerrordescription {set;get;}
        /** attribute */ public String systemerrorcause {set;get;}
    }
    /**
    -------------------------------------------------------------------------------------------------
    @Name <Params>
    @Description Wrapper Class Params
    -------------------------------------------------------------------------------------------------
    */
    public class Params {
        @AuraEnabled
        /** attribute */ public String documentType {set;get;}
        /** attribute */ public String documentNumber {set;get;}
    }

    /** JSON STRUCTURE
    -------------------------------------------------------------------------------------------------
    @Name <BusinessDocumentType>
    @Description Wrapper Class BusinessDocumentType
    -------------------------------------------------------------------------------------------------
    */
    public class BusinessDocumentType {
        /** attribute */ public String id {set;get;}
        /** attribute */ public String name {set;get;}
    }
    /**
    -------------------------------------------------------------------------------------------------
    @Name <BusinessDocuments>
    @Description Wrapper Class BusinessDocuments
    -------------------------------------------------------------------------------------------------
    */
    public class BusinessDocuments {
        /** attribute */
        BusinessDocumentType businessDocumentType;
        /** attribute */
        String documentNumber;
    }

    /**
    -------------------------------------------------------------------------------------------------
    @Name <Bank>
    @Description Wrapper Class Bank
    -------------------------------------------------------------------------------------------------
    */
    public class Bank {
        /** attribute */
        BusinessDocumentType branch;
    }

    /**
    -------------------------------------------------------------------------------------------------
    @Name <AnnualSales>
    @Description Wrapper Class AnnualSales
    -------------------------------------------------------------------------------------------------
    */
    public class AnnualSales {
        /** attribute */
        Integer amount;
        /** attribute */
        String currencys;
    }

    /**
    -------------------------------------------------------------------------------------------------
    @Name <BusinessType>
    @Description Wrapper Class Parse
    -------------------------------------------------------------------------------------------------
    */
    public class BusinessType {
    }
    /**
    -------------------------------------------------------------------------------------------------
    @Name <Data>
    @Description Wrapper Class Parse
    -------------------------------------------------------------------------------------------------
    */
    public class Data {
        /** attribute */ public List<BusinessDocuments> businessDocuments {set;get;}
        /** attribute */ public String id {set;get;}
        /** attribute */ public Formation formation {set;get;}
        /** attribute */ public String membershipDate {set;get;}
        /** attribute */ public String legalName {set;get;}
        /** attribute */ public BusinessDocumentType businessGroup {set;get;}
        /** attribute */ public Bank bank {set;get;}
        /** attribute */ public Integer employeesNumber {set;get;}
        /** attribute */ public AnnualSales annualSales {set;get;}
        /** attribute */ public BusinessDocumentType economicActivity {set;get;}
    }
    /**
    -------------------------------------------------------------------------------------------------
    @Name <Formation>
    @Description Wrapper Class Parse
    -------------------------------------------------------------------------------------------------
    */
    public class Formation {
        /** attribute */ String dates;
        /** attribute */ BusinessDocumentType country;
        /** attribute */ BusinessType businessType;
    }
}