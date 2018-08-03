public with sharing class SimulatePrice_ctrl {
    @AuraEnabled
    public static Map<String,Object> getInfo(String recordId){
        Map<String,Object> mapReturn = new Map<String,Object>();

        List<OpportunityLineItem> lstOppLineItem = [SELECT  Id
                                                    FROM OpportunityLineItem
                                                    WHERE OpportunityId = :recordId];
        mapReturn.put('oli',lstOppLineItem[0]);
        
        return mapReturn;
    }
}