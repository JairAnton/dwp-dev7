Global class caseStatusButtonClass implements dwp_dbpn.DynamicButtonsStatusInterface {
    Global Set<String> getDynamicButtonStatus(String recordId, String sObjectName)
    {
        Set<String> buttonsStatusSet = new Set<String>();
        
        // Compose the list of opportunities Ids
        List<Id> lstIds = new List<Id>();
        lstIds.add(recordId);
        
        Map<String,Set<String>> actionsPerOppIdMap = dwp_dace.DynamicActionsEngine_helper.getAvailableActions(lstIds,sObjectName,'CASE_BUTTON_COLLECTION_RULE_SET_01');


        buttonsStatusSet.addAll(actionsPerOppIdMap.get(recordId));
        return buttonsStatusSet;
    }
}