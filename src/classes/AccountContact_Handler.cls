/**
 * Handler of Trigger of the AccountContactRelation object.
 * Author: Julio Medellin
 * Date: 22/02/2018
 * Last modified by: Alberto Gómez
 * Date: 27/02/2018
 */
public class AccountContact_Handler {

    /**
     * Method for set values in AccountContactRelation records.
     */
    public static void setValuesRelation(List<AccountContactRelation> lstAccountContactRelation) {
        List<AccountContactRelation> lstAccountContactRelationUpdated = new List<AccountContactRelation>();
        Map<Id, Contact> mapContact = new Map<Id, Contact>([SELECT Id, prof_position_type__c, other_prof_prosition_type__c, decision_making_desc__c FROM Contact]);
        for(AccountContactRelation objAccountContactRelation : lstAccountContactRelation) {
            AccountContactRelation objAccountContactRelation2  = new AccountContactRelation(
                    Id = objAccountContactRelation.Id,
                    prof_position_type__c = mapContact.get(objAccountContactRelation.contactId).prof_position_type__c,
                    other_prof_prosition_type__c = mapContact.get(objAccountContactRelation.contactId).other_prof_prosition_type__c,
                    decision_making_desc__c = mapContact.get(objAccountContactRelation.contactId).decision_making_desc__c
            );
            lstAccountContactRelationUpdated.add(objAccountContactRelation2);
        }
        update lstAccountContactRelationUpdated;
    }

    /**
     * Method for update Contact values according to AccountContactRelation updates.
     */
    public static void updateValuesRelationInContact(List<AccountContactRelation> lstAccountContactRelation) {
        List<Contact> lstContact = new List<Contact>();
        for(AccountContactRelation objAccountContactRelation1 : lstAccountContactRelation) {
            lstContact.add([SELECT Id, prof_position_type__c, other_prof_prosition_type__c, decision_making_desc__c FROM Contact WHERE Id =: objAccountContactRelation1.ContactId]);
        }
        for(AccountContactRelation objAccountContactRelation : lstAccountContactRelation) {
            for(Contact objContact : lstContact) {
                if(objAccountContactRelation.IsDirect == TRUE) {
                    objContact.prof_position_type__c = objAccountContactRelation.prof_position_type__c;
                    objContact.other_prof_prosition_type__c = objAccountContactRelation.other_prof_prosition_type__c;
                    objContact.decision_making_desc__c = objAccountContactRelation.decision_making_desc__c;
                }
                update lstContact;
            }
        }
    }
}