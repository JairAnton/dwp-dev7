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
        List<Opportunity>  opName = [Select Id,Account.Name,Account.AccountNumber,opportunity_product__c,opportunity_product_family__c From Opportunity WHERE Id=:listRow[0].OpportunityId  LIMIT 1];
        List<Product2>  opProduct = [Select Name, Family From Product2 WHERE Id=:listRow[0].Product2Id LIMIT 1];
        if(!opProduct.isEmpty())
        {
            opName[0].opportunity_product__c=opProduct[0].Name;
            opName[0].opportunity_product_family__c=opProduct[0].Family;
            update opName[0];
        }
            List<fprd__GBL_Intervener__c> row =[SELECT Id FROM fprd__GBL_Intervener__c WHERE  fprd__GBL_Opportunity_product__c=: listRow[0].OpportunityId and  main_intervener__c=true];
            if(row.isEmpty())
            {
                fprd__GBL_Intervener__c nRow = new fprd__GBL_Intervener__c();
                nRow.fprd__GBL_Opportunity_product__c=listRow[0].OpportunityId;
                nRow.Name=opName[0].Account.Name;
                nRow.participant_type__c='01';
                nRow.fiscal_identifier_type__c='01';
                nRow.taxpayer_id__c=opName[0].Account.AccountNumber;
                nRow.guarantor_marital_status_type__c='04';
                nRow.main_intervener__c=true;
                insert nRow;
            }
            else
            {
                row[0].Name=opName[0].Account.Name;
                row[0].participant_type__c='01';
                row[0].fiscal_identifier_type__c='01';
                row[0].guarantor_marital_status_type__c='04';
                row[0].taxpayer_id__c=opName[0].Account.AccountNumber;
                update row;
            }

    }

 public void updateDateLine(List<OpportunityLineItem> listRow){
        
        for(OpportunityLineItem OLI: listRow){

            if(!String.isEmpty(String.valueOf(OLI.gipr_Plazo__c))&&
               (Label.lblPDFProductImport.equals(OLI.ProductCode)||
                Label.lblPDFProductCartaTecnicaEconomica.equals(OLI.ProductCode)||
                Label.lblPDFProductCartaTecnicaImport.equals(OLI.ProductCode)||
                Label.lblPDFProductForfaitingImport.equals(OLI.ProductCode)||
                Label.lblPDFProductImportComex.equals(OLI.ProductCode)||
                Label.lblPDFProductExportComex.equals(OLI.ProductCode)||
                !Label.lblPDFProductCommercialLoanCP.equals(OLI.ProductCode))){
                    //isPlazoNotEmpty2
                    OLI.cpliq_Fecha_Vencimiento__c =OLI.gipr_Periodicidad__c=='01'?
                        (Date.valueOf(OLI.LastModifiedDate).addDays(Integer.valueOf(OLI.gipr_Plazo__c))):
                    (Date.valueOf(OLI.LastModifiedDate).addMonths(Integer.valueOf(OLI.gipr_Plazo__c)));
                        }
            else
                if(String.isEmpty(String.valueOf(OLI.gipr_Plazo__c)) && 
                   !String.isEmpty(String.valueOf(OLI.cpliq_Fecha_Vencimiento__c ))&&
                   (Label.lblPDFProductImport.equals(OLI.ProductCode)||
                    Label.lblPDFProductCartaTecnicaImport.equals(OLI.ProductCode)||
                    Label.lblPDFProductCartaTecnicaEconomica.equals(OLI.ProductCode)||
                    Label.lblPDFProductForfaitingImport.equals(OLI.ProductCode))){
                        //isDateDueNotEmpty2 
                        system.debug('isDateDueNotEmpty2'); 
                        OLI.gipr_Periodicidad__c='01';
                        OLI.gipr_Plazo__c=system.Math.abs(Date.valueOf(OLI.cpliq_Fecha_Vencimiento__c).daysBetween(Date.valueOf(OLI.LastModifiedDate)));
                    }
            else
                if((!String.isEmpty(String.valueOf(OLI.gipr_Plazo__c)))&&
                   (!Label.lblPDFProductImport.equals(OLI.ProductCode)&&
                   	!Label.lblPDFProductCartaTecnicaEconomica.equals(OLI.ProductCode)&&
                    !Label.lblPDFProductCartaTecnicaImport.equals(OLI.ProductCode)&&
                    !Label.lblPDFProductForfaitingImport.equals(OLI.ProductCode)&&
                    !Label.lblPDFProductImportComex.equals(OLI.ProductCode)&&
                	!Label.lblPDFProductExportComex.equals(OLI.ProductCode))){
                        system.debug('isPlazoNotEmpty');
                        //isPlazoNotEmpty
                        OLI.cpliq_Periodicidad__c=OLI.cpliq_Periodicidad__c==null?'01':OLI.cpliq_Periodicidad__c;
                        OLI.cpliq_Fecha_Vencimiento__c= OLI.cpliq_Periodicidad__c=='01'?	Date.ValueOf(OLI.LastModifiedDate).addDays(Integer.valueOf(OLI.gipr_Plazo__c)):
                        OLI.cpliq_Periodicidad__c=='02'?Date.ValueOf(OLI.LastModifiedDate).ADDMONTHS(Integer.valueOf(OLI.gipr_Plazo__c)):
                        Date.ValueOf(OLI.LastModifiedDate).ADDMONTHS(Integer.valueOf(OLI.gipr_Plazo__c*12));
                    }
            else
                    if((String.isEmpty(String.valueOf(OLI.cpliq_n__c)) && !String.isEmpty(String.valueOf(OLI.cpliq_Fecha_Vencimiento__c )))&&
                   (!Label.lblPDFProductImport.equals(OLI.ProductCode)&&
                    !Label.lblPDFProductCartaTecnicaImport.equals(OLI.ProductCode)&&
                    !Label.lblPDFProductCartaTecnicaEconomica.equals(OLI.ProductCode)&&
                    !Label.lblPDFProductForfaitingImport.equals(OLI.ProductCode)&&
                    !Label.lblPDFProductPrestamoLP.equals(OLI.ProductCode)&&
                    !Label.lblPDFProductLeasing.equals(OLI.ProductCode))){
																			 
                        //isDateDueNotEmpty 
                        system.debug('isDateDueNotEmpty');
                        OLI.cpliq_Periodicidad__c='01';
                        OLI.cpliq_n__c=system.math.abs(Integer.ValueOf(Date.valueOf(OLI.cpliq_Fecha_Vencimiento__c).daysBetween(Date.valueOf(OLI.LastModifiedDate))));
                        
                    }
            else
                if((String.isEmpty(String.valueOf(OLI.cpliq_n__c))&&
                    !String.isEmpty(String.valueOf(OLI.cpliq_Fecha_Vencimiento__c )))&&
                   (Label.lblPDFProductPrestamoLP.equals(OLI.ProductCode)||Label.lblPDFProductLeasing.equals(OLI.ProductCode)) ){
                       system.debug('isDateDueNotEmpty3');
                       //isDateDueNotEmpty3
                       OLI.cpliq_Periodicidad__c='02';
                       OLI.cpliq_n__c=system.math.abs(Integer.ValueOf((Date.ValueOf(OLI.LastModifiedDate).daysBetween(Date.valueOf(OLI.cpliq_Fecha_Vencimiento__c)))/30));
                       
                   } 
            else
                if(!String.isEmpty(String.valueOf(OLI.cpliq_n__c))&&
                   (Label.lblPDFProductImportComex.equals(OLI.ProductCode)||
                	Label.lblPDFProductExportComex.equals(OLI.ProductCode)||
                    Label.lblPDFProductCommercialLoanCP.equals(OLI.ProductCode))){
                       system.debug('isDateDueNotEmpty41');
                       //isDateDueNotEmpty3
                       OLI.cpliq_Fecha_Vencimiento__c =OLI.cpliq_Periodicidad__c=='01'?
                           (Date.valueOf(OLI.LastModifiedDate).addDays(Integer.valueOf(OLI.cpliq_n__c))):
                       (Date.valueOf(OLI.LastModifiedDate).addMonths(Integer.valueOf(OLI.cpliq_n__c)));
                           }
            else
                if( !String.isEmpty(String.valueOf(OLI.cpliq_n__c))&&
                   !String.isEmpty(String.valueOf(OLI.cpliq_Periodicidad__c))&&
                   (Label.lblPDFProductPrestamoLP.equals(OLI.ProductCode)||Label.lblPDFProductLeasing.equals(OLI.ProductCode))){
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
}