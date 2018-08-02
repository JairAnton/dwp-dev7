trigger Case_Trigger on Case (after update, after insert) {
    Case_Handler caseHandler = new Case_Handler();
    if(trigger.isAfter) {
        if(trigger.isUpdate) {
            caseHandler.caseAfterUpdate(trigger.new, trigger.oldMap);
        }
        if(trigger.isInsert) {
            caseHandler.caseAfterInsert(trigger.new);
        }
    }
}