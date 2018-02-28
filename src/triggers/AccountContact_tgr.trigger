/**
 * Trigger of AccountContactRelation object.
 * Author: Julio Medellin
 * Date: 22/02/2018
 * Last modified by: Alberto Gómez
 * Date: 27/02/2018
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