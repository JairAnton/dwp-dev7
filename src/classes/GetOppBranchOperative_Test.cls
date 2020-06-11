@isTest
public class GetOppBranchOperative_Test {
	@isTest
	public static void test1() {
		Account acc = TestFactory.createAccount();
		User operativoTest1 = TestFactory.createUser('operativoTest1', 'Operativo');
		User operativoTest2 = TestFactory.createUser('operativoTest2', 'Operativo');
		User operativoTest3 = TestFactory.createUser('operativoTest3', 'Operativo');
		User ejecutivoTest1 = TestFactory.createUser('operativoTest1', 'Ejecutivo');
		List<Branch__c> branchList = new List<Branch__c>();
		Branch__c branch1 = new Branch__c();
		branchList.add(branch1);
		Branch__c branch2 = new Branch__c();
		branchList.add(branch2);
		insert branchList;
		List<User_Branch__c> ubList = new List<User_Branch__c>();
		User_Branch__c ub1 = new User_Branch__c(branch_name__c = branchList[0].id, User__c = operativoTest1.Id);
		ubList.add(ub1);
		User_Branch__c ub2 = new User_Branch__c(branch_name__c = branchList[0].id, User__c = operativoTest2.Id);
		ubList.add(ub2);
		User_Branch__c ub3 = new User_Branch__c(branch_name__c = branchList[1].id, User__c = operativoTest3.Id);
		ubList.add(ub3);
		User_Branch__c ub4 = new User_Branch__c(branch_name__c = branchList[1].id, User__c = ejecutivoTest1.Id);
		ubList.add(ub4);
		insert ubList;
		List<Opportunity> oppList = new List<Opportunity>();
		Opportunity opp1 = new Opportunity(
			ownerId = operativoTest1.Id,
			Name = 'testopp1',
			AccountId = acc.Id,
			StageName = '01',
			Amount = 100,
			CloseDate = system.Date.today(),
			opportunity_status_type__c = '01',
			Branch_id__c = branchList[0].Id);
		oppList.add(opp1);
		Opportunity opp2 = new Opportunity(
			ownerId = operativoTest1.Id,
			Name = 'testopp2',
			AccountId = acc.Id,
			StageName = '01',
			Amount = 100,
			CloseDate = system.Date.today(),
			opportunity_status_type__c = '01',
			Branch_id__c = branchList[1].Id);
		oppList.add(opp2);
		insert oppList;
		List<Id> oppIdList = new List<Id>();
		for(Opportunity opp : oppList) {
			oppIdList.add(opp.Id);
		}
		System.runAs(operativoTest1) {
			Map<Id, List<Id>> result = GetOppBranchOperative.getRecipients(oppIdList, 'Opportunity');
			System.debug('Resultado Test ' + result);
			System.assertEquals(result.size(), 2);
		}
	}
}
