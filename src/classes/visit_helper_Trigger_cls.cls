/*
*Helper visit kit v1
* 17/09/2018
* 
*/
public without sharing class visit_helper_Trigger_cls {
    
    /*Method comunMethod1*/
    public void comunMethod1(List<SObject> objectInsert) {
        Final Map<id,String> stagea = new Map<id,String>();
        Final List<id> Opa= new List<id>();
        List<SObject> opa2= new List<SObject>();
        for(SObject a : objectInsert) {
            Opa.add((Id)a.get('dwp_kitv__visit_id__c'));
        }
        Final Schema.SObjectType sobjectType = Opa[0].getSObjectType();
        Final String  sobjectName =String.escapeSingleQuotes(sobjectType.getDescribe().getName());
        opa2 = Database.query('Select Id, dwp_kitv__visit_status_type__c From ' + sobjectName + ' Where Id IN:Opa');
        for(SObject obs: opa2) {
            stagea.put((id)obs.get('Id'),(String)obs.get('dwp_kitv__visit_status_type__c'));
        }
        for(SObject a : objectInsert) {
            if('06'.equals(stagea.get((Id)a.get('dwp_kitv__visit_id__c')))) {
                a.addError('No se puede eliminar datos a una visita finalizada');
            }
        }
    }
    
    /*Method to not eliminated Owner in VMT*/
    public static void deleteOwner(List<dwp_kitv__Visit_Management_Team__c> lstVmt) {
        Final Id profileId=UserInfo.getProfileId();
        Final String profileName=[SELECT id, Name FROM Profile WHERE Id=:profileId].Name;
        Final List<String> lst_profilesName=new List<String>{'Migracion', System.Label.profAdministrator};
        if(!lst_profilesName.contains(profileName)) {
            for(dwp_kitv__Visit_Management_Team__c vmt:lstVmt) {
                if(vmt.dwp_owner_visit__c) {
                    vmt.addError(Label.Msg_DeleteOwner_VMT);
                }
            }
        }
    }
    
}