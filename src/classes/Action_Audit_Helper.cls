/**
* @author Global_HUB developers
* @date 10-07-2018
*
* @group Global_HUB
*
* @description Helper class to get Action Audits and Action Audits Detail
**/
public class Action_Audit_Helper {
    //method helper to get Action Audit
    public static dwp_cvad__Action_Audit__c getAudit(String auditName, String apiName, String recordId, DateTime auditDate, String auditType, String userId, String auditStyle, String sioCode, Boolean email){
        
        dwp_cvad__Action_Audit__c actAudit = new dwp_cvad__Action_Audit__c();
        
        actAudit.dwp_cvad__action_audit_name__c = auditName;
        actAudit.dwp_cvad__action_audit_object_api_name__c  = apiName;
        actAudit.dwp_cvad__action_audit_record_id__c = recordId;
        actAudit.dwp_cvad__action_audit_date__c = auditDate;
        actAudit.dwp_cvad__action_audit_type__c = auditType;
        actAudit.dwp_cvad__action_audit_user_id__c = userId;
        actAudit.dwp_cvad__action_audit_style__c = auditStyle;
        actAudit.action_opp_SIO_code__c = sioCode;
        actAudit.action_audit_email__c = email;
        
        return actAudit;
    }
    //method helper to get Action Audit Detail
    public static dwp_cvad__Action_Audit_Detail__c getAuditDetail(String auditId, String content, Integer order, String title, String disType){
        
        dwp_cvad__Action_Audit_Detail__c auditDetail = new dwp_cvad__Action_Audit_Detail__c();
        
        auditDetail.dwp_cvad__action_audit_id__c = auditId;
        auditDetail.dwp_cvad__action_audit_detail_content__c = content;
        auditDetail.dwp_cvad__action_audit_detail_display_order__c = order;
        auditDetail.dwp_cvad__action_audit_detail_display_title__c = title;
        auditDetail.dwp_cvad__action_audit_detail_display_type__c = disType;
        
        return auditDetail;        
    }
    
}