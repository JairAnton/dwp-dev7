/**
 * Handler of Trigger of the AccountContactRelation object.
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Julio Medellin               22/02/2018          Original version.<p />
 * Alberto Gómez                27/02/2018          Added updateValuesRelationInContact method.<p />
 *
 * @author Julio Medellin
 */
 public with sharing class AccountContactParentAssociation {
public static boolean uContact= true;

    /**
     * Method for set values in AccountContactRelation records.
     *
     * @param lstAccountContactRelation Account Contact Relation List.
     */
    public static void setValuesRelation(List<AccountContactRelation> lstAccountContactRelation) {
        List<AccountContactRelation> lstAccountContactRelationUpdated = new List<AccountContactRelation>();
        set<Id> Ids = new set<Id>();
        for(AccountContactRelation tempcont:lstAccountContactRelation)
            Ids.add(tempcont.contactId);
        Map<Id, Contact> mapContact = new Map<Id, Contact>([SELECT Id,
                                                            AccountId,
                                                            Account.ParentID,
                                                            prof_position_type__c,
                                                            other_prof_prosition_type__c,
                                                            decision_making_desc__c,
                                                            parent_account_prof_position_type__c,
                                                            parent_account_other_prof_prosition_type__c,
                                                            parent_account_decision_making_desc__c,
                                                            MobilePhone,
                                                            Email,
                                                            phone_1_area_code__c,
                                                            phone_2_area_code__c,
                                                            phone_1__c,
                                                            phone_2__c,
                                                            events_info_type__c,
                                                            Status_desc__c,
                                                            Description
                                                            FROM Contact
                                                            WHERE Id IN: Ids]);
        for(AccountContactRelation objAccountContactRelation : lstAccountContactRelation) {
           if(objAccountContactRelation.IsDirect) {
             AccountContactRelation objAccountContactRelation2  = new AccountContactRelation(
                    Id = objAccountContactRelation.Id,
                    prof_position_type__c = (objAccountContactRelation.AccountId != mapContact.get(objAccountContactRelation.contactId).Account.parentId) ? mapContact.get(objAccountContactRelation.contactId).prof_position_type__c : mapContact.get(objAccountContactRelation.contactId).parent_account_prof_position_type__c ,
                    other_prof_prosition_type__c = (objAccountContactRelation.AccountId != mapContact.get(objAccountContactRelation.contactId).Account.parentId) ? mapContact.get(objAccountContactRelation.contactId).other_prof_prosition_type__c : mapContact.get(objAccountContactRelation.contactId).parent_account_other_prof_prosition_type__c ,
                    decision_making_desc__c = (objAccountContactRelation.AccountId != mapContact.get(objAccountContactRelation.contactId).Account.parentId) ? mapContact.get(objAccountContactRelation.contactId).decision_making_desc__c : mapContact.get(objAccountContactRelation.contactId).parent_account_decision_making_desc__c,
                    MobilePhone__c=mapContact.get(objAccountContactRelation.contactId).MobilePhone,
                    Email__c=mapContact.get(objAccountContactRelation.contactId).Email,
                    phone_1_area_code__c=mapContact.get(objAccountContactRelation.contactId).phone_1_area_code__c,
                    phone_2_area_code__c=mapContact.get(objAccountContactRelation.contactId).phone_2_area_code__c,
                    phone_1__c=mapContact.get(objAccountContactRelation.contactId).phone_1__c,
                    phone_2__c=mapContact.get(objAccountContactRelation.contactId).phone_2__c,
                    events_info_type__c=mapContact.get(objAccountContactRelation.contactId).events_info_type__c,
                    Status_desc__c=mapContact.get(objAccountContactRelation.contactId).Status_desc__c,
                    Description__c=mapContact.get(objAccountContactRelation.contactId).Description
                    );
            lstAccountContactRelationUpdated.add(objAccountContactRelation2);
           }
           }

        update lstAccountContactRelationUpdated;

    }

    /**
     * Method for update Contact values according to AccountContactRelation updates.
     *
     * @param lstAccountContactRelation Account Contact Relation List.
     */
    public static void updateValuesRelationInContact(List<AccountContactRelation> lstAccountContactRelation) {
        List<Contact> lstContact = new List<Contact>();
        set<Id> Ids = new set<Id>();
        for(AccountContactRelation objAccountContactRelation1 : lstAccountContactRelation) {
           Ids.add(objAccountContactRelation1.ContactId);
        }
        if(!Ids.isEmpty()){
        lstContact=[SELECT Id, prof_position_type__c, other_prof_prosition_type__c, decision_making_desc__c
                            FROM Contact WHERE Id in:Ids];
        for(AccountContactRelation objAccountContactRelation : lstAccountContactRelation) {
            for(Contact objContact : lstContact) {
                if(objAccountContactRelation.IsDirect == TRUE && objAccountContactRelation.ContactId == objContact.id ) {
                    objContact.prof_position_type__c = objAccountContactRelation.prof_position_type__c;
                    objContact.other_prof_prosition_type__c = objAccountContactRelation.other_prof_prosition_type__c;
                    objContact.decision_making_desc__c = objAccountContactRelation.decision_making_desc__c;
                    objContact.MobilePhone=objAccountContactRelation.MobilePhone__c;
                    objContact.Email=objAccountContactRelation.Email__c;
                    objContact.phone_1_area_code__c=objAccountContactRelation.phone_1_area_code__c;
                    objContact.phone_2_area_code__c=objAccountContactRelation.phone_2_area_code__c;
                    objContact.phone_1__c=objAccountContactRelation.phone_1__c;
                    objContact.phone_2__c=objAccountContactRelation.phone_2__c;
                    objContact.events_info_type__c=objAccountContactRelation.events_info_type__c;
                    objContact.Status_desc__c=objAccountContactRelation.Status_desc__c;
                    objContact.Description=objAccountContactRelation.Description__c;

                }
            }

        }
           if(uContact){//esta variable es actualizada mediante otro Proceso
               update lstContact;
                }
        }
    }
	
	 /**
	 * Method for update Total_campos_obligatorios_llenos__c field of Account to AccountContactRelation.
	 *
	 * @param lstAccountContactRelation Account Contact Relation List.
	 */
	 public static void updateTotalRequiredFields(List<AccountContactRelation> lstAccountContactRelation) {
		 Set<Id> ids = new Set<Id>();
		 for(AccountContactRelation acr : lstAccountContactRelation) {
			 ids.add(acr.AccountId);
		 }
		 if(!ids.isEmpty()) {
			 Map<Id, Account> accMaps = new Map<Id, Account>();
			 for(AccountContactRelation acr : [SELECT Id, AccountId, Total_campos_obligatorios__c FROM AccountContactRelation WHERE AccountId IN : ids]) {
				 if(accMaps.containsKey(acr.AccountId)) {
					 if(accMaps.get(acr.AccountId).Total_campos_obligatorios_llenos__c < acr.Total_campos_obligatorios__c) {
						 accMaps.put(acr.AccountId, new Account(Id=acr.AccountId, Total_campos_obligatorios_llenos__c = acr.Total_campos_obligatorios__c));
					 }
				 }
				 else {
					 accMaps.put(acr.AccountId, new Account(Id=acr.AccountId, Total_campos_obligatorios_llenos__c = acr.Total_campos_obligatorios__c));
				 }
			 }
			 for(Id idAux : ids) {
				 if(!accMaps.containsKey(idAux)) {
					 accMaps.put(idAux, new Account(Id=idAux, Total_campos_obligatorios_llenos__c = null));
				 }
			 }
			 if(!accMaps.isEmpty()) {
				 update accMaps.values();
			 }
		 }
	 }

}
