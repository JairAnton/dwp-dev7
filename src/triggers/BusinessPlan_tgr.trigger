trigger BusinessPlan_tgr on bupl__BusinessPlan__c (before update, before delete, after insert, after update) {
    new BusinessPlan_Handler_cls().run();
}