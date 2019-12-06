/**
-------------------------------------------------------------------------------------------------
@Name <OpportunityLineItem_Trigger_cls>
@Author Isaías Velázquez Cortés  17-07-2018
@Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
@Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
@Date 2019-09-13
@Description Class Helper for Trigger for OpportunityLineItem(OLI)
@Changes
Date        Author   Email                  Type   
			ISV								Creation
2019-11-04  LMBR     lolo.bravo@bbva.com    Modify  
2019-11-05  MAMC     martin.mori.contractor@bbva.com    Modify  
-------------------------------------------------------------------------------------------------
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
        if(Opps_New[0].gipr_Tipo_Garantia__c=='01' || Opps_New[0].gipr_Tipo_Garantia__c=='02' || Opps_New[0].gipr_Tipo_Garantia__c=='04') {
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
    
    /**
    @Description Method used to update name and family of product
    @return is void method
    */
    public  void updateNameFamilyProduct() {
        List<Opportunity> oppList=new List<Opportunity>();
        for(OpportunityLineItem oli : [SELECT Id,OpportunityId, Product2.Name, Product2.Family FROM OpportunityLineItem WHERE Id IN: TRIGGER.NEW]) {
            oppList.add(new Opportunity(Id=oli.OpportunityId, opportunity_product__c=oli.Product2.Name,opportunity_product_family__c=oli.Product2.Family));
        }
        update oppList;
    }
    
    /**
    @Description create and update principal Intervener for Opportunity
    @return is void method
    */
    public  void upsertMasterParticipant () {
        final Integer SIZE_LST=0;
        final String  VALUE_ZERO='01';
        final String  VALUE_FOUR='04';
        Set<Id> oppIds=new Set<Id>();
        final Map<Id,OpportunityLineItem> oLIMap=new Map<Id,OpportunityLineItem>([SELECT Id,OpportunityId,Opportunity.Account.Name,Opportunity.Account.AccountNumber, Product2.Name, Product2.Family FROM OpportunityLineItem WHERE Id IN: TRIGGER.NEW AND Product2.risk_sanction__c=TRUE]);
        for(OpportunityLineItem oLI:oLIMap.values()) {
            oppIds.add(oLI.OpportunityId);
	    }
        
        if (oppIds.size()>SIZE_LST) {
            Map<Id,fprd__GBL_Intervener__c> intvrMap =new Map<Id,fprd__GBL_Intervener__c>();
            List<fprd__GBL_Intervener__c> intvrList=new List<fprd__GBL_Intervener__c>();
            for(fprd__GBL_Intervener__c iter:[SELECT Id,fprd__GBL_Opportunity_product__c FROM fprd__GBL_Intervener__c WHERE  fprd__GBL_Opportunity_product__c IN:oppIds AND  main_intervener__c=TRUE]) {
               intvrMap.put(iter.fprd__GBL_Opportunity_product__c,iter);
            }
            
            for(OpportunityLineItem oLI:oLIMap.values()) {
                 fprd__GBL_Intervener__c ro = new fprd__GBL_Intervener__c();
                if(intvrMap.containsKey(oLI.OpportunityId)){
                    ro.Id=intvrMap.get(oLI.OpportunityId).Id;
                 	ro.Name=oLI.Opportunity.Account.Name;
                	ro.participant_type__c=VALUE_ZERO;
                	ro.fiscal_identifier_type__c=VALUE_ZERO;
                	ro.guarantor_marital_status_type__c=VALUE_FOUR;
                	ro.taxpayer_id__c=oLI.Opportunity.Account.AccountNumber;
                } else {
                   	ro.fprd__GBL_Opportunity_product__c=OLi.OpportunityId;
                	ro.Name=oLI.Opportunity.Account.Name;
                	ro.participant_type__c=VALUE_ZERO;
                	ro.fiscal_identifier_type__c=VALUE_ZERO;
                	ro.taxpayer_id__c=oLI.Opportunity.Account.AccountNumber;
                	ro.guarantor_marital_status_type__c=VALUE_FOUR;
                	ro.main_intervener__c=true; 
                }
                intvrList.add(ro);
            }
            if(intvrList.size()>SIZE_LST) {
            upsert intvrList;
            }
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
    
    /* Metod used for calculate due date of opportunity */
    private static OpportunityLineItem calculateDueDate(OpportunityLineItem oli, String plazo, String periodicity) {
        OpportunityLineItem oliTemp = oli;
        if(Integer.valueOf(oliTemp.get(plazo))>=0 && (oliTemp.get(periodicity) == '01' || oliTemp.get(periodicity) == '02' || oliTemp.get(periodicity) == '03')) {
            oliTemp = usingTermPeriodicity(oliTemp, plazo, periodicity);
        } else if(oliTemp.cpliq_Fecha_Vencimiento__c != null) {
        	oliTemp = usingDate(oliTemp, plazo, periodicity, 999);
        }
        return oliTemp;
    }
    
    /* Metod used for calculate due date using term peridodicity */
    private static OpportunityLineItem usingTermPeriodicity(OpportunityLineItem oli, String plazo, String periodicity) {
        OpportunityLineItem oliTemp = oli;
        switch on String.valueOf(oliTemp.get(periodicity)) {
            when '01' {
                oliTemp.cpliq_Fecha_Vencimiento__c = System.today().addDays(Integer.valueOf(oliTemp.get(plazo)));
            }
            when '02' {
                oliTemp.cpliq_Fecha_Vencimiento__c = System.today().addMonths(Integer.valueOf(oliTemp.get(plazo)));
            }
            when '03' {
                oliTemp.cpliq_Fecha_Vencimiento__c = System.today().addYears(Integer.valueOf(oliTemp.get(plazo)));
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
    
    public  void deleteOppSolComm ( Map<id,OpportunityLineItem> Opps_OldMap){
        List<Opportunity_Solution_Commitment__c> lstoppsolcom = [Select Id,opp_solution_id__c from Opportunity_Solution_Commitment__c where opp_solution_id__c =:Opps_OldMap.keySet()];
        if(!lstoppsolcom.isEmpty()){
            delete lstoppsolcom;
        }
    }
    /*
Public void UpdateCaseAnalist(List<OpportunityLineItem> NEwlist,Map<id,OpportunityLineItem> Opps_NewMap,Map<id,OpportunityLineItem> Opps_OldMap){
Id profileId=userinfo.getProfileId();
String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
if( Label.lblAnalistaProf.equals(profileName)){
List<Case> UpCase = new List<Case>();
Set<Id> IDs = new set<ID>();
for(OpportunityLineItem OLI1 :Opps_NewMap.values())
IDs.add(OLI1.OpportunityId);
Map<Id,Case> cas = new Map<Id,Case>();
for(Case ca:[select id,suggested_apr_per__c,opportunity_id__c from case where opportunity_id__c IN:IDs order by createdDate asc limit 1])
cas.put(ca.opportunity_id__c,ca);
for(OpportunityLineItem OLI1 :Opps_NewMap.values()){

if(OLI1.suggested_apr_per__c != cas.get(OLI1.OpportunityId).proposed_apr_per__c && 
!String.isBlank(String.valueOf(OLI1.suggested_apr_per__c)))
{
cas.get(OLI1.OpportunityId).suggested_apr_per__c=OLI1.proposed_fee_per__c;
UpCase.add(cas.get(OLI1.OpportunityId));
}else 
if(OLI1.proposed_apr_per__c != cas.get(OLI1.OpportunityId).proposed_apr_per__c && 
!String.isBlank(String.valueOf(OLI1.proposed_apr_per__c)))
{
cas.get(OLI1.OpportunityId).suggested_apr_per__c=OLI1.proposed_apr_per__c;
UpCase.add(cas.get(OLI1.OpportunityId));
}

}
if(!UpCase.isempty())
update UpCase;
}
}*/
}