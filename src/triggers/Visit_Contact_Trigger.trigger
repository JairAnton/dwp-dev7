trigger Visit_Contact_Trigger on dwp_kitv__Visit_Contact__c(before insert, before delete) {
    dwp_kitv.Visit_Contact_Handler handler = new dwp_kitv.Visit_Contact_Handler();
	visit_helper_Trigger_cls Handlervisithelper= new visit_helper_Trigger_cls();
    if(trigger.isBefore) {
        if(trigger.isInsert) {
            handler.visitContactBeforeInsert(trigger.new);
        }
		if(trigger.isdelete){
            Handlervisithelper.ComunMethod1(trigger.old);
        }
    }
}