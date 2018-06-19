/*
@Autor: Arsenio Perez Lopez
@Proyect: BBVA PERU
@Version:1
@HIstorial de cambios:
- Creacion del Handler
*/
public class PE_OpportunityLITTriggerHandler extends TriggerHandler {
    
    list<OpportunityLineItem>Opps_New = Trigger.new;
    //list<OpportunityLineItem>Opps_Old = Trigger.Old;
    //Map<id,OpportunityLineItem>Opps_NewMap = ((Map<Id,OpportunityLineItem>)(Trigger.NewMap));
    //Map<id,OpportunityLineItem>Opps_OldMap = ((Map<Id,OpportunityLineItem>)(Trigger.OldMap));
    
    public Override void beforeInsert(){
        new OpportunityLineItem_Trigger_cls().AsignBeforeInsert(Opps_New);
    }
}