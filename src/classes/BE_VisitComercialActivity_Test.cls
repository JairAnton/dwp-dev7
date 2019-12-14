/**
* _________________________________________________________________________________
* @Name     BE_VisitComercialActivity_Test
* @Author   Antony de la rosa guzman
* @Date     2019-11-13
* @Group    DWP Perú
* @Description Clase de pruebas del controlador BE_VisitComercialActivity_Cls que muestra 
*              los datos de las visitas.
* _________________________________________________________________________________
* @Changes
* _________________________________________________________________________________
*/
@isTest
public class BE_VisitComercialActivity_Test {
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
            final Account acc = BE_UtilitysDataTest_Test.crearCuenta('Test acc');
            acc.BillingStreet = 'test';
            acc.BillingCity='Lima';
            insert acc;
            final dwp_kitv__Visit__c visit = BE_UtilitysDataTest_Test.crearVisita('Test Visita',acc.Id,'02');
            insert visit;
            final dwp_kitv__Visit__c visit1 = BE_UtilitysDataTest_Test.crearVisita('Test Visita',acc.Id,'06');
            insert visit1;
            final dwp_kitv__Visit__c visit2 = BE_UtilitysDataTest_Test.crearVisita('Test Visita',acc.Id,'06');
            insert visit2;
            final dwp_kitv__Visit_Topic__c topic = BE_UtilitysDataTest_Test.crtVisitTopic(String.valueOf(visit1.Id));
            topic.dwp_kitv__visit_id__c = visit.Id;
            topic.dwp_kitv__topic_desc__c='test';
            Insert topic;
            final Contact realcon=BE_UtilitysDataTest_Test.crearContacto(null, 'Test', 'Contacto');
            insert realcon;
            final dwp_kitv__Visit_Contact__c con=new dwp_kitv__Visit_Contact__c();
            con.dwp_kitv__contact_called_type__c=true;
            con.dwp_kitv__visit_id__c=visit.Id;
            con.dwp_kitv__contact_id__c=realcon.Id;
            insert con;
            visit1.dwp_kitv__visit_start_date__c= datetime.newInstance(System.today().year(), 9, 15, 13, 30, 0);
            visit1.dwp_kitv__visit_status_type__c = '06';
            update visit1;
            visit.dwp_kitv__visit_start_date__c= datetime.newInstance(System.today().year()-1, 9, 15, 13, 30, 0);
            visit.dwp_kitv__visit_status_type__c = '06';
            update Visit;
        }
    }
    
    @isTest
    private static void testMethod1() {
        final User thisUser = [SELECT Id FROM User WHERE Name = 'User test'];
        final List<Account> lsAcc = [SELECT Id,Name FROM Account WHERE OwnerId =:thisUser.id];
        System.runAs(thisUser) {
            test.startTest();
            BE_VisitComercialActivity_Cls.getVisitInfo(lsAcc[0].Id);
            System.assertNotEquals(null, lsAcc[0].Name, 'datos registrados con exito');
            test.stopTest();
        }
    }
    
    @isTest
    private static void testMethod2() {
        final BE_VisitComercialActivity_Cls tstCls = new BE_VisitComercialActivity_Cls();
        System.assertNotEquals(null, tstCls, 'Constructor iniciado con éxito');
    }
}