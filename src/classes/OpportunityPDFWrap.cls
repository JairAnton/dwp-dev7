public virtual class OpportunityPDFWrap {


    public static OpportunityLineItem OLI {get;set;}
    Public Static Account_BBVA_Classification__c ABBVAC {get;set;}
    Public static Account_Banking_System_Classification__c  CSBS {get;set;}
    Public static Product2 Product {get;set;}
    Public static Account Client {get;set;}
    Public static Contact Contacto {get;set;}
    Public static User_Branch__c usuarioOficina {get;set;}
    Public static Branch__c Oficina {get;set;}




    public static void setValues(String Oppid){
      opportunity opp = [SELECT AccountId,OwnerId,opportunity_expiry_date__c  FROM Opportunity WHERE id =:Oppid LIMIT 1];
      OLI = [SELECT ID,Siocode__c,gipr_Destino__c,Product2Id,gipr_Plazo__c ,gipr_Garantia__c  FROM OpportunityLineItem WHERE  OpportunityID =:Oppid ORDER BY CreatedDate DESC LIMIT 1];
      Product = [SELECT ID,Family,Name,CurrencyIsoCode FROM Product2 WHERE Id =:OLI.Product2Id LIMIT 1];
      Client =[SELECT ID,Name,AccountNumber,branch_id__c,bbva_classification_desc__c,alert_desc__c,main_code_id__c,banking_system_classification_desc__c,bureau_classification_type__c FROM Account WHERE Id =: opp.AccountId LIMIT 1];
      ABBVAC = [SELECT ID,bbva_classification_desc__c,Name FROM Account_BBVA_Classification__c WHERE account_id__c =:Client.Id LIMIT 1];
      CSBS = [SELECT ID,Name FROM Account_Banking_System_Classification__c WHERE account_id__c =:Client.Id LIMIT 1];
      Contacto = [SELECT Status_desc__c,Name FROM Contact WHERE AccountId =: Client.Id LIMIT 1];
      usuarioOficina = [SELECT Id,branch_name__c FROM User_Branch__c WHERE User__c  =: opp.ownerId LIMIT 1];
      oficina = [SELECT Id,Name,branch_id__c FROM Branch__c WHERE id =: usuarioOficina.branch_name__c LIMIT 1];
    }


}
