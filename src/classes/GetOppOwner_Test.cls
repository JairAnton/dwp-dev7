@isTest
public class GetOppOwner_Test {
    
    @isTest
    public static void positiveTest() {
        Account acc1 = TestFactory.createAccount();
        User user1 = TestFactory.createUser('TestUser1', 'Ejecutivo');
        User user2 = TestFactory.createUser('TestUser2', 'Ejecutivo');
        Opportunity opp1 = TestFactory.createOpportunity(acc1.Id, user1.Id);
        opp1.OwnerId = user1.Id;
        update opp1;
        List<Id> oppIdList = new List<Id>{opp1.Id};
        System.runAs(user2) {
            Map<Id,List<Id>> result = GetOppOwner.getRecipients(oppIdList, 'Opportunity');
            System.assertEquals(result.get(opp1.Id)[0], user1.Id);
        }        
    }
    
    @isTest
    public static void negativeTest() {
        Account acc1 = TestFactory.createAccount();
        User user1 = TestFactory.createUser('TestUser1', 'Ejecutivo');
        User user2 = TestFactory.createUser('TestUser2', 'Ejecutivo');
        Opportunity opp1 = TestFactory.createOpportunity(acc1.Id, user1.Id);
        opp1.OwnerId = user1.Id;
        update opp1;
        List<Id> oppIdList = new List<Id>{opp1.Id};
        System.runAs(user1) {
            Map<Id,List<Id>> result = GetOppOwner.getRecipients(oppIdList, 'Opportunity');
            System.assertEquals(result.get(opp1.Id), null);
        }        
    }

}