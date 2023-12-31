/**
 * Case_Helper
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 *     		--/--/20--          Original version.<p />
 *
 * @author
 */
public with sharing class Case_Helper {
    
    /**
	   @Description RT_ID
	 */
	private Final static String RT_ID = [SELECT Id FROM RecordType WHERE DeveloperName = 'Sanction_Price'].Id;
    /**
	   @Description Case_Helper
	 */
    private Case_Helper() {}

	/**
	   @Description updateCaseNotification
	 */
	public static void updateCaseNotification(List<Case> lstNew, Map<Id, Case> mapOld) {
		Final List <Id> lstId = new List <Id>();
		for(Case casnew : lstNew) {
			if(!casnew.IsClosed && casnew.OwnerId != mapOld.get(casnew.Id).OwnerId && casnew.recordTypeId == RT_ID && casnew.bypass__c) {
				lstId.add(casnew.Id);
			}
		}
		if(!lstId.isEmpty()) {
			DynamicBatchChatterNotification.getDynamicBatchChatterNotification(lstId, 'Case', Label.lblREASIGN_CASE);
		}
	}

	/**
	   @Description insertCaseNotification
	 */
	public static void insertCaseNotification(List<Case> lstNew) {
		Final List <Id> lstId = new List <Id>();
		for(Case cas : lstNew) {
			if(!cas.IsClosed && cas.recordTypeId == RT_ID) {
				lstId.add(cas.Id);
			}
		}
		if(!lstId.isEmpty()) {
			DynamicBatchChatterNotification.getDynamicBatchChatterNotification(lstId, 'Case', Label.lblCREATE_CASE);
		}
	}

	/**
	 * Method using to Update rate
	 *

	   public static void UpdaterateCases(List<Case> lstNew){
	    set<id> iOpportuni = new set<Id>();
	    for(case cas : lstNew)
	        if(cas.opportunity_id__c!=null)
	        iOpportuni.add(cas.opportunity_id__c);
	    If(!iOpportuni.isempty()){
	        Map<Id,OpportunityLineItem> MAOLI = new Map<Id,OpportunityLineItem>();
	        for(OpportunityLineItem OLI : [Select Id,OpportunityId, proposed_fee_per__c,proposed_apr_per__c   from
	                                       OpportunityLineItem where OpportunityId IN :iOpportuni
	                                       order by createdDate asc])
	            MAOLI.put(OLI.OpportunityId, OLI);

	        for(case cas : lstNew){
	            if(!String.isBlank(String.valueOf(MAOLI.get(cas.opportunity_id__c).proposed_fee_per__c)))
	            cas.proposed_apr_per__c=MAOLI.get(cas.opportunity_id__c).proposed_fee_per__c;
	            else
	            cas.proposed_apr_per__c=MAOLI.get(cas.opportunity_id__c).proposed_apr_per__c;
	        }
	    }
	   }*/
}