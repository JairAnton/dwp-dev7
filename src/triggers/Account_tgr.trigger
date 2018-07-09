/*
 * @Name: Opportunity_tgr
 * @Description: Trigger de Ejecucion Opportunity
 * @Create by: Isaías Velázquez Cortés

*/
trigger Account_tgr on Account (after update) {
    new Account_Handler_cls().run();
}