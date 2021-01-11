/**
----------------------------------------------------------------------------------------------------
@Name <BE_ModifyNonClientContact_REST>
@Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
@Date 2020-05-12
@Description Class BE_ModifyNonClientContact_REST 
@Changes
    Date        Author   Email                  Type        
    2020-05-12  LMBR     lolo.bravo@bbva.com    Creation   
----------------------------------------------------------------------------------------------------
*/
public with sharing class BE_NonClient_ModifyContact_REST {
    
    /**
    @Description call REST API to modify NonClient
    @param  Map<String, Object> placeholderMap 
    @return System.HttpResponse response
    */
    public System.HttpResponse invoke(Map<String, Object> placeholderMap) {
        return iaso.GBL_Integration_GenericService.invoke('ModifyNonBusinessContact', placeholderMap);
    }

    /** NonClientResponse_Wrapper Class */
    public class NonClientResponse_Wrapper {
        /** messages */
        List<Object> messages {set;get;}
    }
    /** Params Class */
    public class Params {
        /** Attribute */ public String firstName {get;set;}
        /** Attribute */ public String middleName {get;set;}
        /** Attribute */ public String lastName {get;set;}
        /** Attribute */ public String secondLastName {get;set;}
        /** Attribute */ public RoleType roleType {get;set;}
        /** Attribute */ public List<ContactDetails> contactDetails {get;set;}
        /** public constructor */
        public Params() {
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
        /** contact */
		public Contact contact {set;get;}
        /** Attribute */ 
        public Boolean isPreferential {set;get;}

        /** public constructor */
        public ContactDetails() {
            contact=new Contact();
        }
        /** public constructor */
        public ContactDetails (Boolean isPreferential,Contact contact) {
            this.isPreferential=isPreferential;
            this.contact=contact;
        }
	}
    /** RoleType Class */
	public class RoleType {
        /** Attribute */
        public String id {set;get;}
        /**  public constructor */
        public RoleType() {
            id='';
        }
    }
    /** IdentityDocument Class */
	public class IdentityDocument {
		/** Attribute */ public String documentNumber {get;set;}
        /** Attribute */ public RoleType documentType {get;set;}
    }
    /** Contact Class */
	public class Contact {
		/** Attribute */ public String username {get;set;}
		/** Attribute */ public String socialNetwork {get;set;}
        /** Attribute */ public String contactDetailType {get;set;}
        /** Attribute */ public String address {set;get;}
        /** Attribute */ public Boolean receivesNotifications {set;get;}
        /** Attribute */ public String numberSF {set;get;}
        /** Attribute */ public String regionalCode {set;get;}
        /** Attribute */ public String emailType {set;get;}
    }
    /** Location Class */
	public class Location {
		/** Attribute */ public String formattedAddress {set;get;}
	}
}