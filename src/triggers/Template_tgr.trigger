trigger Template_tgr on dyfr__Template__c(after insert) {
	new Template_Handler_cls().run();
}