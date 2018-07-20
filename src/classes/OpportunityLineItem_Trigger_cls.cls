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
            List<fprd__GBL_Guarantee__c> row =[SELECT Id FROM fprd__GBL_Guarantee__c WHERE Product__c=: Opps_New[0].Product2Id and Opportunity__c=: Opps_New[0].OpportunityId and  isMaster__c=true];
            System.debug(Opps_New[0].gipr_Garantia__c);
            if(row.isEmpty())
            {
                fprd__GBL_Guarantee__c nRow = new fprd__GBL_Guarantee__c();
                nRow.Product__c=Opps_New[0].Product2Id;
                nRow.fprd__GBL_Opportunity_product__c=Opps_New[0].OpportunityId;
                nRow.Opportunity__c=Opps_New[0].OpportunityId;
                nRow.GuaranteeType__c=Opps_New[0].gipr_Tipo_Garantia__c;
                nRow.Guarantee__c=Opps_New[0].gipr_Garantia__c;
                nRow.isMaster__c=true;
                insert nRow;
            }
            else
            {
                row[0].GuaranteeType__c=Opps_New[0].gipr_Tipo_Garantia__c;
                row[0].Guarantee__c=Opps_New[0].gipr_Garantia__c;
                update row;
            }        
    

        }
        else
        {
            List<fprd__GBL_Guarantee__c> row =[SELECT Id FROM fprd__GBL_Guarantee__c WHERE Product__c=: Opps_New[0].Product2Id and Opportunity__c=: Opps_New[0].OpportunityId and  isMaster__c=true LIMIT 1];
            
            if(!row.isEmpty())delete row;
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
            List<fprd__GBL_Intervener__c> row =[SELECT Id FROM fprd__GBL_Intervener__c WHERE Product__c=: listRow[0].Product2Id and Opportunity__c=: listRow[0].OpportunityId and  isMaster__c=true];
            if(row.isEmpty())
            {
                fprd__GBL_Intervener__c nRow = new fprd__GBL_Intervener__c();
                nRow.Product__c=listRow[0].Product2Id;
                nRow.Opportunity__c=listRow[0].OpportunityId; 
                nRow.fprd__GBL_Opportunity_product__c=listRow[0].OpportunityId;    
                nRow.Name=opName[0].Account.Name;
                nRow.Participation__c='01';
          nRow.DOI__c='01';
          nRow.N_DOI__c=opName[0].Account.AccountNumber;
          nRow.Marital_Status__c='04';
          nRow.isMaster__c=true;
                insert nRow;
            }
            else
            {
                row[0].Name=opName[0].Account.Name;             
            row[0].Participation__c='01';
            row[0].DOI__c='01';
            row[0].Marital_Status__c='04';
            row[0].N_DOI__c=opName[0].Account.AccountNumber;
                update row;
            }   

    } 
}