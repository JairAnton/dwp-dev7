/**
* @author Global_HUB developers
* @date 01-08-2018
*
* @group Global_HUB
*
* @description Controller class from SanctionPriceDecision_ctrl
**/
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
    public static Map<String,Object> saveDecision(String recordId, String status_opp, String stageName, Boolean createCase, String styleAudit, String nameAudit, String strComments, String storeHtml){
        Map<String,Object> mapReturn = new Map<String,Object>();
        List<dwp_cvad__Action_Audit__c> lstAudit = new List<dwp_cvad__Action_Audit__c>();
        Opportunity opp = new Opportunity();
        opp.Id = recordId;
        opp.StageName = stageName;
        opp.opportunity_status_type__c = status_opp;
        opp.isProcess__c = true;
        try{
            update opp;
            lstAudit.add(Action_Audit_Helper.getAudit(nameAudit, 'Opportunity', recordId, DateTime.now(), label.AuditPriceApproval, UserInfo.getUserId(), styleAudit, null, false));
            lstAudit[0].dwp_cvad__audit_audit_comments__c = strComments;
            insert lstAudit;


            List<dwp_cvad__Action_Audit_Detail__c> lstDetails = new List<dwp_cvad__Action_Audit_Detail__c>();
            lstDetails.add(Action_Audit_Helper.getAuditDetail(lstAudit[0].Id, storeHtml, 1, '', 'Embedded'));
            insert lstDetails;
           
            if(createCase){
                List<Group> queueGroup = [SELECT    Id, 
                                                    DeveloperName,
                                                    Type  
                                                FROM Group 
                                                WHERE Type = 'Queue' 
                                                AND DeveloperName = 'Tier_1'];
                List<Opportunity> lstOpp = [SELECT  Id,
                                                    AccountId
                                            FROM Opportunity
                                            WHERE Id = :recordId];
                Case caseInsert = new Case();
                caseInsert.Status = '01';
                caseInsert.OwnerId = queueGroup[0].Id;
                caseInsert.Type = 'Other';
                caseInsert.AccountId = lstOpp[0].AccountId;
                caseInsert.opportunity_id__c = recordId;
                insert caseInsert;
            }
            mapReturn.put('isOk', true);
        }catch(Exception e){
            mapReturn.put('isOk', false);
        }
        return mapReturn;
    }

    @AuraEnabled
    public static Map<String,Object> saveDecisionAnalist(String recordId, String status_opp, String stageName, Boolean elevateCase, String styleAudit, String nameAudit, String strComments, String recordOli, List<String> lstApiField, List<Object> lstValue, String statusCase, String storeHtml, String approvalMethod, String wsPhase){
        Map<String,Object> mapReturn = new Map<String,Object>();
        List<dwp_cvad__Action_Audit__c> lstAudit = new List<dwp_cvad__Action_Audit__c>();
        Opportunity opp = new Opportunity();
        opp.Id = recordId;
        opp.StageName = stageName;
        opp.opportunity_status_type__c = status_opp;
        opp.isProcess__c = true;
        Boolean isOk = true;
        Id idAnalist = null;
        try{
            if(approvalMethod == 'Web'){
                ModifyQuotationRequest_helper modifyHelper = new ModifyQuotationRequest_helper(recordId,wsPhase,Double.valueOf(lstValue[0]),'');
                try{
                    System.HttpResponse invokeModify = modifyHelper.invoke();
                    switch on invokeModify.getStatusCode(){
                        when 200 {
                            ModifyQuotationRequest_helper.ResponseModifyQuotationRequest_Wrapper responseBody = ModifyQuotationRequest_helper.responseParse(invokeModify.getBody());
                            ModifyQuotationRequest_helper.Response_data mqData = responseBody.data;
                            ModifyQuotationRequest_helper.Response_status mqStatus = mqData.status;
                            
                            OpportunityLineItem oliRecord = new OpportunityLineItem();
                            oliRecord.Id = recordOli;
                            oliRecord.price_quote_status_id__c = mqStatus.id;
                            
                            List<ModifyQuotationRequest_helper.Response_businessAgents> mqBusinessAgentsList = mqData.businessAgents;
                            
                            if(!mqBusinessAgentsList.isEmpty()){
                                List<User> userList = [SELECT Id FROM User WHERE user_id__c = : mqBusinessAgentsList[0].id];
                                if(!userList.isEmpty()){
                                    oliRecord.price_quote_owner_id__c = userList[0].Id;
                                    idAnalist = userList[0].Id;
                                }else{
                                    oliRecord.price_quote_owner_id__c = null;
                                }
                            }
                            update oliRecord;

                        }
                        when 409{
                            WebServiceUtils.ResponseErrorMessage_Wrapper errorW = WebServiceUtils.parse(invokeModify.getBody());
                            isOk = false;
                            mapReturn.put('isOk', false);
                            mapReturn.put('errorMessage',Label.DecisionPriceActionError + ' ' + errorW.errormessage);
                        }
                        when else{
                            isOk = false;
                            mapReturn.put('isOk', false);
                            mapReturn.put('errorMessage',Label.PriceGenericError);
                        }
                    }
                }catch(Exception e){
                    System.debug(e);
                    isOk = false;
                    mapReturn.put('isOk', false);
                    mapReturn.put('errorMessage',Label.PriceGenericError);
                }
            }
            if(isOk){
                update opp;
                lstAudit.add(Action_Audit_Helper.getAudit(nameAudit, 'Opportunity', recordId, DateTime.now(), label.AuditPriceApproval, UserInfo.getUserId(), styleAudit, null, false));
                lstAudit[0].dwp_cvad__audit_audit_comments__c = strComments;
                insert lstAudit;

                List<dwp_cvad__Action_Audit_Detail__c> lstDetails = new List<dwp_cvad__Action_Audit_Detail__c>();
                lstDetails.add(Action_Audit_Helper.getAuditDetail(lstAudit[0].Id, storeHtml, 1, '', 'Embedded'));
                insert lstDetails;

                List<Case> lstCases = [SELECT   Id, 
                                            opportunity_id__c, 
                                            IsClosed,
                                            OwnerId,
                                            Status,
                                            bypass__c
                                    FROM Case 
                                    WHERE opportunity_id__c = :recordId 
                                    AND IsClosed = false];
                lstCases[0].Status = statusCase;
                lstCases[0].bypass__c = true;
                if(elevateCase && idAnalist==null){
                    List<Group> queueGroup = [SELECT    Id, 
                                                        DeveloperName,
                                                        Type  
                                                    FROM Group 
                                                    WHERE Type = 'Queue' 
                                                    AND DeveloperName = 'Tier_2'];
                    lstCases[0].OwnerId = queueGroup[0].Id;
                }else if(elevateCase && idAnalist!=null){
                    lstCases[0].OwnerId = idAnalist;
                }
                update lstCases;
                Map<String,Object> mapReturnSaveOli = FieldForm_ctrl.doSave(recordOli,'OpportunityLineItem', lstApiField, lstValue);

                mapReturn.put('isOk', (Boolean)mapReturnSaveOli.get('isOk'));
            }
        }catch(Exception e){
            mapReturn.put('isOk', false);
        }
        return mapReturn;
    }

    @AuraEnabled
    public static Map<String,Object> getInfoAnalist(String recordIdOppLineItem){
        Map<String,Object> mapReturn = new Map<String,Object>();

        List<OpportunityLineItem> lstOppLineItem = [SELECT  Id, 
                                                            Product2.Name,
                                                            Product2Id,
                                                            proposed_fee_per__c,
                                                            minimun_fee_per__c,
                                                            OpportunityId
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

        List<Case> lstCases = [SELECT   Id, 
                                        opportunity_id__c, 
                                        IsClosed 
                                FROM Case 
                                WHERE opportunity_id__c = :lstOppLineItem[0].OpportunityId
                                AND IsClosed = false
                                AND Status = '01'];
        mapReturn.put('caseOpen', !lstCases.isEmpty());
        
        return mapReturn;
    }
    
    @AuraEnabled
    public static Map<String,Object> saveAuditWeb(String auditRecordId,  String storeHtml){
        Map<String,Object> mapReturn = new Map<String,Object>();
        
        List<dwp_cvad__Action_Audit_Detail__c> lstDetails = new List<dwp_cvad__Action_Audit_Detail__c>();
        lstDetails.add(Action_Audit_Helper.getAuditDetail(auditRecordId, storeHtml, 1, '', 'Embedded'));
        insert lstDetails;
        
        mapReturn.put('isOk', true);
        return mapReturn;
    }
}