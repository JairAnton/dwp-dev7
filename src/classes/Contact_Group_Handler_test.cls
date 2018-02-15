/*-------------------------------------------------------------------------
 * Name: Contact_Group_Handler
 * Description : Contact_Group_Handler test Class
 * Created date : Feb 14 2018
 * Developer name: Julio Medellín Oliva Indra(México)
--------------------------------------------------------------------------*/
@istest
public class Contact_Group_Handler_test {
    
    @testSetup static void setup() {
        // Create common test accounts
        List<Account> testAccts = new List<Account>();
        for(Integer i=0;i<2;i++) {
            testAccts.add(new Account(Name = 'TestAcct'+i));
        }
        insert testAccts;       
    }

    @isTest static void positiveMethod() {
     test.startTest();
     account[] accs = [SELECT id FROM Account];
     account parent = accs[0];
     account child = accs[1];
     child.ParentId=parent.Id;
     update child;     
     Contact c = new Contact(
     Firstname =  'Test contact',
     lastName =   'Test Last',  
     AccountId  = Child.Id,
     decision_making_desc__c = 'Si',
     Salutation = 'Mr',
     CurrencyISOCode='PEN',    
     parent_account_assignment__c = 'Si'    
     );
     insert c;   
     test.stopTest();
    }

}