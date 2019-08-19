trigger Event_Trigger on Event (after insert, before update, after update, after delete) {

    gcal.GBL_EventHandler gcalHandler = new gcal.GBL_EventHandler();
    dwp_kitv.Event_Handler eventHandler = new dwp_kitv.Event_Handler();
    
    if(trigger.isBefore && trigger.isUpdate) {
        eventHandler.eventBeforeUpdate(trigger.new, Trigger.oldMap);
    }
    if (trigger.isAfter) {
        if(trigger.isInsert) {
            gcalHandler.afterInsert();
        }
        else if(trigger.isUpdate) {
            gcalHandler.afterUpdate();
            eventHandler.eventAfterUpdate(trigger.new, Trigger.oldMap);
        }
        if (trigger.isDelete) {
            gcalHandler.afterDelete();
        }
    }
}