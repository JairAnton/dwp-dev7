public virtual class OpportunityPDFWrap {

    public static OpportunityLineItem OLI {get;set;}
    Public Static Account_BBVA_Classification__c ABBVAC {get;set;}
    Public static Account_Banking_System_Classification__c  CSBS {get;set;}
    Public static Product2 Product {get;set;}
    Public static Account Client {get;set;}
    Public static Contact Contacto {get;set;}
    Public static User_Branch__c usuarioOficina {get;set;}
    Public static Branch__c Oficina {get;set;}
    Public static Account_Rating__c  Rating {get;set;}
    Public static list<Product_participants__c> Intervenientes {get;set;}
    Public static list<Product_Gurantee__c> Garantias {get;set;}
    public static AggregateResult[] totalComprimisos{get;set;}
    public static Integer totalC {get;set;}
    public static String title{get;set;}
    public static opportunity opp{get;set;}
    public static string Modalidad{get;set;}
    public static string setValues(String Oppid){
        string msg;
        try{
            msg= 'Datos incompletos en oportunidad';
            opportunity opp = [SELECT LastSIOcode__c,Name,AccountId,OwnerId,opportunity_expiry_date__c, toLabel(Modality__c), opportunity_status_type__c,Amount    FROM Opportunity WHERE id =:Oppid LIMIT 1];
            Modalidad =opp.Modality__c;
            msg= 'Datos incompletos en producto oportunidad';
            OLI = [SELECT ID,PE_POR_TEA_minima__c,da_Used_Risk__c,da_Observations__c,da_Available_Balance__c ,da_Exporter__c,da_Importer__c,CurrencyIsoCode,toLabel(da_Replacement_Reason__c) ,cpliq_Manual__c,da_nOperation__c,toLabel(tcf_type_beneficiary__c),toLabel(gipr_Comex_Bag__c),toLabel(tcf_Periodicity_commission__c),tcf_beneficiary__c,toLabel(tcf_type_bail_letter__c),toLabel(tcf_Legal_VB_text__c),toLabel(gipr_Tipo_Garantia__c),cpliq_n_gracia__c  ,PE_POR_TEA_propuesta__c,PE_POR_TEA_sugerida__c, toLabel(cpliq_Periodicidad__c),cpliq_Codigo_Simulacion__c ,cpliq_Fecha_Vencimiento__c ,toLabel(cpliq_Periodicidad_gracia__c),Siocode__c,toLabel(gipr_Destino__c),cpliq_Cuenta_vinculada__c,toLabel(cpliq_Amortizacion__c),Product2Id,gipr_Plazo__c ,gipr_Garantia__c  FROM OpportunityLineItem WHERE  OpportunityID =:Oppid ORDER BY CreatedDate DESC LIMIT 1];
            msg= 'Datos incompletos en producto';
            Product = [SELECT ID,Family,Name,CurrencyIsoCode, ProductCode  FROM Product2 WHERE Id =:OLI.Product2Id LIMIT 1];
            msg= 'Datos incompletos en cliente';
            Client =[SELECT ID,risk_strategy_class_name__c,email__c,Name,AccountNumber,branch_id__c,bbva_classification_desc__c,alert_desc__c,main_code_id__c,banking_system_classification_desc__c,bureau_classification_type__c FROM Account WHERE Id =: opp.AccountId LIMIT 1];
            msg= 'Datos incompletos en clasificación BBVA-Cliente';
            ABBVAC = [SELECT ID,bbva_classification_desc__c,Name FROM Account_BBVA_Classification__c WHERE account_id__c =:Client.Id LIMIT 1];
            msg= 'Datos incompletos en SBS';
            CSBS = [SELECT ID,Name FROM Account_Banking_System_Classification__c WHERE account_id__c =:Client.Id LIMIT 1];
            msg= 'Datos incompletos en contacto';
            Contacto = [SELECT Status_desc__c,Name FROM Contact WHERE AccountId =: Client.Id LIMIT 1];
            msg= 'Datos incompletos en usuario oficina';
            usuarioOficina = [SELECT Id,branch_name__c FROM User_Branch__c WHERE User__c  =: opp.ownerId LIMIT 1];
            msg= 'Datos incompletos en Oficina';
            oficina = [SELECT Id,Name,branch_id__c FROM Branch__c WHERE id =: usuarioOficina.branch_name__c LIMIT 1];
            msg= 'Datos incompletos en calificación cliente';
            Rating = [SELECT Id,total_rating_score_number__c,Account_Rating__c.rating_scale_type__c  FROM Account_Rating__c WHERE account_id__c  =: Client.Id  ORDER BY createdDate DESC LIMIT 1];
            msg= 'Datos incompletos en intervieniente';
            Intervenientes =[SELECT toLabel(DOI__c),N_DOI__c, toLabel(Participation__c), Name,toLabel(Marital_Status__c)   FROM Product_participants__c WHERE Opportunity__c =:Oppid];
            msg= 'Datos incompletos en garantias';
            Garantias = [SELECT toLabel(Guarantee__c),nGuarantee__c,toLabel(Modality__c), toLabel(Status__c) , Term__c ,toLabel(Periodicity__c) , Amount__c    FROM Product_Gurantee__c  WHERE Opportunity__c =:Oppid];
            totalComprimisos = [SELECT COUNT_DISTINCT(Id) total FROM compromiso__c WHERE Oportunidad__c =:Oppid];
            totalC=Integer.valueOf(totalComprimisos[0].get('total'));
            msg= 'SUCCESS';
            title = 'PDF Formalización '+Opportunity.Name;
        }catch(System.Exception e){
            system.debug('Exception : '+e.getMessage());
            return msg;
        }

        return msg;
    }


}
