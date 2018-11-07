public class CreateQuotationCommitment_helper {
    public CreateQuotationCommitment_Wrapper inputDataMapping;

    public CreateQuotationCommitment_helper(String commitmentId){
        List<Opportunity_Solution_Commitment__c> lstCommitments = [SELECT   Id,
                                                                            opp_solution_commitment_amount__c,
                                                                            opp_solution_commitment_id__c,
                                                                            opp_soln_comt_expiry_days_number__c,
                                                                            opp_solution_id__c,
                                                                            CurrencyIsoCode
                                                                    FROM Opportunity_Solution_Commitment__c 
                                                                    WHERE Id = :commitmentId];
        
        if(!lstCommitments.isEmpty()){
            List<OpportunityLineItem> lstOli = [SELECT  Id, 
                                                        price_quote_id__c, 
                                                        price_operation_id__c 
                                                FROM OpportunityLineItem 
                                                WHERE Id = :lstCommitments[0].opp_solution_id__c];
                                                
            CreateQuotationCommitment_Wrapper inputWrapper = new CreateQuotationCommitment_Wrapper();
            inputWrapper.commitmentProductId = (lstCommitments[0].opp_solution_commitment_id__c == null ? '' : lstCommitments[0].opp_solution_commitment_id__c );
            inputWrapper.validityDays = (lstCommitments[0].opp_soln_comt_expiry_days_number__c == null ? '' : String.valueOf(lstCommitments[0].opp_soln_comt_expiry_days_number__c) );
            inputWrapper.ammount = (lstCommitments[0].opp_solution_commitment_amount__c == null ? '' : String.valueOf(lstCommitments[0].opp_solution_commitment_amount__c) );
            inputWrapper.strCurrency = (lstCommitments[0].CurrencyIsoCode == null ? '' : lstCommitments[0].CurrencyIsoCode );
            inputWrapper.quotationId = (lstOli.isEmpty() || lstOli[0].price_quote_id__c == null ? '' : lstOli[0].price_quote_id__c);
            inputWrapper.operationId = (lstOli.isEmpty() || lstOli[0].price_operation_id__c == null ? '' : lstOli[0].price_operation_id__c);
            this.inputDataMapping = inputWrapper;
        }

    }

    public class CreateQuotationCommitment_Wrapper { 
        public String commitmentProductId;
        public String validityDays;
        public String ammount;
        public String strCurrency;
        public String quotationId;
        public String operationId;
    }

    public String generateJSONRequest(){
        return JSON.serialize(this.inputDataMapping);
    }
    
    //method to invoke the webservice 
    public System.HttpResponse invoke(){
        return iaso.GBL_Integration_GenericService.invoke('CreateQuotationCommitment',generateJSONRequest());
    }
}