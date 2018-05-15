public virtual class OpportunityPDFWrap {
    

    public static OpportunityLineItem OLI {get;set;}
    Public Static Account_BBVA_Classification__c ABBVAC {get;set;}
    Public static Product2 Product {get;set;}
    Public static Account Client {get;set;}
    public static void setValues(String Oppid){
      OLI = [SELECT ID,Destination__c,Product2Id,Term__c,Warranty__c FROM OpportunityLineItem WHERE  OpportunityID =:Oppid ORDER BY CreatedDate DESC LIMIT 1];
      Product = [SELECT ID,Family,Name,CurrencyIsoCode FROM Product2 WHERE Id =:OLI.Product2Id LIMIT 1];
    } 
    

}