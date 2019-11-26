/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_ForecastPlanGroupingManager_Queue>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2019-11-22
   @Description Queueable Class for create grouping plans to manager.
   @Changes
   Date        Author   Email                  Type
   2019-11-22  LMBR     lolo.bravo@bbva.com    Created
   -------------------------------------------------------------------------------------------------
 */
public with sharing class BE_ForecastPlanGroupingManager_Queue implements Queueable {
/**Profile Owner of Plan */
final String PROF_NAME='Ejecutivo';
/** Over size update */
final Integer SIZE_UPDATE=0;
/**
    @Description create grouping pla for manager.
    @param QueueableContext.
    @return void
 */
public void execute(QueueableContext context) {
	final DateTime dtToday=Datetime.now();
	final List<dwp_frct__grouping__c>groupDataLst=[SELECT Id,dwp_frct__management_plan_id__c,dwp_frct__management_plan_id__r.OwnerId FROM dwp_frct__grouping__c WHERE dwp_frct__management_plan_id__r.dwp_frct__management_plan_start_date__c <=: dtToday AND dwp_frct__management_plan_id__r.dwp_frct__management_plan_end_date__c >=: dtToday];
	final List<dwp_frct__grouping__c>groupList=new List<dwp_frct__grouping__c>();
	if(groupDataLst.size()>SIZE_UPDATE) {
		final Set<Id>planGroupSet= new Set<Id>();
		for(dwp_frct__grouping__c groupItem:groupDataLst) {
			planGroupSet.add(groupItem.dwp_frct__management_plan_id__c);
		}
		final AggregateResult[] groupedResults = [SELECT count(Id) userSize FROM User WHERE Profile.Name=:PROF_NAME];
		if((Integer)groupedResults[0].get('userSize')>planGroupSet.size()) {
			final Map<String,BE_FamilyGroupingForecast__c>familyProductMap=BE_FamilyGroupingForecast__c.getAll();
			for(dwp_frct__management_plan__c plan :[SELECT Id,OwnerId FROM dwp_frct__management_plan__c WHERE Id NOT IN:planGroupSet AND dwp_frct__management_plan_end_date__c >=: dtToday AND dwp_frct__management_plan_start_date__c <=: dtToday AND Owner.Profile.Name=:PROF_NAME]) {
				for(String typeFamily: familyProductMap.keySet()) {
					groupList.add(new dwp_frct__grouping__c(
							      Name=typeFamily,
							      dwp_frct__management_plan_id__c=plan.Id,
							      dwp_frct__solution_category_type__c=typeFamily,
							      dwp_frct__management_expected_drop_amount__c=0,
							      dwp_frct__opportunity_amortization_amount__c=0,
							      dwp_frct__opportunity_antcp_expiry_amount__c=0,
							      dwp_frct__opportunity_cancellation_amount__c=0,
							      dwp_frct__opportunity_closed_amount__c=0,
							      dwp_frct__opportunity_selected_tot_amount__c=0,
							      dwp_frct__original_commitment_amount__c=0
							      ));
				}
			}
		}
	}
	if(groupList.size()>SIZE_UPDATE) {
		insert groupList;
	}
}
}
