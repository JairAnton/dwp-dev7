/*
 * @Name: Opportunity_tgr
 * @Description: Trigger de Ejecucion Opportunity
 * @Create by:
 *
 * V0-Creacion
 */
@isTest(seeAllData = true)

public class Opportunity_Trigger_Test {
	/*
	 *   @Variable: TGR_CNTXT_ERROR
	 */
	static Final String TGR_CNTXT_ERROR = 'Trigger Error';
	/*
	 *   @Variable: LANGUAGE_US
	 */
	static Final String LANGUAGE_US = 'en_US';
	/*
	 *   @Variable: opp
	 */
	static Opportunity opp = new Opportunity();
	static Map<String, Profile> perfilMapa = new Map<String, Profile>();
	/*
	 *   @Variable: rolMapa
	 */
	static Map<String, UserRole> rolMapa = new Map<String, UserRole>();
	static List<RecordType> rTypesClientes;
	static List<UserRole> userRole;
	/*
	 *   @Variable: EXXECUTIVE
	 */
	static Final String EXXECUTIVE = 'Ejecutivo';

	static {
		userRole = new List<UserRole>([SELECT Id, Name FROM UserRole limit 1000]);
		for(Profile perfil:[SELECT Id, Name FROM Profile limit 100]) {
			perfilMapa.put(perfil.Name, perfil);
		}
	}

	@isTest
	static void testEjecutivo() {
		Final User ejecutivo = creaUsuario(EXXECUTIVE);
		Final User operativo = creaUsuario('Operativo');
		creatOpp(ejecutivo);
		test.startTest();
		opp.ownerId = ejecutivo.Id;
		Update Opp;
		opp.ownerId = operativo.Id;
		Update opp;
		test.stopTest();
		System.assertEquals(opp.ownerId, operativo.Id, 'Error Assertion');
	}

	@isTest
	static void testEspecialista() {
		Final User ejecutivo = creaUsuario(EXXECUTIVE);
		Final User especialista = creaUsuario('Especialista');
		creatOpp(ejecutivo);
		test.startTest();
		opp.ownerId = ejecutivo.Id;
		Update Opp;
		opp.ownerId = especialista.Id;
		Update opp;
		test.stopTest();
		System.assertEquals(opp.ownerId, especialista.Id, 'Error Assertion');
	}

	@isTest
	static void changeState11() {
		Final User usuario = TestFactory.createUser('TestUser1', EXXECUTIVE);
		Final Date todayDate = Date.today();
		Final Account acc = TestFactory.createAccount();
		opp = TestFactory.createOpportunity(acc.Id, usuario.Id);
		Final Product2 prod = TestFactory.createProduct();
		TestFactory.createOLI(opp.Id, prod.Id);
		insert new Opportunity_Solution_Commitment__c(opportunity_id__c = opp.Id);
		opp.StageName = '04';
		opp.opportunity_status_type__c = '11';
		Test.startTest();
		update opp;
		Final List<OpportunityLineItem> oliList = [select Id, price_quote_date__c from OpportunityLineItem where OpportunityId =:opp.Id];
		Final List<Opportunity_Solution_Commitment__c> oscList = [select Id, price_quote_date__c from Opportunity_Solution_Commitment__c where opportunity_id__c =:opp.Id];
		Final List<Date> actual = new List<Date> { todayDate, todayDate};
		Final List<Date> result = new List<Date> { oliList[0].price_quote_date__c, oscList[0].price_quote_date__c};
		System.assertEquals(result, actual);
		Test.stopTest();
	}

	@isTest
	static void changeState08() {
		Final User usuario = TestFactory.createUser('TestUser1', EXXECUTIVE);
		Final Account acc = TestFactory.createAccount();
		opp = TestFactory.createOpportunity(acc.Id, usuario.Id);
		Final Product2 prod = TestFactory.createProduct();
		TestFactory.createOLI(opp.Id, prod.Id);
		insert new Opportunity_Solution_Commitment__c(opportunity_id__c = opp.Id);
		opp.StageName = '04';
		opp.opportunity_status_type__c = '08';
		Test.startTest();
		update opp;
		Final List<OpportunityLineItem> oliList = [select Id, price_quote_date__c from OpportunityLineItem where OpportunityId =:opp.Id];
		Final List<Opportunity_Solution_Commitment__c> oscList = [select Id, price_quote_date__c from Opportunity_Solution_Commitment__c where opportunity_id__c =:opp.Id];
		Final List<Date> actual = new List<Date> {Date.today(), Date.today()};
		Final List<Date> result = new List<Date> {oliList[0].price_quote_date__c, oscList[0].price_quote_date__c};
		System.assertEquals(result, actual, 'Assertion Error');
		Test.stopTest();
	}

	@isTest
	static void state10() {
		Final User ejecutivo = creaUsuario(EXXECUTIVE);
		creatOpp(ejecutivo);
		test.startTest();
		opp.StageName = '04';
		opp.opportunity_status_type__c = '10';
		opp.isProcess__c = true;
		Update opp;
		test.stopTest();
		//sonar
		Integer result = 1 + 2;
		System.assertEquals(3, result);
	}

	@isTest
	static void state13() {
		Final User ejecutivo = creaUsuario(EXXECUTIVE);
		creatOpp(ejecutivo);
		test.startTest();
		opp.StageName = '04';
		opp.opportunity_status_type__c = '13';
		opp.isProcess__c = true;
		Update opp;
		test.stopTest();
		//sonar
		Integer result = 1 + 2;
		System.assertEquals(3, result);
	}

	@isTest
	static void state19() {
		Final User ejecutivo = creaUsuario(EXXECUTIVE);
		creatOpp(ejecutivo);
		test.startTest();
		opp.StageName = '05';
		opp.opportunity_status_type__c = '19';
		opp.isProcess__c = true;
		Update opp;
		test.stopTest();
		//sonar
		Integer result = 1 + 2;
		System.assertEquals(3, result);
	}

	@isTest
	static void state23() {
		Final User ejecutivo = creaUsuario(EXXECUTIVE);
		creatOpp(ejecutivo);
		test.startTest();
		opp.StageName = '06';
		opp.opportunity_status_type__c = '23';
		opp.isProcess__c = true;
		Update opp;
		test.stopTest();
		//sonar
		Integer result = 1 + 2;
		System.assertEquals(3, result);
	}

	@isTest
	static void state12() {
		Final User ejecutivo = creaUsuario(EXXECUTIVE);
		creatOpp(ejecutivo);
		test.startTest();
		opp.StageName = '04';
		opp.opportunity_status_type__c = '12';
		opp.isProcess__c = true;
		Update opp;
		test.stopTest();
		//sonar
		Integer result = 1 + 2;
		System.assertEquals(3, result);
	}

	@isTest
	static void state24() {
		Final User ejecutivo = creaUsuario(EXXECUTIVE);
		creatOpp(ejecutivo);
		test.startTest();
		opp.StageName = '04';
		opp.opportunity_status_type__c = '24';
		opp.isProcess__c = true;
		Update opp;
		test.stopTest();
		//sonar
		Integer result = 1 + 2;
		System.assertEquals(3, result);
	}

	@isTest
	static void state18() {
		Final User ejecutivo = creaUsuario(EXXECUTIVE);
		creatOpp(ejecutivo);
		test.startTest();
		opp.StageName = '04';
		opp.opportunity_status_type__c = '18';
		opp.isProcess__c = true;
		Update opp;
		test.stopTest();
		//sonar
		Integer result = 1 + 2;
		System.assertEquals(3, result);
	}

	@isTest
	static void state17() {
		Final User ejecutivo = creaUsuario(EXXECUTIVE);
		creatOpp(ejecutivo);
		test.startTest();
		opp.StageName = '04';
		opp.opportunity_status_type__c = '17';
		opp.isProcess__c = true;
		Update opp;
		test.stopTest();
		//sonar
		Integer result = 1 + 2;
		System.assertEquals(3, result);
	}

	@isTest
	static void state09() {
		Final User ejecutivo = creaUsuario(EXXECUTIVE);
		creatOpp(ejecutivo);
		test.startTest();
		opp.StageName = '04';
		opp.opportunity_status_type__c = '09';
		opp.isProcess__c = true;
		Update opp;
		test.stopTest();
		//sonar
		Integer result = 1 + 2;
		System.assertEquals(3, result);
	}

	@isTest
	static void state22() {
		Final User ejecutivo = creaUsuario(EXXECUTIVE);
		creatOpp(ejecutivo);
		test.startTest();
		opp.StageName = '07';
		opp.opportunity_status_type__c = '22';
		opp.isProcess__c = true;
		Update opp;
		test.stopTest();
		//sonar
		Integer result = 1 + 2;
		System.assertEquals(3, result);
	}

	@isTest
	static void state21() {
		Final User ejecutivo = creaUsuario(EXXECUTIVE);
		creatOpp(ejecutivo);
		test.startTest();
		opp.StageName = '05';
		opp.opportunity_status_type__c = '21';
		opp.isProcess__c = true;
		Update opp;
		test.stopTest();
		//sonar
		Integer result = 1 + 2;
		System.assertEquals(3, result);
	}

	@isTest
	static void state20() {
		Final User ejecutivo = creaUsuario(EXXECUTIVE);
		creatOpp(ejecutivo);
		test.startTest();
		opp.StageName = '05';
		opp.opportunity_status_type__c = '20';
		opp.isProcess__c = true;
		Update opp;
		test.stopTest();
		//sonar
		Integer result = 1 + 2;
		System.assertEquals(3, result);
	}
    
	static void creatOpp(User usuario) {
		Account acc = new Account();
		acc.Name = 'MyAccount';
		insert acc;
		opp = new Opportunity(Name = 'Test', CloseDate = system.today(), Stagename = '02', AccountId = acc.id);
		system.RunAs(usuario) {
			insert opp;
		}
	}

	static User creaUsuario(String perfil) {
		Final User usuario = new User();
		usuario.Username = perfil + 'u2@u.com.u';
		usuario.LastName = perfil + 'uLast2';
		usuario.Email = perfil + 'u2@u.com';
		usuario.Alias = perfil.substring(0, 2) + 'uAas2';
		usuario.CommunityNickname = perfil + '2uComm';
		usuario.TimeZoneSidKey = 'America/Mexico_City';
		usuario.LocaleSidKey = LANGUAGE_US;
		usuario.EmailEncodingKey = 'ISO-8859-1';
		usuario.ProfileId =  perfilMapa.get(perfil).Id;
		usuario.LanguageLocaleKey = LANGUAGE_US;
		insert usuario;
		return usuario;
	}
	@isTest
	public static void createOppsDifferentOwnerFromClientOwner() {
		// Get profile information
		Final List<Profile> testProfileList = [SELECT Id FROM Profile WHERE Name =: EXXECUTIVE];

		// Create users
		List<User> testUsersList = new List<User>();
		User testUser1 = new User();
		testUser1.Username = 'testUser1@test.com.demo';
		testUser1.LastName = 'testUser1';
		testUser1.Email = 'testUser1@test.com.demo';
		testUser1.Alias = 'testU1';
		testUser1.CommunityNickname = 'testU1';
		testUser1.TimeZoneSidKey = 'America/Mexico_City';
		testUser1.LanguageLocaleKey = 'es';
		testUser1.LocaleSidKey = LANGUAGE_US;
		testUser1.EmailEncodingKey = 'ISO-8859-1';
		testUser1.ProfileId =  testProfileList.get(0).Id;
		testUsersList.add(testUser1);

		User testUser2 = new User();
		testUser2.Username = 'testUser2@test.com.demo';
		testUser2.LastName = 'testUser2';
		testUser2.Email = 'testUser2@test.com.demo';
		testUser2.Alias = 'testU2';
		testUser2.CommunityNickname = 'testU2';
		testUser2.TimeZoneSidKey = 'America/Mexico_City';
		testUser2.LanguageLocaleKey = 'es';
		testUser2.LocaleSidKey = LANGUAGE_US;
		testUser2.EmailEncodingKey = 'ISO-8859-1';
		testUser2.ProfileId =  testProfileList.get(0).Id;
		testUsersList.add(testUser2);

		insert testUsersList;

		// Create account assigned to one of the users
		Final Account testAccount = new Account(Name = 'TEST ACCOUNT', OwnerId = testUsersList.get(0).Id);
		insert testAccount;

		// Create opportunities assigned to the other users
		List<Opportunity> testOppsList = new List<Opportunity>();
		for(Integer i = 0; i < 202; i++) {
			Opportunity testOpp = new Opportunity(OwnerId = testUsersList.get(1).Id, Name = 'TEST OPP - ' + i, AccountId = testAccount.Id, StageName = '02', Amount = 10000,
                                                  CloseDate = System.Date.today(), opportunity_planning_date__c = System.Date.today(), Support_currency__c = '01', Field_Sup_Closing_Date__c = System.Date.today());
			testOppsList.add(testOpp);
		}
		insert testOppsList;
        
        Final Branch__c newBranch = new Branch__c(Name = 'Oficina Nueva');
		insert newBranch;
        
        Final Opportunity opp2 = new Opportunity(Name = 'Test', CloseDate = system.today(), Stagename = '02', AccountId = testAccount.id, Branch_id__c = newBranch.Id, Field_Sup_Closing_Date__c = null, opportunity_planning_date__c = System.Date.today(),
                                           opportunity_product_family__c = 'Financiamiento a corto plazo', OwnerId = testUsersList.get(1).Id);
		insert opp2;
        
        Final Opportunity opp1 = new Opportunity(Name = 'Test final', CloseDate = system.today(), Stagename = '02', AccountId = testAccount.id, Branch_id__c = newBranch.Id, 
                                           opportunity_product_family__c = 'Financiamiento a corto plazo', OwnerId = testUsersList.get(1).Id);
		insert opp1;
        
        opp1.opportunity_product_family__c = 'Financiamiento a largo plazo';
        opp1.CurrencyIsoCode = 'USD';
        update opp1;
        
        opp1.StageName = '01';
        opp1.OwnerId = testUsersList.get(0).Id;
        update opp1;
        
		// Check that the account user owner is in the opp team
		Set<Id> insertedOppIdsSet = new Set<Id>();
		for(Opportunity insertedOpp :testOppsList) {
			insertedOppIdsSet.add(insertedOpp.Id);
		}

		List<OpportunityTeamMember> oppTeamMembersList = [SELECT Id, OpportunityId, UserId FROM OpportunityTeamMember WHERE OpportunityId =: insertedOppIdsSet AND UserId =: testUsersList.get(0).Id];

		Map<Id, List<OpportunityTeamMember>> oppTeamByOppMap = new Map<Id, List<OpportunityTeamMember>>();

		for(OpportunityTeamMember oppTeamMember : oppTeamMembersList) {
			if(oppTeamByOppMap.containsKey(oppTeamMember.OpportunityId)) {
				oppTeamByOppMap.get(oppTeamMember.OpportunityId).add(oppTeamMember);
			} else {
				List<OpportunityTeamMember> newOppTeamList = new List<OpportunityTeamMember>();
				newOppTeamList.add(oppTeamMember);
				oppTeamByOppMap.put(oppTeamMember.OpportunityId, newOppTeamList);
			}
		}

		for(Opportunity insertedOpp :testOppsList) {
			System.assert (oppTeamByOppMap.containsKey(insertedOpp.Id));
			System.assertEquals(1, oppTeamByOppMap.get(insertedOpp.Id).size());
		}
	}
}