global with sharing class Container_Product_Form_ctrl implements dwp_dbpn.DynamicButtonsStatusInterface{
	@AuraEnabled
    global static Map<String,Boolean> getActions(String recordId) {
        Set<String> actionsSet = getDynamicButtonStatus(recordId, 'Opportunity');
        Map<String, Boolean> retValues = new Map<String,Boolean>();
        retValues.put('key',actionsSet.contains('editProduct'));
        retValues.put('key2',actionsSet.contains('addProduct'));
        retValues.put('key3',actionsSet.contains('deleteProduct'));
        return retValues;
    }
    
    Global static Set<String> getDynamicButtonStatus(String recordId, String sObjectName)
    {
        Set<String> buttonsStatusSet = new Set<String>();
        
        // Compose the list of opportunities Ids
        List<Id> lstIds = new List<Id>();
        lstIds.add(recordId);
        
        Map<String,Set<String>> actionsPerOppIdMap = dwp_dace.DynamicActionsEngine_helper.getAvailableActions(lstIds,sObjectName,'PRODUCT_FORM_RULE_SET_02');


        buttonsStatusSet.addAll(actionsPerOppIdMap.get(recordId));
        return buttonsStatusSet;
    }
}