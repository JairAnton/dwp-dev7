trigger Visit_Management_Team_Trigger on dwp_kitv__Visit_Management_Team__c(before insert, before delete) {
    dwp_kitv.Visit_Management_Team_Handler handler = new dwp_kitv.Visit_Management_Team_Handler();
    if(trigger.isBefore) {
        if(trigger.isInsert) {
            handler.VisitManagementTeamBeforeInsert(trigger.new);
        }
    }
}