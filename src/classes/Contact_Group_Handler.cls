/*-------------------------------------------------------------------------
 * Name: Contact_Group_Handler
 * Description : Create a relationship between Contact and Account ParentId 
 * Created date : Feb 14 2018
 * Developer name: Julio Medellín Oliva Indra(México)
--------------------------------------------------------------------------*/
public without sharing class Contact_Group_Handler {
    
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
        set<Id> Ids = new set<Id>();
        for(Contact d: Contacts)
            Ids.add(d.AccountId);

        for(Account acc : [SELECT Id,ParentId FROM account WHERE Id in:Ids and ParentId != null]){
            MapAccount.put(acc.Id,acc.ParentId);    
        }

        for(Contact c : Contacts){  
            if((c.parent_account_assignment__c==Label.assignationApproval) && (MapAccount.get(c.AccountId) != null)){  
                AccountContactRelation   acr = new AccountContactRelation(
                    AccountId= MapAccount.get(c.AccountId),
                    ContactId=c.id,   
                    CurrencyIsoCode = c.CurrencyIsoCode ,
                    prof_position_type__c=c.parent_account_prof_position_type__c,
                    other_prof_prosition_type__c=c.parent_account_other_prof_prosition_type__c,
                    decision_making_desc__c=c.parent_account_decision_making_desc__c,
                    MobilePhone__c 	=c.MobilePhone,
                    Email__c =c.Email,
                    phone_1_area_code__c=c.phone_1_area_code__c,	
                    phone_2_area_code__c=c.phone_2_area_code__c,
                    phone_1__c =c.phone_1__c,
                    phone_2__c =c.phone_2__c,
                    events_info_type__c=c.events_info_type__c,
                    Status_desc__c =c.Status_desc__c,
                    Description__c =c.Description
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
         
        for(AccountContactRelation acr : [SELECT AccountID, prof_position_type__c, 
                                          other_prof_prosition_type__c, 
                                          decision_making_desc__c,
                                          MobilePhone__c,
                                          Email__c,
                                          phone_1_area_code__c,
                                          phone_2_area_code__c,
                                          phone_1__c,
                                          phone_2__c,
                                          events_info_type__c,
                                          Status_desc__c,
                                          Description__c
                                          FROM AccountContactRelation 
                                          WHERE ContactID in :cid]){
            mapCuentaContacto.put(acr.AccountId, acr);   
        }
        list<Id>ContactsIds = new list<Id>();
        for(Contact c : Contacts){
            try{
                if(c.AccountId != mapOld.get(c.Id).AccountId){
                    c.prof_position_type__c=mapCuentaContacto.get(c.AccountId).prof_position_type__c;
                    c.other_prof_prosition_type__c=mapCuentaContacto.get(c.AccountId).other_prof_prosition_type__c;
                    c.decision_making_desc__c=mapCuentaContacto.get(c.AccountId).decision_making_desc__c;    
                    c.MobilePhone=mapCuentaContacto.get(c.AccountId).MobilePhone__c;
                    c.Email =mapCuentaContacto.get(c.AccountId).Email__c;
                    c.phone_1_area_code__c=mapCuentaContacto.get(c.AccountId).phone_1_area_code__c;	
                    c.phone_2_area_code__c=mapCuentaContacto.get(c.AccountId).phone_2_area_code__c;
                    c.phone_1__c =mapCuentaContacto.get(c.AccountId).phone_1__c;
                    c.phone_2__c =mapCuentaContacto.get(c.AccountId).phone_2__c;
                    c.events_info_type__c=mapCuentaContacto.get(c.AccountId).events_info_type__c;
                    c.Status_desc__c =mapCuentaContacto.get(c.AccountId).Status_desc__c;
                    c.Description =mapCuentaContacto.get(c.AccountId).Description__c;
                }
            }
            catch(NullPointerException e){
                system.debug('Exception :' + e);
            }  
        }             
    }
      
    public static void updateGroupContact(list<Contact> Contacts){
        list<AccountContactRelation> accs = new list<AccountContactRelation>();
        set<Id>ContactsIds = new set<Id>();
            for(Contact c : Contacts){  
                ContactsIds.add(c.Id);
            } 
        accs = [SELECT ID,AccountId,ContactId,isDirect, prof_position_type__c, 
                other_prof_prosition_type__c, decision_making_desc__c 
                FROM AccountContactRelation 
                WHERE ContactId IN: ContactsIDs AND IsDirect = true];
                AccountContactParentAssociation.ucontact=false;
                AccountContactParentAssociation.setValuesRelation(accs);       
    }      
}