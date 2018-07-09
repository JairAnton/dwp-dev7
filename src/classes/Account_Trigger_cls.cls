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
    

}