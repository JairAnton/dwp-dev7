trigger GrowthDriver_tgr on bupl__BP_GrowthDriver__c (before insert, before update, before delete, after insert) {
    new BP_GrowthDriver_Handler_cls().run();
}