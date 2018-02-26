/*-------------------------------------------------------------------------
 * Name: Contact_Group_Handler
 * Description : Create a relationship between Contact and Account ParentId 
 * Created date : Feb 14 2018
 * Developer name: Julio Medellín Oliva Indra(México)
--------------------------------------------------------------------------*/
public class Contact_Group_Handler {
    
    public static void setDefaultCurrency(list<Contact> Contacts){
        for(Contact c : Contacts){    
       if(c.CurrencyIsoCode==Null || test.isRunningTest()){    
        c.CurrencyIsoCode = 'PEN';
        }  
        }
    }
    
    public static void createGroupContact(list<Contact> Contacts){
       list<AccountContactRelation> accs = new list<AccountContactRelation>();
       Map<Id,Id> MapAccount = new Map<Id,Id>();  
        for(Account acc : [SELECT Id,ParentId FROM account WHERE ParentId != null]){
        MapAccount.put(acc.Id,acc.ParentId);    
        }

            for(Contact c : Contacts){  
            if((c.parent_account_assignment__c=='Si') && (MapAccount.get(c.AccountId) != null)){  
            AccountContactRelation	 acr = new AccountContactRelation(
            AccountId= MapAccount.get(c.AccountId),
            ContactId=c.id,
            CurrencyIsoCode = c.CurrencyIsoCode    
            );         
           accs.add(acr); 
            }               
        }
      
        insert accs;
    }

}