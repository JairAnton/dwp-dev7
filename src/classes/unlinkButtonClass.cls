/**
* @author Global_HUB developers
* @date 18-07-2018
*
* @group Global_HUB
*
* @description Controller class of the Unlink_cmp
**/
public class unlinkButtonClass {
    @auraenabled
    public static String unlink (String Idopp){
        /**
        * @description Method to update the Audits to Account and the opportunity to delete SIO code and SIO status
        * @return String
        **/
        string msg;
        Opportunity opp = [Select Id,StageName, opportunity_status_type__c, sio_code__c, sio_status_type__c, AccountId, Risk_modality_type__c From Opportunity where Id =:Idopp];
        Account acc = [Select Id From Account where Id =:opp.AccountId];
        List <dwp_cvad__Action_Audit__c> lstaction = [Select Id, dwp_cvad__action_audit_record_id__c, dwp_cvad__action_audit_object_api_name__c from dwp_cvad__Action_Audit__c where dwp_cvad__action_audit_record_id__c =:opp.id and action_audit_email__c = true];
        List <dwp_cvad__Action_Audit__c> lstactionnew = new List <dwp_cvad__Action_Audit__c>();
        if(!lstaction.isEmpty()){
            for(dwp_cvad__Action_Audit__c action : lstaction){
                action.dwp_cvad__action_audit_record_id__c = acc.Id;
                action.dwp_cvad__action_audit_object_api_name__c = 'Account';
            }            
            update lstaction;
            
            lstactionnew.add(Action_Audit_Helper.getAudit(Label.lblUnlink, 'Opportunity', Idopp, DateTime.now(), label.AuditRiskApproval, UserInfo.getUserId(), label.auditStyleSendBack, opp.sio_code__c, false));
            
            opp.sio_code__c ='';
            opp.sio_status_type__c='';
            opp.Risk_modality_type__c ='';
            update opp;
            insert lstactionnew;
            
            return 'Updated';        
        }
        return 'emptyAudit';
        
    }
    
}