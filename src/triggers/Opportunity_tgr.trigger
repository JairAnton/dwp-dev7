/*
 * @Name: Opportunity_tgr
 * @Description: Trigger de Ejecucion Opportunity
 * @Create by: 
 * 
 * V0- Creacion 
*/
trigger Opportunity_tgr on Opportunity (before insert, before update, after update, after insert) {
	new Opportunity_Handler_cls().run();
}