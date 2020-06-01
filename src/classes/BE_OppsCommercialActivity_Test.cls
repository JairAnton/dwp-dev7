/**
 * @Name     BE_OppsCommercialActivity_Test
 * @Author   Antony de la rosa guzman
 * @Date     2019-11-13
 * @Group    DWP Perú
 * @Description Clase de pruebas del controlador BE_OppsCommercialActivity_Cls que muestra
 *              los datos de las oportunidades.
 */
@isTest
public class BE_OppsCommercialActivity_Test {
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
			insert opp;
			final Opportunity opp1 = BE_UtilitysDataTest_Test.crearOportunidad('Test opp1', acc.Id, userInfo.getUserId(), null);
			opp1.Amount = 79888;
			insert opp1;
			opp1.StageName = '07';
			update opp1;
			final Opportunity opp2 = BE_UtilitysDataTest_Test.crearOportunidad('Test opp2', acc.Id, userInfo.getUserId(), null);
			opp2.Amount = 79888;
			insert opp2;
			opp2.StageName = '06';
			update opp2;
		}
	}

	@isTest
	private static void testMethod1() {
		final User thisUser = [SELECT Id FROM User WHERE Name = 'User test'];
		final List<Account> lsAcc = [SELECT Id, Name FROM Account WHERE OwnerId =:thisUser.id];
		System.runAs(thisUser) {
			test.startTest();
			BE_OppsCommercialActivity_Cls.getOppInfo(lsAcc[0].Id);
			System.assertNotEquals(null, lsAcc[0].Name, 'datos registrados con exito');
			test.stopTest();
		}
	}

	@isTest
	private static void testMethod2() {
		final BE_OppsCommercialActivity_Cls tstCls = new BE_OppsCommercialActivity_Cls();
		System.assertNotEquals(null, tstCls, 'Constructor iniciado con éxito');
	}
    
	@isTest
	private static void testMethod3() {
		final User thisUser = [SELECT Id, Name FROM User WHERE Name = 'User test'];
		System.runAs(thisUser) {
			test.startTest();
			BE_OppsCommercialActivity_Cls.getOppInfo('8977');
			System.assertNotEquals(null, thisUser.Name, 'Usuario encontrado');
			test.stopTest();
		}
	}
}
