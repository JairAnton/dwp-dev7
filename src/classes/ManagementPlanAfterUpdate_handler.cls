/** @Name <ManagementPlanAfterUpdate_handler>
   @Author Isaías Velázquez Cortés Indra(México)
   @Date Jan-Feb 2019
   Date        Author   Email                  				Type
   2019-01-01  IVC     						   				Created
   2019-11-22  LMBR     lolo.bravo@bbva.com    				Modified
   2021-09-07  JAAA		jair.anton.contractor@bbva.com		Add 5 hours start and end date
 */

public with sharing class ManagementPlanAfterUpdate_handler {
	/* variable isExecuting */
	public static boolean isExecuting = false;

	/* update unique ID with period and user code */
	public static void updateValues(List<dwp_frct__management_plan__c> tggn, Map<id, dwp_frct__management_plan__c> tggOld) {
		if(ManagementPlanAfterUpdate_handler.isExecuting) {
			return;
		}

		ManagementPlanAfterUpdate_handler.isExecuting = true;
		dwp_frct__management_plan__c[] mpList = new dwp_frct__management_plan__c[] {};
		final Map<Id, User> usrMap = new Map<Id, User>([SELECT Id, user_id__c FROM USER WHERE IsActive = true]);
		DateTime d = Datetime.now();
		String dateStr =  d.format('MMyyyy');

		for(dwp_frct__management_plan__c a: tggn) {
			dwp_frct__management_plan__c aux  = new dwp_frct__management_plan__c(Id = a.Id);
			aux.id_unique__c =  dateStr + usrMap.get(a.OwnerId).user_id__c;
			mpList.add(aux);
		}

		update mpList;
	}

	/* add 5 hours to start and end date */
	public static void hoursInPeriod(List<dwp_frct__management_plan__c> mPlanNew) {
		for(dwp_frct__management_plan__c item : mPlanNew) {
			item.dwp_frct__management_plan_start_date__c = item.dwp_frct__management_plan_start_date__c.addHours(5);
			item.dwp_frct__management_plan_end_date__c = item.dwp_frct__management_plan_end_date__c.addHours(4).addMinutes(59);
		}
	}
}