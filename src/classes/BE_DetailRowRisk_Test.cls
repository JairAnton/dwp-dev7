/**
* _________________________________________________________________________________
* @Name     BE_DetailRowRisk_Test
* @Author   Antony de la rosa guzman
* @Date     2019-11-13
* @Group    DWP Perú
* @Description Clase de pruebas del controlador BE_DetailRowRisk_Cls.
* _________________________________________________________________________________
* @Changes
* _________________________________________________________________________________
*/
@isTest
public class BE_DetailRowRisk_Test {
    @testSetup
    private static void makeData() {
        User thisUser = BE_UtilitysDataTest_Test.crearUsuario('User test','Administrador del sistema','');
        insert thisUser;
        System.runAs(thisUser) {
            Account acc = BE_UtilitysDataTest_Test.crearCuenta('Test acc');
            acc.BillingStreet = 'test';
            acc.BillingCity='Lima';
            acc.net_cash_desc__c='Premiun';
            acc.financial_program_expiry_date__c = system.today()-1;
            insert acc;
        }
    }
    
    @isTest
    private static void testMethod1() {
        User thisUser = [SELECT Id FROM User WHERE Name = 'User test'];
        List<Account> lsAcc = [SELECT Id,Name FROM Account WHERE OwnerId =:thisUser.id];
        System.runAs(thisUser) {
            test.startTest();
            BE_DetailRowRisk_Cls.getDataInfo(lsAcc[0].Id);
            test.stopTest();
        }
    }
    
    @isTest
    private static void testMethod2() {
        BE_DetailRowRisk_Cls tstCls = new BE_DetailRowRisk_Cls();
        System.assertNotEquals(null, tstCls, 'Constructor iniciado con éxito');
    }
     @isTest
    private static void testMethod3() {
        User thisUser = [SELECT Id FROM User WHERE Name = 'User test'];
        List<Account> lsAcc = [SELECT Id,Name FROM Account WHERE OwnerId =:thisUser.id];
        System.runAs(thisUser) {
            test.startTest();
            BE_DetailRowRisk_Cls.getDataInfo('8977');
            test.stopTest();
        }
    }
}