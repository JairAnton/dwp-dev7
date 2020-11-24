trigger SalesMeeting_tgr on slmt__Sales_Meeting__c (before insert, after insert) {
    new SalesMeeting_Handler_cls().run();
}