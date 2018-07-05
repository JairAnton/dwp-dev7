trigger Event_Trigger on Event (before update, after update) {
     dwp_kitv.Event_Handler eventHandler = new dwp_kitv.Event_Handler();
     if(trigger.isBefore) {
        if(trigger.isUpdate) {
          eventHandler.eventBeforeUpdate(trigger.new, Trigger.oldMap);
        }
     }
     if(trigger.isAfter) {
        if(trigger.isUpdate) {
           eventHandler.eventAfterUpdate(trigger.new, Trigger.oldMap);
        }
     }
}