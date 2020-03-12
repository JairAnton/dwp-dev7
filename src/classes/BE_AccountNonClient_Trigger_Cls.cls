/**
----------------------------------------------------------------------------------------------------
@Name <BE_AccountNonClient_Trigger_cls>
@Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
@Date 2020-03-10
@Description Class for non client logic.
@Changes
    Date        Author   Email                  Type        
    2020-02-21  LMBR     lolo.bravo@bbva.com    Creation   
----------------------------------------------------------------------------------------------------
 */
public without sharing class BE_AccountNonClient_Trigger_Cls {

    /**
    @Description merge Non Client to Client
    @return void
   */
    public void mergeNonClientToClient() {
        final List<String> sObjNames=new List<String>{'Account'};
        final Map<String,Schema.RecordTypeInfo> recordType=BE_General_Utils.getRecordTypeInfo(sObjNames);
        final String rtNonClientId=recordType.get('Record_Type_Non_Client').getRecordTypeId();
        final String rtClientId=recordType.get('Record_Type_Client').getRecordTypeId();
        Map<String,Id> accsMap = new Map<String,Id>();
        for (Account accItem : [SELECT Id,AccountNumber FROM Account WHERE recordTypeId=:rtClientId  AND Id IN:TRIGGER.NEW]) {
          accsMap.put(accItem.AccountNumber, accItem.Id);
        }
        for (Account nonClientItem : [SELECT Id,AccountNumber FROM Account WHERE AccountNumber IN:accsMap.keySet() AND recordTypeId=:rtNonClientId]) {
            merge  new Account(Id=accsMap.get(nonClientItem.AccountNumber)) nonClientItem;
        }
    }
    
   /**
   @Description delete account type nonClient when non_client_code__c field is blank.
   @param List of accounts wich insert.
   @return void
    public void deleteNonClient(List<Account> accLst){
        Set<String> accDelt=new Set<String>();
        final List<String> sObjNames=new List<String>{'Account'};
        final Map<String,Schema.RecordTypeInfo> recordType=BE_General_Utils.getRecordTypeInfo(sObjNames);
        final String rtNonClientId=recordType.get('Record_Type_Non_Client').getRecordTypeId();
        for (Account acc : accLst) {
            if(rtNonClientId.equals(acc.RecordTypeId) && String.isBlank(acc.non_client_code__c)){
                accDelt.add(acc.Id);
            }
        }
        if(accDelt.size()>0){
           deteleNonClientAsync(accDelt); 
        }
    }

   @Description delete account type nonClient when non_client_code__c field is blank.
   @param Set<Id> of NonClients with AccountNumber blank
   @return void
    @future
    private static void deteleNonClientAsync(Set<String> accIds){
        final List<Account> accLst=[SELECT ID FROM Account WHERE Id IN:accIds FOR UPDATE];
        if(accLst.size()>0){
        delete accLst;
        }
    }
    
    */
}