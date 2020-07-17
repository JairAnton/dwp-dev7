/**
 * Handler of Trigger of the ContentVersion object.
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal		    13/07/2020          Original version.<p />
 *
 * @author Diego Carbajal
 */
public without sharing class ContentVersion_Handler_cls extends TriggerHandler {

    /* Variable newCV*/
    List<ContentVersion> newCV = Trigger.new;
    /* Variable oldCV*/
    List<ContentVersion> oldCV = Trigger.Old;
    /* Variable newCVMap*/
    Map<id,ContentVersion> newCVMap = ((Map<Id,ContentVersion>)(Trigger.NewMap));
    /* Variable oldCVMap*/
    Map<id,ContentVersion> oldCVMap = ((Map<Id,ContentVersion>)(Trigger.OldMap));
    
    /* Method beforeInsert*/
    @TestVisible
    protected override void beforeInsert() {
        ContentVersion_Trigger_cls.preventUploadExtnsFiles(newCV);
    }
}