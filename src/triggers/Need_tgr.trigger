trigger Need_tgr on bupl__BP_Need__c (before insert,  before update, before delete, after insert) {
    new BP_Need_Handler_cls().run();
}