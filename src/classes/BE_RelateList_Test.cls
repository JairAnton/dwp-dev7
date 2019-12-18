/**
* _________________________________________________________________________________
* @Name     BE_RelateList_Test
* @Author   Antony de la rosa guzman
* @Date     2019-11-13
* @Group    DWP Perú
* @Description Clase de pruebas del controlador BE_RelateList_Cls que muestra 
*              los datos de las visitas.
* _________________________________________________________________________________
* @Changes
* _________________________________________________________________________________
*/
@isTest
public class BE_RelateList_Test {
    /*
	* Attribute
	*/
    private static final String OBJECTNAME = 'dwp_kitv__Visit__c';
    /*
	* Attribute
	*/
    private static final string FIELNAMERELATION ='dwp_kitv__account_id__c';
    /*
	* Attribute
	*/
    private static final String FIELDS='Name,dwp_kitv__visit_start_date__c,CreatedBy.Name'; 
    /*
	* Attribute
	*/
    private static final String FILTERS='dwp_kitv__visit_start_date__c>= TODAY';
    /*
	* Attribute
	*/
    private static final String ORDERROW='dwp_kitv__visit_start_date__c asc'; 
    /*
	* Attribute
	*/
    private static final String LIMITROW='5'; 
    
    @testSetup
    private static void makeData() {
        final  User thisUser = BE_UtilitysDataTest_Test.crearUsuario('User test','Administrador del sistema','');
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
            final dwp_kitv__Visit__c Visit = BE_UtilitysDataTest_Test.crearVisita('Test Visita',acc.Id,'02');
            insert Visit;
        }
    }
    
    @isTest
    private static void testMethod1() {
        final User thisUser = [SELECT Id FROM User WHERE Name = 'User test'];
        final List<Account> lsAcc = [SELECT Id,Name FROM Account WHERE OwnerId =:thisUser.id];
        System.runAs(thisUser) {
            test.startTest();
            BE_RelateList_Cls.getRelatedVisit(lsAcc[0].Id,OBJECTNAME,FIELNAMERELATION,FIELDS,FILTERS,ORDERROW,LIMITROW);
            System.assertNotEquals(null, lsAcc[0].Name, 'datos registrados con exito');
            test.stopTest();
        }
    }
    
    @isTest
    private static void testMethod2() {
        final BE_RelateList_Cls tstCls = new BE_RelateList_Cls();
        System.assertNotEquals(null, tstCls, 'Constructor iniciado con éxito');
    }
}