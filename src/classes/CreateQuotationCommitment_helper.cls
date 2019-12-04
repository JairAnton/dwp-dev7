public without sharing class CreateQuotationCommitment_helper {
    public CreateQuotationCommitment_Wrapper inputDataMapping{ get; set; } //Ernesto 04/12/2018 : se agregó el get y set

    public CreateQuotationCommitment_helper(String commitmentId){
        List<Opportunity_Solution_Commitment__c> lstCommitments = [SELECT   Id,
                                                                            opp_solution_commitment_amount__c,
                                                                            opp_solution_commitment_id__c,
                                                                            opp_soln_comt_expiry_days_number__c,
                                                                            opp_solution_id__c,
                                                                   			opp_solution_commitment_number__c, 
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
            inputWrapper.quotationId = (lstOli.isEmpty() || lstOli[0].price_quote_id__c == null ? '' : lstOli[0].price_quote_id__c);
            inputWrapper.operationId = (lstOli.isEmpty() || lstOli[0].price_operation_id__c == null ? '' : lstOli[0].price_operation_id__c);
            
            if(lstCommitments[0].opp_solution_commitment_number__c == null) {
                Request_unitValueAmount unitValueAmount = new Request_unitValueAmount();
                unitValueAmount.amount = (lstCommitments[0].opp_solution_commitment_amount__c == null ? '' : String.valueOf(lstCommitments[0].opp_solution_commitment_amount__c));
                unitValueAmount.currency_type = (lstCommitments[0].CurrencyIsoCode == null ? '' : lstCommitments[0].CurrencyIsoCode);
                inputWrapper.unitValue = JSON.serialize(unitValueAmount);
            } else {
                Request_unitValueQuantity unitValueQuantity = new Request_unitValueQuantity();
                unitValueQuantity.value = String.valueOf(lstCommitments[0].opp_solution_commitment_number__c);
                inputWrapper.unitValue = JSON.serialize(unitValueQuantity);
            }
            this.inputDataMapping = inputWrapper;
        }

    }

    public class CreateQuotationCommitment_Wrapper { 
        public String commitmentProductId {get; set;} //Yulino 30/11/2018 : se agregó el get y set
        public String validityDays {get; set;} //Yulino 30/11/2018 : se agregó el get y set
        public String quotationId {get; set;} //Yulino 30/11/2018 : se agregó el get y set
        public String operationId {get; set;} //Yulino 30/11/2018 : se agregó el get y set
        public String unitValue {get; set;}
    }

    public String generateJSONRequest(){
        String json = JSON.serialize(this.inputDataMapping);
        json = json.replace('currency_type', 'currency');
        return json;
    }
    
    //method to invoke the webservice 
    public System.HttpResponse invoke(){
        return iaso.GBL_Integration_GenericService.invoke('CreateQuotationCommitment',generateJSONRequest());
    }
    
    public class Request_unitValueAmount {
		public String amount { get; set; }
		public String currency_type { get; set; }
	}
    
    public class Request_unitValueQuantity {
		public String value { get; set; }
	}
}