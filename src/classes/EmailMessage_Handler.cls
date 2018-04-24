/*-------------------------------------------------------------------------
 * Name: EmailMessage_Handler
 * Description : EmailMessage Trigger Handler
 * Created date : Apr 19 2018
 * Developer name: Isaías Velázquez Cortés Indra(México)
--------------------------------------------------------------------------*/
public without sharing class EmailMessage_Handler extends TriggerHandler {
    protected override void beforeInsert(){
    	//Opportunity new activity EmailMessage,Change stage In management
        Set<Id> opIds = new Set<Id>();
	    for(EmailMessage e : (List<EmailMessage>)(trigger.new)){
	        String wId = e.RelatedToId;
	        if(wId!=null && wId.startsWith(Label.OppId) && !opIds.contains(e.RelatedToId)){
	            opIds.add(e.RelatedToId);
	        }
	    }	    
	    List<Opportunity> EventOps = [Select Id, StageName from Opportunity where Id in :opIds];	    
	    for(Opportunity o : EventOps){
	        if(o.StageName=='02'){o.StageName = '03'; update o;} 
	    }

    }
        
}