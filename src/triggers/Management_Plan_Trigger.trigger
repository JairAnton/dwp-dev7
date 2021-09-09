trigger Management_Plan_Trigger on dwp_frct__management_plan__c (before insert, before update, after update, after insert) {
	new ManagementPlan_Handler_cls().run();
}