public with sharing class Object_Controller {
    @AuraEnabled
    public static List<compromiso__c> getContacts(String Filtro) {
        List<compromiso__c> contacts = 
            [SELECT Id, PE_DIVISA_Importe__c,PE_NUM_Plazo_Vcto__c,Product_relate__c,
             PE_FOR_Fecha_Vcto__c, PE_NUM_Permanencia__c, CurrencyIsoCode FROM compromiso__c 
             where Oportunidad__c =:Filtro and Oportunidad__c !='' order by createdDate desc];
        return contacts;
    }
    @AuraEnabled
    public static Id getOportunityLineItemID(String Filtro) {
        ID OpLiItem = 
            [SELECT Id FROM OpportunityLineItem 
             where OpportunityId =:Filtro][0].Id;
        return OpLiItem;
    }  
    @AuraEnabled   
    public static String getOportunidadSytem(String Filtro) {
        String OpLiItem = 
            [SELECT Id, Product2.Type_of_quote__c  FROM OpportunityLineItem 
             where OpportunityId =:Filtro][0].Product2.Type_of_quote__c;
        return OpLiItem;
        
    }
    @AuraEnabled   
    public static list<compromiso__c> getCompromisosSytem(String Filtro) {
        list<compromiso__c> OpLiItem = 
            [SELECT Id, OwnerId, IsDeleted, Name, CurrencyIsoCode, Product_relate__c,
             CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, 
             LastActivityDate,  PE_DIVISA_Importe__c, 
             PE_NUM_Plazo_Vcto__c, PE_NUM_Permanencia__c, PE_FOR_Fecha_Vcto__c, Client__c, 
             Oportunidad__c FROM compromiso__c where Oportunidad__c =:Filtro order by createdDate desc limit 1];
        
        return OpLiItem;
        
    }
}