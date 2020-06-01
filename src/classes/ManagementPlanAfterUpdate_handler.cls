/**
   -------------------------------------------------------------------------------------------------
   @Name <ManagementPlanAfterUpdate_handler>
   @Author Isaías Velázquez Cortés Indra(México)
   @Date Jan-Feb 2019
   @Description Class to update unique_id to dwp_frct__management_plan__c
   @Changes
   Date        Author   Email                  Type
   2019-01-01  IVC     						   Created
   2019-11-22  LMBR     lolo.bravo@bbva.com    Modified
   -------------------------------------------------------------------------------------------------
 */
public with sharing class ManagementPlanAfterUpdate_handler {
	public static boolean isExecuting = false;
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
}
