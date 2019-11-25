/*
*Helper visit kit v1
* 17/09/2018
* 
*/
public without sharing class visit_helper_Trigger_cls {
    
    /**
     * static variable lstProfilesName
	*/
    static Final List<String> lstProfilesName = new List<String>{'Migracion', System.Label.profAdministrator, 'System Administrator'};
        
    /*
     * Method prevent deleted data
	*/
    public void comunMethod1(List<SObject> objectInsert) {
        Map<id,String> stagea = new Map<id,String>();
        List<id> opa= new List<id>();
        List<SObject> opa2= new List<SObject>();
        Final String profileName = [SELECT id, Name FROM Profile WHERE Id=:UserInfo.getProfileId()].Name;
        for(SObject a : objectInsert) {
            opa.add((Id)a.get('dwp_kitv__visit_id__c'));
        }
        Final Schema.SObjectType sobjectType = Opa[0].getSObjectType();
        Final String  sobjectName = String.escapeSingleQuotes(sobjectType.getDescribe().getName());
        opa2 = Database.query('Select Id, dwp_kitv__visit_status_type__c From ' + sobjectName + ' Where Id IN:Opa');
        for(SObject obs : opa2) {
            stagea.put((id)obs.get('Id'),(String)obs.get('dwp_kitv__visit_status_type__c'));
        }
        for(SObject a : objectInsert) {
            if('06'.equals(stagea.get((Id)a.get('dwp_kitv__visit_id__c'))) && !lstProfilesName.contains(profileName)) {
                a.addError(System.Label.ErrorVisitManagementTeam);
            }
        }
    }
    
    /*
     * Method prevent deleted owner
	*/
    public void deleteOwner(List<dwp_kitv__Visit_Management_Team__c> lstvmt) {
        Final Id profileId=UserInfo.getProfileId();
        Final String profileName=[SELECT id, Name FROM Profile WHERE Id=:profileId].Name;
            if(!lstProfilesName.contains(profileName)) {
                for(dwp_kitv__Visit_Management_Team__c vmt : lstvmt) {
                    if(vmt.dwp_owner_visit__c) {
                        vmt.addError(System.Label.Msg_DeleteOwner_VMT);
                    }
                }
            }
    }
    
    /*
     * Method to deleted Sharing with Visit Managment Team
	*/
    public void deleteVMTShare(Map<Id, dwp_kitv__Visit_Management_Team__c> mapVMT) {
        //Id visit - List Id Users in VMT to delete
        Final Map<Id, List<Id>> mapVM = new Map<Id, List<Id>>();
        Final List<Id> idsUser = new List<Id>();
        List<Id> idsUserByVisit;
        //Fill mapVM with id Visit and List Id Users by visit
        for(dwp_kitv__Visit_Management_Team__c vmt:mapVMT.values()) {
            idsUserByVisit = new List<Id>();
            //If visit exist in mapVM
            if(mapVM.containsKey(vmt.dwp_kitv__visit_id__c)) {
                idsUserByVisit = mapVM.get(vmt.dwp_kitv__visit_id__c);
                idsUserByVisit.add(vmt.dwp_kitv__user_id__c);
                mapVM.put(vmt.dwp_kitv__visit_id__c, idsUserByVisit);
            } else {//If not, put in mapVM
                idsUserByVisit.add(vmt.dwp_kitv__user_id__c);
                mapVM.put(vmt.dwp_kitv__visit_id__c, idsUserByVisit);
            }
            idsUser.add(vmt.dwp_kitv__user_id__c);
        }
        Final List<dwp_kitv__Visit__Share> lstVisitShare = [SELECT Id, ParentID, RowCause, UserOrGroupId FROM dwp_kitv__Visit__Share WHERE RowCause = 'Manual' AND 
                                                      ParentID IN:mapVM.keySet() AND UserOrGroupId IN:idsUser];
        Final List<dwp_kitv__Visit__Share> visitShareDelete = new List<dwp_kitv__Visit__Share>();
        //Validate records to delete
        for(dwp_kitv__Visit__Share vShare:lstVisitShare) {
            idsUserByVisit = mapVM.get(vShare.ParentID);
            if(idsUserByVisit.contains(vShare.UserOrGroupId)) {
                visitShareDelete.add(vShare);
            }
        }
        Final Integer visitShareSize = visitShareDelete.size();
        if(visitShareSize > 0) {delete visitShareDelete;}
    }
    
}