trigger Stockholder_tgr on BE_Stockholder__c (before insert, before update, before delete, after insert) {
	new AP_StockHolder_Handler_cls().run();
}