trigger AccountPlanningType_tgr on acpl__Account_Planning_Type__c(after insert) {
    new AccountPlanningType_Handler_cls().run();
}