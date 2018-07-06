trigger Visit_Contact_Trigger on dwp_kitv__Visit_Contact__c(before insert, before delete) {
    dwp_kitv.Visit_Contact_Handler handler = new dwp_kitv.Visit_Contact_Handler();
    if(trigger.isBefore) {
        if(trigger.isInsert) {
            handler.visitContactBeforeInsert(trigger.new);
        }
    }
}