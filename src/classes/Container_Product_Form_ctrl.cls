global with sharing class Container_Product_Form_ctrl implements dwp_dbpn.DynamicButtonsStatusInterface{
	@AuraEnabled
    global static Map<String,Object> getActions(String recordId) {
        Set<String> actionsSet = getDynamicButtonStatus(recordId, 'Opportunity');
        Map<String, Object> retValues = new Map<String,Object>();
        retValues.put('key',actionsSet.contains('editProduct'));
        retValues.put('key2',actionsSet.contains('addProduct'));
        retValues.put('key3',actionsSet.contains('deleteProduct'));
        Map<String,Object> mapValidateCotizaWeb = validateCotizaWeb(recordId);
        retValues.put('dataCW',mapValidateCotizaWeb);
        return retValues;
    }

    global static Set<String> getDynamicButtonStatus(String recordId, String sObjectName){
        Set<String> buttonsStatusSet = new Set<String>();
        
        // Compose the list of opportunities Ids
        List<Id> lstIds = new List<Id>();
        lstIds.add(recordId);
        
        Map<String,Set<String>> actionsPerOppIdMap = dwp_dace.DynamicActionsEngine_helper.getAvailableActions(lstIds,sObjectName,'PRODUCT_FORM_RULE_SET_02');


        buttonsStatusSet.addAll(actionsPerOppIdMap.get(recordId));
        return buttonsStatusSet;
    }

    public static Map<String,Object> validateCotizaWeb(String recordId){
        Map<String,Object> mapReturn = new Map<String,Object>();
        List<OpportunityLineItem> lstOppLineItem = [SELECT   Id,
                                                price_quote_availability_check__c,
                                                Product2.Type_of_quote__c, 
                                                price_availability_check_error__c,
                                                OpportunityId,
                                                price_quote_available__c,
                                                Opportunity.Branch_id__r.branch_id__c
                                        FROM OpportunityLineItem
                                        WHERE OpportunityId = :recordId];
        List<User> lstUser = [SELECT    Id,
                                        Profile.Name,
                                        (SELECT     Id, 
                                                    branch_id__c
                                        FROM Users_Branches__r)
                                FROM User
                                WHERE Id = :UserInfo.getUserId()];
        
        Boolean showWarning = (!lstOppLineItem.isEmpty()?!lstOppLineItem[0].price_quote_available__c:false);

        if(!lstOppLineItem.isEmpty() && lstOppLineItem[0].price_quote_availability_check__c==false && lstOppLineItem[0].Product2.Type_of_quote__c == 'Web' && (lstUser[0].Profile.Name == 'Ejecutivo' || lstUser[0].Profile.Name == 'System Administrator') ){
            Boolean flagLoopUser = true;
            //Boolean hasBranch = false;
            Boolean hasBranch = (lstUser[0].Profile.Name == 'System Administrator');
            for(Integer i = 0; i<lstUser[0].Users_Branches__r.size() && flagLoopUser; i++){
                if(lstUser[0].Users_Branches__r[i].branch_id__c == lstOppLineItem[0].Opportunity.Branch_id__r.branch_id__c){
                    flagLoopUser = false;
                    hasBranch = true;
                }
            }
            if(hasBranch){
                try{
                    ProductsQuoteAvailability_helper prodQuoteAva = new ProductsQuoteAvailability_helper(lstOppLineItem[0].OpportunityId);
                    System.HttpResponse responseProdQ = prodQuoteAva.invoke();
                    switch on responseProdQ.getStatusCode(){
                        when 200{
                            ProductsQuoteAvailability_helper.ResponseProductsQuoteAvailability_Wrapper responseWrapper = ProductsQuoteAvailability_helper.parse(responseProdQ.getBody());
                            List<ProductsQuoteAvailability_helper.Response_data> lstResponseData = responseWrapper.data;
                            Boolean flagLoop = true;
                            String strPriceModel = '';
                            for(Integer i=0; i<lstResponseData.size() && flagLoop; i++){
                                if(lstResponseData[i].id=='11'){
                                    flagLoop = false;
                                    ProductsQuoteAvailability_helper.Response_pricing pricingModel = lstResponseData[i].pricing;
                                    strPriceModel = pricingModel.id;
                                }
                            }
                            lstOppLineItem[0].price_quote_availability_check__c = true;
                            lstOppLineItem[0].pricing_model_id__c = strPriceModel;
                            lstOppLineItem[0].price_availability_check_error__c = '';
                            showWarning=false;
                        }
                        when 500{
                            WebServiceUtils.ResponseErrorMessage_Wrapper errorW = WebServiceUtils.parse(responseProdQ.getBody());
                            lstOppLineItem[0].price_quote_availability_check__c = false;
                            lstOppLineItem[0].price_availability_check_error__c = errorW.errormessage;
                            showWarning=true;
                        }
                        when else{
                            WebServiceUtils.ResponseErrorMessage_Wrapper errorW = WebServiceUtils.parse(responseProdQ.getBody());
                            lstOppLineItem[0].price_quote_availability_check__c = true;
                            lstOppLineItem[0].price_availability_check_error__c = errorW.errormessage;
                            showWarning=true;
                        }
                    }
                    update lstOppLineItem;
                }catch(Exception e){
                    System.debug(e);
                }
            }
            
        }
        mapReturn.put('showWarning', (!lstOppLineItem.isEmpty() && lstOppLineItem[0].Product2.Type_of_quote__c == 'Web'?showWarning:false));
        return mapReturn;
    }
    
}