/**statusButtonClass
 *  object.
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Julio Medellin               18/05/2018          Original version.<p />
 * -------------------------------------------------------------------
 * GlobalHub					   16/07/2018          Modified Version
 *
 * @author Julio Medellin
 */
Global class statusButtonClass implements dwp_dbpn.DynamicButtonsStatusInterface {
	Global Set<String> getDynamicButtonStatus(String recordId, String sObjectName) {
		Set<String> buttonsStatusSet = new Set<String>();

		// Compose the list of opportunities Ids
		List<Id> lstIds = new List<Id>();
		lstIds.add(recordId);

		Map<String, Set<String>> actionsPerOppIdMap = dwp_dace.DynamicActionsEngine_helper.getAvailableActions(lstIds, sObjectName, 'BUTTON_COLLECTION_RULE_SET_01');

		buttonsStatusSet.addAll(actionsPerOppIdMap.get(recordId));
		return buttonsStatusSet;
	}
}
