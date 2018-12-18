//Controller for Penalize Risk button
public without sharing class Risk_Approval_cls {
	@AuraEnabled
    public static List<AggregateResult> getSIOCodesToSelect(String searchText, Opportunity opp) {
        //List to set with Audits records grouped by action_opp_sio_code__c in order to avoid duplicate records
        List<AggregateResult> audits = new List<AggregateResult>();
        try{
            //Logic to search audits records from opportunity's account and if it has been set the search text
            if(searchText != null && searchText != '') { //yulino - Se modificó el orden de las condiciones
                String text = '%' + searchText + '%';
                audits = [Select action_opp_sio_code__c From dwp_cvad__Action_Audit__c
                          Where dwp_cvad__action_audit_record_id__c = :opp.AccountId and dwp_cvad__action_audit_object_api_name__c = :Label.ApiNameAccount
                          and dwp_cvad__action_audit_type__c = :Label.AuditRiskApproval and action_audit_email__c = true and action_opp_sio_code__c Like :text
                          Group by action_opp_sio_code__c];
            }
            else {
                audits = [Select action_opp_sio_code__c From dwp_cvad__Action_Audit__c
                          Where dwp_cvad__action_audit_record_id__c = :opp.AccountId and dwp_cvad__action_audit_object_api_name__c = :Label.ApiNameAccount
                          and dwp_cvad__action_audit_type__c = :Label.AuditRiskApproval and action_audit_email__c = true
                          Group by action_opp_sio_code__c];
            }
            //If there is any audit record a list will be returned
            if(!audits.isEmpty()) {
                return audits;
            }
        } catch(Exception e) {
            System.debug('Error!: ' + e.getMessage() + e.getLineNumber());
        }
        return audits; //Yulino 27/11/2018 : se modificó de null a audits
    }
    
    @AuraEnabled
    public static Opportunity getOpportunity(String oppId) {
        try {
            List<Opportunity> opportunityRecord = new List<Opportunity>();
            opportunityRecord = [Select Id, Risk_modality_type__c, sio_code__c, sio_status_type__c, StageName, opportunity_status_type__c, AccountId, isProcess__c
                                 From Opportunity Where Id = :oppId];
            if(!opportunityRecord.isEmpty()) {
                return opportunityRecord[0];
            }
        }catch(Exception e) {
            System.debug('Error: ' + e.getMessage());
        }
        return null;
    }
    
    @AuraEnabled
    public static String saveSIO(Opportunity oppRecord, String auditSio) {
        try{
            //Get in a map the values from metadata records, with sio_status__c like key and sio_status_type__c like value
            List<SIO_Status_Mapping__mdt> listValuesMetadata = [Select sio_status__c, sio_status_type__c from SIO_Status_Mapping__mdt];
            Map<String, String> mappingMdt = new Map<String, String>();
            for(SIO_Status_Mapping__mdt mdt : listValuesMetadata) {
                mappingMdt.put(mdt.sio_status__c, mdt.sio_status_type__c);
            }
            
            //Audit record to set with last audit created record, depends on the sio_code__c is filled or not
            dwp_cvad__Action_Audit__c lastAudit;
            //If sio_code__c is empty, it means that is a new opprtunity, else the button has been pressed again
            if(oppRecord.sio_code__c == '' || oppRecord.sio_code__c == null) {
                List<dwp_cvad__Action_Audit__c> auditsToUpdate = [Select Id, dwp_cvad__action_audit_name__c, action_opp_sio_code__c, 
                                                                  dwp_cvad__action_audit_record_id__c, dwp_cvad__action_audit_object_api_name__c, dwp_cvad__action_audit_date__c
                                                                  From dwp_cvad__Action_Audit__c
                                                                  Where dwp_cvad__action_audit_record_id__c = :oppRecord.accountId and dwp_cvad__action_audit_object_api_name__c = :Label.ApiNameAccount
                                                                  and dwp_cvad__action_audit_type__c = :Label.AuditRiskApproval and action_audit_email__c = true and action_opp_sio_code__c = :auditSio order by dwp_cvad__action_audit_date__c desc];
                
                for(Integer i = 0; i < auditsToUpdate.size(); i++) {
                    if(auditsToUpdate[i].action_opp_sio_code__c == auditSio) {
                        auditsToUpdate[i].dwp_cvad__action_audit_record_id__c = oppRecord.Id;
                    	auditsToUpdate[i].dwp_cvad__action_audit_object_api_name__c = Label.ApiNameOpp;
                    }
                }
                lastAudit = auditsToUpdate[0];
                oppRecord.sio_code__c = auditsToUpdate[0].action_opp_sio_code__c;
                oppRecord.sio_status_type__c = auditsToUpdate[0].dwp_cvad__action_audit_name__c;
                update auditsToUpdate;
            }
            else {
                List<dwp_cvad__Action_Audit__c> auditsOpp = [Select Id, dwp_cvad__action_audit_name__c, action_opp_sio_code__c, dwp_cvad__action_audit_date__c From dwp_cvad__Action_Audit__c
                                                             Where dwp_cvad__action_audit_object_api_name__c = :Label.OpportunityObjectName and dwp_cvad__action_audit_record_id__c = :oppRecord.Id
                                                             and dwp_cvad__action_audit_type__c = :Label.AuditRiskApproval and action_audit_email__c = true 
                                                             order by dwp_cvad__action_audit_date__c desc];
                lastAudit = auditsOpp[0];
            }
            //Set the modality and the StageName from opportunity
            oppRecord.Risk_modality_type__c = Label.OppModalityRA;
            oppRecord.StageName = Label.lblSanctionStage;
            oppRecord.isProcess__c = true;
            
            
            //newAudit will be the new audit record to insert and depends the type of the audit compare to metadata values
            dwp_cvad__Action_Audit__c newAudit;
            if(mappingMdt.get(lastAudit.dwp_cvad__action_audit_name__c) == Label.Authorized) {
                newAudit = Action_Audit_Helper.getAudit(Label.RiskAuthorized, Label.OpportunityObjectName, oppRecord.Id, System.now(), Label.AuditRiskApproval, UserInfo.getUserId(), Label.AuditStyleApproveTop, oppRecord.sio_code__c, false);
                oppRecord.opportunity_status_type__c = Label.lblOpportunityStatusRiskAuth;
            }
            else if(mappingMdt.get(lastAudit.dwp_cvad__action_audit_name__c) == Label.Denied) {
                newAudit = Action_Audit_Helper.getAudit(Label.RiskDenied, Label.OpportunityObjectName, oppRecord.Id, System.now(), Label.AuditRiskApproval, UserInfo.getUserId(), Label.AuditStyleDeny, oppRecord.sio_code__c, false);
                oppRecord.opportunity_status_type__c = Label.lblOpportunityStatusRiskDenied;
            }
            else {
                newAudit = Action_Audit_Helper.getAudit(Label.RiskSendToApproval, Label.OpportunityObjectName, oppRecord.Id, System.now(), Label.AuditRiskApproval, UserInfo.getUserId(), Label.AuditStyleElevate, oppRecord.sio_code__c, false);
                oppRecord.opportunity_status_type__c = Label.lblOpportunityStatusSentRisk;
            }
            update oppRecord;
            insert newAudit;
            return 'OK';
        } catch(Exception e) {
            return e.getMessage();
        }
    }
    
    @AuraEnabled
    public static String sendApproval(Opportunity opp) {
        try{
            opp.Stagename = Label.lblSanctionStage;
            opp.opportunity_status_type__c = Label.lblOpportunityStatusApprovedInsideLine;
            opp.Risk_modality_type__c = Label.OppModalityDL;
            opp.isProcess__c = true;
            update opp;
            
            dwp_cvad__Action_Audit__c newAudit = Action_Audit_Helper.getAudit(Label.OpportunityStatusInsideLine, Label.OpportunityObjectName, opp.Id, System.now(), Label.AuditRiskApproval, UserInfo.getUserId(), Label.AuditStyleApproveTop, '', false);
            insert newAudit;
            return 'OK';
        }
        catch(Exception e) {
            return e.getMessage();
        }
    }
    
    public Risk_Approval_cls(){//Yulino 27-11-2018: agregado el constructor 
    }
}