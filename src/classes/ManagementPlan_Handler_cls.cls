/** @Name <ManagementPlan_Handler_cls>
   @Author Jair Anton (jair.anton.contractor@bbva.com)
   @Date 2021-09-07
   Date        Author   Email                  				Type
   2021-09-07  JAAA		jair.anton.contractor@bbva.com		Creation
 */

public without sharing class ManagementPlan_Handler_cls extends TriggerHandler {
    List<dwp_frct__management_plan__c> mPlanNew = Trigger.new;
	List<dwp_frct__management_plan__c> mPlanOld = Trigger.Old;
	Map<Id, dwp_frct__management_plan__c> mPlanNewMap = ((Map<Id, dwp_frct__management_plan__c>)(Trigger.NewMap));
	Map<Id, dwp_frct__management_plan__c> mPlanOldMap = ((Map<Id, dwp_frct__management_plan__c>)(Trigger.OldMap));

    Final dwp_frct.Management_Plan_Handler HANDLER = new dwp_frct.Management_Plan_Handler();

    @TestVisible
	protected override void beforeInsert() {
        ManagementPlanAfterUpdate_handler.hoursInPeriod(mPlanNew);
	}

	@TestVisible
	protected override void beforeUpdate() {
        HANDLER.ManagementPlanBeforeUpdate(mPlanNew, mPlanOldMap);
	}
    
	@TestVisible
	protected override void afterInsert() {
        ManagementPlanAfterUpdate_handler.updateValues(mPlanNew, mPlanOldMap);
	}
}
