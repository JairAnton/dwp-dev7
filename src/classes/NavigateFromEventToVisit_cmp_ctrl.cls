/**
* @author bbva.com developers
* @date 2018
*
* @group global_hub
*
* @description Retrieve de visit asociated with the event
**/

public class NavigateFromEventToVisit_cmp_ctrl {

    //Returns the id of the visit if the Event contains any
    @AuraEnabled
    public static String getInfo(String eventId){
    	Event ev = [SELECT Id, dwp_kitv__visit_id__c FROM Event WHERE Id = :eventId LIMIT 1];
    	if(ev.dwp_kitv__visit_id__c != null){
    		return ev.dwp_kitv__visit_id__c;
    	}else{
    		return '';
    	}
        
    }
}