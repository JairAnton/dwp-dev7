/*
*Helper visit kit v1
* 17/09/2018
* 
*/
public without sharing class visit_helper_Trigger_cls {
   
   public void ComunMethod1(List<SObject> ObjectInsert){
       Map<id,String> Stagea = new Map<id,String>();
       List<id> Opa= new List<id>();
       List<SObject> Opa2= new List<SObject>();
       String profileName=[SELECT id, Name FROM Profile WHERE Id=:UserInfo.getProfileId()].Name;
       List<String> lst_profilesName=new List<String>{'Migracion', System.Label.profAdministrator, 'System Administrator'};
       for(SObject a : ObjectInsert){
           Opa.add((Id)a.get('dwp_kitv__visit_id__c'));
       }
       Schema.SObjectType sobjectType = Opa[0].getSObjectType();
       String  sobjectName =String.escapeSingleQuotes(sobjectType.getDescribe().getName());
       Opa2 = Database.query('Select Id, dwp_kitv__visit_status_type__c From ' + sobjectName + ' Where Id IN:Opa');
       for(SObject obs: Opa2){
           Stagea.put((id)obs.get('Id'),(String)obs.get('dwp_kitv__visit_status_type__c'));
       }
       for(SObject a : ObjectInsert){
           System.debug(profileName);
           if('06'.equals(Stagea.get((Id)a.get('dwp_kitv__visit_id__c'))) && !lst_profilesName.contains(profileName)){
               a.addError('No se puede eliminar datos a una visita finalizada');
           }
       }
   }
   
   public void deleteOwner(List<dwp_kitv__Visit_Management_Team__c> lst_vmt){
       Id profileId=UserInfo.getProfileId();
       String profileName=[SELECT id, Name FROM Profile WHERE Id=:profileId].Name;
       List<String> lst_profilesName=new List<String>{'Migracion', System.Label.profAdministrator, 'System Administrator'};
       if(!lst_profilesName.contains(profileName)){
           for(dwp_kitv__Visit_Management_Team__c vmt:lst_vmt){
               if(vmt.dwp_owner_visit__c){
                   vmt.addError('No puede eliminar al propietario de la visita en el Equipo BBVA.');
               }
           }
       }
   }
   
}