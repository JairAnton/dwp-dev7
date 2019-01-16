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
    
    public void updateDateLine(List<OpportunityLineItem> listRow){
        
        for(OpportunityLineItem OLI: listRow){
            String oliCode =OLI.ProductCode==null?'':OLI.ProductCode;
            if(oliCode.contains('_Depre'))
                oliCode= oliCode.removeEnd('_Depre');
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
                   (!Label.lblPDFProductImport.equals(oliCode)&&
                    !Label.lblPDFProductCartaTecnicaEconomica.equals(oliCode)&&
                    !Label.lblPDFProductCartaTecnicaImport.equals(oliCode)&&
                    !Label.lblPDFProductForfaitingImport.equals(oliCode)&&
                    !Label.lblPDFProductImportComex.equals(oliCode)&&
                    !Label.lblPDFProductExportComex.equals(oliCode)&&
                    !Label.lblPDFProductCommercialLoanCP.equals(oliCode)&&
                    !Label.lblPDFProductCommercialLoanCP2.equals(oliCode)&&
                    !Label.lblPDFProductLeasing.equals(oliCode)&&
                    !Label.lblPDFProductPrestamoLP.equals(oliCode))) {
                        system.debug('isPlazoNotEmpty');
                        //isPlazoNotEmpty
                        OLI.cpliq_Periodicidad__c=OLI.cpliq_Periodicidad__c==null?'01':OLI.cpliq_Periodicidad__c;
                        OLI.cpliq_Fecha_Vencimiento__c= OLI.cpliq_Periodicidad__c=='01'?	Date.ValueOf(OLI.LastModifiedDate).addDays(Integer.valueOf(OLI.gipr_Plazo__c)):
                        OLI.cpliq_Periodicidad__c=='02'?Date.ValueOf(OLI.LastModifiedDate).ADDMONTHS(Integer.valueOf(OLI.gipr_Plazo__c)):
                        Date.ValueOf(OLI.LastModifiedDate).ADDMONTHS(Integer.valueOf(OLI.gipr_Plazo__c*12));
                    }
            else
                if((String.isEmpty(String.valueOf(OLI.cpliq_n__c)) && !String.isEmpty(String.valueOf(OLI.cpliq_Fecha_Vencimiento__c )))&&
                   (!Label.lblPDFProductImport.equals(oliCode)&&
                    !Label.lblPDFProductCartaTecnicaImport.equals(oliCode)&&
                    !Label.lblPDFProductCartaTecnicaEconomica.equals(oliCode)&&
                    !Label.lblPDFProductForfaitingImport.equals(oliCode)&&
                    !Label.lblPDFProductPrestamoLP.equals(oliCode)&&
                    !Label.lblPDFProductLeasing.equals(oliCode))) {
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