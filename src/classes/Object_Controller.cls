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
    public static String getOportunityModality(String Filtro) {
        String Modality = [SELECT Modality__c FROM Opportunity
             WHERE Id =:Filtro LIMIT 1].Modality__c;
        return Modality;
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
             Oportunidad__c FROM compromiso__c where Oportunidad__c =:Filtro order by createdDate desc limit 5];
        return OpLiItem;
    }


    @AuraEnabled
    public static void  setSanction(String Idopp){

    Opportunity op  = new Opportunity();
    Map<string,string> MapStatus = getMapOppStatus();
    Task t = [SELECT Id,Subject,Status FROM Task WHERE whatId = : idopp ORDER BY CreatedDate DESC];
    op = [SELECT StageName,Modality__c,opportunity_status_type__c FROM Opportunity WHERE ID =:Idopp];
    op.opportunity_status_type__c='10';
    String[] valStatus = t.Subject.split('##');
    String filter = '%'+valStatus[0]+'%';
    Integer totalTrace;
    update op;
    AggregateResult[] countTrace  = [SELECT Count(Id) total FROM dwp_cvad__Action_Audit__c];
    new OpportunityTraceability_cls().addOpportunityTraceability(valStatus[1],'Código SIO:' +valStatus[0],'Opportunity',op.Id,'Aprove',('AT-'+totalTrace),UserInfo.getUserId(),'embedded',1,true);

    }
    private static  Map<string,string> getMapOppStatus(){
       Map<string,string> MapStatus = new Map<string,string>();
       Schema.DescribeFieldResult fieldResult = Opportunity.opportunity_status_type__c.getDescribe();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
       for( Schema.PicklistEntry f : ple)
       {
               MapStatus.put(f.getLabel(), f.getValue());
       }
       return MapStatus;


    }

}
