/*
 * @Name: Account_tgr
 * @Description: Trigger de Ejecucion Account
 * @Create by: Isaías Velázquez Cortés
 * 
*/
public without sharing class Account_Trigger_cls {

    public void AsignAfterUpdate(list<Account>oppsNew, Map<id,Account>oppsNewMap,
                                  list<Account>oppsOld, Map<id,Account>oppsOldMap) {

            onChangeBranch(oppsNew,oppsOldMap);
            /**Actualizar Primero Objeto Relacionado, despues objeto hijo del relacionado**/
            Account_Trigger_Visit_cls.updateVisit(oppsNew, oppsNewMap, oppsOld, oppsOldMap);
            updateTeamVisit(oppsNewMap, oppsOldMap);
    }
    
    //Method onChangeBranch
    private void onChangeBranch(list<Account>oppsNew, Map<id,Account>oppsOldMap) {

        List<Opportunity> listOpp = [select Id,Branch_id__c from Opportunity where AccountId=: oppsNew[0].Id and StageName not in ('06','07')];

        for(Opportunity item :listOpp ) {
        	item.Branch_id__c=oppsNew[0].Branch_id__c;
        }
        update listOpp;

    }
    //Insert new AccountTeamMember records depend on a new Account record and User Assistant Team records with the Account Owner like user_id__c
    public void AfterInsert(List<Account> accsNew) {
        List<User_Assistant_Team__c> lstUsers =  new List<User_Assistant_Team__c>();
        Final List<String> ownerIds = new List<String>();
        Final List<AccountTeamMember> lstATM = new List<AccountTeamMember>();
        
        for(Account acc : accsNew) {
            //Get the Owner Ids of the new Account records
            ownerIds.add(acc.OwnerId);
        }
        //User Assistant Team list with the Owner Ids of the Account records
        lstUsers = [Select Id, user_id__c, assistant_id__c from User_Assistant_Team__c where user_id__c IN :ownerIds];    
        for(Account acc : accsNew) {
            for(User_Assistant_Team__c userAT : lstUsers) {
                //If the Owner Id of the Account record is equal than user_id__c field on User_Assistant_Team__c record, it will create a new AccountTeamMember record
                if(acc.OwnerId == userAT.user_id__c) {
                    AccountTeamMember atm = new AccountTeamMember();
                    atm.AccountId = acc.Id;
                    atm.UserId = userAt.assistant_id__c;
                    atm.TeamMemberRole = Label.TeamMemberRoleExecutive;
                    atm.AccountAccessLevel = Label.AccessLevelRead;
                    atm.OpportunityAccessLevel = Label.AccessLevelEdit;
                    atm.CaseAccessLevel = Label.AccessLevelEdit;
                    lstATM.add(atm);
                }
            }
        }
        Final Integer lstATMSize = lstATM.size();
        if(lstATMSize > 0) {
            insert lstATM;
        }
    }
    
    /*Method to update Owner*/
    public void AfterUpdateOwner(List<Account> accsNew, Map<Id, Account> accsOldMap) {
        List<User_Assistant_Team__c> lstUsers =  new List<User_Assistant_Team__c>();
        Final List<String> ownerIdsNew = new List<String>();
        Final List<String> accIds = new List<String>();

        for(Account acc : accsNew) {
            //If a account record has changed its OwnerId field, get its new OwnerId and its Id
            if(acc.OwnerId != accsOldMap.get(acc.Id).OwnerId) {
                ownerIdsNew.add(acc.OwnerId);
                accIds.add(acc.Id);
            }
        }
        //If some record has new OwnerId
        Final Integer ownerIdsNewSize = ownerIdsNew.size();
        if(ownerIdsNewSize > 0) {
            //Old AccountTeamMember records was searched to delete
            List<AccountTeamMember> lstAtmOld = new List<AccountTeamMember>();
            lstAtmOld = [Select Id From AccountTeamMember where AccountId IN :accIds];
            
            //Get the User Assistant Team records with the new OwnerId of the account
            lstUsers = [Select Id, user_id__c, assistant_id__c from User_Assistant_Team__c where user_id__c IN :ownerIdsNew];
            
            Final List<AccountTeamMember> lstAtmNews = new List<AccountTeamMember>();
            for(Account acc : accsNew) {
                for(User_Assistant_Team__c userAT : lstUsers) {
                    //If the Owner Id of the Account record is equal than user_id__c field on User_Assistant_Team__c record, it will create a new AccountTeamMember record
                    if(acc.OwnerId == userAT.user_id__c) {
                        AccountTeamMember atm = new AccountTeamMember();
                        atm.AccountId = acc.Id;
                        atm.UserId = userAt.assistant_id__c;
                        atm.TeamMemberRole = Label.TeamMemberRoleExecutive;
                        atm.AccountAccessLevel = Label.AccessLevelRead;
                        atm.OpportunityAccessLevel = Label.AccessLevelEdit;
                        atm.CaseAccessLevel = Label.AccessLevelEdit;
                        lstAtmNews.add(atm);
                    }
                }
            }
            Final Integer lstAtmOldSize=lstAtmOld.size();
            if(lstAtmOldSize > 0) {
                delete lstAtmOld;
            }
            Final Integer lstAtmNewsSize = lstAtmNews.size();
            if(lstAtmNewsSize > 0) {
                insert lstAtmNews;
            }
        }
    }
    
    /*Method to update Owners in VMT with Active Visit*/
    public void updateTeamVisit(Map<id,Account> accsNewMap, Map<id,Account> accsOldMap) {
        Final Set<Id> idsOldOwners = new Set<Id>();
        Final Set<Id> idsAccounts = new Set<Id>();
        List<dwp_kitv__Visit_Management_Team__c> lstOldTeam = new List<dwp_kitv__Visit_Management_Team__c>();
        
        for(Account accNew:accsNewMap.values()) {
            //Get Old Owners Ids from Account where Owner change
            if(accNew.OwnerId != accsOldMap.get(accNew.Id).OwnerId) {
                idsOldOwners.add(accsOldMap.get(accNew.Id).OwnerId);
                idsAccounts.add(accsOldMap.get(accNew.Id).Id);
            }
        }
        
        //If idsOldOwners contains values, do query
        Final Integer idsOldOwnersSize = idsOldOwners.size();
        if(idsOldOwnersSize > 0) {
            lstOldTeam = [SELECT id, dwp_kitv__user_id__c, dwp_kitv__visit_id__r.dwp_kitv__account_id__c, dwp_kitv__Send_minutes__c 
                           FROM dwp_kitv__Visit_Management_Team__c WHERE dwp_kitv__user_id__c IN: idsOldOwners AND dwp_owner_visit__c=true AND 
                           dwp_kitv__visit_id__r.dwp_kitv__account_id__c=:idsAccounts AND 
                          (dwp_kitv__visit_id__r.report_visit_status_type__c='No realizada' OR dwp_kitv__visit_id__r.report_visit_status_type__c='Pendiente de feedback')];
        }
        
        dwp_kitv__Visit_Management_Team__c tmpTeam;
        Final dwp_kitv__Visit_Management_Team__c[] lstNewTeam=new dwp_kitv__Visit_Management_Team__c[]{};
        for(dwp_kitv__Visit_Management_Team__c equipo:lstOldTeam) {
            tmpTeam = new dwp_kitv__Visit_Management_Team__c();
            tmpTeam.dwp_kitv__visit_id__c=equipo.dwp_kitv__visit_id__c;
            tmpTeam.dwp_kitv__user_id__c=accsNewMap.get(equipo.dwp_kitv__visit_id__r.dwp_kitv__account_id__c).OwnerId;
            tmpTeam.dwp_kitv__Send_minutes__c = equipo.dwp_kitv__Send_minutes__c;
            tmpTeam.dwp_owner_visit__c=true;
            lstNewTeam.add(tmpTeam);
        }
        
        Final Integer lstOldTeamSize = lstOldTeam.size();
        if(lstOldTeamSize > 0) {
            delete lstOldTeam;
            insert lstNewTeam;
        } 
    }
}