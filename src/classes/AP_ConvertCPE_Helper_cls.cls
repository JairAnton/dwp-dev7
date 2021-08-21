/** @Name AP_ConvertCPE_Helper_cls
* @Author Jair Anton jair.anton.contractor@bbva.com
* @Date Created: 2021-08-19
* Jair Anton 		19/08/2021		Helper clase AP_ConvertCPE_cls
*/
public with sharing class AP_ConvertCPE_Helper_cls {
    /** @Description  NAME*/
    private static Final String NAME = 'Name';
    /** @Description  NAME*/
    private static Final String RT_ECO_GRP = 'Record_Type_Economic_Group';

    private AP_ConvertCPE_Helper_cls() {}

    /** Modify actions commercial created */
    public static void verifyCPEModified(Map<Id, acpl__Commercial_Plan_Event__c> mapCPE, Map<Id, acpl__Commercial_Plan_Event__c> mapCPEAux, Map<Id, User> mapUser, Map<Id, Id> mapCPEPartner) {
		Final Set<Id> cpeModifiedSet = new Set<Id>();
		Final List<acpl__Commercial_Plan_Event__c> cpeList = [SELECT Id, acpl__gf_account_planning_id__r.acpl__gf_ap_validation_date__c, LastModifiedDate, CreatedDate 
																FROM acpl__Commercial_Plan_Event__c WHERE Id IN : mapCPE.keySet()];

        for(acpl__Commercial_Plan_Event__c item : cpeList) {
			if(Date.valueOf(item.LastModifieddate) >= item.acpl__gf_account_planning_id__r.acpl__gf_ap_validation_date__c) {
				cpeModifiedSet.add(item.Id);
			}
		}

		if(!cpeModifiedSet.isEmpty()) {
			Final Map<String, PriceBookEntry> mapPBE = new Map<String, PriceBookEntry>();
			for(PriceBookEntry pbe: [SELECT Id, Product2.Name, Product2.Family, Product2.Unique_id__c, CurrencyIsoCode FROM PriceBookEntry WHERE IsActive = TRUE AND Product2.isActive = TRUE]) {
				mapPBE.put(pbe.Product2.Unique_id__c + '_' + PBE.CurrencyIsoCode, pbe);
			}

            validateCPE(cpeModifiedSet, mapCPE, mapCPEAux, mapPBE, mapUser, mapCPEPartner);
		}	

	}

    private static void validateCPE(Set<Id> cpeModifiedSet, Map<Id, acpl__Commercial_Plan_Event__c> mapCPE, Map<Id, acpl__Commercial_Plan_Event__c> mapCPEAux, Map<String, PriceBookEntry> mapPBE, Map<Id, User> mapUser, Map<Id, Id> mapCPEPartner) {        
        Final Map<Id, Opportunity> oppToUpdateMap = new Map<Id, Opportunity>([SELECT  Id, StageName, commercial_plan_event__c, name, Description, currencyIsoCode, Amount, opportunity_planning_date__c, opportunity_product__c, 
                                                                                    opportunity_product_family__c FROM Opportunity WHERE commercial_plan_event__c IN: cpeModifiedSet AND StageName IN ('01', '02', '03')]);
        
        Final Map<Id, Opportunity> resultOppToUpdate = mapOpportunity(oppToUpdateMap);
        Final Map<Id, OpportunityLineItem> oppLineItemMap = new Map<Id, OpportunityLineItem>([SELECT Id, OpportunityId, Quantity, UnitPrice, PricebookEntryId  FROM OpportunityLineItem WHERE OpportunityId IN : oppToUpdateMap.keySet()]);
        Final Map<Id, OpportunityLineItem> resultOppLineItem = mapOpportunityLineItem(oppLineItemMap);

        Final List<OpportunityLineItem> oliToInsert = new List<OpportunityLineItem>();
        Final List<OpportunityLineItem> oliToDelete = new List<OpportunityLineItem>();
        Final List<OpportunityLineItem> oliToUpdate = new List<OpportunityLineItem>();
        Final List<Opportunity> oppToUpdate = new List<Opportunity>();
        Final List<OpportunityTeamMember> otmToInsert = new List<OpportunityTeamMember>();
        Final Map<Id, Id> visitTeamMap = new Map<Id, Id>();

        for(acpl__Commercial_Plan_Event__c item : mapCPE.values()) {
            if(cpeModifiedSet.contains(item.Id) && resultOppToUpdate.containsKey(item.Id)) {
                Opportunity oppItem = resultOppToUpdate.get(item.Id);
                
                validateGD(item, mapCPEAux, oppItem, mapPBE, resultOppLineItem, oliToInsert, oliToDelete, oliToUpdate, oppToUpdate);
                validateCreateATM(oppItem, item, otmToInsert, visitTeamMap, mapUser, mapCPEPartner);
            }
        }
        validateAction(oliToInsert, oliToDelete, oliToUpdate, oppToUpdate);

        if(!otmToInsert.isEmpty()) {
            insert otmToInsert;
        }
    }

    private static void validateCreateATM(Opportunity oppItem, acpl__Commercial_Plan_Event__c item, List<OpportunityTeamMember> otmToInsert, Map<Id, Id> visitTeamMap, Map<Id, User> mapUser, Map<Id, Id> mapCPEPartner) {
        if(mapCPEPartner.containsKey(item.Id)) {
            Id itemId = mapCPEPartner.get(item.Id);
            if(mapUser.containsKey(itemId)) {   
                otmToInsert.add(new OpportunityTeamMember(UserId = item.Asiggned_User__c, OpportunityId = oppItem.Id));
                visitTeamMap.put(item.Id, item.Asiggned_User__c);
            }
        }
    }

    private static void validateAction(List<OpportunityLineItem> oliToInsert, List<OpportunityLineItem> oliToDelete, List<OpportunityLineItem> oliToUpdate, List<Opportunity> oppToUpdate) {
        if(!oliToDelete.isEmpty()) {
            delete oliToDelete;
        }

        if(!oppToUpdate.isEmpty()) {
            update oppToUpdate;
        }

        if(!oliToInsert.isEmpty()) {
            insert oliToInsert;
        }

        if(!oliToUpdate.isEmpty()) {
            update oliToUpdate;
        }
    }

    private static void validateGD(acpl__Commercial_Plan_Event__c item, Map<Id, acpl__Commercial_Plan_Event__c> mapCPEAux, Opportunity oppItem, Map<String, PriceBookEntry> mapPBE, Map<Id, OpportunityLineItem> resultOppLineItem,
                                        List<OpportunityLineItem> oliToInsert, List<OpportunityLineItem> oliToDelete, List<OpportunityLineItem> oliToUpdate, List<Opportunity> oppToUpdate) {
        if(mapCPEAux.containsKey(item.Id)) {
            Final acpl__Commercial_Plan_Event__c cpeAuxItem = mapCPEAux.get(item.Id);
            Final OpportunityLineItem oppLineItem = resultOppLineItem.get(oppItem.Id);

            oppItem.CloseDate = item.acpl__gf_event_date__c; 
            oppItem.Description = item.Comments__c;

            oppItem.Amount = mapCPEAux.get(item.Id).GrowthDriver__r.Amount__c;

            validateProduct(mapPBE, cpeAuxItem, oppLineItem, oppItem, oliToInsert, oliToDelete, oliToUpdate, item, mapCPEAux);     
        } else {
            oppItem.CloseDate = item.acpl__gf_event_date__c; 
            oppItem.Description = item.Comments__c;
        }

        oppToUpdate.add(oppItem);   
    }

    private static void validateProduct(Map<String, PriceBookEntry> mapPBE, acpl__Commercial_Plan_Event__c cpeAuxItem, OpportunityLineItem oppLineItem, Opportunity oppItem, List<OpportunityLineItem> oliToInsert, 
                                            List<OpportunityLineItem> oliToDelete, List<OpportunityLineItem> oliToUpdate, acpl__Commercial_Plan_Event__c item, Map<Id, acpl__Commercial_Plan_Event__c> mapCPEAux) {
        if(mapPBE.containsKey(cpeAuxItem.GrowthDriver__r.bupl__solution_category_desc__c + '_' + cpeAuxItem.GrowthDriver__r.CurrencyIsoCode)) {
            if(mapPBE.get(cpeAuxItem.GrowthDriver__r.bupl__solution_category_desc__c + '_' + cpeAuxItem.GrowthDriver__r.CurrencyIsoCode).Id == oppLineItem.PricebookEntryId) {
                oppLineItem.UnitPrice = oppItem.Amount;
                oliToUpdate.add(oppLineItem);
            } else {
                Final PriceBookEntry pbeItem = mapPBE.get(cpeAuxItem.GrowthDriver__r.bupl__solution_category_desc__c + '_' + cpeAuxItem.GrowthDriver__r.CurrencyIsoCode);
                oliToDelete.add(oppLineItem);
                oliToInsert.add(new OpportunityLineItem(OpportunityId = oppItem.Id, Quantity = 1, UnitPrice = oppItem.Amount, PricebookEntryId = pbeItem.Id));

                oppItem.CurrencyIsoCode = mapCPEAux.get(item.Id).GrowthDriver__r.CurrencyIsoCode;
                oppItem.opportunity_product__c = pbeItem.Product2.Name;
                oppItem.opportunity_product_family__c = pbeItem.Product2.Family;
            }	
        }    
    }
    
	private static Map<Id, Opportunity> mapOpportunity(Map<Id, Opportunity> objectMap) {
		Final Map<Id, Opportunity> resultMap = new Map<Id, Opportunity>();
		
		for(Opportunity item : objectMap.values()) {
			resultMap.put(item.commercial_plan_event__c, item);
		}

		return resultMap;
	}

	private static Map<Id, OpportunityLineItem> mapOpportunityLineItem(Map<Id, OpportunityLineItem> objectMap) {
		Final Map<Id, OpportunityLineItem> resultMap = new Map<Id, OpportunityLineItem>();
		
		for(OpportunityLineItem item : objectMap.values()) {
			resultMap.put(item.OpportunityId, item);
		}
		
		return resultMap;
	}
    
	/*
	 * @Description  getMapClientAssigned
	 */
	public static Map<String, String> getMapClientAssigned(acpl__Commercial_Plan_Event__c cpe) {
		Final Map<String, String> mapClient = new Map<String, String>();
		if(cpe.acpl__gf_account_planning_id__r.acpl__participant_id__r.RecordType.DeveloperName == RT_ECO_GRP) {
			mapClient.put(NAME, cpe.ClientAssigned__r.Name);
			mapClient.put('Id', cpe.ClientAssigned__c);
		} else {
			mapClient.put(NAME, cpe.acpl__gf_account_planning_id__r.acpl__participant_id__r.Name);
			mapClient.put('Id', cpe.acpl__gf_account_planning_id__r.acpl__participant_id__c);
		}
		return mapClient;
	}
}