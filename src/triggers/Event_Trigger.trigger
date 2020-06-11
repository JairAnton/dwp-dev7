trigger Event_Trigger on Event (after insert, before update, before delete, after update) {
    gcal.GBL_EventHandler gcalHandler = new gcal.GBL_EventHandler();
    dwp_kitv.Event_Handler eventHandler = new dwp_kitv.Event_Handler();
    gcal.GBL_Configuration_wrp googleConfig = new gcal.GBL_Configuration_wrp();
    
    if(trigger.isBefore) {
        if(trigger.isUpdate) {
            eventHandler.eventBeforeUpdate(trigger.new, Trigger.oldMap);
        }
        else if(trigger.isDelete) {
            List<Id> ids = new List<Id>();
            ids.addAll(trigger.oldMap.keySet());
            googleConfig.notifications = false;
            googleConfig.isDelete = true;
			if(!Test.isRunningTest()) {
				gcal.GBL_EventHandler.deleteShyncronizedEvent(ids,googleConfig);
			}
        }
    }
    if (trigger.isAfter) {
        if(trigger.isInsert || trigger.isUpdate) {
            List<Id> ids = new List<Id>();
            googleConfig.synchronizeAll = true;
            googleConfig.notifications = true;
            ids.addAll(trigger.newMap.keySet());
			if(!Test.isRunningTest()) {
				gcal.GBL_EventHandler.synchronizeEvent(ids,googleConfig);
			}
        }
    }
}
