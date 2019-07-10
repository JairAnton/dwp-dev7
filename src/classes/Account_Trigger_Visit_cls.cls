/*
 * @Name: Account_tgr_Visit
 * @Description: Trigger de Ejecucion
 * @Create by: Diego Carbajal
 * 
*/
public without sharing class Account_Trigger_Visit_cls {

    //Map of Records to update
    private static Map<Id, dwp_kitv__Visit__c> visitUpdMap = new Map<Id, dwp_kitv__Visit__c>();
    //Reutilizable
    private static Set<Id> idsAccounts;
    
    /*Method Constructor*/
    private Account_Trigger_Visit_cls() {
        
    }
    
    /**Master method Execute**/
    public static void updateVisit(list<Account> accsNew, Map<id,Account> accsNewMap, list<Account> accsOld, Map<id,Account> accsOldMap) {
        
        updateVisitAfterChangeBranch(accsNew, accsOldMap);
        updateVisitAfterChangeOwner(accsNewMap, accsOldMap);
        
		Final Integer mapSize=visitUpdMap.size();
        if(mapSize > 0) {
            update visitUpdMap.values();
        }
    }
    
    /*Update Active Visit with New Branch*/
    public static void updateVisitAfterChangeBranch(List<Account> accsNew, Map<id,Account> accsOldMap) {
        idsAccounts = new Set<Id>();
        List<dwp_kitv__Visit__c> lstVisitas= new List<dwp_kitv__Visit__c>();
        for(Account accNew:accsNew) {
            //Get Accounts Ids where branch is change
            if(accNew.branch_id__c != accsOldMap.get(accNew.Id).branch_id__c) {
                idsAccounts.add(accNew.Id);
            }
        }
        
        //If Ids_account_new_branch contains id, do query
        Final Integer idsAccountsSize = idsAccounts.size();
        if(idsAccountsSize > 0) {
            //Get Visit where related account are in accounts where changes branch and status is not finish
       		lstVisitas=[SELECT id, dwp_kitv__account_id__r.branch_id__c, dwp_branch_id__c FROM dwp_kitv__Visit__c WHERE dwp_kitv__account_id__c IN: idsAccounts AND
                         (report_visit_status_type__c='No realizada' OR report_visit_status_type__c='Pendiente de feedback')];
        }
        
        //Records to update branch with Account branch
        for(dwp_kitv__Visit__c tmpV:lstVisitas) {
            tmpV.dwp_branch_id__c=tmpV.dwp_kitv__account_id__r.branch_id__c;
            visitUpdMap.put(tmpV.Id, tmpV);
        }

    }
    
    /*Update Active Visit with New Owner*/
    public static void updateVisitAfterChangeOwner(Map<id,Account> accsNewMap, Map<id,Account> accsOldMap) {
        Final Set<Id> idsOldOwners = new Set<Id>();
        Final Set<Id> idsAccounts = new Set<Id>();
        List<dwp_kitv__Visit_Management_Team__c> lstEquipo = new List<dwp_kitv__Visit_Management_Team__c>();
        
        for(Account accNew:accsNewMap.values()) {
            //Get Old Owners Ids from Accounts where Owner change
            if(accNew.OwnerId != accsOldMap.get(accNew.Id).OwnerId) {
                idsOldOwners.add(accsOldMap.get(accNew.Id).OwnerId);
                idsAccounts.add(accsOldMap.get(accNew.Id).Id);
            }
        }
        
        //If Ids_account_new_branch contains values, do query
        Final Integer idsOldOwnersSize = idsOldOwners.size();
        if(idsOldOwnersSize > 0) {
            //Get Team Visit where visit are related with accounts where changes Owner and status is not finish
            lstEquipo = [SELECT Id, dwp_kitv__user_id__c, dwp_kitv__visit_id__c, dwp_kitv__visit_id__r.dwp_kitv__account_id__c FROM 
                          dwp_kitv__Visit_Management_Team__c WHERE dwp_kitv__user_id__c IN: idsOldOwners 
                          AND dwp_kitv__visit_id__r.dwp_kitv__account_id__c=:idsAccounts AND dwp_owner_visit__c=true AND
                          (dwp_kitv__visit_id__r.report_visit_status_type__c='No realizada' OR dwp_kitv__visit_id__r.report_visit_status_type__c='Pendiente de feedback')];
        }
        
        dwp_kitv__Visit__c visita;
        for(dwp_kitv__Visit_Management_Team__c equipo: lstEquipo) {
                //Replace new Owner
                visita = new dwp_kitv__Visit__c();
                //If record exists in map, update record
                if(visitUpdMap.containsKey(equipo.dwp_kitv__visit_id__c)) {
                    visita = visitUpdMap.get(equipo.dwp_kitv__visit_id__c);
                    visita.OwnerId = accsNewMap.get(equipo.dwp_kitv__visit_id__r.dwp_kitv__account_id__c).OwnerId;
                } else {//If record doesn't exists in map, add
                    visita.Id=equipo.dwp_kitv__visit_id__c;
                	visita.OwnerId=accsNewMap.get(equipo.dwp_kitv__visit_id__r.dwp_kitv__account_id__c).OwnerId;
                }
                visitUpdMap.put(visita.Id, visita);
        }
 
    }
    
}