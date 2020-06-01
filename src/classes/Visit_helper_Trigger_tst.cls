/* Test class for AccountContact_Handler class.
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------------
 * Diego Carbajal            0/06/2019          Original version.<p />
 *
 * @author Diego Carbajal
 */
@isTest
public class Visit_helper_Trigger_tst {
	/*Setup Data*/
	@TestSetup
	public static void setUp() {
		Final String perfil = [SELECT Id FROM Profile WHERE name = 'Ejecutivo'].Id;
		//Create custom settings
		insert new dwp_kitv__Visit_validations_acc_cs__c(SetupOwnerId = UserInfo.getOrganizationId(), dwp_kitv__User_Team_Member__c = true);
		/*Crea Ejecutivo propietario*/
		Map<Schema.SObjectField, Object> mapFields = new Map<Schema.SObjectField, Object> {User.LastName => 'Owner_Account', User.ProfileId => perfil,
			                                                                               User.user_position_equivalence__c => 'EJECUTIVO BEC'};
		Final User userOwner = TestFactory.getUser(true, mapFields);
		/*Crea Ejecutivo a compartir registro*/
		mapFields = new Map<Schema.SObjectField, Object> {User.LastName => 'Vinegar', User.ProfileId => perfil,
			                                              User.user_position_equivalence__c => 'GERENTE BEC'};
		TestFactory.getUser(true, mapFields);
		/*Crea Ejecutivo 2 a compartir registro*/
		mapFields = new Map<Schema.SObjectField, Object> {User.LastName => 'Guido', User.ProfileId => perfil,
			                                              User.user_position_equivalence__c => 'GERENTE BEC'};
		TestFactory.getUser(true, mapFields);
		//Crea oficina
		Final Branch__c oficina = new Branch__c(Name = 'Chincha BEC');
		insert oficina;
		//Crea Account
		mapFields = new Map<Schema.SObjectField, Object> {Account.OwnerId => userOwner.Id, Account.Name => 'CLIENTE MARTÍN', Account.branch_id__c => oficina.Id};
		Final Account cuenta = TestFactory.getAccount(true, mapFields);
		//Creación de visitas
		Final dwp_kitv__Visit__c [] lstVisitas = new dwp_kitv__Visit__c[] {};
		dwp_kitv__Visit__c tmpV;
		for(Integer i = 0; i < 30; i++) {
			tmpV = new dwp_kitv__Visit__c(dwp_kitv__account_id__c = cuenta.Id, dwp_kitv__visit_duration_number__c = '15', dwp_kitv__visit_start_date__c = System.now());
			lstVisitas.add(tmpV);
		}
		System.runAs(userOwner) {
			insert lstVisitas;
		}
	}

	/*Method to test deleteOwners*/
	@isTest
	public static void deleteOwners() {
		Final User usuario = [SELECT ID, Name, profile.Name FROM USER WHERE LastName LIKE '%Owner_Account%'];
		Final dwp_kitv__Visit_Management_Team__c[] lstEquipos = [SELECT Id FROM dwp_kitv__Visit_Management_Team__c WHERE
		                                                         dwp_kitv__user_id__c =:usuario.Id AND dwp_owner_visit__c = true limit 100];
		Test.startTest();
		Boolean pass = true;
		System.runAs(usuario) {
			try {
				delete lstEquipos;
			} catch(Exception e) {
				System.debug('Exception e ==> ' + e.getMessage());
				pass = false;
			}
		}
		Test.stopTest();
		System.assert (!pass, '!pass is false');
	}

	/*Method to test deleteVMTShare*/
	@isTest
	public static void deleteSharingVMT() {
		Final User owner = [SELECT Id, Name, LastName FROM User WHERE LastName = 'Owner_Account' limit 1];
		Final List<dwp_kitv__Visit_Management_Team__c> lstVMT = new List<dwp_kitv__Visit_Management_Team__c>();
		System.runAs(owner) {
			Final List<dwp_kitv__Visit__c> lstVisit = [SELECT Id FROM dwp_kitv__Visit__c WHERE OwnerId =:owner.Id limit 10];
			Final User userToShare = [SELECT Id FROM User WHERE LastName = 'Vinegar' limit 1];
			Final User userToShare2 = [SELECT Id FROM User WHERE LastName = 'Guido' limit 1];
			for(dwp_kitv__Visit__c visit:lstVisit) {
				lstVMT.add(new dwp_kitv__Visit_Management_Team__c(dwp_kitv__visit_id__c = visit.Id, dwp_kitv__user_id__c = userToShare.Id));
				lstVMT.add(new dwp_kitv__Visit_Management_Team__c(dwp_kitv__visit_id__c = visit.Id, dwp_kitv__user_id__c = userToShare2.Id));
			}
			insert lstVMT;
		}
		Test.startTest();
		delete lstVMT;
		Test.stopTest();
		Final List<dwp_kitv__Visit__Share> visitShare = [SELECT Id, ParentID, RowCause, UserOrGroupId FROM dwp_kitv__Visit__Share WHERE RowCause = 'Manual'];
		Final Integer visitShareSize = visitShare.size();
        System.assertEquals(0, visitShareSize, 'Assertion Error');
	}
}
