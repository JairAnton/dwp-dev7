/*
 * @Name: User_Assistant_Team_trg
 * @Description: User_Assistant_Team trigger
 * @Create by: Jose Luis Ruiz Garrido

*/
trigger User_Assistant_Team_trg on User_Assistant_Team__c (after insert, after delete) {
	new User_Assistant_Team_Handler_cls().run();
}