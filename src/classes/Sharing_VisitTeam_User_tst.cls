/**
 * ------------------------------------------------------------------------------------------------
 * @Name Sharing_VisitTeam_User_tst
 * @Author Diego Carbajal diego.carbajal@bbva.com
 * @Date Created: 2019-11-20
 * @Group
 * @Description Clase que valida la funcionalidad de la clase Sharing_VisitTeam_User_cls
 */
@isTest
public class Sharing_VisitTeam_User_tst {
	/*Setup Data*/
	@TestSetup
	public static void setUp() {
		Final String perfil = [SELECT Id FROM Profile WHERE name = 'Ejecutivo'].Id;
		//Create custom settings
		insert new dwp_kitv__Visit_validations_acc_cs__c(SetupOwnerId = UserInfo.getOrganizationId(), dwp_kitv__User_Team_Member__c = true);
		/*Crea Ejecutivo propietario*/
		Map<Schema.SObjectField, Object> mapFields = new Map<Schema.SObjectField, Object> {User.LastName => 'Risotto', User.ProfileId => perfil,
			                                                                               User.user_position_equivalence__c => 'EJECUTIVO BEC'};
		Final User userOwner = TestFactory.getUser(true, mapFields);
		/*Crea Ejecutivo a compartir registro*/
		mapFields = new Map<Schema.SObjectField, Object> {User.LastName => 'Vinegar', User.ProfileId => perfil,
			                                              User.user_position_equivalence__c => 'GERENTE BEC'};
		TestFactory.getUser(true, mapFields);
		//Crea oficina
		Final Branch__c oficina = new Branch__c(Name = 'Chincha BEC');
		insert oficina;
		//Crea Account
		mapFields = new Map<Schema.SObjectField, Object> {Account.OwnerId => userOwner.Id, Account.Name => 'CLIENTE MARTÍN', Account.branch_id__c => oficina.Id};
		TestFactory.getAccount(true, mapFields);
	}

	/*Method to test sharingVisitTeamMember*/
	public static testmethod void shareRecordSuccess() {
		Final User owner = [SELECT Id, Name, LastName FROM User WHERE LastName = 'Risotto' limit 1];
		Final Account cuenta = [SELECT Id, branch_id__c FROM Account WHERE OwnerId =: owner.Id limit 1];
		Final dwp_kitv__Visit__c visita;
		System.runAs(owner) {
			visita = new dwp_kitv__Visit__c(Name = 'Visita', dwp_kitv__account_id__c = cuenta.Id, dwp_kitv__visit_duration_number__c = '15',
			                                dwp_kitv__visit_start_date__c = DateTime.now(), dwp_branch_id__c = cuenta.branch_id__c);
			insert visita;
			Final User userToShare = [SELECT Id FROM User WHERE LastName = 'Vinegar' limit 1];
			insert new dwp_kitv__Visit_Management_Team__c(dwp_kitv__visit_id__c = visita.Id, dwp_kitv__user_id__c = userToShare.Id);
		}
		Final List<dwp_kitv__Visit__Share> visitShare = [SELECT Id, ParentID, RowCause, UserOrGroupId FROM dwp_kitv__Visit__Share WHERE RowCause = 'Manual' AND
		                                                                                                                                           ParentID =:visita.Id];
		Final Integer visitShareSize = visitShare.size();
		System.assertEquals(1, visitShareSize, 'Assertion Error');
	}
}
