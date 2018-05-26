public with sharing class Object_Controller {
 @AuraEnabled
    public static List<compromiso__c> getContacts(String Filtro) {
        List<compromiso__c> contacts = 
                [SELECT Id, PE_FM_PRODUCT__c, PE_DIVISA_Importe__c,PE_NUM_Plazo_Vcto__c,
                 PE_FOR_Fecha_Vcto__c, PE_NUM_Permanencia__c, CurrencyIsoCode FROM compromiso__c 
                 where Oportunidad__c =:Filtro and Oportunidad__c !='' order by createdDate desc];
        return contacts;
    }
   
}