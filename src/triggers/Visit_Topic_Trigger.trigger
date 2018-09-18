trigger Visit_Topic_Trigger on dwp_kitv__Visit_Topic__c (before delete) {
    visit_helper_Trigger_cls Handlervisithelper= new visit_helper_Trigger_cls();
    if(trigger.isBefore) {
        if(trigger.isdelete){
            Handlervisithelper.ComunMethod1(trigger.old);
        }
    }
}