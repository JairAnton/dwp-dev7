/**
 * @author adrian.caro.contractor@bbva.com 
 * @date 2018
 *
 * @group NONE
 *  * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		14/08/2020          modified version.<p />
 * @description checkIfUserNotOppAccountOwner_Test
 **/
@isTest
public class checkIfUserNotOppAccountOwner_Test {
    
    /** @Description  Setup*/
    @TestSetup
    static void setUp() {
        Final Id productId = TestFactory.createProduct().Id;
		Final Id pricebookId = Test.getStandardPricebookId();
		insert new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = productId, UnitPrice = 10000, IsActive = true);
		Final Pricebook2 customPB = new Pricebook2(Name = 'PriceBook', isActive = true);
		insert customPB;
		insert new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = productId, UnitPrice = 12000, IsActive = true);
        Final Account acc1 = TestFactory.createAccount();
		Final Account acc2 = TestFactory.createAccount();
		Final User usr1 = TestFactory.createUser('TestUser1', 'Ejecutivo');
		Final User usr2 = TestFactory.createUser('TestUser2', 'Ejecutivo');
		acc1.OwnerId = usr1.Id;
		update acc1;
		acc2.OwnerId = usr2.Id;
		update acc2;
    }
    
    /** @Description  opportunityTestPositive*/
	@isTest
	public static void opportunityTestPositive() {
        Final User usr1 = [SELECT Id FROM User WHERE LastName LIKE '%TestUser1%'];
        Final Account acc1 = [SELECT Id FROM Account WHERE OwnerId =:usr1.Id];
		Final List<Opportunity> opps1 = new List<Opportunity>();
		Final List<Id> opps1Id = new List<Id>();
		for(Integer i = 0; i < 2; i++) {
			opps1.add(TestFactory.createOpportunity(acc1.Id, usr1.Id));
			opps1Id.add(opps1[i].Id);
		}
        List<String> result;
        Test.startTest();
		System.runAs(usr1) {
			result = checkIfUserNotOppAccountOwner.getValidRecords(opps1Id, 'Opportunity');
		}
        Test.stopTest();
        System.assertEquals(0, result.size());
	}

    /** @Description  opportunityTestNegative*/
	@isTest
	public static void opportunityTestNegative() {
        Final User usr1 = [SELECT Id FROM User WHERE LastName LIKE '%TestUser1%'];
        Final User usr2 = [SELECT Id FROM User WHERE LastName LIKE '%TestUser2%'];
        Final Account acc1 = [SELECT Id FROM Account WHERE OwnerId =:usr1.Id];
		Final List<Opportunity> opps1 = new List<Opportunity>();
		Final List<Id> opps1Id = new List<Id>();
		for(Integer i = 0; i < 2; i++) {
			opps1.add(TestFactory.createOpportunity(acc1.Id, usr1.Id));
			opps1Id.add(opps1[i].Id);
		}
        List<String> result;
        Test.startTest();
		System.runAs(usr2) {
			result = checkIfUserNotOppAccountOwner.getValidRecords(opps1Id, 'Opportunity');
		}
        Test.stopTest();
        System.assertEquals(2, result.size());
	}

    /** @Description  oliTestPositive*/
	@isTest
	public static void oliTestPositive() {
        Final User usr1 = [SELECT Id FROM User WHERE LastName LIKE '%TestUser1%'];
        Final User usr2 = [SELECT Id FROM User WHERE LastName LIKE '%TestUser2%'];
        Final Account acc1 = [SELECT Id FROM Account WHERE OwnerId =:usr1.Id];
        Final Account acc2 = [SELECT Id FROM Account WHERE OwnerId =:usr2.Id];
        Final Id productId = [SELECT Id FROM Product2 LIMIT 1].Id;
        Final Id customPrice = [SELECT Id FROM PricebookEntry LIMIT 1].Id;
		Final List<Opportunity> opps1 = new List<Opportunity>();
		Final List<Id> opps1Id = new List<Id>();
		for(Integer i = 0; i < 2; i++) {
			opps1.add(TestFactory.createOpportunity(acc1.Id, usr1.Id));
			opps1Id.add(opps1[i].Id);
		}
		Final List<Opportunity> opps2 = new List<Opportunity>();
		Final List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
		Final List<Id> opps2Id = new List<Id>();
		Final List<Id> oliId = new List<Id>();
		for(Integer i = 0; i < 2; i++) {
			opps2.add(TestFactory.createOpportunity(acc2.Id, usr2.Id));
			opps2Id.add(opps2[i].Id);
		}
		for(Opportunity opp : opps2) {
			for(Integer i = 0; i < 2; i++) {
				Final OpportunityLineItem oli = New OpportunityLineItem(OpportunityId = opp.Id, Quantity = 1, TotalPrice = 10.00, PricebookEntryId = customPrice, Product2Id = productId);
				insert oli;
				oliList.add(oli);
				oliId.add(oliList[i].Id);
			}
		}
        List<String> result;
        Test.startTest();
		System.runAs(usr1) {
			result = checkIfUserNotOppAccountOwner.getValidRecords(oliId, 'OpportunityLineItem');
		}
        Test.stopTest();
        System.assertEquals(2, result.size());
	}

    /** @Description  oliTestNegative*/
	@isTest
	public static void oliTestNegative() {
        Final User usr1 = [SELECT Id FROM User WHERE LastName LIKE '%TestUser1%'];
        Final User usr2 = [SELECT Id FROM User WHERE LastName LIKE '%TestUser2%'];
        Final Account acc1 = [SELECT Id FROM Account WHERE OwnerId =:usr1.Id];
        Final Account acc2 = [SELECT Id FROM Account WHERE OwnerId =:usr2.Id];
        Final Id productId = [SELECT Id FROM Product2 LIMIT 1].Id;
        Final Id customPrice = [SELECT Id FROM PricebookEntry LIMIT 1].Id;
		Final List<Opportunity> opps1 = new List<Opportunity>();
		Final List<Id> opps1Id = new List<Id>();
		for(Integer i = 0; i < 2; i++) {
			opps1.add(TestFactory.createOpportunity(acc1.Id, usr1.Id));
			opps1Id.add(opps1[i].Id);
		}
		Final List<Opportunity> opps2 = new List<Opportunity>();
		Final List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
		Final List<Id> opps2Id = new List<Id>();
		Final List<Id> oliId = new List<Id>();
		for(Integer i = 0; i < 2; i++) {
			opps2.add(TestFactory.createOpportunity(acc2.Id, usr2.Id));
			opps2Id.add(opps2[i].Id);
		}
		for(Opportunity opp : opps2) {
			for(Integer i = 0; i < 2; i++) {
				Final OpportunityLineItem oli = New OpportunityLineItem(OpportunityId = opp.Id, Quantity = 1, TotalPrice = 10.00, PricebookEntryId = customPrice, Product2Id = productId);
				insert oli;
				oliList.add(oli);
				oliId.add(oliList[i].Id);
			}
		}
        List<String> result;
        Test.startTest();
		System.runAs(usr2) {
			result = checkIfUserNotOppAccountOwner.getValidRecords(oliId, 'OpportunityLineItem');
		}
        Test.stopTest();
        System.assertEquals(0, result.size());
	}
}