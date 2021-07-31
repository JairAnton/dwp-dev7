trigger CalceDetails_Tgr on Calce_Details__c (before insert, before update, after insert, after update) {
	new CalceDetails_Handler_cls().run();
}