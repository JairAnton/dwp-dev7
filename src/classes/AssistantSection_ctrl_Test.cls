@IsTest
public class AssistantSection_ctrl_Test {
    @isTest
    static void test_method_one(){
        User usr1 = TestFactory.createUser('TestUser1', 'Ejecutivo');
        User usr2 = TestFactory.createUser('TestUser1', 'Ejecutivo');
        System.assert((Boolean)AssistantSection_ctrl.getInfoContainer(usr1.Id).get('showSection'));

        List<String> lstNewAssistant = new List<String>();
        lstNewAssistant.add(usr2.Id);

        List<String> lstDeleteAssistant = new List<String>();

        Map<String,Object> mapReturn = AssistantSection_ctrl.saveAll(usr1.Id, lstNewAssistant, lstDeleteAssistant);
        System.assert((Boolean)mapReturn.get('isOk'));
        lstDeleteAssistant.add(usr2.Id);
        Map<String,Object> mapReturn2 = AssistantSection_ctrl.saveAll(usr1.Id, new List<String>(), lstDeleteAssistant);
        System.assert((Boolean)mapReturn2.get('isOk'));

        Map<String,Object> mapReturn3 = AssistantSection_ctrl.getInfo(usr1.Id);
        System.assert(mapReturn3.containsKey('info'));

        System.assert(AssistantSection_ctrl.fetchUser(usr2.Name, usr1.Id).isEmpty());

        

    }
}