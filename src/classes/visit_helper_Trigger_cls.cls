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
            if('05'.equals(Stagea.get((Id)a.get('dwp_kitv__visit_id__c')))){
                a.addError('No se puede eliminar datos a una visita finalizada');
            }
        }
    }
    
}