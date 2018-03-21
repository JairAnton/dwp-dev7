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
        Map<Id, Contact> mapContact = new Map<Id, Contact>([SELECT Id, AccountId,Account.ParentID,prof_position_type__c, other_prof_prosition_type__c, decision_making_desc__c, parent_account_prof_position_type__c,parent_account_other_prof_prosition_type__c,parent_account_decision_making_desc__c   FROM Contact]);
        for(AccountContactRelation objAccountContactRelation : lstAccountContactRelation) {
           if(objAccountContactRelation.IsDirect == TRUE) {
             AccountContactRelation objAccountContactRelation2  = new AccountContactRelation(
                    Id = objAccountContactRelation.Id,
                    prof_position_type__c = (objAccountContactRelation.AccountId != mapContact.get(objAccountContactRelation.contactId).Account.parentId) ? mapContact.get(objAccountContactRelation.contactId).prof_position_type__c : mapContact.get(objAccountContactRelation.contactId).parent_account_prof_position_type__c ,
                    other_prof_prosition_type__c = (objAccountContactRelation.AccountId != mapContact.get(objAccountContactRelation.contactId).Account.parentId) ? mapContact.get(objAccountContactRelation.contactId).other_prof_prosition_type__c : mapContact.get(objAccountContactRelation.contactId).parent_account_other_prof_prosition_type__c ,
                    decision_making_desc__c = (objAccountContactRelation.AccountId != mapContact.get(objAccountContactRelation.contactId).Account.parentId) ? mapContact.get(objAccountContactRelation.contactId).decision_making_desc__c : mapContact.get(objAccountContactRelation.contactId).parent_account_decision_making_desc__c
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
                }
            }
            
        }
           if(uContact){//esta variable es actualizada mediante otro Proceso
               update lstContact;
                }
        }
    }  
    

}