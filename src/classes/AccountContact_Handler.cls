public class AccountContact_Handler {
    
    public static void setValuesRelation(list<AccountContactRelation> AccountContactR){
    list<AccountContactRelation> ac = new list<AccountContactRelation>();  
     Map<ID, Contact> mc = new Map<ID, Contact>([SELECT Id, prof_position_type__c,other_prof_prosition_type__c,decision_making_desc__c FROM Contact]);
     for(AccountContactRelation acr : AccountContactR){
       AccountContactRelation acr2  = new AccountContactRelation(id=acr.id,
        prof_position_type__c = mc.get(acr.contactId).prof_position_type__c,
        other_prof_prosition_type__c =mc.get(acr.contactId).other_prof_prosition_type__c,
        decision_making_desc__c = mc.get(acr.contactId).decision_making_desc__c                                                          
      );
        ac.add(acr2);
     }
    update ac;
        
        
    }

}