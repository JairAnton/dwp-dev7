/*
 * @Name: Opportunity_tgr
 * @Description: Trigger de Ejecucion Opportunity
 * @Create by: Isaías Velázquez Cortés

*/
trigger Account_tgr on Account (after update, after insert) {
    new Account_Handler_cls().run();
}