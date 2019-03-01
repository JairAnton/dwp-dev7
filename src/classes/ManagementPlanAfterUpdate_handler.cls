/*-------------------------------------------------------------------------
* Name: Product_cls
* Description : Class to insert a record from Account
* Created date : Jan-Feb 2019
* Developer name: Isaías Velázquez Cortés Indra(México)
--------------------------------------------------------------------------*/
public with sharing class ManagementPlanAfterUpdate_handler {
	public static boolean isExecuting = false;
 
	public static	 void updateValues(List<dwp_frct__management_plan__c> tggn,Map<id,dwp_frct__management_plan__c> tggOld){
 
		if( ManagementPlanAfterUpdate_handler.isExecuting ){return;}
 
		ManagementPlanAfterUpdate_handler.isExecuting = true; 

	    dwp_frct__management_plan__c[] mpList = new dwp_frct__management_plan__c[]{};
		List<User> usrList = [SELECT user_id__c FROM USER WHERE IsActive=true];
		String ucode;
		DateTime d = Datetime.now();
        String dateStr =  d.format('MMyyyy') ;
	  	
	    for (dwp_frct__management_plan__c a: tggn) {  


			for(User u: usrList)
				if(a.ownerid==u.id)
					ucode=u.user_id__c;
					
	        dwp_frct__management_plan__c aux  = new dwp_frct__management_plan__c(Id = a.Id);       
	        aux.id_unique__c =  dateStr + ucode;
                mpList.add(aux);
	    }     
	    update mpList;
 
	}
}