/**
 * Handler of Trigger of the AccountContactRelation object.
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Julio Medellin               22/02/2018          Original version.<p />
 * Alberto Gómez                27/02/2018          Added updateValuesRelationInContact method.<p />
 * Martin Mori                  02/10/2019          Added updateTotalRequiredFields method.<p />
 *
 * @author Julio Medellin
 */
public without sharing class AccountContact_Handler extends TriggerHandler {
    /**
    * Method for set values in AccountContactRelation records.
    *
    * @param lstAccountContactRelation Account Contact Relation List.
    */
	protected override void afterInsert() {
		AccountContactParentAssociation.setValuesRelation((List<AccountContactRelation>)(trigger.new));
		UpdateTotalFieldsRequired_cls.updateTotalRequiredFields((List<AccountContactRelation>)(trigger.new));
	}

    /**
    * Method for update Contact values according to AccountContactRelation updates.
    *
    * @param lstAccountContactRelation Account Contact Relation List.
    */
	protected override void afterUpdate() {
		AccountContactParentAssociation.updateValuesRelationInContact((List<AccountContactRelation>)(trigger.new));
		UpdateTotalFieldsRequired_cls.updateTotalRequiredFields((List<AccountContactRelation>)(trigger.new));
	}

    /**
    * Method for update Total_campos_obligatorios_llenos__c field of Account to AccountContactRelation.
    */
	protected override void afterdelete() {
		UpdateTotalFieldsRequired_cls.updateTotalRequiredFields((List<AccountContactRelation>)(trigger.old));
	}
}
