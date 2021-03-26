/*
 * @Name: Commercial Alert Visit Relation
 * @Description: Trigger de Ejecucion Comercial Visit Alert Relation
 * @Create by: Eduardo Vargas
 * @HIstorial de cambios:
	
 * 
*/
public class BE_CA_Visit_Relation_Trigger_cls {
    /*Reusable variable in methods*/
    private static Final List<String> PROFILE_NAMES = new List<String>{'Migracion', System.Label.profAdministrator, 'System Administrator'};

	/*Constructor Account_Trigger_cls*/
    private BE_CA_Visit_Relation_Trigger_cls() {}
    
    /*Method Master for trigger*/
    public static void asignBeforeUpdate(list<Commercial_Alert_Visit_Relation__c> accsNew, Map<id,Commercial_Alert_Visit_Relation__c> accsNewMap, list<Commercial_Alert_Visit_Relation__c> accsOld, Map<id,Commercial_Alert_Visit_Relation__c> accsOldMap) {
		Final Map<id, User	> userAdmins = new Map<Id,User>([SELECT Id FROM user WHERE profile.Name IN: PROFILE_NAMES AND isActive=true]);
        Final Map<Id, Id> accOwnChange = new Map<Id, Id>();
        Final Map<Id,Id> mapBranchIds = new Map<Id,Id>();
        
        //Actualiza gestores principales de los AP's activos
        checkDuplicityBeforeUpdate(accsNew, accsNewMap, accsOld, accsOldMap);
    }
    
    /*Validate Duplicate Values*/
    private static void checkDuplicityBeforeUpdate(list<Commercial_Alert_Visit_Relation__c> accsNew, Map<id,Commercial_Alert_Visit_Relation__c> accsNewMap, list<Commercial_Alert_Visit_Relation__c> accsOld, Map<id,Commercial_Alert_Visit_Relation__c>accsOldMap) {
        if(accsNew.size() == 1) {
            List<Commercial_Alert_Visit_Relation__c> relation = [SELECT commercial_id__c, visit_id__c FROM Commercial_Alert_Visit_Relation__c WHERE commercial_id__c = :accsNew[0].commercial_id__c AND visit_id__c = :accsNew[0].visit_id__c];
            if(relation.size() > 0) {
                accsNew[0].visit_id__c.addError('El registro ya existe');
            }
        }
    }

}