trigger CommercialPlanEvent_tgr on acpl__Commercial_Plan_Event__c (before insert, before update, before delete, after insert) {
    new AP_CommercialPlanEvent_Handler_cls().run();
}