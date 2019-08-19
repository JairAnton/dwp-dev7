/**
* @author Global_HUB developers
* @date 01-08-2018
*
* @group Global_HUB
*
* @description Controller class from SanctionPriceDecision_ctrl
**/
public with sharing class SanctionPriceDecision_ctrl {
    /**
     * Label status Approved
     */
    Final Static String SAPPROVED = '08';
    /**
     * Label status Sent
     */
    Final Static String SSENT = '09';
    /**
     * Label status Authorized
     */
    Final Static String SAUTHORIZED = '10';
    /**
     * Label status Denied
     */
    Final Static String SDENIED = '13';
    
    /**Method for get information of price process **/
    @AuraEnabled
    public static Map<String,Object> getInfo(String recordIdOppLineItem) {
        Map<String,Object> mapReturn = new Map<String,Object>();
        
        List<OpportunityLineItem> lstOppLineItem = [SELECT Id, 
                                                    Product2.Name,
                                                    Product2Id,
                                                    proposed_fee_per__c,
                                                    minimun_fee_per__c,
                                                    OpportunityId,
                                                    Opportunity.opportunity_status_type__c
                                                    FROM OpportunityLineItem
                                                    WHERE Id = :recordIdOppLineItem];
        List<fprd__GBL_Product_Configuration__c> lstConfig = [SELECT Id,
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
        try {
            if(!lstOppLineItem.isEmpty() && lstOppLineItem[0].Opportunity.opportunity_status_type__c==SAPPROVED) {
                //helper to call the service
                Final GetQuotationRequest_helper getquoteHelper = new GetQuotationRequest_helper(lstOppLineItem[0].OpportunityId); 
                //invoke the service
                Final System.HttpResponse invoke = getquoteHelper.invoke();
                switch on invoke.getStatusCode() {                        
                    when 200 {
                        //get json body
                        Final GetQuotationRequest_helper.ResponseGetQuotationRequest_Wrapper jbody = GetQuotationRequest_helper.parse(invoke.getBody());
                        if(jbody.data.quotations[0].validityDate != null && jbody.data.quotations[0].validityDate != '') {
                            mapReturn.put('validityDate', Date.valueOf(jbody.data.quotations[0].validityDate.substring(0,10)));
                            mapReturn.put('changeDate', false);
                            lstOppLineItem[0].validityDate__c = Date.valueOf(jbody.data.quotations[0].validityDate.substring(0,10));
                            update lstOppLineItem[0];
                        }
                    }
                }
            }
        } catch(Exception e) {
            System.debug('error: '+e);
        }
        
        Set<String> setFields = new Set<String>();
        Map<String,Object> mapMapfieldConfig = new Map<String,Object>();
        for(fprd__GBL_Product_Configuration__c prodConfig : lstConfig) {
            setFields.add(prodConfig.fprd__Map_field__c);
            mapMapfieldConfig.put(prodConfig.fprd__Map_field__c,prodConfig);
        }
        List<String> lstStringField = new List<String>(setFields);
        mapReturn.put('lstInfoIsEmpty', lstStringField.isEmpty());
        mapReturn.put('lstField', lstStringField);
        mapReturn.put('lstOppLineItem', lstOppLineItem);
        mapReturn.put('mapMapfieldConfig',mapMapfieldConfig);
        if(!lstStringField.isEmpty()) { 
            List<SObject> lstRow = Database.query('SELECT ' + String.join(lstStringField, ',') + ' FROM OpportunityLineItem WHERE Id = \'' + recordIdOppLineItem + '\'');
            mapReturn.put('lstInfo', lstRow);
        }
        
        /**getSanctionPriceInfo*/
        mapReturn.put('sanctionPriceInfo', getSanctionPriceInfo(recordIdOppLineItem));
        
        return mapReturn;
    }
    
    /**Method for save decision of ejecutive **/
    @AuraEnabled
    public static Map<String,Object> saveDecision(String recordId, String status_opp, String stageName, Boolean createCase, String styleAudit, String nameAudit, String strComments, String storeHtml) {
        Map<String,Object> mapReturn = new Map<String,Object>();
        List<dwp_cvad__Action_Audit__c> lstAudit = new List<dwp_cvad__Action_Audit__c>();
        Opportunity opp = new Opportunity();
        opp.Id = recordId;
        opp.StageName = stageName;
        opp.opportunity_status_type__c = status_opp;
        opp.isProcess__c = true;
        try {
            update opp;
            lstAudit.add(Action_Audit_Helper.getAudit(nameAudit, 'Opportunity', recordId, DateTime.now(), label.AuditPriceApproval, UserInfo.getUserId(), styleAudit, null, false));
            lstAudit[0].dwp_cvad__audit_audit_comments__c = strComments;
            insert lstAudit;
            
            
            List<dwp_cvad__Action_Audit_Detail__c> lstDetails = new List<dwp_cvad__Action_Audit_Detail__c>();
            lstDetails.add(Action_Audit_Helper.getAuditDetail(lstAudit[0].Id, storeHtml, 1, '', 'Embedded'));
            insert lstDetails;
            
            if(createCase) {
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
        } catch(Exception e) {
            mapReturn.put('isOk', false);
        }
        return mapReturn;
    }
    
    /**Method for save decision of analist **/
    @AuraEnabled
    public static Map<String,Object> saveDecisionAnalist(String jsonParams, Boolean elevateCase, List<String> lstApiField, List<Object> lstValue) {
        Parameters params = (Parameters)JSON.deserialize(jsonParams, Parameters.class);
        Map<String,Object> mapReturn = new Map<String,Object>();
        Opportunity opp = new Opportunity();
        opp.Id = params.recordId;
        opp.StageName = params.stageName;
        opp.opportunity_status_type__c = params.statusOpp;
        opp.isProcess__c = true;
        Boolean isOk = true;
        Id idAnalist = null;
        String newStoreHtml = params.storeHtml;
        try {
            if(params.approvalMethod == 'Web') {
                Final ModifyQuotationRequest_helper modifyHelper = new ModifyQuotationRequest_helper(params.recordId, params.wsPhase, (lstValue[1] == null? null : Double.valueOf(lstValue[1])) ,'', null);
                try {
                    Final System.HttpResponse invokeModify = modifyHelper.invoke();
                    switch on invokeModify.getStatusCode(){
                        when 200 {
                            String assignedAnalyst = null;
                            Final ModifyQuotationRequest_helper.ResponseModifyQuotationRequest_Wrapper responseBody = ModifyQuotationRequest_helper.responseParse(invokeModify.getBody());
                            ModifyQuotationRequest_helper.Response_data mqData = responseBody.data;
                            ModifyQuotationRequest_helper.Response_status mqStatus = mqData.status;
                            
                            Final OpportunityLineItem oliRecord = new OpportunityLineItem(Id=params.recordOli,
                                                                                    price_quote_status_id__c=mqStatus.id,
                                                                                    Assigned_analyst__c=assignedAnalyst,
                                                                                    price_quote_date__c=null,
                                                                                    validityDate__c=null);
                            
                            List<ModifyQuotationRequest_helper.Response_businessAgents> mqBusinessAgentsList = mqData.businessAgents;
                            if(!mqBusinessAgentsList.isEmpty()) {
                                Final List<User> userList = [SELECT Id, FirstName, LastName FROM User WHERE user_id__c = : mqBusinessAgentsList[0].id AND IsActive = true];
                                if(!userList.isEmpty()) {
                                    idAnalist = userList[0].Id;
                                    assignedAnalyst = userList[0].FirstName + ' ' + userList[0].LastName;
                                } else {
                                    assignedAnalyst = mqBusinessAgentsList[0].firstName + ' ' + mqBusinessAgentsList[0].lastName + ' ' + mqBusinessAgentsList[0].secondLastName;
                                }
                            }
                            
                            if(opp.opportunity_status_type__c==SSENT) {
                                oliRecord.price_quote_owner_id__c = idAnalist;
                                oliRecord.Assigned_analyst__c = assignedAnalyst;
                            } else if(opp.opportunity_status_type__c==SAUTHORIZED) {
                                oliRecord.price_quote_date__c = System.today();
                                oliRecord.validityDate__c = Date.valueOf(params.validDate);
                                assignedAnalyst = System.UserInfo.getFirstName() + ' ' + System.UserInfo.getLastName();
                                oliRecord.Assigned_analyst__c = assignedAnalyst;
                                mapReturn.put('getQuote', true);
                            } else if(opp.opportunity_status_type__c==SDENIED) {
                                oliRecord.price_quote_date__c = System.today();
                            }
                            update oliRecord;
                            
                            if(assignedAnalyst != null && params.storeHtml.contains('#Assigned_analyst#')) {
                                newStoreHtml = params.storeHtml.replace('#Assigned_analyst#', assignedAnalyst);
                            }
                        }
                        when 409 {
                            WebServiceUtils.ResponseErrorMessage_Wrapper errorW = WebServiceUtils.parse(invokeModify.getBody());
                            isOk = false;
                            mapReturn.put('isOk', false);
                            mapReturn.put('errorMessage',Label.DecisionPriceActionError + ' ' + errorW.errormessage);
                        }
                        when else {
                            isOk = false;
                            mapReturn.put('isOk', false);
                            mapReturn.put('errorMessage',Label.PriceGenericError);
                        }
                    }
                } catch(Exception e) {
                    isOk = false;
                    mapReturn.put('isOk', false);
                    mapReturn.put('errorMessage',Label.PriceGenericError);
                }
            }
            if(isOk) {
                update opp;
                mapReturn = saveAuditCase(params, newStoreHtml, elevateCase, idAnalist, lstApiField, lstValue);
            }
        } catch(Exception e) {
            mapReturn.put('isOk', false);
        }
        return mapReturn;
    }
    
    /**Method for get information used to analist **/
    @AuraEnabled
    public static Map<String,Object> getInfoAnalist(String recordIdOppLineItem) {
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
        for(fprd__GBL_Product_Configuration__c prodConfig : lstConfig) {
            setFields.add(prodConfig.fprd__Map_field__c);
            mapMapfieldConfig.put(prodConfig.fprd__Map_field__c,prodConfig);
        }
        List<String> lstStringField = new List<String>(setFields);
        mapReturn.put('lstInfoIsEmpty', lstStringField.isEmpty());
        mapReturn.put('lstField', lstStringField);
        mapReturn.put('lstOppLineItem', lstOppLineItem);
        mapReturn.put('mapMapfieldConfig',mapMapfieldConfig);
        if(!lstStringField.isEmpty()) { 
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
    
    /**Method for save audit web **/
    @AuraEnabled
    public static Map<String,Object> saveAuditWeb(String auditRecordId,  String storeHtml) {
        Map<String,Object> mapReturn = new Map<String,Object>();
        
        List<dwp_cvad__Action_Audit_Detail__c> lstDetails = new List<dwp_cvad__Action_Audit_Detail__c>();
        lstDetails.add(Action_Audit_Helper.getAuditDetail(auditRecordId, storeHtml, 1, '', 'Embedded'));
        insert lstDetails;
        
        mapReturn.put('isOk', true);
        return mapReturn;
    }
    
    /**Method to redirect to Case List View **/
    @AuraEnabled
    public static Map<String, Object> redirect() {
        Final Map<String, Object> mapRes=new Map<String, Object>();
        mapRes.put('isError', true);
        Final List<ListView> listViews = [SELECT Id, Name FROM ListView WHERE SobjectType = 'Case' AND DeveloperName = 'MyPendingRequest'];
        Final Integer listViewsSize= listViews.size();
        if(listViewsSize > 0) {
            mapRes.put('isError', false);
            mapRes.put('listView', listViews[0]);
        }
        return mapRes;
    }
    
    /**Method to getSanctionPriceInfo for History **/
    private static List<Map<String, Object>> getSanctionPriceInfo(Id oliId) {
        Final List<Map<String, Object>> lstMapRes = new List<Map<String, Object>>();
        Final OpportunityLineItem[] oli = [SELECT Product2Id, Product2.Name, UnitPrice, PE_List_Product_mode__c, gipr_Plazo__c, gipr_Periodicidad__c, gipr_Tipo_Garantia__c, 
                                           gipr_Garantia__c, gipr_Cobertura__c FROM OpportunityLineItem WHERE Id=: oliId];
        Final Integer oliSize = oli.size();
        if(oliSize > 0) {
            Final Set<String> lstPicklist = new Set<String>{'PE_List_Product_mode__c', 'gipr_Tipo_Garantia__c', 'gipr_Garantia__c', 'gipr_Periodicidad__c'};
                Final Map<String, Object> mapPC = new Map<String, Object>();
            fprd__GBL_Product_Configuration__c[] lstProductConf = [SELECT id, fprd__DeveloperName__c, fprd__LoV_labels__c, fprd__LoV_values__c, fprd__Product__r.Name, 
                                                                   fprd__Map_field__c FROM fprd__GBL_Product_Configuration__c WHERE fprd__Product__c =: oli[0].Product2Id 
                                                                   AND fprd__Map_field__c IN: lstPicklist];
            for(fprd__GBL_Product_Configuration__c pc:lstProductConf) {
                if(!String.isEmpty(pc.fprd__LoV_values__c)) {
                    String[] strLabelTmp = pc.fprd__LoV_labels__c.split(',');
                    String[] strValueTmp = pc.fprd__LoV_values__c.split(',');
                    Integer position = strValueTmp.indexOf(''+oli[0].get(pc.fprd__Map_field__c));
                    if(position >= 0) {
                        mapPC.put(pc.fprd__Map_field__c, strLabelTmp[position]);   
                    }
                }
            }
            
            lstMapRes.add(new Map<String, Object>{ 'label' => 'Importe', 'value' => (oli[0].UnitPrice != null?oli[0].UnitPrice.setScale(2):null), 'type' => 'DOUBLE', 'position' => 1});
            lstMapRes.add(new Map<String, Object>{ 'label' => 'Modalidad', 'value' => mapPC.get('PE_List_Product_mode__c'), 'type' => 'STRING', 'position' => 2});
            lstMapRes.add(new Map<String, Object>{ 'label' => 'Plazo', 'value' => oli[0].gipr_Plazo__c, 'type' => 'INTEGER', 'position' => 3});
            lstMapRes.add(new Map<String, Object>{ 'label' => 'Periodicidad', 'value' => mapPC.get('gipr_Periodicidad__c'), 'type' => 'STRING' , 'position' => 4});
            lstMapRes.add(new Map<String, Object>{ 'label' => 'Tipo de garantía', 'value' => mapPC.get('gipr_Tipo_Garantia__c'), 'type' => 'STRING', 'position' => 5});
            if(oli[0].gipr_Tipo_Garantia__c != '03') {
                lstMapRes.add(new Map<String, Object>{ 'label' => 'Garantía', 'value' => mapPC.get('gipr_Garantia__c'), 'type' => 'STRING', 'position' => 6});
                lstMapRes.add(new Map<String, Object>{ 'label' => 'Cobertura (%)', 'value' => (oli[0].gipr_Cobertura__c !=null?oli[0].gipr_Cobertura__c.setScale(2):null), 'type' => 'PERCENT', 'position' => 7});
            }
            
        }
        return lstMapRes;
    }
    
    /**Method for save validityDate of Quotation **/
    @AuraEnabled
    public static Map<String,Object> saveValidityDate(String idOLI, String auditDetailId, String validDate) {
        Final Map<String,Object> mapReturn = new Map<String,Object>();
        
        Final List<OpportunityLineItem> lstOppLineItem = [SELECT  Id, 
                                                    Product2.Name,
                                                    Product2Id,
                                                    proposed_fee_per__c,
                                                    minimun_fee_per__c,
                                                    OpportunityId,
                                                    validityDate__c,
                                                    Opportunity.opportunity_status_type__c
                                                    FROM OpportunityLineItem
                                                    WHERE Id = :idOLI];
        
        try {
            if(!lstOppLineItem.isEmpty()) {
                //helper to call the service
                Final GetQuotationRequest_helper getquoteHelper = new GetQuotationRequest_helper(lstOppLineItem[0].OpportunityId); 
                //invoke the service
                Final System.HttpResponse invoke = getquoteHelper.invoke();
                switch on invoke.getStatusCode() {                        
                    when 200{
                        //get json body
                		Final GetQuotationRequest_helper.ResponseGetQuotationRequest_Wrapper jbody = GetQuotationRequest_helper.parse(invoke.getBody());
                        if(jbody.data.quotations[0].validityDate == '') {
                            lstOppLineItem[0].validityDate__c = Date.valueOf(validDate);
                        } else {
                            lstOppLineItem[0].validityDate__c = Date.valueOf(jbody.data.quotations[0].validityDate.substring(0,10));
                        }
                        update lstOppLineItem[0];
                    }
                }
                Final List<dwp_cvad__Action_Audit_Detail__c> lts = [SELECT Id, dwp_cvad__action_audit_detail_display_title__c, dwp_cvad__action_audit_detail_content__c FROM dwp_cvad__Action_Audit_Detail__c WHERE ID=:auditDetailId];
                if(!lts.isEmpty()) {
                    if(lstOppLineItem[0].validityDate__c==null) {
                        lts[0].dwp_cvad__action_audit_detail_content__c.replace('#validityDate#', '');
                    } else {
                        lts[0].dwp_cvad__action_audit_detail_content__c.replace('#validityDate#', ((DateTime)lstOppLineItem[0].validityDate__c).format('dd/MM/yyyy'));
                    }
                    lts[0].dwp_cvad__action_audit_detail_content__c.replace('#Assigned_analyst#', lstOppLineItem[0].Assigned_analyst__c);
                    update lts[0];
                }
            }
            mapReturn.put('isOk', true);
        } catch(Exception e) {
            mapReturn.put('isOk', false);
        }
        return mapReturn;
    }
    
    /**Method for save audit and case **/
    @AuraEnabled
    public static Map<String,Object> saveAuditCase(Parameters params, String newStoreHtml, Boolean elevateCase, Id idAnalist, List<String> lstApiField, List<Object> lstValue) {
        Map<String,Object> mapReturn = new Map<String,Object>();
        List<dwp_cvad__Action_Audit__c> lstAudit = new List<dwp_cvad__Action_Audit__c>();
        lstAudit.add(Action_Audit_Helper.getAudit(params.nameAudit, 'Opportunity', params.recordId, DateTime.now(), label.AuditPriceApproval, UserInfo.getUserId(), params.styleAudit, null, false));
        lstAudit[0].dwp_cvad__audit_audit_comments__c = params.strComments;
        insert lstAudit;
        
        List<dwp_cvad__Action_Audit_Detail__c> lstDetails = new List<dwp_cvad__Action_Audit_Detail__c>();
        lstDetails.add(Action_Audit_Helper.getAuditDetail(lstAudit[0].Id, newStoreHtml, 1, '', 'Embedded'));
        insert lstDetails;
        mapReturn.put('auditDetailId', lstDetails[0].Id);
        
        List<Case> lstCases = [SELECT   Id, 
                               opportunity_id__c, 
                               IsClosed,
                               OwnerId,
                               Status,
                               bypass__c
                               FROM Case 
                               WHERE opportunity_id__c = :params.recordId 
                               AND IsClosed = false];
        lstCases[0].Status = params.statusCase;
        lstCases[0].bypass__c = true;
        if(elevateCase && idAnalist==null) {
            List<Group> queueGroup = [SELECT    Id, 
                                      DeveloperName,
                                      Type  
                                      FROM Group 
                                      WHERE Type = 'Queue' 
                                      AND DeveloperName = 'Tier_2'];
            lstCases[0].OwnerId = queueGroup[0].Id;
        } else if(elevateCase && idAnalist!=null) {
            lstCases[0].OwnerId = idAnalist;
        }
        update lstCases;
        Map<String,Object> mapReturnSaveOli = FieldForm_ctrl.doSave(params.recordOli,'OpportunityLineItem', lstApiField, lstValue);
        
        mapReturn.put('isOk', (Boolean)mapReturnSaveOli.get('isOk'));
        return mapReturn;
    }
    
    /**Method for map parameters **/
    public class Parameters {
        /**
        * record id param
        */
        private String recordId;
        /**
        * status of opportunity param
        */
        private String statusOpp;
        /**
        * stage opportunity param
        */
        private String stageName;
        /**
        * style audit param
        */
        private String styleAudit;
        /**
        * name audit param
        */
        private String nameAudit;
        /**
        * comments param
        */
        private String strComments;
        /**
        * OpportunityLineItem id param
        */
        private String recordOli;
        /**
        * status of case param
        */
        private String statusCase;
        /**
        * html audit param
        */
        private String storeHtml;
        /**
        * aprroval method param
        */
        private String approvalMethod;
        /**
        * phase param
        */
        private String wsPhase;
        /**
        * validity date of quotation param
        */
        private String validDate;
    }
}