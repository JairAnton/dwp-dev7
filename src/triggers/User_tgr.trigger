/*
 * @Name: User_tgr
 * @Description: Trigger of User
 * @Create by: Jose Roderiguez Paredes

*/
trigger User_tgr on User(before insert, before update) {
    new User_Handler_cls().run();
}