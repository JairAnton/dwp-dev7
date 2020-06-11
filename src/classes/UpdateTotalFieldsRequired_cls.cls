/**
 * Handler of Trigger of the AccountContactRelation object.
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Martin Mori               09/10/2019          Original version.<p />
 *
 * @author Martin Mori
 */
public without sharing class UpdateTotalFieldsRequired_cls {
	/**
	 * Method for update Total_campos_obligatorios_llenos__c field of Account to AccountContactRelation.
	 *
	 * @param lstAccContRel Account Contact Relation List.
	 */
	public static void updateTotalRequiredFields(List<AccountContactRelation> lstAccContRel) {
		final Set<Id> ids = new Set<Id>();
		for(AccountContactRelation acr : lstAccContRel) {
			ids.add(acr.AccountId);
		}
		if(!ids.isEmpty()) {
			Map<Id, Account> accMaps = new Map<Id, Account>();
			for(AccountContactRelation acr : [SELECT Id, AccountId, Total_campos_obligatorios__c FROM AccountContactRelation WHERE AccountId IN : ids]) {
				if(accMaps.containsKey(acr.AccountId)) {
					if(accMaps.get(acr.AccountId).Total_campos_obligatorios_llenos__c < acr.Total_campos_obligatorios__c) {
						accMaps.put(acr.AccountId, new Account(Id = acr.AccountId, Total_campos_obligatorios_llenos__c = acr.Total_campos_obligatorios__c));
					}
				} else {
					accMaps.put(acr.AccountId, new Account(Id = acr.AccountId, Total_campos_obligatorios_llenos__c = acr.Total_campos_obligatorios__c));
				}
			}
			for(Id idAux : ids) {
				if(!accMaps.containsKey(idAux)) {
					accMaps.put(idAux, new Account(Id = idAux, Total_campos_obligatorios_llenos__c = null));
				}
			}
			if(!accMaps.isEmpty()) {
				update accMaps.values();
			}
		}
	}
}
