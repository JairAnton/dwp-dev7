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
        //Creación de cuentas con perfil de Migracion
        Final User usuario=TestFactory.createUser('Owner_Account', 'Ejecutivo');
        Final Account[] lstAccount=new Account[]{};
        Account acc;
        for(Integer i=0; i<250; i++) {
            acc=new Account(Name='Cuenta '+i, OwnerId=usuario.Id);
            lstAccount.add(acc);
        }
        insert lstAccount;
        
        //Creación de visitas
        Final dwp_kitv__Visit__c [] lstVisitas=new dwp_kitv__Visit__c[]{};
        dwp_kitv__Visit__c tmpV;
        for(Account a:lstAccount) {
            tmpV=new dwp_kitv__Visit__c(dwp_kitv__account_id__c=a.Id, dwp_kitv__visit_duration_number__c='15', dwp_kitv__visit_start_date__c=System.now());
            lstVisitas.add(tmpV);
        }
        insert lstVisitas;
    }
    
    /*Method to test deleteOwners*/
    @isTest
    public static void deleteOwners() {
        Final User usuario=[SELECT ID, Name, profile.Name FROM USER WHERE Name LIKE '%Owner_Account%'];
        Final dwp_kitv__Visit_Management_Team__c[] lstEquipos =[SELECT Id FROM dwp_kitv__Visit_Management_Team__c WHERE 
                                                           dwp_kitv__user_id__c=:usuario.Id AND dwp_owner_visit__c=true limit 250];
        Test.startTest();
        Boolean pass=true;
        System.runAs(usuario) {
            try {
                delete lstEquipos;
            } catch(Exception e) {
                System.debug('Exception e ==> '+e.getMessage());
                pass=false;
            }
        }
        Test.stopTest();
        System.assert(!pass, '!pass is false');
    }
}