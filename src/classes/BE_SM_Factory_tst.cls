@isTest
public with sharing class BE_SM_Factory_tst {
    
    public static Id getEjecutivoProfile() {
        return [SELECT Id FROM Profile WHERE Name = 'Ejecutivo' LIMIT 1].Id;
    }
    
    public static slmt__Sales_Meeting__c createSalesMeeting(DateTime smDT, Id colaboratorId, String smType, Boolean doInsert) {
        Final slmt__Sales_Meeting__c smRecord = new slmt__Sales_Meeting__c(DateTime__c = smDT, Collaborator__c = colaboratorId, 
                                                                           Name = 'SM Test '+Math.random(), Type_of_meeting__c = smType);
        if(doInsert) {insert smRecord;}
        return smRecord;
    }
    
    /** @Description  createProduct*/
	public static Product2 createProduct(String code) {
		Final Product2 prod = new Product2(Name = 'Product Test', Family = 'Test', ProductCode = code, Unique_id__c = code);
		insert prod;
		return prod;
	}
    
    /** @Description  createProduct*/
	public static PricebookEntry createPriceBookEntry(Id pricebookId, Id productId, Decimal unitPrice) {
		Final PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = productId, UnitPrice = unitPrice, IsActive = true);
		insert standardPrice;
		return standardPrice;
	}
    
}