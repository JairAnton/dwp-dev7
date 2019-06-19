/**
* @author Global_HUB developers
* @date 12-06-2019
*
* @group Global_HUB
*
* @description Controller class from FieldSummary_ctrl
**/
public with sharing class FieldSummary_ctrl {
    @AuraEnabled
    public static Map<String,Object> doSave(String recordId){
        Map<String,Object> mapReturn = new Map<String,Object>();
        Opportunity opp = new Opportunity();
        opp.Id = recordId;
        opp.opportunity_status_type__c = '11';
        try{
            update opp;
            mapReturn.put('isOk',true);
        }catch(Exception e){
            mapReturn.put('isOk',false);
            mapReturn.put('errorMessage',e.getMessage());
        }
        return mapReturn;
    }
}