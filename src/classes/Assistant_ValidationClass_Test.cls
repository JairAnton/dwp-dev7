@IsTest
public class Assistant_ValidationClass_Test {
    @isTest
    static void test_method_one(){
        User usr1 = TestFactory.createUser('TestUser1', 'Ejecutivo');
        User usr2 = TestFactory.createUser('TestUser2', 'Ejecutivo');
        System.debug(usr1);
        System.runAs(usr1) {
            List<String> lstError = Assistant_ValidationClass.getErrorMessagesList(usr2.Id,'','');
            System.assertEquals(lstError[0], Label.AssistantValidationError);
        }
    }
}