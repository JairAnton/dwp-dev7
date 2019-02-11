trigger Management_Plan_Trigger on dwp_frct__management_plan__c (before update,after insert) {
    dwp_frct.Management_Plan_Handler handler = new
    dwp_frct.Management_Plan_Handler();
    if(trigger.isBefore) {
        if(trigger.isUpdate) {
            handler.ManagementPlanBeforeUpdate(trigger.new, Trigger.oldMap);
        }
    }
    
    if(trigger.isAfter) {
        if(trigger.isInsert) {
            ManagementPlanAfterUpdate_handler.updateValues(trigger.new, Trigger.oldMap);
        }
    }
}