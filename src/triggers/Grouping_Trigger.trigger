trigger Grouping_Trigger on dwp_frct__grouping__c (after update) {
    dwp_frct.Grouping_Handler handler = new dwp_frct.Grouping_Handler ();
    if(trigger.isAfter) {
        if(trigger.isUpdate) {
            handler.GroupingAfterUpdate(trigger.new, Trigger.oldMap);
        }
    }
}