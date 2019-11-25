trigger Visit_Management_Team_Trigger on dwp_kitv__Visit_Management_Team__c(before insert, before delete, after delete) {
    dwp_kitv.Visit_Management_Team_Handler handler = new dwp_kitv.Visit_Management_Team_Handler();
    visit_helper_Trigger_cls Handlervisithelper= new visit_helper_Trigger_cls();
    if(trigger.isBefore) {
        if(trigger.isInsert) {
            handler.VisitManagementTeamBeforeInsert(trigger.new);
        }
        if(trigger.isdelete) {
            Handlervisithelper.comunMethod1(trigger.old);
            Handlervisithelper.deleteOwner(trigger.old);
        }
    } else {
        if(trigger.isdelete) {
            Handlervisithelper.deleteVMTShare(trigger.oldMap);
        }
    }
}