/**
* @author Global_HUB developers
* @date 12-06-2019
*
* @group Global_HUB
*
* @description Controller class from FieldSummary_ctrl
**/
public with sharing class FieldSummary_ctrl {
    
    /**
     * This is the method constructor of the class
     */
    private FieldSummary_ctrl() {
        
    }
    
    /**
     * This method is used to change status type to 11 in opportunity
     * @param recordId This is Opportunity Id that will update
     * @return Map<String,Object> This returns map with result of operation.
     */
    @AuraEnabled
    public static Map<String,Object> doSave(String recordId) {
        Final Map<String,Object> mapReturn = new Map<String,Object>();
        Final Opportunity opp = new Opportunity();
        opp.Id = recordId;
        opp.opportunity_status_type__c = '11';
        try {
            update opp;
            mapReturn.put('isOk',true);
        } catch(Exception e) {
            mapReturn.put('isOk',false);
            mapReturn.put('errorMessage',e.getMessage());
            throw e;
        }
        return mapReturn;
    }
}