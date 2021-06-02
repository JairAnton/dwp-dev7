/*
   @Autor: Arsenio Perez Lopez
   @Proyect: BBVA PERU
   @Version:1
   @Changes
   Date        Author   Email                  				Type		Description
            ISV												Creation
   2020-07-14  MAMC     martin.mori.contractor@bbva.com    	Modify		add call to method setProductVersion
   2021-06-02  JOAA		jair.anton.contractor@bbva.com		Modify		add call to method validateOppCancellation
 */
public class PE_OpportunityLITTriggerHandler extends TriggerHandler {
	list<OpportunityLineItem> Opps_New = Trigger.new;
	list<OpportunityLineItem> Opps_Old = Trigger.Old;
	Map<id, OpportunityLineItem> Opps_NewMap = ((Map<Id, OpportunityLineItem>)(Trigger.NewMap));
	Map<id, OpportunityLineItem> Opps_OldMap = ((Map<Id, OpportunityLineItem>)(Trigger.OldMap));

	public Override void beforeInsert() {
		new OpportunityLineItem_Trigger_cls().AsignBeforeInsert(Opps_New);
		new OpportunityLineItem_Trigger_cls().updateDateLine(Opps_New);
		new OpportunityLineItem_Trigger_cls().addProductVersion(Opps_New);
        OpportunityLineItemHelper_Trigger_cls.validateOppCancellation(Opps_New);
	}

	public Override void beforeUpdate() {
		new OpportunityLineItem_Trigger_cls().updateDateLine(Opps_New);
	}

	public Override void afterInsert() {
		new OpportunityLineItem_Trigger_cls().updateNameFamilyProduct();
		new OpportunityLineItem_Trigger_cls().MasteRecord_Guarantee(Opps_New);
		new OpportunityLineItem_Trigger_cls().upsertMasterParticipant();
	}

	public Override void afterUpdate() {
		new OpportunityLineItem_Trigger_cls().MasteRecord_Guarantee(Opps_New);
		//new OpportunityLineItem_Trigger_cls().UpdateCaseAnalist(Opps_New,Opps_NewMap,Opps_OldMap);
	}
    
	public Override void afterDelete() {
		new OpportunityLineItem_Trigger_cls().deleteOppSolComm(Opps_OldMap);
	}
}