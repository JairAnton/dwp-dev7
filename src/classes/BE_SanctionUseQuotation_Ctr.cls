/**
   ----------------------------------------------------------------------------------------------------
   @Name <BE_SanctionUseQuotation_Ctr>
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-11-06
   @Description Class controller for BE_SanctionUseQuotation_cmp
   @Changes
    Date        Author   Email                  			Type		Description
    2020-11-06  MAMCH    martin.mori.contractor@bbva.com    Creation
   ----------------------------------------------------------------------------------------------------
 */
public with sharing class BE_SanctionUseQuotation_Ctr {    
    /**
	   @Description method used to return comments of audit
	   @param  String recordId id of record related of audit
	   @return String with comments of last audit
	 */
    @AuraEnabled
    public static String getComments(String recordId) {
        try {
            String comments = '';
            for(dwp_cvad__Action_Audit_Detail__c auditDet : [SELECT Id, dwp_cvad__action_audit_detail_content__c, dwp_cvad__action_audit_id__r.dwp_cvad__action_audit_record_id__c FROM dwp_cvad__Action_Audit_Detail__c WHERE dwp_cvad__action_audit_id__r.dwp_cvad__action_audit_record_id__c = :recordId ORDER BY dwp_cvad__action_audit_id__r.CreatedDate DESC LIMIT 1]) {
                comments = auditDet.dwp_cvad__action_audit_detail_content__c;
                comments = comments.substringAfterLast('>Comentarios</h3>');
                comments = comments.substringBefore('</span>');
                comments = comments.stripHtmlTags();
            }
            return comments;
        } catch(Exception e) {
            return null;
        }
    }
    
    /**
	   @Description method used to set opportunity values when selected current quote
	   @param  String oppId id of opportunity
	   @param  String idOliSelected of OpportunityLineItem that has quotation
	   @return Map<String, Object> with result of operation
	 */
    @auraenabled
	public static Map<String, Object> useQuotationPrice(String oppId, String idOliSelected) {
        Final Map<String, Object> mapReturn = new Map<String, Object>();
		mapReturn.put('isOk', true);
        Savepoint sp = Database.setSavepoint();
		try {
			Final opportunity opp  = [SELECT Id FROM Opportunity WHERE ID =:oppId];
			opp.isProcess__c = true;
			opp.opportunity_status_type__c  = '11';
            opp.BE_UseApprovedQuote__c = true;
            update opp;
            
            Final List<OpportunityLineItem> olis = [SELECT Id FROM OpportunityLineItem WHERE OpportunityId = :oppId LIMIT 1];
            Final List<OpportunityLineItem> oliSelected = [SELECT Id, OpportunityId, Opportunity.Account.Name, price_quote_date__c, suggested_apr_per__c, validityDate__c, proposed_apr_per__c, minimun_apr_per__c, price_quote_id__c, Assigned_analyst__c, price_operation_id__c FROM OpportunityLineItem WHERE Id = :idOliSelected LIMIT 1];
            olis[0].price_quote_date__c = oliSelected[0].price_quote_date__c;
            olis[0].suggested_apr_per__c = oliSelected[0].suggested_apr_per__c;
            olis[0].validityDate__c = oliSelected[0].validityDate__c;
            olis[0].proposed_apr_per__c = oliSelected[0].proposed_apr_per__c;
            olis[0].minimun_apr_per__c = oliSelected[0].minimun_apr_per__c;
            olis[0].price_quote_id__c = oliSelected[0].price_quote_id__c;
            olis[0].Assigned_analyst__c = oliSelected[0].Assigned_analyst__c;
            olis[0].price_operation_id__c = oliSelected[0].price_operation_id__c;
            update olis;
            
            Final List<Opportunity_Solution_Commitment__c> commitments = new List<Opportunity_Solution_Commitment__c>();
            for(Opportunity_Solution_Commitment__c commitment : [SELECT added_to_price_quotation__c, opp_solution_commitment_amount__c, price_quote_date__c, opportunity_id__c, opp_soln_comt_expiry_days_number__c, opp_soln_comt_stay_days_number__c, opp_solution_commitment_number__c, CurrencyIsoCode, opp_solution_comt_product_name__c, opp_solution_id__c, price_quotation_id__c, price_quotation_method__c, opp_solution_commitment_id__c FROM Opportunity_Solution_Commitment__c WHERE opportunity_id__c = :oliSelected[0].OpportunityId]) {
                Opportunity_Solution_Commitment__c oppSolCommitment = commitment.clone();
                oppSolCommitment.opportunity_id__c = oppId;
                oppSolCommitment.opp_solution_id__c = olis[0].Id;
                commitments.add(oppSolCommitment);
            }
            if(!commitments.isEmpty()) {
                insert commitments;
            }
            
            Final List<dwp_cvad__Action_Audit__c> audits = new List<dwp_cvad__Action_Audit__c>();
            Final List<dwp_cvad__Action_Audit__c> auditExist = [SELECT action_audit_email__c, dwp_cvad__action_audit_date__c, dwp_cvad__action_audit_user_id__c, dwp_cvad__action_audit_style__c, dwp_cvad__audit_audit_comments__c, dwp_cvad__action_audit_name__c, dwp_cvad__action_audit_object_api_name__c, dwp_cvad__action_audit_record_id__c, action_opp_sio_code__c, dwp_cvad__action_audit_type__c FROM dwp_cvad__Action_Audit__c WHERE dwp_cvad__action_audit_record_id__c = :oliSelected[0].OpportunityId ORDER BY CreatedDate DESC LIMIT 1];
            if(!auditExist.isEmpty()) {
                for(dwp_cvad__Action_Audit__c audit : auditExist) {
                    dwp_cvad__Action_Audit__c auditClone = audit.clone();
                    auditClone.dwp_cvad__action_audit_name__c = label.PriceApprovalUsingQuote;
                    auditClone.dwp_cvad__action_audit_record_id__c = oppId;
                    audits.add(auditClone);
                }
                if(!audits.isEmpty()) {
                    insert audits;
                }
                
                Final List<dwp_cvad__Action_Audit_Detail__c> auditDetails = new List<dwp_cvad__Action_Audit_Detail__c>();
                for(dwp_cvad__Action_Audit_Detail__c detail : [SELECT dwp_cvad__action_audit_detail_content__c, dwp_cvad__action_audit_detail_display_order__c, dwp_cvad__action_audit_detail_content_format__c, CurrencyIsoCode, dwp_cvad__action_audit_detail_display_type__c, dwp_cvad__action_audit_detail_display_title__c FROM dwp_cvad__Action_Audit_Detail__c WHERE dwp_cvad__action_audit_id__c = :auditExist[0].Id]) {
                    dwp_cvad__Action_Audit_Detail__c detailClone = detail.clone();
                    detailClone.dwp_cvad__action_audit_id__c = audits[0].Id;
                    auditDetails.add(detailClone);
                }
                if(!auditDetails.isEmpty()) {
                    insert auditDetails;
                }
            }
            
            Final String namePDF = oliSelected[0].price_quote_id__c + ' - ' + oliSelected[0].Opportunity.Account.Name;
            Final List<ContentDocumentLink> ltsCDL = [SELECT Id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :oliSelected[0].OpportunityId AND ContentDocument.Title =:namePDF AND ContentDocument.FileType = 'pdf'];
            if(!ltsCDL.isEmpty()) {
                Final Id conDoc = ltsCDL[0].ContentDocumentId;
                Final ContentDocumentLink conDocLink = New ContentDocumentLink();
                conDocLink.LinkedEntityId = oppId;
                conDocLink.ContentDocumentId = conDoc;
                conDocLink.shareType = 'V';
                insert conDocLink;
            }
            
			return mapReturn;
		} catch(Exception e) {
            Database.rollback(sp);
			mapReturn.put('isOk', false);
			mapReturn.put('errorMessage', e.getMessage());
            return mapReturn;
		}
	}
}