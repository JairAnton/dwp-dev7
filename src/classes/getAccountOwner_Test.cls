@isTest
public class getAccountOwner_Test {
	
   @isTest
    public static void test1(){
        Account acc1 = TestFactory.createAccount();
        Account acc2 = TestFactory.createAccount();
        Account acc3 = TestFactory.createAccount();
        User user1 = TestFactory.createUser('testUser1', 'Ejecutivo');
        User user2 = TestFactory.createUser('testUser1', 'Ejecutivo');
        User user3 = TestFactory.createUser('testUser1', 'Ejecutivo');
        acc1.OwnerId = user1.Id;
        update acc1;
        acc2.OwnerId = user2.Id;
        update acc2;
        acc3.OwnerId = user3.Id;
        update acc3;
        Opportunity opp1 = TestFactory.createOpportunity(acc1.Id, user1.Id);
        Opportunity opp2 = TestFactory.createOpportunity(acc1.Id, user1.Id);
        Opportunity opp3 = TestFactory.createOpportunity(acc2.Id, user1.Id);
        Opportunity opp4 = TestFactory.createOpportunity(acc2.Id, user1.Id);
        Opportunity opp5 = TestFactory.createOpportunity(acc3.Id, user1.Id);
        List<Id> oppIdList = new List<Id>{opp1.Id,opp2.Id,opp3.Id,opp4.Id,opp5.Id};
        System.runAs(user1) {
            Map<Id,List<Id>> result = getAccountOwner.getRecipients(oppIdList, 'Opportunity');
            System.debug(result.size());
        }
        
    }
}