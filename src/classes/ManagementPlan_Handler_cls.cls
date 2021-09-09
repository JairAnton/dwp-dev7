/** @Name <ManagementPlan_Handler_cls>
   @Author Jair Anton (jair.anton.contractor@bbva.com)
   @Date 2021-09-07
   Date        Author   Email                  				Type
   2021-09-07  JAAA		jair.anton.contractor@bbva.com		Creation
 */

public without sharing class ManagementPlan_Handler_cls extends TriggerHandler {
	/* trigger new list */
    List<dwp_frct__management_plan__c> mPlanNew = Trigger.new;
	/* trigger old list */
	List<dwp_frct__management_plan__c> mPlanOld = Trigger.Old;
	/* trigger new Map */
	Map<Id, dwp_frct__management_plan__c> mPlanNewMap = ((Map<Id, dwp_frct__management_plan__c>)(Trigger.NewMap));
	/* trigger old Map */
	Map<Id, dwp_frct__management_plan__c> mPlanOldMap = ((Map<Id, dwp_frct__management_plan__c>)(Trigger.OldMap));

	/* method call handler package */
    Final dwp_frct.Management_Plan_Handler HANDLER = new dwp_frct.Management_Plan_Handler();

	/* event beforeInsert */
    @TestVisible
	protected override void beforeInsert() {
        ManagementPlanAfterUpdate_handler.hoursInPeriod(mPlanNew);
	}

	/* event beforeUpdate */
	@TestVisible
	protected override void beforeUpdate() {
        HANDLER.ManagementPlanBeforeUpdate(mPlanNew, mPlanOldMap);
	}
    
	/* event afterInsert */
	@TestVisible
	protected override void afterInsert() {
        ManagementPlanAfterUpdate_handler.updateValues(mPlanNew, mPlanOldMap);
	}
}
