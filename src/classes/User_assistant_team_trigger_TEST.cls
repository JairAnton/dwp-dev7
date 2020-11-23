/*
 * @Name: User_assistant_team_trigger_TEST
 * @Description: Trigger de Ejecucion User
 * @Create by: Jose Rodriguez
 *
   @Changes
   Date        Author   Email                  				Type
   2019-06-15  JERP     jose.rodriguez.paredes@bbva.com		Creation
   2020-11-15  DJCP     diego.carbajal@bbva.com				Update
 */
@isTest
private class User_assistant_team_trigger_TEST {

	/*** @Description variable E0B*/
	private static Final String E0B = 'E0B';
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

	 /**
     * @Description insertTest
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

	/**
     * @Description deleteTest
     */
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
	
	/**
     * @Description insertSharingSM
     */
    @isTest
    public static void insertSharingSM() {
        Final Id ejeProfileId = BE_SM_Factory_tst.getEjecutivoProfile();
        Final User userGOF = TestFactory.getUser(true, new Map<Schema.SObjectField, Object>{User.ProfileId => ejeProfileId, User.prof_position_id__c => 'E01'});
        Final User userEJE = TestFactory.getUser(true, new Map<Schema.SObjectField, Object>{User.ProfileId => ejeProfileId, User.prof_position_id__c => 'E03', 
            																				User.ManagerId => userGOF.Id});
        Final User userAssist = TestFactory.getUser(true, new Map<Schema.SObjectField, Object>{User.ProfileId => ejeProfileId, User.prof_position_id__c => E0B, 
            																				User.ManagerId => userGOF.Id});
        Final User userAssist2 = TestFactory.getUser(true, new Map<Schema.SObjectField, Object>{User.ProfileId => ejeProfileId, User.prof_position_id__c => E0B, 
            																				User.ManagerId => userGOF.Id});
        BE_SM_Factory_tst.createSalesMeeting(DateTime.newInstance(2020, 11, 1), userEJE.Id, 'Planning', true);
        Test.startTest();
        Final User_Assistant_Team__c[] lstUAT = new User_Assistant_Team__c[]{new User_Assistant_Team__c(user_id__c = userEJE.Id, assistant_id__c = userAssist.Id), 
            																new User_Assistant_Team__c(user_id__c = userEJE.Id, assistant_id__c = userAssist2.Id)};
		System.runAs(userEJE) {insert lstUAT;}
        Test.stopTest();
        Final slmt__Sales_Meeting__Share[] lstSMAssist = [SELECT Id FROM slmt__Sales_Meeting__Share WHERE UserOrGroupId =: userAssist.Id OR UserOrGroupId =:userAssist2.Id];
        System.assertEquals(2, lstSMAssist.size(), 'Assertion Fail');
    }
	
	/**
     * @Description deleteSharingSM
     */
    @isTest
    public static void deleteSharingSM() {
        Final Id ejeProfileId = BE_SM_Factory_tst.getEjecutivoProfile();
        Final User userGOF = TestFactory.getUser(true, new Map<Schema.SObjectField, Object>{User.ProfileId => ejeProfileId, User.prof_position_id__c => 'E01'});
        Final User userEJE = TestFactory.getUser(true, new Map<Schema.SObjectField, Object>{User.ProfileId => ejeProfileId, User.prof_position_id__c => 'E03', 
            																				User.ManagerId => userGOF.Id});
        Final User userAssist = TestFactory.getUser(true, new Map<Schema.SObjectField, Object>{User.ProfileId => ejeProfileId, User.prof_position_id__c => E0B, 
            																				User.ManagerId => userGOF.Id});
        Final User userAssist2 = TestFactory.getUser(true, new Map<Schema.SObjectField, Object>{User.ProfileId => ejeProfileId, User.prof_position_id__c => E0B, 
            																				User.ManagerId => userGOF.Id});
        insert new User_Assistant_Team__c(user_id__c = userEJE.Id, assistant_id__c = userAssist.Id);
        insert new User_Assistant_Team__c(user_id__c = userEJE.Id, assistant_id__c = userAssist2.Id);
        BE_SM_Factory_tst.createSalesMeeting(DateTime.newInstance(2020, 11, 1), userEJE.Id, 'Planning', true);
        Test.startTest();
        delete [SELECT Id FROM User_Assistant_Team__c WHERE user_id__c=:userEJE.Id];
        Test.stopTest();
        Final slmt__Sales_Meeting__Share[] lstSMAssist = [SELECT Id FROM slmt__Sales_Meeting__Share WHERE UserOrGroupId =: userAssist.Id OR UserOrGroupId =:userAssist2.Id];
        System.assertEquals(0, lstSMAssist.size(), 'Assertion Fail');
    }
}