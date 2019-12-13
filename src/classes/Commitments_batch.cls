global without sharing class Commitments_batch implements Database.Batchable<Object>, Database.AllowsCallouts{
    
    global String prodModel;
    
    global Commitments_batch(String productModel){
        this.prodModel = productModel;
    }

    global List<Object> start(Database.BatchableContext BC){
        List<Object> lstObject = new List<Object>(); 

        CompromiseProducts_helper compromiseHelper = new CompromiseProducts_helper(this.prodModel);
        System.HttpResponse compromiseResponse = compromiseHelper.invoke();

        switch on compromiseResponse.getStatusCode(){
            when 200 {
                CompromiseProducts_helper.ResponseCompromiseProducts_Wrapper responseParse = compromiseHelper.parse(compromiseResponse.getBody());
                if(!responseParse.data.isEmpty()){
                    //delete
                    List<Commitment_Value__c> lstCommitmentsVal = [SELECT Id, pricing_model_id__c FROM Commitment_Value__c WHERE pricing_model_id__c = :this.prodModel];
                    if(!lstCommitmentsVal.isEmpty()) delete lstCommitmentsVal;
                    lstObject = responseParse.data;
                }
            }
            when else {
                //nothing
            }
        }

        return lstObject;
    }

    global void execute(Database.BatchableContext BC, List<Object> lstobj){
        List<Commitment_Value__c> lstCommitmentsInsert = new List<Commitment_Value__c>();
        for(Object data : lstobj){
            CompromiseProducts_helper.Response_data dataResponse = (CompromiseProducts_helper.Response_data) data;
            for(CompromiseProducts_helper.Response_committableData committable : dataResponse.committableData){
                Commitment_Value__c commitment = new Commitment_Value__c(   CurrencyIsoCode = committable.currency_type,
                                                                            commitment_unit_type__c = committable.unitType,
                                                                            commitment_product_name__c = dataResponse.name,
                                                                            commitment_id__c = dataResponse.id,
                                                                            quote_type__c = 'Web',
                                                                            commitment_expiry_days_number__c = String.valueOf(committable.validityDays),
                                                                            pricing_model_id__c = this.prodModel);
                lstCommitmentsInsert.add(commitment);
            }
        }
        if(!lstCommitmentsInsert.isEmpty()) insert lstCommitmentsInsert;
    }

    public void finish(Database.BatchableContext BC){
     
    }
}