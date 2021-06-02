/**
   -------------------------------------------------------------------------------------------------
   @Name <OpportunityLineItemHelper_Trigger_cls>
   @Author Jair Anton Atuncar (jair.anton.contractor@bbva.com)
   @Date 2021-06-01
   @Description Class Helper for Trigger for OpportunityLineItem(OLI)
   @Changes
   Date        Author   Email                  				Type		Description	
   2021-06-01  JOAA     jair.anton.contractor@bbva.com    	Creation	Validación de productos para 
																		carga de oportunidades de tipo cancelación
	Extensión de la clase (OpportunityLineItem_Trigger_cls), debido a que el sonar admite solo 10 métodos. 
   -------------------------------------------------------------------------------------------------
 */

public without sharing class OpportunityLineItemHelper_Trigger_cls {
	
    public void validateOppCancellation(List<OpportunityLineItem> newList) {
        Final Map<Id, Id> prdBookSet = new Map<Id, Id>();
        Final Map<String, Id> prodNewMap = new Map<String, Id>();
        Final Map<String, Map<Id, Id>> pbookNewMap = new Map<String, Map<Id, Id>>();
        Final Map<Id, Id> pBookReplaceMap = new Map<Id, Id>();
        Final Map<Id, Id> prodReplaceMap = new Map<Id, Id>();
        
        Final Set<Id> oppSet = new Set<Id>();
        
        for(OpportunityLineItem oli : newList) {
            oppSet.add(oli.OpportunityId);
            prdBookSet.put(oli.Product2Id, oli.PricebookEntryId);
        }
        
        /* Obtiene las oportunidades de tipo cancelación */
        Final Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>([SELECT Id, Name, Type FROM Opportunity WHERE Id IN : oppSet AND Type = '02']);
        /* Obtiene el pricebook y productos de tipo 'web' */ 
        Final List<PricebookEntry> genList = [SELECT Id, Product2Id, Product2.Unique_Id__c, CurrencyIsoCode FROM PricebookEntry WHERE Product2.Type_of_quote__c = 'Web'];
        
        /* Mapea los uniqueId de los productos con sus ID y filtra por tipo de moneda los pricebooks para obtener un map de productos con el id de los pricebook */
        for(PricebookEntry item : genList) {
            prodNewMap.put(item.Product2.Unique_Id__c.replace('_NEW', ''), item.Product2Id);
            Map<Id, Id> itemMap = new Map<Id, Id>();
            
            if(pbookNewMap.containsKey(item.CurrencyIsoCode)) {
                itemMap = pbookNewMap.get(item.CurrencyIsoCode);
                itemMap.put(item.Product2Id, item.Id);
            } else {
                itemMap.put(item.Product2Id, item.Id);
            }
            
            pbookNewMap.put(item.CurrencyIsoCode, itemMap);
        }
        
        Final List<PricebookEntry> pBookList = [SELECT Id, Product2Id, Product2.Unique_Id__c, CurrencyIsoCode FROM PricebookEntry WHERE Product2Id IN : prdBookSet.keySet() AND Id IN : prdBookSet.values()];
               	
        for(PricebookEntry pBook : pBookList) {
            if(prodNewMap.containsKey(pBook.Product2.Unique_Id__c)){
                Id productNewId = prodNewMap.get(pBook.Product2.Unique_Id__c);
                Map<Id, Id> currencyMap = pbookNewMap.get(pBook.CurrencyIsoCode);
                Id priceBookNewId = currencyMap.get(productNewId);
                
                prodReplaceMap.put(pBook.Product2Id, productNewId);
                pBookReplaceMap.put(pBook.Id, priceBookNewId);   
            }
        }
        
        
        for(OpportunityLineItem oli : newList) {
            if(oppMap.containsKey(oli.OpportunityId)){
                if(prodReplaceMap.containsKey(oli.Product2Id) && pBookReplaceMap.containsKey(oli.PricebookEntryId)) {
                    oli.Product2Id = prodReplaceMap.get(oli.Product2Id);
                    oli.PricebookEntryId = pBookReplaceMap.get(oli.PricebookEntryId);
                }
            }
        }
    }
}