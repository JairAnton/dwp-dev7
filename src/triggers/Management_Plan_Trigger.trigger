trigger Management_Plan_Trigger on dwp_frct__management_plan__c (before insert) {
	dwp_frct.Management_Plan_Handler handler = new
    dwp_frct.Management_Plan_Handler();
    if(trigger.isBefore) {
        if(trigger.isUpdate) {
            handler.ManagementPlanBeforeUpdate(trigger.new, Trigger.oldMap);
        }
    }
}