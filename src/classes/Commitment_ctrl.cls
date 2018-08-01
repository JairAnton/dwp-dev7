public with sharing class Commitment_ctrl {
 	@AuraEnabled
    public static Map<String,Object> getInfo(String quoteType){
        Map<String,Object> mapReturn = new Map<String,Object>();
        List<Commitment_Value__c> lstCommitmentValues = [SELECT     Id,
                                                                    commitment_product_name__c,
                                                                    web_product_code__c,
                                                                    commitment_expiry_days_number__c,
                                                                    commitment_stay_days_number__c,
                                                                    CurrencyIsoCode,
                                                                    quote_type__c
                                                            FROM Commitment_Value__c
                                                            WHERE quote_type__c = :quoteType
                                                            ORDER BY commitment_product_name__c];
        mapReturn.put('lstCommitments', lstCommitmentValues);
        Set<String> setApiName = new Set<String>();
        setApiName.add('opp_solution_commitment_amount__c');
        setApiName.add('opp_soln_comt_expiry_days_number__c');
        setApiName.add('opp_soln_comt_stay_days_number__c');
        setApiName.add('opp_solution_comt_product_name__c');
        setApiName.add('CurrencyIsoCode');
        mapReturn.put('schemaSetup', FieldForm_ctrl.getInfoSchema(setApiName, 'Opportunity_Solution_Commitment__c'));
        return mapReturn; 
    }
    @AuraEnabled
    public static Map<String,Object> getInfoTable(String recordId){
        Map<String,Object> mapReturn = new Map<String,Object>();
        List<Opportunity_Solution_Commitment__c> lstCommitments = [SELECT   Id,
                                                                            opp_solution_commitment_amount__c,
                                                                            opp_soln_comt_expiry_days_number__c,
                                                                            opp_soln_comt_stay_days_number__c,
                                                                            opp_solution_comt_product_name__c,
                                                                            CurrencyIsoCode
                                                                    FROM Opportunity_Solution_Commitment__c
                                                                    WHERE opportunity_id__c = :recordId];
        mapReturn.put('lstCommitments', lstCommitments); 
        Set<String> setApiName = new Set<String>();
        setApiName.add('opp_solution_commitment_amount__c');
        setApiName.add('opp_soln_comt_expiry_days_number__c');
        setApiName.add('opp_soln_comt_stay_days_number__c');
        setApiName.add('opp_solution_comt_product_name__c');
        setApiName.add('CurrencyIsoCode');
        mapReturn.put('schemaSetup', FieldForm_ctrl.getInfoSchema(setApiName, 'Opportunity_Solution_Commitment__c'));
        return mapReturn; 
    }
    
    @AuraEnabled
    public static Map<String,Object> saveCommitment(String recordId, List<Object> lstData){
        Map<String,Object> mapReturn = new Map<String,Object>();
        Opportunity_Solution_Commitment__c oppSolCommitment = new Opportunity_Solution_Commitment__c();
        oppSolCommitment.opp_solution_comt_product_name__c = String.valueOf(lstData[0]);
        oppSolCommitment.CurrencyIsoCode = String.valueOf(lstData[1]);
        oppSolCommitment.opp_soln_comt_expiry_days_number__c = Double.valueOf(lstData[2]);
        oppSolCommitment.opp_solution_commitment_amount__c = Double.valueOf(lstData[3]);
        oppSolCommitment.opp_soln_comt_stay_days_number__c = Double.valueOf(lstData[4]);
        oppSolCommitment.opportunity_id__c = recordId;
        insert oppSolCommitment;
        mapReturn.put('isOK', true);
        return mapReturn; 
    }

    @AuraEnabled
    public static Map<String,Object> deleteCommitment(String recordId){
        Map<String,Object> mapReturn = new Map<String,Object>();
        Opportunity_Solution_Commitment__c oppSolCommitment = new Opportunity_Solution_Commitment__c();
        oppSolCommitment.Id = recordId;
        delete oppSolCommitment;
        mapReturn.put('isOK', true);
        return mapReturn; 
    }
}