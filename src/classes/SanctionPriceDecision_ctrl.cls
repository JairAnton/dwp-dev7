public with sharing class SanctionPriceDecision_ctrl {
    @AuraEnabled
    public static Map<String,Object> getInfo(String recordIdOppLineItem){
        Map<String,Object> mapReturn = new Map<String,Object>();

        List<OpportunityLineItem> lstOppLineItem = [SELECT  Id, 
                                                            Product2.Name,
                                                            Product2Id,
                                                            proposed_fee_per__c,
                                                            minimun_fee_per__c
                                                    FROM OpportunityLineItem
                                                    WHERE Id = :recordIdOppLineItem];
        List<fprd__GBL_Product_Configuration__c> lstConfig = [SELECT    Id,
                                                                        fprd__Map_field__c,
                                                                        fprd__Header__c, 
                                                                        fprd__Header_order__c,
                                                                        fprd__LoV_values__c, 
                                                                        fprd__LoV_labels__c, 
                                                                        fprd__Label__c 
                                                                FROM fprd__GBL_Product_Configuration__c
                                                                WHERE fprd__Product__c = :lstOppLineItem[0].Product2Id
                                                                AND fprd__Header__c = true
                                                                ORDER BY fprd__Header_order__c];
        Set<String> setFields = new Set<String>();
        Map<String,Object> mapMapfieldConfig = new Map<String,Object>();
        for(fprd__GBL_Product_Configuration__c prodConfig : lstConfig){
            setFields.add(prodConfig.fprd__Map_field__c);
            mapMapfieldConfig.put(prodConfig.fprd__Map_field__c,prodConfig);
        }
        List<String> lstStringField = new List<String>(setFields);
        mapReturn.put('lstInfoIsEmpty', lstStringField.isEmpty());
        mapReturn.put('lstField', lstStringField);
        mapReturn.put('lstOppLineItem', lstOppLineItem);
        mapReturn.put('mapMapfieldConfig',mapMapfieldConfig);
        if(!lstStringField.isEmpty()){ 
            List<SObject> lstRow = Database.query('SELECT ' + String.join(lstStringField, ',') + ' FROM OpportunityLineItem WHERE Id = \'' + recordIdOppLineItem + '\'');
            mapReturn.put('lstInfo', lstRow);
        }
        
        return mapReturn;
    }

    @AuraEnabled
    public static Map<String,Object> saveDecision(String recordId, String status_opp, String stageName, Boolean createCase, String styleAudit, String nameAudit, String strComments){
        Map<String,Object> mapReturn = new Map<String,Object>();
        List<dwp_cvad__Action_Audit__c> lstAudit = new List<dwp_cvad__Action_Audit__c>();
        Opportunity opp = new Opportunity();
        opp.Id = recordId;
        opp.StageName = stageName;
        opp.opportunity_status_type__c = status_opp;
        try{
            update opp;
            lstAudit.add(Action_Audit_Helper.getAudit(nameAudit, 'Opportunity', recordId, DateTime.now(), label.AuditPriceApproval, UserInfo.getUserId(), styleAudit, null, false));
            lstAudit[0].dwp_cvad__audit_audit_comments__c = strComments;
            insert lstAudit;
            if(createCase){
                List<Group> queueGroup = [SELECT    Id, 
                                                    DeveloperName,
                                                    Type  
                                                FROM Group 
                                                WHERE Type = 'Queue' 
                                                AND DeveloperName = 'Tier_1'];
                Case caseInsert = new Case();
                caseInsert.Status = 'New';
                caseInsert.OwnerId = queueGroup[0].Id;
                caseInsert.Type = 'Other';
                caseInsert.opportunity_id__c = recordId;
                insert caseInsert;
            }
            mapReturn.put('isOk', true);
        }catch(Exception e){
            mapReturn.put('isOk', false);
        }
        return mapReturn;
    }
}