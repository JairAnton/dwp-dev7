/**
----------------------------------------------------------------------------------------------------
@Name <BE_ModifyNonClient_REST>
@Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
@Date 2020-05-12
@Description Class BE_ModifyNonClient_REST 
@Changes
    Date        Author   Email                  Type        
    2020-05-12  LMBR     lolo.bravo@bbva.com    Creation   
----------------------------------------------------------------------------------------------------
*/
public without sharing class BE_NonClient_Modify_REST {
    
    /**
    @Description call REST API to modify NonClient
    @param  Map<String, Object> placeholderMap 
    @return System.HttpResponse response
    */
    public System.HttpResponse invoke(Map<String, Object> placeholderMap) {
        return iaso.GBL_Integration_GenericService.invoke('ModifyNonClient', placeholderMap);
    }
    
    /** NonClient Class */
    public class NonClient {
	    /** attribute */ public String legalName {set;get;}
	    /** attribute */ public Formation formation {set;get;}
	    /** attribute */ public List<BusinessDocuments> businessDocuments {set;get;}
	    /** attribute */ public List<ContactDetails> contactDetails {set;get;}
        /** attribute */ public List<Addresses> addresses {set;get;}
        /** public constructor */
        public NonClient () {
            businessDocuments=new List<BusinessDocuments>();
            contactDetails= new List<ContactDetails>();
            addresses= new List<Addresses> ();
        }
    }
    /** Formation Class */
	public class Formation {
		/** attribute */ public String dateSF {set;get;}
		/** attribute */ public Country country {set;get;}
    }
    /** BusinessDocuments Class */
	public class BusinessDocuments {
		/** attribute */ public Country businessDocumentType {set;get;}
        /** attribute */ public String documentNumber {set;get;}
        /** attribute */ public Boolean isVerified {set;get;}
        /** public constructor */
        public BusinessDocuments () {
            businessDocumentType=new Country();
        }
    }
    /** ContactDetails Class */
    public class ContactDetails {
		/** attribute */ public String id {set;get;}
		/** attribute */ public Boolean isPreferential {get;set;}
        /** attribute */ public Contact contact {set;get;}
        /** public contructor */
        public ContactDetails () {
            contact=new Contact();
        }
    }
    /** Contact Class */
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
    /** Addresses Class */
    public class Addresses {
		/** attribute */ public Boolean isPreferential {set;get;}
		/** attribute */ public Country addressType {set;get;}
        /** attribute */ public Location location {set;get;}
        /** public constructor */
        public Addresses () {
            addressType=new Country();
            location= new Location();
        }
    }
    /** Location Class */
    public class Location {
        /** attribute */ public String formattedAddress {set;get;}
        /** public constructor */
        public Location () {
            this.formattedAddress='';
        }
    }
    /** Country Class */
    public class Country {
        /** attribute */
		public String id {set;get;}
	}
}