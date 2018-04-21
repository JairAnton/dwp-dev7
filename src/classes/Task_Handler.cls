/*-------------------------------------------------------------------------
 * Name: Task_Handler
 * Description : Task Trigger Handler
 * Created date : Apr 19 2018
 * Developer name: Isaías Velázquez Cortés Indra(México)
--------------------------------------------------------------------------*/
public without sharing class Task_Handler extends TriggerHandler {
    protected override void beforeInsert(){
    	//Opportunity new activity Task or Call ,Change stage In management
        Set<Id> opIds = new Set<Id>();
        List<SObject> OpsUpdate = new LIST<SObject>();
	    for(Task e : (List<Task>)(trigger.new)){
	        String wId = e.WhatId;
	        if(wId!=null && wId.startsWith(Label.OppId) && !opIds.contains(e.WhatId)){
	            opIds.add(e.WhatId);
	        }
	    }	    
	    List<Opportunity> EventOps = [Select Id, StageName from Opportunity where Id in :opIds];	    
	    for(Opportunity o : EventOps){
	        if(o.StageName=='02'){o.StageName = '03';o.opportunity_status_type__c = '04'; OpsUpdate.add(o);} 
	    }
        update OpsUpdate;

    }
        
}