/*-------------------------------------------------------------------------
 * Name: Event_Handler
 * Description : Event Trigger Handler
 * Created date : Apr 19 2018
 * Developer name: Isaías Velázquez Cortés Indra(México)
--------------------------------------------------------------------------*/
public without sharing class Event_Handler extends TriggerHandler {
    protected override void beforeInsert(){
    	//Opportunity new activity Event ,Change stage In management
        Set<Id> opIds = new Set<Id>();
	    for(Event e : (List<Event>)(trigger.new)){
	        String wId = e.WhatId;
	        if(wId!=null && wId.startsWith(Label.OppId) && !opIds.contains(e.WhatId)){
	            opIds.add(e.WhatId);
	        }
	    }	    
	    List<Opportunity> EventOps = [Select Id, StageName from Opportunity where Id in :opIds];	    
	    for(Opportunity o : EventOps){
	        if(o.StageName=='02'){o.StageName = '03'; update o;} 
	    }

    }
        
}