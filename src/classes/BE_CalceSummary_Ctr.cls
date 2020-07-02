/**
   ----------------------------------------------------------------------------------------------------
   @Name <BE_CalceNewOpportunities_Ctr>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2020-02-24
   @Description Class Ctr for NewOpportunities
   @Changes
    Date        Author   Email                  Type
    2020-06-21  LMBR     lolo.bravo@bbva.com    Creation
   ----------------------------------------------------------------------------------------------------
 */
public with sharing class BE_CalceSummary_Ctr {
/** Lang Code */
private static final List<String> LANG_CODE = new List<String> {'es','en_US'};
/** private constructor */
    private BE_CalceSummary_Ctr() {}
    /**
   @Description return sObject Calce
   @param recordId  of Sbject
   @return a SObject
    */
    @AuraEnabled(cacheable=false)
    public static SObject getSummaryCalce(String recordId) {
        return [SELECT Id,status__c, portfolio_loss__c,direct_early_cancellations__c,indirect_early_cancellations__c,direct_regular_cancellations__c,indirect_regular_cancellations__c,credit_letter__c,bond_letter__c,comex__c,desc_letter_bill__c,leasing__c,net_direct_calce__c,net_indirect_calce__c,short_term_loan__c,long_term_loan__c,sub_total_direct__c,sub_total_indirect__c,portfolio_recovery__c,CurrencyIsoCode FROM Calce__c WHERE Id=: recordId];
    }
    /**
   @Description update Calce
   @param  SObject to Update
   @return 
    */
    @AuraEnabled(cacheable=false)
    public static Response updateSummaryCalce(SObject calce) {
        final Response res=new Response();
        final Map<String,String> messages = new Map<String,String>();
        try {
            messages.put(LANG_CODE[0], 'Calce Actualizado satisfactoriamente');
            messages.put(LANG_CODE[1], 'Calce updated sucessfully.');
		    res.isSuccess = true;
		    res.message = messages.get(UserInfo.getLanguage());
            update calce;
            res.data=getSummaryCalce(calce.Id);
            BE_CalceDetailManger_Helper.setCalceStatus((Calce__c)res.data);
        } catch (DmlException ex) {
            res.isSuccess=false;
            res.message=ex.getDmlMessage(0);
        }
        return res;
    }
/**
   -------------------------------------------------------------------------------------------------
   @Name <Response>
   @Description Wrapper Class for the reponse to lwc.
   -------------------------------------------------------------------------------------------------
 */
    public without sharing class Response {
        /**Indicate if the transaction is Success*/
        @AuraEnabled
        public Boolean isSuccess {set; get;}
        /**Message to show in the front to final user*/
        @AuraEnabled
        public String message {set; get;}
        /**List of Sobject*/
        @AuraEnabled
        public SObject data {set; get;}
    }
}