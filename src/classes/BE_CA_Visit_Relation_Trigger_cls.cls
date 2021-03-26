/*
 * @Name: Commercial Alert Visit Relation
 * @Description: Trigger de Ejecucion Comercial Visit Alert Relation
 * @Create by: Eduardo Vargas
 * @HIstorial de cambios:
	
 * 
*/
public with sharing class BE_CA_Visit_Relation_Trigger_cls {
    /** MESSAGE */
    final static String TEXT_MESSAGE='El registro ya existe';
	/*Constructor Account_Trigger_cls*/
    private BE_CA_Visit_Relation_Trigger_cls() {}
    
    /*Method Master for trigger*/
    public static void asignBeforeUpdate(list<Commercial_Alert_Visit_Relation__c> accsNew) {
        checkDuplicityBeforeUpdate(accsNew);
    }
    
    /*Validate Duplicate Values*/
    private static void checkDuplicityBeforeUpdate(list<Commercial_Alert_Visit_Relation__c> accsNew) {
        final Integer sizeVal=1;
        if(accsNew.size() == sizeVal) {
            final List<Commercial_Alert_Visit_Relation__c> relation = [SELECT commercial_id__c, visit_id__c FROM Commercial_Alert_Visit_Relation__c WHERE commercial_id__c = :accsNew[0].commercial_id__c AND visit_id__c = :accsNew[0].visit_id__c];
            if(relation.size() >= sizeVal) {
                accsNew[0].visit_id__c.addError(TEXT_MESSAGE);
            }
        }
    }

}