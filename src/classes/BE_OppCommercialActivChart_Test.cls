/**
 * _________________________________________________________________________________
 * @Name     BE_OppCommercialActivChart_Test
 * @Author   Antony de la rosa guzman
 * @Date     2019-11-13
 * @Group    DWP Perú
 * @Description Clase de pruebas del controlador BE_OppCommercialActivChart_Cls que muestra
 *              los datos de las oportunidades.
 * _________________________________________________________________________________
 * @Changes
 * _________________________________________________________________________________
 */
@isTest
public class BE_OppCommercialActivChart_Test {
	@testSetup
	private static void makeData() {
		final User thisUser = BE_UtilitysDataTest_Test.crearUsuario('User test', 'Administrador del sistema', '');
		insert thisUser;
		System.runAs(thisUser) {
			final Account acc = BE_UtilitysDataTest_Test.crearCuenta('Test acc');
			acc.BillingStreet = 'test';
			acc.BillingCity = 'Lima';
			acc.financial_program_expiry_date__c = system.today() - 1;
			insert acc;
			final Opportunity opp = BE_UtilitysDataTest_Test.crearOportunidad('Test opp', acc.Id, userInfo.getUserId(), null);
			opp.Amount = 79888;
			insert opp;
			final Opportunity opp1 = BE_UtilitysDataTest_Test.crearOportunidad('Test opp1', acc.Id, userInfo.getUserId(), null);
			opp1.Amount = 79888;
			opp1.opportunity_planning_date__c = system.today();
			insert opp1;
			final Opportunity opp2 = BE_UtilitysDataTest_Test.crearOportunidad('Test opp2', acc.Id, userInfo.getUserId(), null);
			opp2.Amount = 79888;
			opp2.opportunity_planning_date__c = system.today();
			insert opp2;
			final Opportunity opp3 = BE_UtilitysDataTest_Test.crearOportunidad('Test opp2', acc.Id, userInfo.getUserId(), null);
			opp3.Amount = 79888;
			insert opp3;
			opp.StageName = '06';
			opp.opportunity_planning_date__c = system.today();
			Update opp;
			opp3.StageName = '07';
			opp3.opportunity_planning_date__c = system.today();
			Update opp3;
		}
	}

	@isTest
	private static void testMethod1() {
		final User thisUser = [SELECT Id FROM User WHERE Name = 'User test'];
		final List<Account> lsAcc = [SELECT Id, Name FROM Account WHERE OwnerId =:thisUser.id];
		System.runAs(thisUser) {
			test.startTest();
			BE_OppCommercialActivChart_Cls.getOppAbierInfo(lsAcc[0].Id, false);
			BE_OppCommercialActivChart_Cls.getOppInfoHits(lsAcc[0].Id, false);
			System.assertNotEquals(null, lsAcc[0].Name, 'datos registrados con exito');
			test.stopTest();
		}
	}

	@isTest
	private static void testMethod2() {
		final BE_OppCommercialActivChart_Cls tstCls = new BE_OppCommercialActivChart_Cls();
		System.assertNotEquals(null, tstCls, 'Constructor iniciado con éxito');
	}
}
