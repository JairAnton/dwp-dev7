/*
 * @Name: Account_tgr
 * @Description: Trigger de Ejecucion Account
 * @Create by: Isaías Velázquez Cortés
 * 
*/
public without sharing class  Account_Trigger_cls {

    public void AsignAfterUpdate(list<Account>Opps_New, Map<id,Account>Opps_NewMap,
                                  list<Account>Opps_Old, Map<id,Account>Opps_OldMap){

            onChangeBranch(Opps_New,Opps_OldMap);
            
    }
    
    /**/
    private void onChangeBranch(list<Account>Opps_New, Map<id,Account>Opps_OldMap){

        List<Opportunity> listOpp = [select Id,Branch_id__c from Opportunity where AccountId=: Opps_New[0].Id and StageName not in ('06','07')];

        for(Opportunity item :listOpp )
        {
        	item.Branch_id__c=Opps_New[0].Branch_id__c;
        }
        update listOpp;

    }
    //Insert new AccountTeamMember records depend on a new Account record and User Assistant Team records with the Account Owner like user_id__c
    public void AfterInsert(List<Account> Accs_new) {
        List<User_Assistant_Team__c> lst_Users =  new List<User_Assistant_Team__c>();
        List<String> owner_Ids = new List<String>();
        List<AccountTeamMember> lst_ATM = new List<AccountTeamMember>();
        
        for(Account acc : Accs_new) {
            //Get the Owner Ids of the new Account records
            owner_Ids.add(acc.OwnerId);
        }
        //User Assistant Team list with the Owner Ids of the Account records
        lst_Users = [Select Id, user_id__c, assistant_id__c from User_Assistant_Team__c where user_id__c IN :owner_Ids];    
        for(Account acc : Accs_new) {
            for(User_Assistant_Team__c userAT : lst_Users) {
                //If the Owner Id of the Account record is equal than user_id__c field on User_Assistant_Team__c record, it will create a new AccountTeamMember record
                if(acc.OwnerId == userAT.user_id__c) {
                    AccountTeamMember atm = new AccountTeamMember();
                    atm.AccountId = acc.Id;
                    atm.UserId = userAt.assistant_id__c;
                    atm.TeamMemberRole = Label.TeamMemberRoleExecutive;
                    atm.AccountAccessLevel = Label.AccessLevelRead;
                    atm.OpportunityAccessLevel = Label.AccessLevelEdit;
                    atm.CaseAccessLevel = Label.AccessLevelEdit;
                    lst_ATM.add(atm);
                }
            }
        }
        if(!lst_ATM.isEmpty()) {
            insert lst_ATM;
        }
    }
    public void AfterUpdateOwner(List<Account> Accs_new, Map<Id, Account> Accs_oldMap) {
        List<User_Assistant_Team__c> lst_Users =  new List<User_Assistant_Team__c>();
        List<String> owner_Ids_new = new List<String>();
        List<String> acc_Ids = new List<String>();

        for(Account acc : Accs_new) {
            //If a account record has changed its OwnerId field, get its new OwnerId and its Id
            if(acc.OwnerId != Accs_oldMap.get(acc.Id).OwnerId) {
                owner_Ids_new.add(acc.OwnerId);
                acc_Ids.add(acc.Id);
            }
        }
        //If some record has new OwnerId
        if(!owner_Ids_new.isEmpty()) {
            //Old AccountTeamMember records was searched to delete
            List<AccountTeamMember> lst_ATM_old = new List<AccountTeamMember>();
            lst_ATM_old = [Select Id From AccountTeamMember where AccountId IN :acc_Ids];
            
            //Get the User Assistant Team records with the new OwnerId of the account
            lst_Users = [Select Id, user_id__c, assistant_id__c from User_Assistant_Team__c where user_id__c IN :owner_Ids_new];
            
            List<AccountTeamMember> lst_ATM_news = new List<AccountTeamMember>();
            for(Account acc : Accs_new) {
                for(User_Assistant_Team__c userAT : lst_Users) {
                    //If the Owner Id of the Account record is equal than user_id__c field on User_Assistant_Team__c record, it will create a new AccountTeamMember record
                    if(acc.OwnerId == userAT.user_id__c) {
                        AccountTeamMember atm = new AccountTeamMember();
                        atm.AccountId = acc.Id;
                        atm.UserId = userAt.assistant_id__c;
                        atm.TeamMemberRole = Label.TeamMemberRoleExecutive;
                        atm.AccountAccessLevel = Label.AccessLevelRead;
                        atm.OpportunityAccessLevel = Label.AccessLevelEdit;
                        atm.CaseAccessLevel = Label.AccessLevelEdit;
                        lst_ATM_news.add(atm);
                    }
                }
            }
            if(!lst_ATM_old.isEmpty()) {
                delete lst_ATM_old;
            }
            if(!lst_ATM_news.isEmpty()) {
                insert lst_ATM_news;
            }
        }
    }
}