/*
*Helper visit kit v1
* 17/09/2018
* 
*/
public without sharing class visit_helper_Trigger_cls {
    
    /*
     * Method prevent deleted data
	*/
    public void comunMethod1(List<SObject> objectInsert) {
        Map<id,String> stagea = new Map<id,String>();
        List<id> opa= new List<id>();
        List<SObject> opa2= new List<SObject>();
        Final String profileName = [SELECT id, Name FROM Profile WHERE Id=:UserInfo.getProfileId()].Name;
        Final List<String> lstProfilesName = new List<String>{'Migracion', System.Label.profAdministrator, 'System Administrator'};
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
        Final List<String> lstProfilesName=new List<String>{'Migracion', System.Label.profAdministrator, 'System Administrator'};
            if(!lstProfilesName.contains(profileName)) {
                for(dwp_kitv__Visit_Management_Team__c vmt : lstvmt) {
                    if(vmt.dwp_owner_visit__c) {
                        vmt.addError(System.Label.Msg_DeleteOwner_VMT);
                    }
                }
            }
    }
    
}