@isTest
public class GetAccountOppTeam_Test {
    
    @isTest
    public static void test1(){
        Account acc1 = TestFactory.createAccount();
        Account acc2 = TestFactory.createAccount();
        Account acc3 = TestFactory.createAccount();
        User user1 = TestFactory.createUser('testUser1', 'Ejecutivo');
        User user2 = TestFactory.createUser('testUser2', 'Ejecutivo');
        User user3 = TestFactory.createUser('testUser3', 'Ejecutivo');
        User user4 = TestFactory.createUser('testUser4', 'Ejecutivo');
        User user5 = TestFactory.createUser('testUser5', 'Ejecutivo');
        User user6 = TestFactory.createUser('testUser6', 'Ejecutivo');
        acc1.OwnerId = user1.Id;
        update acc1;
        acc2.OwnerId = user2.Id;
        update acc2;
        acc3.OwnerId = user3.Id;
        update acc3;
        Opportunity opp1 = TestFactory.createOpportunity(acc1.Id, user1.Id);
        Opportunity opp2 = TestFactory.createOpportunity(acc1.Id, user2.Id);
        Opportunity opp3 = TestFactory.createOpportunity(acc2.Id, user1.Id);
        Opportunity opp4 = TestFactory.createOpportunity(acc2.Id, user2.Id);
        Opportunity opp5 = TestFactory.createOpportunity(acc3.Id, user1.Id);
        OpportunityTeamMember optm1 = new OpportunityTeamMember(UserId=user4.Id, OpportunityId=opp3.Id);
        OpportunityTeamMember optm2 = new OpportunityTeamMember(UserId=user5.Id, OpportunityId=opp4.Id);
        OpportunityTeamMember optm3 = new OpportunityTeamMember(UserId=user6.Id, OpportunityId=opp5.Id);
        insert new List<OpportunityTeamMember>{optm1,optm2,optm3};
        List<Id> oppIdList = new List<Id>{opp1.Id,opp2.Id,opp3.Id,opp4.Id,opp5.Id};
        System.runAs(user1) {
            Map<Id,List<Id>> result = GetAccountAndOppTeam.getRecipients(oppIdList, 'Opportunity');
            System.debug('user1: '+user1.Id+' ,user2: '+user2.Id+' ,user3: '+user3.Id);
            System.debug(result.size());
        }
        
    }

}