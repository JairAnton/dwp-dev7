/*
@Autor: Arsenio Perez Lopez
@Proyect: BBVA PERU
@Version:1
@HIstorial de cambios:
- Creacion del Handler
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
                if(OLI.UnitPrice==null )
                    OLI.TotalPrice=OportunidadMAp.get(OLI.OpportunityId).Amount;
            }
        }
    }
}