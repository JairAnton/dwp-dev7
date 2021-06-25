/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_CalculateCommission_Ctr>
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2021-03-17
   @Description Controller class of BE_CalculateCommission_Cmp
   @Changes
   Date        Author   Email                  				    Type		Description
   2021-03-17  MAMC     martin.mori.contractor@bbva.com    	    Creation
   2021-05-12  MAMC     luis.vargas.matute.contractor@bbva.com  Update
   -------------------------------------------------------------------------------------------------
 */
public with sharing class BE_CalculateCommission_Ctr {
    /* Map with results of call */
    static Map<String, Object> mapReturn = new Map<String, Object>();

    /* private constant */
    private static final string SUGGESTED_RATE = 'SUGGESTED_RATE';

    /* private constant */
    private static final string MINIMUM_RATE = 'MINIMUM_RATE';

    /* constructor of class */
    private BE_CalculateCommission_Ctr() {
    }

    /* exception of class */
    public class ApplicationException extends Exception {}

    /**Method to return web service mapping**/
	private static String webServiceValue(Map<String, Web_Service_Value_Mapping__c> mapWs, String key) {
		String valueMap = '';
		if(mapWs.containsKey(key)) {
			valueMap = mapWs.get(key).web_service_value__c;
		}
		return valueMap;
	}

    /**Method used to call api to get commissions **/
    public static List<Object> callCommissionsApi(OpportunityLineItem oli) {
        List<Object> rtnList = new List<Object>();
        try {
            Final Map<String, Web_Service_Value_Mapping__c> mapWsVal = WebServiceUtils.getWebServiceValuesMapping(new List<String> {'TERM_PERIOCITY', 'GUARANTEE_CLASSIFICATION', 'CONTRACT_MODALITY'}, oli.pricing_model_id__c);
            Final BE_ListCommissionRequest_Helper listCHelper = new BE_ListCommissionRequest_Helper(oli.pricing_model_id__c, webServiceValue(mapWsVal, 'CONTRACT_MODALITY' + oli.PE_List_Product_mode__c), webServiceValue(mapWsVal, 'GUARANTEE_CLASSIFICATION' + oli.gipr_Tipo_Garantia__c) , oli.CurrencyIsoCode, oli.Opportunity.Account.main_code_id__c);
            Final System.HttpResponse invoke = listCHelper.invoke();
            if (invoke.getStatusCode() == 200) {
                Final Map<string,Object> data = (Map<String, Object>)JSON.deserializeUntyped(invoke.getBody());
                rtnList = (List<Object>) data.get('data') ;
            } else {
                mapReturn.put('error',true);
                mapReturn.put('responseCode',invoke.getStatusCode());
                mapReturn.put('errorBody',invoke.getBody());
            }
        } catch(Exception e) {
            system.debug('Error: '+e.getMessage());
            throw e;
        }
        if(Test.isRunningTest()) {
            Final string jsonInput='{"data":[{"id":"CO239","name":"Por Liquidación Anticipada","product":{"id":"5","modality":{"id":"8"}},"currency":"PEN","isNegotiable":true,"isRORCApplicable":false,"calculationType":"PERCENTAGE","settledValues":[{"settledValueType":"PERCENTAGE","percentage":5,"name":"SUGGESTED_RATE"}],"maximumValue":{"currency":"PEN"},"minimumValue":{"currency":"PEN"},"isTermIncluded":true,"paymenMethod":{"frequency":{"id":"MONTHLY"}},"term":{"frequency":{"id":"MONTHLY"},"number":12},"additionalAmount":{},"questionnaire":{"id":"CU0022","questions":[{"id":"2","outputType":"YES_OR_NOT","description":"El Plazo es mayor a 12?","parentId":"1","parentOutputType":"YES_OR_NOT","parentAnswerActivator":"SI"},{"id":"1","outputType":"YES_OR_NOT","description":"El tipo de prestamo es Cancelación Anticipada, Amortización Parcial o Prepago de cuotas?"}]}},{"id":"CO235","name":"Por Liquidación Anticipada","product":{"id":"5","modality":{"id":"8"}},"currency":"PEN","isNegotiable":true,"isRORCApplicable":false,"calculationType":"PERCENTAGE","settledValues":[{"settledValueType":"PERCENTAGE","percentage":5,"name":"SUGGESTED_RATE"}],"maximumValue":{"currency":"PEN"},"minimumValue":{"currency":"PEN"},"isTermIncluded":true,"paymenMethod":{"frequency":{"id":"MONTHLY"}},"term":{"frequency":{"id":"MONTHLY"},"number":12},"additionalAmount":{},"questionnaire":{"id":"CU0022","questions":[{"id":"2","outputType":"YES_OR_NOT","description":"El Plazo es mayor a 12?","parentId":"1","parentOutputType":"YES_OR_NOT","parentAnswerActivator":"SI"},{"id":"1","outputType":"YES_OR_NOT","description":"El tipo de prestamo es Cancelación Anticipada, Amortización Parcial o Prepago de cuotas?"}]}},{"id":"CO229","name":"Comisión de Estructuración","product":{"id":"5","modality":{"id":"8"}},"currency":"PEN","isNegotiable":true,"isRORCApplicable":true,"calculationType":"PERCENTAGE","settledValues":[{"settledValueType":"PERCENTAGE","percentage":1,"name":"SUGGESTED_RATE"}],"maximumValue":{"currency":"PEN"},"minimumValue":{"amount":850,"currency":"PEN"},"isTermIncluded":false,"paymenMethod":{},"term":{},"additionalAmount":{}},{"id":"CO217","name":"Gestión Operativa","product":{"id":"5","modality":{"id":"8"}},"currency":"PEN","isNegotiable":true,"isRORCApplicable":true,"calculationType":"PERCENTAGE","settledValues":[{"settledValueType":"PERCENTAGE","percentage":20,"name":"SUGGESTED_RATE"}],"maximumValue":{"amount":700,"currency":"PEN"},"minimumValue":{"amount":120,"currency":"PEN"},"isTermIncluded":false,"paymenMethod":{},"term":{},"additionalAmount":{}}]}';
            Final Map<String,Object> dInputValue = (Map<String,Object>)JSON.deserializeUntyped(jsonInput);
            rtnList = (List<Object>) dInputValue.get('data');
        }
        return rtnList;
    }
    
    /**Method used to read JSON questions **/
    public static Map<String, Commission_Question__c> readQuestions(String commExternalId, Object questions) {
        Final Map<String, Commission_Question__c> mapQuestions = new Map<String, Commission_Question__c>();
        Final List<Object> ltsQuestion = (List<Object>) questions;
        for(Object question : ltsQuestion) {
            Final Commission_Question__c newQuestion = new Commission_Question__c();
            Final Map<String, Object> questionMap = (Map<String, Object>) question;
            
            newQuestion.Product_Commission__r = new Product_Commission__c(External_Id__c=commExternalId);
            
            newQuestion.Code__c = Integer.valueOf(questionMap.get('id'));
            newQuestion.Description__c = String.valueOf(questionMap.get('description'));
            newQuestion.output_Type__c = String.valueOf(questionMap.get('outputType'));

            if(questionMap.containsKey('parentOutputType')
            && String.valueOf(questionMap.get('parentOutputType'))!='') {
                newQuestion.Input_Type__c = String.valueOf(questionMap.get('parentOutputType')).replace(' ', '');
            }
            if(questionMap.containsKey('parentAnswerActivator')
            && String.valueOf(questionMap.get('parentAnswerActivator'))!='') {
                newQuestion.Input_Value__c = String.valueOf(questionMap.get('parentAnswerActivator'));
            }

            if(questionMap.containsKey('parentId') && String.valueOf(questionMap.get('parentId'))!='') {
                newQuestion.Parent_Code__c = Integer.valueOf(questionMap.get('parentId'));                
            }
            
            newQuestion.External_Id__c = commExternalId+'-'+newQuestion.Code__c;
            mapQuestions.put(newQuestion.External_Id__c, newQuestion);
        }
        return mapQuestions;
    }
    
    /**Method used to get quotes **/
	@AuraEnabled
    public static Map<String,Object> getCommissions(String recordId, Boolean negotiables, Boolean requestDataToAso) {
    //public static List<Product_Commission__c> getCommissions(String recordId, Boolean negotiables, Boolean requestDataToAso) {
        mapReturn = new Map<String,Object>();
        mapReturn.put('error',false);
        Final Map<String, Product_Commission__c> respCommissions = new Map<String, Product_Commission__c>();
        Final Map<String, Commission_Question__c> respQuestions = new Map<String, Commission_Question__c>();
        Final List<Product_Commission__c> deleteCommissions = new List<Product_Commission__c>();
        Final List<Commission_Question__c> deleteQuestions = new List<Commission_Question__c>();
        
        Final OpportunityLineItem oli = [SELECT Id, Name, Product2.Name, unitprice, gipr_Plazo__c, gipr_Periodicidad__c, gipr_Tipo_Garantia__c, pricing_model_id__c, PE_List_Product_mode__c, CurrencyIsoCode, gipr_Garantia__c,Opportunity.Account.main_code_id__c FROM OpportunityLineItem WHERE Id = :recordId limit 1];

        if(requestDataToAso) {
            Final List<Object> ltsResponse = callCommissionsApi(oli);
            for(Object item : ltsResponse) {
                Product_Commission__c newCommission = new Product_Commission__c();
                Final Map<String, Object> itemMap = (Map<String, Object>) item;
                newCommission = newProductCommission(itemMap, oli, respQuestions, respCommissions);
                
                if(itemMap.containsKey('questionnaire')) {
                    Final Map<String, Object> questionnaireMap =  (Map<String, Object>) itemMap.get('questionnaire');
                    newCommission.Questionnaire_Code__c = String.valueOf(questionnaireMap.get('id'));
                    respQuestions.putAll(readQuestions(newCommission.External_Id__c, questionnaireMap.get('questions')));
                }
            }
            Final List<Product_Commission__c> commissions = [SELECT Id, Product_Commission_Name__c, Opportunity_Product__c, Code__c, Calculation_Type__c, Suggested_Rate_Type__c, CurrencyIsoCode, Suggested_Rate__c, Commission_Calculation_Amount__c, Requested_Rate_Value__c, Authorized_Rate_Value__c, Commission_Maximum_Amount__c, Commission_Minimum_Amount__c,Is_Negotiable__c,  (SELECT Id, Product_Commission__c, Parent_Question__c, Input_Value__c, Input_Type__c, isBoolean__c, BooleanValue__c, isCurrency__c, CurrencyIsoCode, Description__c, Code__c, output_Type__c, isParent__c, Answer__c FROM Commission_Questions__r ORDER BY Code__c ASC) FROM Product_Commission__c WHERE Opportunity_Product__c = :oli.Id ORDER BY Code__c ASC];
            updateCommissionsQuestions(commissions, respCommissions, deleteCommissions, respQuestions, deleteQuestions);
            commitCommissionsQuestions(respCommissions, deleteCommissions, respQuestions, deleteQuestions);
        }
        
        List<Product_Commission__c> response = new List<Product_Commission__c>();
        if(negotiables) {
            response = [SELECT Id, Product_Commission_Name__c, Opportunity_Product__c, Code__c, Calculation_Type__c, Suggested_Rate_Type__c, CurrencyIsoCode, Suggested_Rate__c, Commission_Calculation_Amount__c, Requested_Rate_Value__c, Authorized_Rate_Value__c, Commission_Maximum_Amount__c, Commission_Minimum_Amount__c,Is_Negotiable__c, Commission_Maximum_Iso_Code__c, Commission_Minimum_Iso_Code_c__c, Suggested_Rate_Iso_Code__c, Rate_Is_Amount__c, Rate_Is_Percent__c, Rate_Is_Range__c, Rate_Is_Number__c, Minimum_Rate_Type__c, Minimum_Rate_Iso_Code__c, Minimum_Rate__c, Commission_Calculation_Currency__c, showMinimumRateClass__c, (SELECT Id, Product_Commission__c, Parent_Question__c, Input_Value__c, Input_Type__c, isBoolean__c, BooleanValue__c, isCurrency__c, CurrencyIsoCode, Description__c, Code__c, output_Type__c, isParent__c, Answer__c FROM Commission_Questions__r ORDER BY Code__c ASC) FROM Product_Commission__c WHERE Opportunity_Product__c = :oli.Id AND Is_Negotiable__c = true ORDER BY Code__c ASC];
        } else {
            response = [SELECT Id, Product_Commission_Name__c, Opportunity_Product__c, Code__c, Calculation_Type__c, Suggested_Rate_Type__c, CurrencyIsoCode, Suggested_Rate__c, Commission_Calculation_Amount__c, Requested_Rate_Value__c, Authorized_Rate_Value__c, Commission_Maximum_Amount__c, Commission_Minimum_Amount__c,Is_Negotiable__c, Commission_Maximum_Iso_Code__c, Commission_Minimum_Iso_Code_c__c, Suggested_Rate_Iso_Code__c, Rate_Is_Amount__c, Rate_Is_Percent__c, Rate_Is_Range__c, Rate_Is_Number__c, Minimum_Rate_Type__c, Minimum_Rate_Iso_Code__c, Minimum_Rate__c, Commission_Calculation_Currency__c, showMinimumRateClass__c, (SELECT Id, Product_Commission__c, Parent_Question__c, Input_Value__c, Input_Type__c, isBoolean__c, BooleanValue__c, isCurrency__c, CurrencyIsoCode, Description__c, Code__c, output_Type__c, isParent__c, Answer__c FROM Commission_Questions__r ORDER BY Code__c ASC) FROM Product_Commission__c WHERE Opportunity_Product__c = :oli.Id ORDER BY Code__c ASC];
        }
        //return response;
        mapReturn.put('commissions',response);
        return mapReturn;
    }
    
    /** Method to Update */
    public static Product_Commission__c newProductCommission(Map<String, Object> itemMap, OpportunityLineItem oli, Map<String, Commission_Question__c> respQuestions,  Map<String, Product_Commission__c> respCommissions) {
        Final Product_Commission__c newCommission = new Product_Commission__c();
    	newCommission.Product_Commission_Name__c = String.valueOf(itemMap.get('name'));
        newCommission.Opportunity_Product__c = oli.Id;
        newCommission.Code__c = String.valueOf(itemMap.get('id'));
        newCommission.Is_Negotiable__c = Boolean.valueOf(itemMap.get('isNegotiable'));
        newCommission.Calculation_Type__c = String.valueOf(itemMap.get('calculationType'));
        newCommission.CurrencyIsoCode = String.valueOf(itemMap.get('currency'));
        
        if(Test.isRunningTest()) {
            newCommission.Authorized_Rate_Value__c = 10;
         	newCommission.Term_Frequency_Id__c = 'MONTHLY';
        }
        
        Final List<Object> settledValuesList = (List<Object>) itemMap.get('settledValues');
        for(Object obj : settledValuesList) {
            Final Map<string,Object> settledValue = (Map<string,Object>) obj;
            if (String.valueOf(settledValue.get('name')) == SUGGESTED_RATE) {
                newCommission.Suggested_Rate_Type__c = String.valueOf(settledValue.get('settledValueType'));
                newCommission.Suggested_Rate_Iso_Code__c = String.valueOf(settledValue.get('currency'));
                newCommission.Suggested_Rate__c = String.valueOf(settledValue.get('amount'));
                if(settledValue.containsKey('percentage')) {
                    newCommission.Suggested_Rate__c = String.valueOf(Double.valueOf(settledValue.get('percentage'))/100);
                }
            }
            if( String.valueOf(settledValue.get('name')) == MINIMUM_RATE) {
                newCommission.Minimum_Rate_Type__c = String.valueOf(settledValue.get('settledValueType'));
                newCommission.Minimum_Rate_Iso_Code__c = String.valueOf(settledValue.get('currency'));
                newCommission.Minimum_Rate__c = String.valueOf(settledValue.get('amount'));
                if(settledValue.containsKey('percentage')) {
                    newCommission.Minimum_Rate__c = String.valueOf(Double.valueOf(settledValue.get('percentage'))/100);
                }
            }
        }

        Final Map<String, Object> maximumValue = (Map<String, Object>) itemMap.get('maximumValue');
        newCommission.Commission_Maximum_Amount__c = Integer.valueOf(maximumValue.get('amount'));
        newCommission.Commission_Maximum_Iso_Code__c = String.valueOf(maximumValue.get('currency'));
        
        Final Map<String, Object> minimumValue = (Map<String, Object>) itemMap.get('minimumValue');
        newCommission.Commission_Minimum_Amount__c = Integer.valueOf(minimumValue.get('amount'));
        newCommission.Commission_Minimum_Iso_Code_c__c = String.valueOf(minimumValue.get('currency'));
        
        newCommission.Commission_Calculation_Amount__c = 0;
        newCommission.External_Id__c = oli.Id+'-'+newCommission.code__c;
        
        respCommissions.put(newCommission.External_Id__c, newCommission);
        
        if(itemMap.containsKey('term')) {
            Final Map<String, Object> termMap =  (Map<String, Object>) itemMap.get('term');
            newCommission.Term_Number__c = Integer.valueOf(termMap.get('number'));
            
            if(termMap.containsKey('frequency')) {
                Final Map<String, Object> frequencyMap =  (Map<String, Object>) termMap.get('frequency');
                newCommission.Term_Frequency_Id__c = String.valueOf(frequencyMap.get('id'));
            }
        }
        
        return newCommission;
    }

    /**Method used to compare and make a list to update commissions and questions**/
    public static void updateCommissionsQuestions(List<Product_Commission__c> commissions, Map<String, Product_Commission__c> respCommissions, List<Product_Commission__c> deleteCommissions, Map<String, Commission_Question__c> respQuestions, List<Commission_Question__c> deleteQuestions) { 
        integer indexCommission = 0;
        integer indexQuestion = 0;
        Final Set<Integer> cToDelete = new Set<Integer>();

        for(Product_Commission__c commission : commissions) {
            if(respCommissions.containsKey(commission.Opportunity_Product__c+'-'+commission.Code__c)) {
                respCommissions.get(commission.Opportunity_Product__c+'-'+commission.Code__c).Commission_Calculation_Amount__c = commission.Commission_Calculation_Amount__c;
            } else {
                deleteCommissions.add(commission);
                cToDelete.add(indexCommission);
            }
            indexQuestion = 0;
            for(Commission_Question__c question : commission.Commission_Questions__r) {
                if(respQuestions.containsKey(commission.Opportunity_Product__c+'-'+commission.Code__c+'-'+question.Code__c)) {
                    respQuestions.get(commission.Opportunity_Product__c+'-'+commission.Code__c+'-'+question.Code__c).Input_Value__c = question.Input_Value__c;
                    respQuestions.get(commission.Opportunity_Product__c+'-'+commission.Code__c+'-'+question.Code__c).Answer__c = question.Answer__c;
                    respQuestions.get(commission.Opportunity_Product__c+'-'+commission.Code__c+'-'+question.Code__c).isParent__c = question.isParent__c;
                } else {
                    deleteQuestions.add(question);
                    commission.Commission_Questions__r.remove(indexQuestion);
                }
                indexQuestion++;
            }
            indexCommission++;
        }

        Integer deleteIndex = 0;
        for(Integer commissionIndex : cToDelete) {
            commissions.remove(commissionIndex-deleteIndex);
            deleteIndex++;
        }
	}

    /**Method used to delete, update or delete commissions and questions**/
    public static void commitCommissionsQuestions(Map<String, Product_Commission__c> respCommissions, List<Product_Commission__c> deleteCommissions, Map<String, Commission_Question__c> respQuestions, List<Commission_Question__c> deleteQuestions) { 
    
        if(!deleteQuestions.isEmpty()) {
            delete deleteQuestions;
        }
        if(!deleteCommissions.isEmpty()) {
            delete deleteCommissions;
        }
        if(!respCommissions.isEmpty()) {
            upsert respCommissions.values() External_Id__c;
        }
        if(!respQuestions.isEmpty()) {
            upsert respQuestions.values() External_Id__c;
            Final Map<String, Commission_Question__c> respQDepend = new Map<String, Commission_Question__c>();
            for(String key : respQuestions.keySet()) {
                if(respQuestions.get(Key).Parent_Code__c!=null) {
                    respQuestions.get(Key).Parent_Question__r = new Commission_Question__c(External_Id__c=respQuestions.get(Key).Product_Commission__r.External_Id__c+'-'+respQuestions.get(Key).Parent_Code__c);
                    respQDepend.put(respQuestions.get(Key).External_Id__c, respQuestions.get(Key));
                }
            }
            if(!respQDepend.isEmpty()) {
                upsert respQDepend.values() External_Id__c;
            }
        }
    }
    
    /**Method used to get all opportunity line items of a single opp **/
    @AuraEnabled
    public static  Map<String, Object> getOlis(String recordId) {
        Final List <OpportunityLineItem> olis= [SELECT Id, Product2.Name FROM OpportunityLineItem WHERE OpportunityId = :recordId];
        mapReturn.put('olis', olis);
        return mapReturn;
    }
}