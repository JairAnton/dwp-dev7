/**
* _________________________________________________________________________________
* @Name     BE_Ulr_Modalwelcome_Test
* @Author   Antony de la rosa guzman
* @Date     2019-12-04
* @Group    DWP Perú
* @Description Clase de pruebas del controlador BE_Ulr_Modalwelcome_Cls.
* _________________________________________________________________________________
* @Changes
* _________________________________________________________________________________
*/
@isTest
public class BE_Ulr_Modalwelcome_Test {
    @testSetup
    private static void makeData() {
        final User thisUser = BE_UtilitysDataTest_Test.crearUsuario('User test','Administrador del sistema','');
        insert thisUser;
        System.runAs(thisUser) {
            final List<BE_Urls_Dynamic__c> url = new List<BE_Urls_Dynamic__c>();
            url.add(new BE_Urls_Dynamic__c(Name='test',BE_Titulo_Url__c ='test',BE_Url__c = 'test'));
            insert url;
        }
    }
    
    @isTest
    private static void testMethod1() {
        final User thisUser = [SELECT Id,Name FROM User WHERE Name = 'User test'];
        System.runAs(thisUser) {
            test.startTest();
            BE_Ulr_Modalwelcome_Cls.getlisAllData('test');
            System.assertNotEquals(null, thisUser.Name, 'datos registrados con exito');
            test.stopTest();
        }
    }
}