trigger AP_Question_tgr on acpl__AP_Question__c (before update, before delete, after update) {
    new AP_Question_Handler_cls().run();
}