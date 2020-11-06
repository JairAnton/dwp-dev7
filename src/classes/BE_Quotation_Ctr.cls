/**
   ----------------------------------------------------------------------------------------------------
   @Name <BE_Quotation_Ctr>
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-11-06
   @Description Class extension for BE_Quotation_vfp
   @Changes
    Date        Author   Email                  			Type		Description
    2020-11-06  MAMCH    martin.mori.contractor@bbva.com    Creation
   ----------------------------------------------------------------------------------------------------
 */
public with sharing class BE_Quotation_Ctr {
	/** variable opportunity */
	private final Opportunity opp;
    /** list of commintments */
	public final List<Opportunity_Solution_Commitment__c> commitments {get; set;}
    /** string with comments */
	public String comments {get; set;}
    /** string with modality */
	public final String modality {get; set;}
    
    /**
	   @Description Constructor of class
	   @param  ApexPages.StandardController stdController
	 */
    public BE_Quotation_Ctr(ApexPages.StandardController stdController) {
        opp = (Opportunity)stdController.getRecord();
        for(dwp_cvad__Action_Audit_Detail__c auditDet : [SELECT Id, dwp_cvad__action_audit_detail_content__c FROM dwp_cvad__Action_Audit_Detail__c WHERE dwp_cvad__action_audit_id__r.dwp_cvad__action_audit_record_id__c = :opp.Id ORDER BY dwp_cvad__action_audit_id__r.CreatedDate DESC LIMIT 1]) {
            comments = auditDet.dwp_cvad__action_audit_detail_content__c;
            comments = comments.substringAfterLast('>Comentarios</h3>');
            comments = comments.substringBefore('</span>');
            comments = comments.stripHtmlTags();
        }
        commitments = [SELECT Id, opp_solution_comt_product_name__c, CurrencyIsoCode, opp_solution_commitment_amount__c, opp_solution_commitment_number__c, opp_soln_comt_expiry_days_number__c FROM Opportunity_Solution_Commitment__c WHERE opportunity_id__c = :opp.Id];
        Final OpportunityLineItem oli = [SELECT Id, Product2Id, toLabel(PE_List_Product_mode__c) FROM OpportunityLineItem WHERE OpportunityId = :opp.Id LIMIT 1];
        modality = oli.PE_List_Product_mode__c;
    }
}