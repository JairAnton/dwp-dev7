/*-------------------------------------------------------------------------
 * Name: Contact_Group_Handler
 * Description : Create a relationship between Contact and Account ParentId 
 * Created date : Feb 14 2018
 * Developer name: Julio Medellín Oliva Indra(México)
--------------------------------------------------------------------------*/
public with sharing class Contact_Group_Handler {
    
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
            if((c.parent_account_assignment__c==Label.assignationApproval) && (MapAccount.get(c.AccountId) != null)){  
                AccountContactRelation   acr = new AccountContactRelation(
                    AccountId= MapAccount.get(c.AccountId),
                    ContactId=c.id,   
                    CurrencyIsoCode = c.CurrencyIsoCode    
                );         
                accs.add(acr); 
            }               
        }
      
        insert accs;
    }
    
    public static void updateMainContact(list<Contact> Contacts,list<Contact> Contactsold){
        Map<ID, AccountContactRelation> mapCuentaContacto = new Map<ID, AccountContactRelation>();     
        Map<ID, Contact> mapOld = new Map<ID, contact>();
        list<id> cid = new list<id>();
        for(Contact c : Contactsold){
            MapOld.put(c.Id, c); 
            cid.add(c.id);    
         }
         
        for(AccountContactRelation acr : [SELECT AccountID, prof_position_type__c, other_prof_prosition_type__c, decision_making_desc__c from AccountContactRelation WHERE ContactID in :cid]){
            mapCuentaContacto.put(acr.AccountId, acr);   
        }
        list<Id>ContactsIds = new list<Id>();
        for(Contact c : Contacts){
            try{
                if(c.AccountId != mapOld.get(c.Id).AccountId){
                    c.prof_position_type__c=mapCuentaContacto.get(c.AccountId).prof_position_type__c;
                    c.other_prof_prosition_type__c=mapCuentaContacto.get(c.AccountId).other_prof_prosition_type__c;
                    c.decision_making_desc__c=mapCuentaContacto.get(c.AccountId).decision_making_desc__c;    
                }
            }
            catch(NullPointerException e){
                system.debug('Exception :' + e);
            }  
        }             
    }
      
    public static void updateGroupContact(list<Contact> Contacts){
        list<AccountContactRelation> accs = new list<AccountContactRelation>();
        list<Id>ContactsIds = new list<Id>();
            for(Contact c : Contacts){  
                ContactsIds.add(c.Id);
            } 
        accs = [SELECT ID,AccountId,ContactId,isDirect, prof_position_type__c, other_prof_prosition_type__c, decision_making_desc__c from AccountContactRelation WHERE ContactId in : ContactsIDs AND IsDirect = true];
        AccountContactParentAssociation.ucontact=false;
        AccountContactParentAssociation.setValuesRelation(accs);       
    }      
}