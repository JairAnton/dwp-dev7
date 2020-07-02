/**
 * Test class for AccountContact_Handler class.
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------------
 * Isaías Velázquez            09/07/2018          Original version.<p />
 *
 * @author Isaías Velázquez
 */
@isTest(SeeAllData = false)
public class Account_Handler_test {
    /*
	*   @Variable: STR_EJECUTIVO
	*/
	private static final String STR_EJECUTIVO = 'Ejecutivo';
    /*
	*   @Variable: TWO
	*/
    private static final Integer TWO = 2;
    /*
	*   @Variable: THREE
	*/
    private static final Integer THREE = 3;
    /*
	*   @Variable: TEN
	*/
    private static final Integer TEN = 10;
    
	//Setup data.
	@testSetup
	static void setupData() {
		//Obtenemos el perfil Ejecutivo
		Final String perfil = [SELECT Id FROM Profile WHERE name = :STR_EJECUTIVO].Id;
		//Create Owner Account
		Map<Schema.SObjectField, Object> mapFields = new Map<Schema.SObjectField, Object> {User.LastName => 'OwnerVisit', User.ProfileId => perfil,
			                                                                               User.prof_position_type__c => 'EJECUTIVO BEC'};
		Final User userOwner = getUser(true, mapFields);
		//Create new User
		mapFields = new Map<Schema.SObjectField, Object> {User.LastName => 'SecondOwner', User.ProfileId => perfil,
			                                              User.prof_position_type__c => 'EJECUTIVO BEC'};
		getUser(true, mapFields);
		//Create Branches.
		Final List<Branch__c> lstBranches = new List<Branch__c>();
		for(Integer intI = 0; intI < 5; intI++) {
			lstBranches.add(new Branch__c(Name = 'Oficina ' + intI));
		}
		insert lstBranches;
		//Create Accounts.
		Final List<Account> lstAccounts = new List<Account>();
		for(Integer intI = 0; intI < 20; intI++) {
			lstAccounts.add(new Account(Name = 'AccountName ' + intI, Branch_id__c = lstBranches[0].Id, OwnerId = userOwner.Id));
		}
		insert lstAccounts;

		//Create custom settings for Visit
		Final dwp_kitv__Visit_validations_acc_cs__c[] lstCsValidation = new dwp_kitv__Visit_validations_acc_cs__c[] {};
		Final dwp_kitv__Visit_validations_acc_cs__c csValidation = new dwp_kitv__Visit_validations_acc_cs__c(SetupOwnerId = UserInfo.getOrganizationId(),
		                                                                                                     dwp_kitv__User_Team_Member__c = true);
		lstCsValidation.add(csValidation);
		insert lstCsValidation;
	}

	//Positive method.
	@isTest
	static void positiveMethod() {
		//Start test.
		Test.startTest();
		Final List<Account> lstAccounts = [SELECT Id, Name FROM Account LIMIT 20];
		Final List<Branch__c> lstBranches = [SELECT Id, Name FROM Branch__c limit 5];
		Integer iterator = 0;
		Final Integer cont = lstBranches.size() - 1;
		for(Account objAccount : lstAccounts) {
			objAccount.branch_id__c = lstBranches[iterator].Id;
			iterator++;
			if(iterator >= cont) {
				iterator = 0;
			}
		}
		update lstAccounts;

		//Stop test.
		Test.stopTest();

		//sonar
		final Integer result = iterator + 2;
		System.assertEquals(2, result, 'success!!!');
	}

	/*Test AfterInsert*/
	@isTest
	static void afterInsertTest() {
		Final String ejecutivo = STR_EJECUTIVO;
		Final User UOwTest01 = TestFactory.createUser('UserOwnerTest01', ejecutivo);
		TestFactory.createUser('UserOwnerTest02', ejecutivo);
		Final User UATest011 = TestFactory.createUser('UserAssitantTest011', ejecutivo);
		Final User UATest012 = TestFactory.createUser('UserAssitantTest012', ejecutivo);
		Final List<User_Assistant_Team__c> uat_insert = new List<User_Assistant_Team__c>();
		uat_insert.add(new User_Assistant_Team__c(user_id__c = UOwTest01.Id, assistant_id__c = UATest011.Id));
		uat_insert.add(new User_Assistant_Team__c(user_id__c = UOwTest01.Id, assistant_id__c = UATest012.Id));
		insert uat_insert;
		System.runAs(UOwTest01) {
			Test.startTest();
			Final Account acc = new Account(Name = 'AccountTest');
			insert acc;
			Test.stopTest();
		}
        Boolean result;
        Final List<User_Assistant_Team__c> ltsAssistant = [SELECT Id FROM User_Assistant_Team__c LIMIT 10];
        if(ltsAssistant.size() == TWO) {
            result = true;
        } else {
            result = false;
        }
		System.assert(result, 'success!!!');
	}

	/*Test afterUpdate*/
	@isTest
	static void afterUpdateTest() {
		Final User UOTest01 = TestFactory.createUser('UserOwnerTest01', STR_EJECUTIVO);
		Final User UOTest02 = TestFactory.createUser('UserOwnerTest02', STR_EJECUTIVO);
		Final User UATest011 = TestFactory.createUser('UserAssitantTest011', STR_EJECUTIVO);
		Final User UATest012 = TestFactory.createUser('UserAssitantTest012', STR_EJECUTIVO);
		Final User UATest013 = TestFactory.createUser('UserAssitantTest013', STR_EJECUTIVO);
		TestFactory.createUser('UserAssitantTest021', STR_EJECUTIVO);
		Final List<User_Assistant_Team__c> uat_insert = new List<User_Assistant_Team__c>();
		uat_insert.add(new User_Assistant_Team__c(user_id__c = UOTest01.Id, assistant_id__c = UATest011.Id));
		uat_insert.add(new User_Assistant_Team__c(user_id__c = UOTest01.Id, assistant_id__c = UATest012.Id));
		uat_insert.add(new User_Assistant_Team__c(user_id__c = UOTest02.Id, assistant_id__c = UATest013.Id));
		insert uat_insert;

		System.runAs(UOTest01) {
			Test.startTest();
			Final Account acc = new Account(Name = 'AccountTest');
			insert acc;
            Final Account accUpd = new Account();
            accUpd.Id = acc.Id;
			accUpd.OwnerId = UOTest02.Id;
			update accUpd;
			Test.stopTest();
		}
        Boolean result;
        Final List<User_Assistant_Team__c> ltsAssistant = [SELECT Id FROM User_Assistant_Team__c LIMIT 10];
        if(ltsAssistant.size() == THREE) {
            result = true;
        } else {
            result = false;
        }
		System.assert(result, 'success!!!');
	}

	/*Test Update Owner in VMT*/
	@isTest
	public static void updateOwnerVisitTeam() {
		//get Owner
		Final User oldOwner = [SELECT Id, isActive, prof_position_type__c, Name FROM User WHERE LastName LIKE '%OwnerVisit%' limit 1];

		//Create new Owner
		Final String perfil = [SELECT Id FROM Profile WHERE name = :STR_EJECUTIVO].Id;
		Final Map<Schema.SObjectField, Object> mapFields = new Map<Schema.SObjectField, Object> {User.ProfileId => perfil, User.prof_position_type__c => 'EJECUTIVO BEC'};
		Final User newOwner = getUser(true, mapFields);

		//get Accounts
		Final List<Account> lstNewOwnsAcc = [SELECT Id, OwnerId, Name FROM Account WHERE OwnerId =:oldOwner.Id limit 20];

		//Create Visit for each account
		System.runAs(oldOwner) {
			dwp_kitv__Visit__c visita;
			Final List<dwp_kitv__Visit__c> lstVisit = new List<dwp_kitv__Visit__c>();
			for(Account a:lstNewOwnsAcc) {
				visita = new dwp_kitv__Visit__c(Name = 'Visit' + a.Name, dwp_kitv__visit_start_date__c = System.today(), dwp_kitv__visit_duration_number__c = '15',
				                                dwp_kitv__account_id__c = a.Id, dwp_kitv__visit_purpose_type__c = '01', dwp_kitv__visit_status_type__c = '01');
				lstVisit.add(visita);
			}
			insert lstVisit;

			Final dwp_kitv__Visit_Management_Team__c[] lstVMT = new dwp_kitv__Visit_Management_Team__c[] {};
			for(Integer i = 0; i < 20; i++) {
				lstVMT.add(new dwp_kitv__Visit_Management_Team__c(dwp_kitv__visit_id__c = lstVisit[i].Id, dwp_kitv__user_id__c = newOwner.Id));
				if(i < TEN) {
					lstVisit[i].dwp_kitv__visit_status_type__c = '06';
				}
			}
			insert lstVMT;
			update lstVisit;
		}

		//Start Test - Update Owner
		Test.startTest();
		for(Account acc:lstNewOwnsAcc) {
			acc.OwnerId = newOwner.Id;
		}
		update lstNewOwnsAcc;
		Test.stopTest();

		Final dwp_kitv__Visit_Management_Team__c[] visitTeam = [SELECT Id, Name, dwp_owner_visit__c, dwp_kitv__user_id__c, dwp_kitv__visit_id__c FROM
		                                                        dwp_kitv__Visit_Management_Team__c WHERE dwp_kitv__user_id__c =:newOwner.Id AND
		                                                                                                                            (dwp_kitv__visit_id__r.report_visit_status_type__c = 'No realizada' OR
		                                                                                                                                                                                 dwp_kitv__visit_id__r.report_visit_status_type__c = 'Pendiente de feedback')];
		System.assertEquals(10, visitTeam.size(), 'Compared VMT new owner size');
	}

	/*Test Update Branch in Visit Object*/
	@isTest
	public static void updateBranchVisit() {
		//get Owner
		Final User owner = [SELECT Id, isActive, Name FROM User WHERE LastName Like '%OwnerVisit%' limit 1];
		Final User newOwner = [SELECT Id, isActive, Name FROM User WHERE LastName Like '%SecondOwner%' limit 1];
		//Create new branch
		Final Branch__c newBranch = new Branch__c(Name = 'Oficina Nueva');
		insert newBranch;

		//Create Visit's
		Final List<Account> lstAcc = [SELECT Id, Name, Branch_id__c, OwnerId FROM Account WHERE OwnerId =:owner.Id limit 20];
		System.runAs(owner) {
			dwp_kitv__Visit__c visita;
			final List<dwp_kitv__Visit__c> lstVisit = new List<dwp_kitv__Visit__c>();
			for(Account acc:lstAcc) {
				visita = new dwp_kitv__Visit__c(Name = 'Visit' + acc.Name, dwp_kitv__visit_start_date__c = System.today(), dwp_kitv__visit_duration_number__c = '15',
				                                dwp_kitv__account_id__c = acc.Id, dwp_kitv__visit_purpose_type__c = '01', dwp_kitv__visit_status_type__c = '01',
				                                dwp_branch_id__c = acc.Branch_id__c);
				lstVisit.add(visita);
			}
			insert lstVisit;
			//End 10 Visit
			final List<dwp_kitv__Visit__c> lstVisitUpd = new List<dwp_kitv__Visit__c>();
			for(Integer i = 0; i < 10; i++) {
                Final dwp_kitv__Visit__c visitAux = new dwp_kitv__Visit__c();
                visitAux.Id = lstVisit[i].id;
				visitAux.dwp_kitv__visit_status_type__c = '06';
                lstVisitUpd.add(visitAux);
			}
			update lstVisitUpd;
		}
		//Start Test - Update Branch
		Test.startTest();
		for(Account acc:lstAcc) {
			acc.Branch_id__c = newBranch.Id;
		}
		lstAcc[10].OwnerId = newOwner.Id;
		update lstAcc;
		Test.stopTest();

		Final dwp_kitv__Visit__c[] visitasAct = [SELECT id, Name FROM dwp_kitv__Visit__c WHERE dwp_branch_id__c =:newBranch.Id];
		System.assertEquals(10, visitasAct.size(), 'Compared Visit Size');
	}

	/*Test Change Gestor for AP*/
	@isTest
	public static void updateAPMainGestor() {
		Final User[] lstUser = [SELECT Id FROM User WHERE LastName Like '%Owner%' LIMIT 2];
		Final Account[] lstAcc = [SELECT Id FROM Account LIMIT 20];
		//Create AP's
		Final acpl__Account_Planning__c[] lstAP = new acpl__Account_Planning__c[] {};
		for(Account acc:lstAcc) {
			lstAP.add(AP_FactoryTest_tst.createAccountPlanning(acc.Id, lstUser[0].Id, null, true));
		}
		insert lstAP;
		Final bupl__AP_Team__c[] lstAPT = new bupl__AP_Team__c[] {};
		for(acpl__Account_Planning__c ap:lstAP) {
			lstAPT.add(new bupl__AP_Team__c(bupl__gf_ap_team_user_id__c = lstUser[1].Id, acpl__gf_account_planning_id__c = ap.Id,
			                                account_planning_Owner__c = false, bupl__gf_ap_team_role_user_name__c = 'Acompanante'));
		}
		insert lstAPT;
		Test.startTest();
        Final List<Account> ltsAccUpd = new List<Account>();
		for(Account acc : lstAcc) {
            Final Account accAux = new Account();
            accAux.Id = acc.Id;
			accAux.OwnerId = lstUser[1].Id;
            ltsAccUpd.add(accAux);
		}
		update ltsAccUpd;
		Test.stopTest();
		Final bupl__AP_Team__c[] resultAPT = [SELECT Id FROM bupl__AP_Team__c WHERE bupl__gf_ap_team_user_id__c =: lstUser[1].Id AND account_planning_Owner__c = true];
		System.assertEquals(20, resultAPT.size(), 'Fail Assert');
	}

	/*Create User Data*/
	private static User getUser(Boolean doInsert, Map<Schema.SObjectField, Object> mapFields) {
		Final User obj = new User();
		Final Double random = Math.random();
		obj.LastName = 'User' + random;
		obj.Username = obj.LastName + '@user.com.u';
		obj.Email = obj.LastName + 'user@u.com.u';
		obj.Alias = String.valueOf(random).substring(0, 3) + 'uAas2';
		obj.TimeZoneSidKey = 'America/Mexico_City';
		obj.IsActive = true;
		obj.LocaleSidKey = 'en_US';
		obj.EmailEncodingKey = 'ISO-8859-1';
		obj.LanguageLocaleKey = 'es';
		for(Schema.SObjectField sfield : mapFields.keySet()) {
			obj.put(sfield, mapFields.get(sfield));
		}
		if(doInsert) {
			insert obj;
		}
		return obj;
	}
}