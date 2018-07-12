/*
@Author: Arsenio Perez Lopez
@Proyect: BBVA PERU
@CreatedDate: 04-05-2018
@Version:1
@Hysteresis of changes:
- Creation of the class
-(04-07-2018) The methods for the FlashClient object are added 
*/
public with sharing class Object_Controller {
    /**
*Method of get contacts register.
*
**/
    @AuraEnabled
    public static List<compromiso__c> getContacts(String Filtro) {
        List<compromiso__c> contacts =
            [SELECT Id, PE_DIVISA_Importe__c,PE_NUM_Plazo_Vcto__c,Product_relate__c,
             PE_FOR_Fecha_Vcto__c, PE_NUM_Permanencia__c, CurrencyIsoCode FROM compromiso__c
             where Oportunidad__c =:Filtro and Oportunidad__c !='' order by createdDate desc];
        return contacts;
    }
    /**
*Method of get contacts register.
*
**/
    @AuraEnabled
    public static Id getOportunityLineItemID(String Filtro) {
        ID OpLiItem =
            [SELECT Id FROM OpportunityLineItem
             where OpportunityId =:Filtro][0].Id;
        return OpLiItem;
    }
    /**
*Method of get contacts register.
*
**/
    @AuraEnabled
    public static String getOportunityModality(String Filtro) {
        String Modality = [SELECT Modality__c FROM Opportunity
                           WHERE Id =:Filtro LIMIT 1].Modality__c;
        return Modality;
    }
    /**
*Method of get contacts register.
*
**/
    @AuraEnabled
    public static String getOportunidadSytem(String Filtro) {
        String OpLiItem =
            [SELECT Id, Product2.Type_of_quote__c  FROM OpportunityLineItem
             where OpportunityId =:Filtro][0].Product2.Type_of_quote__c;
        return OpLiItem;
        
    }
    /**
*Method of get contacts register.
*
**/
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
    /**
*Method of get contacts register.
*
**/
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
    /**
*Method of get Status register of opportu.
*
**/
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
    
    /**
*
*
**/
    @AuraEnabled
    public static List<String>  getVflasClient(String Idopp, string tipex){
        List<String> ret= new List<String>();
        String Tip= tipex=='Recursos gestionados' ? '02':'01';
            AggregateResult[] scop= [SELECT FORMAT(SUM(average_balance_amount__c)) average_balance_amount__c, 
                                     FORMAT(SUM(current_balance_var_month_amount__c)) current_balance_var_month_amount__c, 
                                     FORMAT(SUM(current_balance_var_year_amount__c)) current_balance_var_year_amount__c 
                                     FROM Account_BBVA_Information__c WHERE  type__c =: Tip AND 
                                     product_group_classification_id__c != '' AND product_desc__c != '' 
                                     AND account_id__c =: Idopp AND 
                                     product_group_classification_id__c=:tipex AND 
                                     year_month_day_date__c = LAST_MONTH Group By product_group_classification_id__c limit 1];
            List<Account_Banking_System_Debt__c> banking = new List<Account_Banking_System_Debt__c>();
            banking= [select FORMAT(debt_quote_amount__c) debt_quote_amount__c from Account_Banking_System_Debt__c 
                      where  product_group_classification_id__c!='' and 
                      entity_name__c LIKE '%BBVA%' AND product_desc__c!='' AND 
                      entity_name__c != '' and year_month_day_date__c = LAST_MONTH and 
                      account_id__c=: Idopp and product_desc_calc__c =:tipex limit 1];
            for (AggregateResult ar :scop){
                ret.add(String.valueOf(ar.get('average_balance_amount__c')));
                ret.add(String.valueOf(banking.isEmpty()?0:banking[0].debt_quote_amount__c)+' %');
                ret.add(String.valueOf(ar.get('current_balance_var_month_amount__c')));
                ret.add(String.valueOf(ar.get('current_balance_var_year_amount__c')));
            }
            if(ret.isEmpty())
            { ret.add('0');ret.add('0');ret.add('0');ret.add('0');}
            return ret;
    }
    
    /**
**/
    @AuraEnabled
    public static Product2 getProduct2(String ProdId){
        Product2 prodreturn = new Product2();
        if(!String.isEmpty(ProdId)){
            List<OpportunityLineItem> temp = [select product2Id from OpportunityLineItem where id=: ProdId limit 1];
            if(!temp.isEmpty())
            	prodreturn = [select id,risk_sanction__c,price_penalty__c,formalization__c from Product2 where id =: temp[0].product2Id limit 1];
        }    
        return prodreturn;
    }
    
}