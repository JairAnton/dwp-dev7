trigger APTeam_tgr on bupl__AP_Team__c (before insert, before update, before delete, after insert, after delete) {
    new AP_Team_Handler_cls().run();
}