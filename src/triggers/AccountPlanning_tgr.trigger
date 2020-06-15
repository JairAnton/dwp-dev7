trigger AccountPlanning_tgr on acpl__Account_Planning__c (before insert, before update, before delete, after insert, after update) {
    new AccountPlanning_Handler_cls().run();
}