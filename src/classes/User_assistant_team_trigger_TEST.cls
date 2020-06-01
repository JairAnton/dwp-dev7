@isTest
private class User_assistant_team_trigger_TEST {
	/*
	   @testSetup
	   static void setup(){
	    User UserOwnerTest01 = TestFactory.createUser('UserOwnerTest01', 'Ejecutivo');
	    User UserOwnerTest02 = TestFactory.createUser('UserOwnerTest02', 'Ejecutivo');
	    User UserAssitantTest011 = TestFactory.createUser('UserAssitantTest011', 'Ejecutivo');
	    User UserAssitantTest012 = TestFactory.createUser('UserAssitantTest012', 'Ejecutivo');
	    User UserAssitantTest013 = TestFactory.createUser('UserAssitantTest013', 'Ejecutivo');
	    User UserAssitantTest021 = TestFactory.createUser('UserAssitantTest021', 'Ejecutivo');
	    Account acc1=new Account(Name = 'TestAcct01',OwnerId = UserOwnerTest01.id);
	    insert acc1;
	    Account acc2=new Account(Name = 'TestAcct02', OwnerId = UserOwnerTest02.id);
	    insert acc2;
	   }
	 */

	@isTest
    static void insertTest() {
		User UserOwnerTest01 = TestFactory.createUser('UserOwnerTest01', 'Ejecutivo');
		User UserOwnerTest02 = TestFactory.createUser('UserOwnerTest02', 'Ejecutivo');
		User UserAssitantTest011 = TestFactory.createUser('UserAssitantTest011', 'Ejecutivo');
		User UserAssitantTest012 = TestFactory.createUser('UserAssitantTest012', 'Ejecutivo');
		User UserAssitantTest013 = TestFactory.createUser('UserAssitantTest013', 'Ejecutivo');
		User UserAssitantTest021 = TestFactory.createUser('UserAssitantTest021', 'Ejecutivo');
		Account acc1 = new Account(Name = 'TestAcct01', OwnerId = UserOwnerTest01.id);
		insert acc1;
		Account acc2 = new Account(Name = 'TestAcct02', OwnerId = UserOwnerTest02.id);
		insert acc2;
		User_Assistant_Team__c Assistant011 = new User_Assistant_Team__c(assistant_id__c = UserAssitantTest011.id, user_id__c = UserOwnerTest01.id);
		User_Assistant_Team__c Assistant012 = new User_Assistant_Team__c(assistant_id__c = UserAssitantTest012.id, user_id__c = UserOwnerTest01.id);
		User_Assistant_Team__c Assistant013 = new User_Assistant_Team__c(assistant_id__c = UserAssitantTest013.id, user_id__c = UserOwnerTest01.id);
		User_Assistant_Team__c Assistant021 = new User_Assistant_Team__c(assistant_id__c = UserAssitantTest021.id, user_id__c = UserOwnerTest01.id);
		List <User_Assistant_Team__c> uatList = new List<User_Assistant_Team__c>();
		uatList.add(Assistant011);
		uatList.add(Assistant012);
		uatList.add(Assistant013);
		uatList.add(Assistant021);
		insert uatList;
		List<AccountTeamMember> atmList = [select id, AccountId, UserId from AccountTeamMember];
		System.assertEquals(4, atmList.size());
	}

	@isTest
    static void deleteTest() {
		User UserOwnerTest01 = TestFactory.createUser('UserOwnerTest01', 'Ejecutivo');
		User UserOwnerTest02 = TestFactory.createUser('UserOwnerTest02', 'Ejecutivo');
		User UserAssitantTest011 = TestFactory.createUser('UserAssitantTest011', 'Ejecutivo');
		User UserAssitantTest012 = TestFactory.createUser('UserAssitantTest012', 'Ejecutivo');
		User UserAssitantTest013 = TestFactory.createUser('UserAssitantTest013', 'Ejecutivo');
		User UserAssitantTest021 = TestFactory.createUser('UserAssitantTest021', 'Ejecutivo');
		Account acc1 = new Account(Name = 'TestAcct01', OwnerId = UserOwnerTest01.id);
		insert acc1;
		Account acc2 = new Account(Name = 'TestAcct02', OwnerId = UserOwnerTest02.id);
		insert acc2;
		User_Assistant_Team__c Assistant011 = new User_Assistant_Team__c(assistant_id__c = UserAssitantTest011.id, user_id__c = UserOwnerTest01.id);
		User_Assistant_Team__c Assistant012 = new User_Assistant_Team__c(assistant_id__c = UserAssitantTest012.id, user_id__c = UserOwnerTest01.id);
		User_Assistant_Team__c Assistant013 = new User_Assistant_Team__c(assistant_id__c = UserAssitantTest013.id, user_id__c = UserOwnerTest01.id);
		User_Assistant_Team__c Assistant021 = new User_Assistant_Team__c(assistant_id__c = UserAssitantTest021.id, user_id__c = UserOwnerTest01.id);
		List <User_Assistant_Team__c> uatList = new List<User_Assistant_Team__c>();
		uatList.add(Assistant011);
		uatList.add(Assistant012);
		uatList.add(Assistant013);
		uatList.add(Assistant021);
		insert uatList;
		delete uatList;
		List<AccountTeamMember> atmList = [select id, AccountId, UserId from AccountTeamMember];
		System.assertEquals(0, atmList.size());
	}
}
