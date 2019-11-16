/**
-------------------------------------------------------------------------------------------------
@Name <OpportunityLineItem_Trigger_cls>
@Author Isaías Velázquez Cortés  17-07-2018
@Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
@Date 2019-09-13
@Description Class Helper for Trigger for OpportunityLineItem(OLI)
@Changes
Date        Author   Email                  Type   
			ISV								Creation
2019-11-04  LMBR     lolo.bravo@bbva.com    Modify  
-------------------------------------------------------------------------------------------------
 */
public without sharing class OpportunityLineItem_Trigger_cls {
    
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
    
    /**
    @Description create and update principal Intervener for Opportunity
    @return is void method
    */
    public  void upsertMasterParticipant () {
        final Integer SIZE_LST=0;
        final String  VALUE_ZERO='01';
        final String  VALUE_FOUR='04';
        Set<Id> oppIds=new Set<Id>();
        Set<String> accIds=new Set<String>();
        List<Opportunity> oppList=new List<Opportunity>();
        final Map<Id,OpportunityLineItem> oLIMap=new Map<Id,OpportunityLineItem>([SELECT Id,OpportunityId,Opportunity.Account.Name,Opportunity.Account.AccountNumber, Product2.Name, Product2.Family FROM OpportunityLineItem WHERE Id IN: TRIGGER.NEW AND Product2.risk_sanction__c=TRUE]);
        for(OpportunityLineItem oLI:oLIMap.values()) {
            oppList.add(new Opportunity(Id=oLI.OpportunityId,opportunity_product__c=oLi.Product2.Name,opportunity_product_family__c=oLi.Product2.Family));
            if(String.isNotBlank(oLI.OpportunityId) && String.isNotBlank(oLI.Opportunity.Account.AccountNumber)){
             oppIds.add(oLI.OpportunityId);
             accIds.add(oLI.Opportunity.Account.AccountNumber);
            }
	    }
        
        if (oppIds.size()>SIZE_LST) {
            update oppList;
           	Map<Id,fprd__GBL_Intervener__c> intvrMap =new Map<Id,fprd__GBL_Intervener__c>();
            List<fprd__GBL_Intervener__c> intvrList=new List<fprd__GBL_Intervener__c>();
            for(fprd__GBL_Intervener__c iter:[SELECT Id,fprd__GBL_Opportunity_product__c FROM fprd__GBL_Intervener__c WHERE  fprd__GBL_Opportunity_product__c IN:oppIds AND taxpayer_id__c IN:accIds AND taxpayer_id__c!=NULL AND main_intervener__c=TRUE AND fprd__GBL_Opportunity_product__c!=NULL LIMIT 200000]) {
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
    
    public void updateDateLine(List<OpportunityLineItem> listRow){
        
        for(OpportunityLineItem OLI: listRow){
            String oliCode =OLI.ProductCode==null?'':OLI.ProductCode;
            if(oliCode.contains('_Depre')) {
                oliCode= oliCode.removeEnd('_Depre');
            }
            if(!String.isEmpty(String.valueOf(OLI.gipr_Plazo__c))&&
               (Label.lblPDFProductImport.equals(oliCode)||
                Label.lblPDFProductCartaTecnicaEconomica.equals(oliCode)||
                Label.lblPDFProductCartaTecnicaImport.equals(oliCode)||
                Label.lblPDFProductForfaitingImport.equals(oliCode))&&
               !Label.lblPDFProductCommercialLoanCP.equals(oliCode)&&
               !Label.lblPDFProductCommercialLoanCP2.equals(oliCode)&&
               !Label.lblPDFProductImportComex.equals(oliCode)&&
               !Label.lblPDFProductExportComex.equals(oliCode)&&
               !Label.lblPDFProductLeasing.equals(oliCode)) {
                   system.debug('isPlazoNotEmpty2');
                   //isPlazoNotEmpty2
                   OLI.cpliq_Fecha_Vencimiento__c =OLI.gipr_Periodicidad__c=='01'?
                       (Date.valueOf(OLI.LastModifiedDate).addDays(Integer.valueOf(OLI.gipr_Plazo__c))):
                   (Date.valueOf(OLI.LastModifiedDate).addMonths(Integer.valueOf(OLI.gipr_Plazo__c)));
                       }
            else
                if(String.isEmpty(String.valueOf(OLI.gipr_Plazo__c)) && 
                   !String.isEmpty(String.valueOf(OLI.cpliq_Fecha_Vencimiento__c ))&&
                   (Label.lblPDFProductImport.equals(oliCode)||
                    Label.lblPDFProductCartaTecnicaImport.equals(oliCode)||
                    Label.lblPDFProductCartaTecnicaEconomica.equals(oliCode)||
                    Label.lblPDFProductForfaitingImport.equals(oliCode))) {
                        //isDateDueNotEmpty2 
                        system.debug('isDateDueNotEmpty2'); 
                        OLI.gipr_Periodicidad__c='01';
                        OLI.gipr_Plazo__c=system.Math.abs(Date.valueOf(OLI.cpliq_Fecha_Vencimiento__c).daysBetween(Date.valueOf(OLI.LastModifiedDate)));
                    }
            else
                if((!String.isEmpty(String.valueOf(OLI.gipr_Plazo__c)))&&
                   !Label.lblPDFProductImport.equals(oliCode)&&
                    !Label.lblPDFProductCartaTecnicaEconomica.equals(oliCode)&&
                    !Label.lblPDFProductCartaTecnicaImport.equals(oliCode)&&
                    !Label.lblPDFProductForfaitingImport.equals(oliCode)&&
                    !Label.lblPDFProductImportComex.equals(oliCode)&&
                    !Label.lblPDFProductExportComex.equals(oliCode)&&
                    !Label.lblPDFProductCommercialLoanCP.equals(oliCode)&&
                    !Label.lblPDFProductCommercialLoanCP2.equals(oliCode)&&
                    !Label.lblPDFProductLeasing.equals(oliCode)&&
                    !Label.lblPDFProductPrestamoLP.equals(oliCode)) {
                        system.debug('isPlazoNotEmpty');
                        //isPlazoNotEmpty
                        OLI.cpliq_Periodicidad__c=OLI.cpliq_Periodicidad__c==null?'01':OLI.cpliq_Periodicidad__c;
                        OLI.cpliq_Fecha_Vencimiento__c= OLI.cpliq_Periodicidad__c=='01'?	Date.ValueOf(OLI.LastModifiedDate).addDays(Integer.valueOf(OLI.gipr_Plazo__c)):
                        OLI.cpliq_Periodicidad__c=='02'?Date.ValueOf(OLI.LastModifiedDate).ADDMONTHS(Integer.valueOf(OLI.gipr_Plazo__c)):
                        Date.ValueOf(OLI.LastModifiedDate).ADDMONTHS(Integer.valueOf(OLI.gipr_Plazo__c*12));
                    }
            else
                if((String.isEmpty(String.valueOf(OLI.cpliq_n__c)) && !String.isEmpty(String.valueOf(OLI.cpliq_Fecha_Vencimiento__c )))&&
                   !Label.lblPDFProductImport.equals(oliCode)&&
                    !Label.lblPDFProductCartaTecnicaImport.equals(oliCode)&&
                    !Label.lblPDFProductCartaTecnicaEconomica.equals(oliCode)&&
                    !Label.lblPDFProductForfaitingImport.equals(oliCode)&&
                    !Label.lblPDFProductPrestamoLP.equals(oliCode)&&
                    !Label.lblPDFProductLeasing.equals(oliCode)) {
                        //isDateDueNotEmpty 
                        system.debug('isDateDueNotEmpty');
                        OLI.cpliq_Periodicidad__c='01';
                        OLI.cpliq_n__c=system.math.abs(Integer.ValueOf(Date.valueOf(OLI.cpliq_Fecha_Vencimiento__c).daysBetween(Date.valueOf(OLI.LastModifiedDate))));
                        
                    }
            else
                if((String.isEmpty(String.valueOf(OLI.cpliq_n__c))&&
                    !String.isEmpty(String.valueOf(OLI.cpliq_Fecha_Vencimiento__c )))&&
                   (Label.lblPDFProductPrestamoLP.equals(oliCode)||Label.lblPDFProductLeasing.equals(oliCode))) {
                       system.debug('isDateDueNotEmpty3');
                       //isDateDueNotEmpty3
                       OLI.cpliq_Periodicidad__c='02';
                       OLI.cpliq_n__c=system.math.abs(Integer.ValueOf((Date.ValueOf(OLI.LastModifiedDate).daysBetween(Date.valueOf(OLI.cpliq_Fecha_Vencimiento__c)))/30));
                       
                   } 
            else
                if(!String.isEmpty(String.valueOf(OLI.cpliq_n__c))&&
                   (Label.lblPDFProductImportComex.equals(oliCode)||
                    Label.lblPDFProductExportComex.equals(oliCode)||
                    Label.lblPDFProductCommercialLoanCP.equals(oliCode)||
                    Label.lblPDFProductCommercialLoanCP2.equals(oliCode))) {
                        system.debug('isDateDueNotEmpty41');
                        //isDateDueNotEmpty3
                        OLI.cpliq_Periodicidad__c=OLI.cpliq_Periodicidad__c==null?'01':OLI.cpliq_Periodicidad__c;
                        OLI.cpliq_Fecha_Vencimiento__c =OLI.cpliq_Periodicidad__c=='01'?
                            (Date.valueOf(OLI.LastModifiedDate).addDays(Integer.valueOf(OLI.cpliq_n__c))):
                        (Date.valueOf(OLI.LastModifiedDate).addMonths(Integer.valueOf(OLI.cpliq_n__c)));
                            }
            else
                if( !String.isEmpty(String.valueOf(OLI.cpliq_n__c))&&
                   !String.isEmpty(String.valueOf(OLI.cpliq_Periodicidad__c))&&
                   (Label.lblPDFProductPrestamoLP.equals(oliCode)||Label.lblPDFProductLeasing.equals(oliCode))) {
                       system.debug('isDateDueNotEmpty4');
                       //isDateDueNotEmpty3
                       OLI.cpliq_Fecha_Vencimiento__c =OLI.cpliq_Periodicidad__c=='02'?
                           (Date.valueOf(OLI.LastModifiedDate).addMonths(Integer.valueOf(OLI.cpliq_n__c))):
                       (Date.valueOf(OLI.LastModifiedDate).addYears(Integer.valueOf(OLI.cpliq_n__c)));
                           }
            
        }
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