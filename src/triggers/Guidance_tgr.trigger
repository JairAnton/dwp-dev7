trigger Guidance_tgr on gfsc__Guidance_for_Success__c(after insert) {
	new Guidance_Handler_cls().run();
}