/**
----------------------------------------------------------------------------------------------------
@Name <BE_NonClient_CreateContact_REST>
@Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
@Date 2020-05-13
@Description Class to invoke REST Service called "NonClientCreateContact"
@Changes
    Date        Author   Email                  Type        
    2020-05-13  LMBR     lolo.bravo@bbva.com    Creation   
----------------------------------------------------------------------------------------------------
 */
public without sharing class BE_NonClient_CreateContact_REST {

    /**
    @Description invoke API REST called "CreateNonClientContact"
    @param placeholderMap params.
    @return System.HttpResponse response.
    */
    public System.HttpResponse invoke(Map<String, Object> placeholderMap) {
        return iaso.GBL_Integration_GenericService.invoke('CreateNonBusinessContact', placeholderMap);
    }

    /**
    -------------------------------------------------------------------------------------------------
    @Name <CreateNonClientContactResponse_Wrapper>
    @Description Wrapper Class for the response API REST
    -------------------------------------------------------------------------------------------------
    */
    public class CreateNonClientContactResponse_Wrapper {
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
        /** attribute */ public String nonclientCode {get;set;}
        /** attribute */ public String firstName {get;set;}
        /** attribute */ public String middleName {get;set;}
        /** attribute */ public String lastName {get;set;}
        /** attribute */ public String secondLastName {get;set;}
        /** attribute */ public RoleType roleType {get;set;}
        /** attribute */ public List<ContactDetails> contactDetails {get;set;}
        /** public constructor */
        public Params() {
            nonclientCode='';
            firstName='';
            middleName='';
            lastName='';
            secondLastName='';
            roleType=new RoleType();
            contactDetails= new List<ContactDetails>();
        }
    }
    
    /** ContactDetails Class */
    public class ContactDetails {
		public Contact contact {set;get;}
        /** attribute */ 
        public Boolean isPreferential {set;get;}
        /** public constructor */
        public ContactDetails() {
            contact=new Contact();
        }
	}

    /** RoleType Class */
	public class RoleType {
        /** attribute */ public String id {set;get;}
        /** public constructor */
        public RoleType() {
            id='';
        }
    }

    /** IdentityDocument Class */
	public class IdentityDocument {
		/** attribute */ public String documentNumber {set;get;}
        /** attribute */ public RoleType documentType {set;get;}
    }
    
    /** Contact Class  */
	public class Contact {
		/** attribute */ public String username {get;set;}
		/** attribute */ public String socialNetwork {get;set;}
        /** attribute */ public String contactDetailType {get;set;}
        /** attribute */ public String address {set;get;}
        /** attribute */ public Boolean receivesNotifications {set;get;}
        /** attribute */ public String numberSF {set;get;}
        /** attribute */ public String regionalCode {set;get;}
        /** attribute */ public String emailType {set;get;}
	}

    /** Location Class */
	public class Location {
        /** attribute */
		public String formattedAddress {set;get;}
	}

}