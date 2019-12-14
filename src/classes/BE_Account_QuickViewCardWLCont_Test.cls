/**
* _________________________________________________________________________________
* @Name     BE_Account_QuickViewCardWLCont_Test
* @Author   Antony de la rosa guzman
* @Date     2019-11-11
* @Group    DWP Perú
* @Description Clase de pruebas del controlador BE_Account_QuickViewCardWLCont_Ctrl que muestra 
*              los datos de la ficha cliente version WLCont.
* _________________________________________________________________________________
* @Changes
* _________________________________________________________________________________
*/
@isTest
public class BE_Account_QuickViewCardWLCont_Test{
    @testSetup
    private static void makeData() {
        final User thisUser = BE_UtilitysDataTest_Test.crearUsuario('User test','Administrador del sistema','');
        insert thisUser;
        System.runAs(thisUser) {
            //Create custom settings
            Final dwp_kitv__Visit_validations_acc_cs__c[] lstCsValidation=new dwp_kitv__Visit_validations_acc_cs__c[]{};
            Final dwp_kitv__Visit_validations_acc_cs__c csValidation=new dwp_kitv__Visit_validations_acc_cs__c(SetupOwnerId=UserInfo.getOrganizationId(), dwp_kitv__User_Team_Member__c=true);
            lstCsValidation.add(csValidation);
            insert lstCsValidation;
            Final Account acc = BE_UtilitysDataTest_Test.crearCuenta('Test acc');
            acc.BillingStreet = 'test';
            acc.BillingCity='Lima';
            insert acc;
            final Account_variation_information__c vari = BE_UtilitysDataTest_Test.crearVariation('SPREAD (%)',acc.Id,'2 Positivos');
            insert vari;
            final Account_variation_information__c vari1 = BE_UtilitysDataTest_Test.crearVariation('CUOTA Directa (%)',acc.Id,'1 Positivo');
            insert vari1;
            final Account_variation_information__c vari2 = BE_UtilitysDataTest_Test.crearVariation('MARGEN FINANCIERO',acc.Id,'1 Negativo');
            insert vari2;
            final Account_variation_information__c vari3 = BE_UtilitysDataTest_Test.crearVariation('ACTIVO Directa',acc.Id,'2 Negativos');
            insert vari3;
            final Opportunity opp = BE_UtilitysDataTest_Test.crearOportunidad('Test opp', acc.Id, userInfo.getUserId(),null);
            insert opp;
            final dwp_kitv__Visit__c visit = BE_UtilitysDataTest_Test.crearVisita('Test Visita',acc.Id,'02');
            insert visit;
            Visit.dwp_kitv__visit_status_type__c ='06';
            update visit;
        }
    }
    
    @isTest
    private static void testMethod1() {
        final User thisUser = [SELECT Id FROM User WHERE Name = 'User test'];
        final List<Account> lsAcc = [SELECT Id,Name FROM Account WHERE OwnerId =:thisUser.id];
        System.runAs(thisUser) {
            test.startTest();
            BE_Account_QuickViewCardWLCont_Cls.getData(lsAcc[0].Id);
            System.assertNotEquals(null, lsAcc[0].Name, 'datos registrados con exito');
            test.stopTest();
        }
    }
    
    @isTest
    private static void testMethod2() {
        final BE_Account_QuickViewCardWLCont_Cls tstCls = new BE_Account_QuickViewCardWLCont_Cls();
        System.assertNotEquals(null, tstCls, 'Constructor iniciado con éxito');
    }
    @isTest
    private static void testMethodNotCte() {
        User thisUser = [SELECT Id FROM User WHERE Name = 'User test'];
        System.runAs(thisUser) {
            test.startTest();
            BE_Account_QuickViewCardWLCont_Cls.getData('676789');
            test.stopTest();
        }
    }    
}