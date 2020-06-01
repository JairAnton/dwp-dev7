@isTest
public class checkIfUserNotOppAccountOwner_Test {
	@isTest
	public static void opportunityTestPositive() {
		Id productId = TestFactory.createProduct().Id;
		Id pricebookId = Test.getStandardPricebookId();
		PricebookEntry standardPrice = new PricebookEntry(
			Pricebook2Id = pricebookId, Product2Id = productId, UnitPrice = 10000, IsActive = true);
		insert standardPrice;
		Pricebook2 customPB = new Pricebook2(Name = 'PriceBook', isActive = true);
		insert customPB;
		PricebookEntry customPrice = new PricebookEntry(
			Pricebook2Id = customPB.Id, Product2Id = productId,
			UnitPrice = 12000, IsActive = true);
		insert customPrice;
		Account acc1 = TestFactory.createAccount();
		Account acc2 = TestFactory.createAccount();
		User usr1 = TestFactory.createUser('TestUser1', 'Ejecutivo');
		User usr2 = TestFactory.createUser('TestUser2', 'Ejecutivo');
		acc1.OwnerId = usr1.Id;
		update acc1;
		acc2.OwnerId = usr2.Id;
		update acc2;
		List<Opportunity> opps1 = new List<Opportunity>();
		List<Id> opps1Id = new List<Id>();
		for(Integer i = 0; i < 2; i++) {
			opps1.add(TestFactory.createOpportunity(acc1.Id, usr1.Id));
			opps1Id.add(opps1[i].Id);
		}

		System.runAs(usr1) {
			List<String> result = checkIfUserNotOppAccountOwner.getValidRecords(opps1Id, 'Opportunity');
			System.assertEquals(0, result.size());
		}
	}

	@isTest
	public static void opportunityTestNegative() {
		Id productId = TestFactory.createProduct().Id;
		Id pricebookId = Test.getStandardPricebookId();
		PricebookEntry standardPrice = new PricebookEntry(
			Pricebook2Id = pricebookId, Product2Id = productId, UnitPrice = 10000, IsActive = true);
		insert standardPrice;
		Pricebook2 customPB = new Pricebook2(Name = 'PriceBook', isActive = true);
		insert customPB;
		PricebookEntry customPrice = new PricebookEntry(
			Pricebook2Id = customPB.Id, Product2Id = productId,
			UnitPrice = 12000, IsActive = true);
		insert customPrice;
		Account acc1 = TestFactory.createAccount();
		Account acc2 = TestFactory.createAccount();
		User usr1 = TestFactory.createUser('TestUser1', 'Ejecutivo');
		User usr2 = TestFactory.createUser('TestUser2', 'Ejecutivo');
		acc1.OwnerId = usr1.Id;
		update acc1;
		acc2.OwnerId = usr2.Id;
		update acc2;
		List<Opportunity> opps1 = new List<Opportunity>();
		List<Id> opps1Id = new List<Id>();
		for(Integer i = 0; i < 2; i++) {
			opps1.add(TestFactory.createOpportunity(acc1.Id, usr1.Id));
			opps1Id.add(opps1[i].Id);
		}

		System.runAs(usr2) {
			List<String> result = checkIfUserNotOppAccountOwner.getValidRecords(opps1Id, 'Opportunity');
			System.assertEquals(2, result.size());
		}
	}

	@isTest
	public static void oliTestPositive() {
		Id productId = TestFactory.createProduct().Id;
		Id pricebookId = Test.getStandardPricebookId();
		PricebookEntry standardPrice = new PricebookEntry(
			Pricebook2Id = pricebookId, Product2Id = productId, UnitPrice = 10000, IsActive = true);
		insert standardPrice;
		Pricebook2 customPB = new Pricebook2(Name = 'PriceBook', isActive = true);
		insert customPB;
		PricebookEntry customPrice = new PricebookEntry(
			Pricebook2Id = customPB.Id, Product2Id = productId,
			UnitPrice = 12000, IsActive = true);
		insert customPrice;
		Account acc1 = TestFactory.createAccount();
		Account acc2 = TestFactory.createAccount();
		User usr1 = TestFactory.createUser('TestUser1', 'Ejecutivo');
		User usr2 = TestFactory.createUser('TestUser2', 'Ejecutivo');
		acc1.OwnerId = usr1.Id;
		update acc1;
		acc2.OwnerId = usr2.Id;
		update acc2;
		List<Opportunity> opps1 = new List<Opportunity>();
		List<Id> opps1Id = new List<Id>();
		for(Integer i = 0; i < 2; i++) {
			opps1.add(TestFactory.createOpportunity(acc1.Id, usr1.Id));
			opps1Id.add(opps1[i].Id);
		}
		List<Opportunity> opps2 = new List<Opportunity>();
		List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
		List<Id> opps2Id = new List<Id>();
		List<Id> oliId = new List<Id>();
		for(Integer i = 0; i < 2; i++) {
			opps2.add(TestFactory.createOpportunity(acc2.Id, usr2.Id));
			opps2Id.add(opps2[i].Id);
		}
		for(Opportunity o : opps2) {
			for(Integer i = 0; i < 2; i++) {
				OpportunityLineItem oli = New OpportunityLineItem(OpportunityId = o.Id, Quantity = 1, TotalPrice = 10.00, PricebookEntryId = customPrice.Id, Product2Id = productId);
				insert oli;
				oliList.add(oli);
				oliId.add(oliList[i].Id);
			}
		}

		System.runAs(usr1) {
			List<String> result = checkIfUserNotOppAccountOwner.getValidRecords(oliId, 'OpportunityLineItem');
			System.assertEquals(2, result.size());
		}
	}

	@isTest
	public static void oliTestNegative() {
		Id productId = TestFactory.createProduct().Id;
		Id pricebookId = Test.getStandardPricebookId();
		PricebookEntry standardPrice = new PricebookEntry(
			Pricebook2Id = pricebookId, Product2Id = productId, UnitPrice = 10000, IsActive = true);
		insert standardPrice;
		Pricebook2 customPB = new Pricebook2(Name = 'PriceBook', isActive = true);
		insert customPB;
		PricebookEntry customPrice = new PricebookEntry(
			Pricebook2Id = customPB.Id, Product2Id = productId,
			UnitPrice = 12000, IsActive = true);
		insert customPrice;
		Account acc1 = TestFactory.createAccount();
		Account acc2 = TestFactory.createAccount();
		User usr1 = TestFactory.createUser('TestUser1', 'Ejecutivo');
		User usr2 = TestFactory.createUser('TestUser2', 'Ejecutivo');
		acc1.OwnerId = usr1.Id;
		update acc1;
		acc2.OwnerId = usr2.Id;
		update acc2;
		List<Opportunity> opps1 = new List<Opportunity>();
		List<Id> opps1Id = new List<Id>();
		for(Integer i = 0; i < 2; i++) {
			opps1.add(TestFactory.createOpportunity(acc1.Id, usr1.Id));
			opps1Id.add(opps1[i].Id);
		}
		List<Opportunity> opps2 = new List<Opportunity>();
		List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
		List<Id> opps2Id = new List<Id>();
		List<Id> oliId = new List<Id>();
		for(Integer i = 0; i < 2; i++) {
			opps2.add(TestFactory.createOpportunity(acc2.Id, usr2.Id));
			opps2Id.add(opps2[i].Id);
		}
		for(Opportunity o : opps2) {
			for(Integer i = 0; i < 2; i++) {
				OpportunityLineItem oli = New OpportunityLineItem(OpportunityId = o.Id, Quantity = 1, TotalPrice = 10.00, PricebookEntryId = customPrice.Id, Product2Id = productId);
				insert oli;
				oliList.add(oli);
				oliId.add(oliList[i].Id);
			}
		}

		System.runAs(usr2) {
			List<String> result = checkIfUserNotOppAccountOwner.getValidRecords(oliId, 'OpportunityLineItem');
			System.assertEquals(0, result.size());
		}
	}
}
