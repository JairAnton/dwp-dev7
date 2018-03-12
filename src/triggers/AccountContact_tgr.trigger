/**
 * Trigger of AccountContactRelation object.
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------------
 * Developer					Date				Description<p />
 * -------------------------------------------------------------------------
 * Julio Medellin				22/02/2018			Original version.<p />
 * Alberto Gómez				27/02/2018			Added updateValuesRelationInContact method in isUpdate and isAfter events.<p />
 *
 * @author Julio Medellin
 */
trigger AccountContact_tgr on AccountContactRelation (after insert, after update) {

    //Is After event.
    if(trigger.isAfter) {
        if(trigger.isInsert) {
            AccountContact_Handler.setValuesRelation(trigger.new);
        }
        if(Trigger.isUpdate) {
            AccountContact_Handler.updateValuesRelationInContact(Trigger.new);
        }
    }
}