@isTest(seeAllData=true)
public class OpportunityChatterNotification_Test {

    @isTest
    public static void test1(){
        Account acc1 = TestFactory.createAccount();
        User user1 = TestFactory.createUser('Test1', 'Ejecutivo');
       	acc1.OwnerId = user1.Id;
        update acc1;
        User user2 = TestFactory.createUser('Test2', 'Operativo');
        Opportunity opp1 = TestFactory.createOpportunity(acc1.Id, user1.Id);
        opp1.StageName='04';
        opp1.opportunity_status_type__c='14';
        update opp1;
    }
    
}