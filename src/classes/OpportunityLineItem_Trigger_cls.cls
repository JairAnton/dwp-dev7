/*
@Autor: Arsenio Perez Lopez
@Proyect: BBVA PERU
@Version:1
@HIstorial de cambios:
- Creacion del Handler
*****************************
Modificaciones:

Isaías Velázquez Cortés  17-07-2018
*/
public without sharing class OpportunityLineItem_Trigger_cls {
    /* static variable */
    private static final String CPLIQFECHAVENC = 'cpliq_Fecha_Vencimiento__c';
    /* static variable */
    private static final String GIPRPLAZO = 'gipr_Plazo__c';
    /* static variable */
    private static final String GIPRPERIOD = 'gipr_Periodicidad__c';
    /* static variable */
    private static final String CPLIQPERIOD = 'cpliq_Periodicidad__c';
    /* static variable */
    private static final String CPLIQN = 'cpliq_n__c';
    
    public void AsignBeforeInsert(list<OpportunityLineItem>Opps_New)
    {
        set<id> IDs = new set<id>();
        for(OpportunityLineItem OLI: Opps_New){
            iDs.add(OLI.OpportunityID);
        }
        Map<Id,Opportunity> OportunidadMAp =new Map<Id,Opportunity>([select id, Amount from Opportunity where id in:IDs]);            
        if(!OportunidadMAp.isempty()){
            for(OpportunityLineItem OLI: Opps_New){
                if(OLI.UnitPrice==null){
                    OLI.TotalPrice=OportunidadMAp.get(OLI.OpportunityId).Amount==null? 0:OportunidadMAp.get(OLI.OpportunityId).Amount;
                }
            }
        }
    }
    
    public void MasteRecord_Guarantee(list<OpportunityLineItem>Opps_New)
    {
        if(Opps_New[0].gipr_Tipo_Garantia__c=='01' || Opps_New[0].gipr_Tipo_Garantia__c=='02'){
            List<fprd__GBL_Guarantee__c> row =[SELECT Id FROM fprd__GBL_Guarantee__c WHERE fprd__GBL_Opportunity_product__c=: Opps_New[0].OpportunityId and  isMaster__c=true];
            System.debug(Opps_New[0].gipr_Garantia__c);
            if(row.isEmpty())
            {
                fprd__GBL_Guarantee__c nRow = new fprd__GBL_Guarantee__c();
                nRow.fprd__GBL_Opportunity_product__c=Opps_New[0].OpportunityId;
                nRow.guarantee_type__c=Opps_New[0].gipr_Tipo_Garantia__c;
                nRow.guarantee_desc__c=Opps_New[0].gipr_Garantia__c;
                nRow.isMaster__c=true;
                insert nRow;
            }
            else
            {
                row[0].guarantee_type__c=Opps_New[0].gipr_Tipo_Garantia__c;
                row[0].guarantee_desc__c=Opps_New[0].gipr_Garantia__c;
                update row;
            }
        }
        else
        {
            List<fprd__GBL_Guarantee__c> row =[SELECT Id FROM fprd__GBL_Guarantee__c WHERE fprd__GBL_Opportunity_product__c=: Opps_New[0].OpportunityId and  isMaster__c=true LIMIT 1];
            
            if(!row.isEmpty()) delete row;
        }
    }
    
    public  void upsertMasterParticipant (List<OpportunityLineItem> listRow) {
        Map<id,id> OLiOpportunity = new Map<id,id>();
        Map<id,id> OLiProduct = new Map<id,id>();
        Map<id,Opportunity> MapOLiOpportunity = new Map<id,Opportunity>();
        Map<id,Product2> MapOLiProduct = new Map<id,Product2>();
        List<Opportunity> Oppupdate = new List<Opportunity>();
        for(OpportunityLineItem Opp :listRow){
            OLiOpportunity.put(Opp.id,opp.OpportunityId);
            OLiProduct.put(Opp.id,opp.Product2Id);  
        }
        
        List<Opportunity>  opName = [Select Id, Account.Name,Account.AccountNumber,opportunity_product__c,opportunity_product_family__c From Opportunity WHERE Id IN:OLiOpportunity.values()];
        List<Product2>  opProduct = [Select Id, Name, Family From Product2 WHERE Id IN:OLiProduct.values()];
        for(Opportunity opi:opName )
            MapOLiOpportunity.put(opi.id,opi);
        for(Product2 pro: opProduct)
            MapOLiProduct.put(pro.id, pro);
        for(OpportunityLineItem OLi :listRow){
            Opportunity temp = MapOLiOpportunity.get(OLi.OpportunityId);
            temp.opportunity_product__c = MapOLiProduct.get(OLi.Product2Id).Name;
            temp.opportunity_product_family__c =  MapOLiProduct.get(OLi.Product2Id).Family;
            Oppupdate.add(temp);
        }
        update Oppupdate;
        
        List<fprd__GBL_Intervener__c> row =[SELECT Id,fprd__GBL_Opportunity_product__c FROM fprd__GBL_Intervener__c WHERE  fprd__GBL_Opportunity_product__c IN:OLiOpportunity.values() and  main_intervener__c=true];
        if(row.isEmpty())
        {
            List<fprd__GBL_Intervener__c> Inter = new List<fprd__GBL_Intervener__c>();
            for(OpportunityLineItem OLi :listRow){
                fprd__GBL_Intervener__c nRow = new fprd__GBL_Intervener__c();
                nRow.fprd__GBL_Opportunity_product__c=OLi.OpportunityId;
                nRow.Name=MapOLiOpportunity.get(OLi.OpportunityId).Account.Name;
                nRow.participant_type__c='01';
                nRow.fiscal_identifier_type__c='01';
                nRow.taxpayer_id__c=MapOLiOpportunity.get(OLi.OpportunityId).Account.AccountNumber;
                nRow.guarantor_marital_status_type__c='04';
                nRow.main_intervener__c=true;
                Inter.add(nRow);
            }
            insert Inter;
        }
        else
        {
            List<fprd__GBL_Intervener__c> Inter = new List<fprd__GBL_Intervener__c>();
            for(fprd__GBL_Intervener__c ro :row){
                ro.Name=MapOLiOpportunity.get(ro.fprd__GBL_Opportunity_product__c).Account.Name;
                ro.participant_type__c='01';
                ro.fiscal_identifier_type__c='01';
                ro.guarantor_marital_status_type__c='04';
                ro.taxpayer_id__c=MapOLiOpportunity.get(ro.fprd__GBL_Opportunity_product__c).Account.AccountNumber;
                Inter.add(ro);
            }
            update Inter;
        }
        
    }
    
    public void updateDateLine(List<OpportunityLineItem> listRow) {
        final Set<Id> productIds = new Set<Id>();
        Map<String, Map<String, Double>> mapFields = new Map<String, Map<String, Double>>();
        for(OpportunityLineItem oli : listRow) {
            productIds.add(oli.Product2Id);
        }
        for(fprd__GBL_Product_Configuration__c pc : [SELECT Id, fprd__Product__c, fprd__Map_field__c, fprd__Section_order__c FROM fprd__GBL_Product_Configuration__c WHERE fprd__Product__c IN : productIds]) {
            Map<String, Double> mapField = new Map<String, Double>();
            if(mapFields.containsKey(pc.fprd__Product__c)) {
                mapField = mapFields.get(pc.fprd__Product__c);
            }
            mapField.put(pc.fprd__Map_field__c, pc.fprd__Section_order__c);
            mapFields.put(pc.fprd__Product__c, mapField);
        }
        
        for(OpportunityLineItem OLI : listRow) {
            if(mapFields.containsKey(OLI.Product2Id)) {
                final Map<String, Double> mapField = mapFields.get(OLI.Product2Id);
                if(mapField.get(CPLIQFECHAVENC)!= null && mapField.get(GIPRPLAZO) == mapField.get(CPLIQFECHAVENC) && mapField.get(GIPRPERIOD) == mapField.get(CPLIQFECHAVENC)) {
                    oli = calculateDueDate(oli, GIPRPLAZO, GIPRPERIOD);
                } else if(mapField.get(CPLIQFECHAVENC)!= null && mapField.get(GIPRPLAZO) == mapField.get(CPLIQFECHAVENC) && mapField.get(CPLIQPERIOD) == mapField.get(CPLIQFECHAVENC)) {
                    oli = calculateDueDate(oli, GIPRPLAZO, CPLIQPERIOD);
                } else if(mapField.get(CPLIQFECHAVENC)!= null && mapField.get(CPLIQN) == mapField.get(CPLIQFECHAVENC) && mapField.get(GIPRPERIOD) == mapField.get(CPLIQFECHAVENC)) {
                    oli = calculateDueDate(oli, CPLIQN, GIPRPERIOD);
                } else if(mapField.get(CPLIQFECHAVENC)!= null && mapField.get(CPLIQN) == mapField.get(CPLIQFECHAVENC) && mapField.get(CPLIQPERIOD) == mapField.get(CPLIQFECHAVENC)) {
                    oli = calculateDueDate(oli, CPLIQN, CPLIQPERIOD);
                }
            }
        }
    }
	
    public void deleteOppSolComm ( Map<id,OpportunityLineItem> Opps_OldMap){
        List<Opportunity_Solution_Commitment__c> lstoppsolcom = [Select Id,opp_solution_id__c from Opportunity_Solution_Commitment__c where opp_solution_id__c =:Opps_OldMap.keySet()];
        if(!lstoppsolcom.isEmpty()){
            delete lstoppsolcom;
        }
    }

	/* Metod used for calculate due date of opportunity */
    private static OpportunityLineItem calculateDueDate(OpportunityLineItem oli, String plazo, String periodicity) {
        OpportunityLineItem oliTemp = oli;
        if(Integer.valueOf(oliTemp.get(plazo))>=0 && (oliTemp.get(periodicity) == '01' || oliTemp.get(periodicity) == '02' || oliTemp.get(periodicity) == '03')) {
            oliTemp = usingTermPeriodicity(oliTemp, Integer.valueOf(oliTemp.get(plazo)), String.valueOf(oliTemp.get(periodicity)));
        } else if(oliTemp.cpliq_Fecha_Vencimiento__c != null) {
        	oliTemp = usingDate(oliTemp, plazo, periodicity, 999);
        }
        return oliTemp;
    }
    
    /* Metod used for calculate due date using term peridodicity */
    private static OpportunityLineItem usingTermPeriodicity(OpportunityLineItem oli, Integer valPlazo, String periodicity) {
        OpportunityLineItem oliTemp = oli;
        switch on String.valueOf(oliTemp.get(periodicity)) {
            when '01' {
                oliTemp.cpliq_Fecha_Vencimiento__c = System.today().addDays(valPlazo);
            }
            when '02' {
                oliTemp.cpliq_Fecha_Vencimiento__c = System.today().addMonths(valPlazo);
            }
            when '03' {
                oliTemp.cpliq_Fecha_Vencimiento__c = System.today().addYears(valPlazo);
            }
        }
        return oliTemp;
    }
    
    /* Metod used for calculate due date using date */
    private static OpportunityLineItem usingDate(OpportunityLineItem oli, String plazo, String periodicity, Integer limitNum) {
        OpportunityLineItem oliTemp = oli;
        oliTemp.put(periodicity,'01');
        oliTemp.put(plazo,System.today().daysBetween(oliTemp.cpliq_Fecha_Vencimiento__c)+1);
        if(Integer.valueOf(oliTemp.get(plazo))>limitNum) {
            Integer numPlazo = Integer.ValueOf((System.today().daysBetween(oliTemp.cpliq_Fecha_Vencimiento__c)+1)/30);
            oliTemp.put(periodicity,'02');
            oliTemp.put(plazo, numPlazo);
            if(Integer.valueOf(oliTemp.get(plazo))>limitNum) {
                oliTemp.put(periodicity,'03');
                numPlazo = Integer.ValueOf((System.today().daysBetween(oliTemp.cpliq_Fecha_Vencimiento__c)+1)/365);
                oliTemp.put(plazo, numPlazo);
            }
        }
        return oliTemp;
    }
}