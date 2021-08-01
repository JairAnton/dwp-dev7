/*  Triiger del objeto Calce Details*/
public without sharing  class CalceDetails_Trigger_cls {    

    /*  Private method */
    private CalceDetails_Trigger_cls(){
	// ...
  }


	public static void createNewCalceDetails(List<Calce_Details__c> triggerNew, Map<Id, Calce_Details__c> triggerOldMap) {
        /*  Lista de IDs de los owners de cada calce__c  */
		/*Final Set<Id> ownersId = new Set<Id>();*/
        /*  Mapa para verificar si hay calces details pendientes de actualizaciòn y los actualiza  */
    	Final Map<Id, Decimal> verifyCDMap = new Map<Id, Decimal>();
        /*  Mapa para verificar si hay nuevos calces details y los inserta en mañana (tambien le crea opportunity & product) */
        /*Final Map<Id, Decimal> calceDetailMapToInsert = new Map<Id, Decimal>();*/
        Final Map<Id, Decimal> oppMapToUpdate = new Map<Id, Decimal>();
        
        /* Para cada calce detail nuevo, obtener la versiòn anterior y validar el cumplimiento de las condiciones    */
        for(Calce_Details__c item : triggerNew) {
            final Calce_Details__c oldItem = triggerOldMap.get(item.Id);
            
            if(item.sub_type__c == '01' && oldItem.amount_cancelled__c <> item.amount_cancelled__c) {
                verifyCDMap.put(item.Id, item.Pending_amount__c);
                
            }
        }
		/*  Si el mapa de calce details tiene registros, entonces actualiza el padre  */
        if(verifyCDMap.size() > 0) {
            updateParent(verifyCDMap, oppMapToUpdate, triggerOldMap);
        } 
    }

    private static void updateParent(Map<Id, Decimal> verifyCDMap, Map<Id, Decimal> oppMapToUpdate, Map<Id, Calce_Details__c> triggerOldMap) {
       
     /*  Lista que obtiene los calcedetails originales y revisa si estan dentro del mapa a actualizar  */  
        final List<Calce_Details__c> parentCDList = [SELECT Id, Name, calce_id__c, ParentCD__c, opportunity_id__c, calce_id__r.OwnerId
                             FROM Calce_Details__c WHERE ParentCD__c IN : verifyCDMap.keySet()];
	 /*  Lista que obtiene los calcedetails originales y revisa si estan dentro del mapa a actualizar  */ 	
        for(Calce_Details__c item : parentCDList) {
             /*  Lista que obtiene los calcedetails originales y revisa si estan dentro del mapa a actualizar
                 Ademàs, la condicional setea los nuevos valores del monto cancellado (para que figure en la tabla)  */
            if(verifyCDMap.containsKey(item.ParentCD__c)){
               final Decimal amountCancelled = verifyCDMap.get(item.ParentCD__c);
                item.amount_cancelled__c = amountCancelled;
                item.amount__c = amountCancelled;
                /*  coloca el id de la oportunidad y el monto cancelado dentro del mapa oppMapToUpdate  */
                oppMapToUpdate.put(item.opportunity_id__c, amountCancelled);
                verifyCDMap.remove(item.ParentCD__c);
            }
        }
         /*  Si se tiene registros en la lista de calce details originales, entonces los actualiza  */
        if(parentCDList.size() > 0) {
			update parentCDList;            
        }
        
        /*  Lista las oportunidades que tienen el Id dentro del mapa oppMapTopUpdate (que contienen las opp a actualizar)  */
        final List<Opportunity> oppListToUpdate = [SELECT Id, Amount FROM Opportunity WHERE Id IN : oppMapToUpdate.keySet()];
        
        /*  Setea el valor de los montos para cada oportunidad que se deba actualizar  */
        for(Opportunity opp : oppListToUpdate) { 
           final Decimal amountCancelled = oppMapToUpdate.get(opp.Id);
            opp.Amount = amountCancelled;
        }
        
        validateOpportunities(oppListToUpdate, verifyCDMap, triggerOldMap);
    }
    
    private static void validateOpportunities(List<Opportunity> oppListToUpdate, Map<Id, Decimal> verifyCDMap, Map<Id, Calce_Details__c> triggerOldMap) {
        if(oppListToUpdate.size() > 0) {
            update oppListToUpdate;
        }
        /*  Lista de calce donde la fecha de cierre es mañana, y el owner es el current user  */
        Final List<Calce__c> calceList = [SELECT Id, Name, OwnerId, close_date__c FROM Calce__c
                                    WHERE OwnerId =: UserInfo.getUserId() AND close_date__c =: Date.today().addDays(1) LIMIT 1];
        /*  Mapa de Calce Details y IDs que selecciona la data que prevalece desde el calce detail antiguo al nuevo */
        Final Map<Id, Calce_Details__c> calceDetailOldList = new Map<Id, Calce_Details__c>([SELECT Id, Name, opportunity_id__c,
         opportunity_id__r.Pricebook2Id, opportunity_id__r.opportunity_product__c, opportunity_id__r.opportunity_product_family__c
                                                                 FROM Calce_Details__c WHERE Id IN : verifyCDMap.keySet()]); 
        
        /*  Mapa de oportunidades a insertar  */
        Final Map<Id, Opportunity> oppCDInsert= new Map<Id, Opportunity>();
        /*  Mapa de Calce Detail a insertar   */
		Final Map<Id, Calce_Details__c> nCDIn= new Map<Id, Calce_Details__c>();
        /*  Mapa de Olis a insertar           */
        Final Map<Id, OpportunityLineItem> nOpItemIn = new Map<Id, OpportunityLineItem>();
        
        Id calceId = null;
            
        if(calceList.size() > 0) {
            calceId = calceList[0].Id;
        }
        
        for(Id item : verifyCDMap.keySet()) {
            final Calce_Details__c oldItem = triggerOldMap.get(item);
            final Calce_Details__c oldRelatedItem = calceDetailOldList.get(item);
         	final Decimal amountCancelled = verifyCDMap.get(item);
            
            /*  Setear valores de la oportunidad  */
            final Opportunity newOpp = new Opportunity();
            newOpp.AccountId = oldItem.account_id__c; newOpp.Amount = amountCancelled; newOpp.CloseDate = Date.today().addDays(1); newOpp.CurrencyIsoCode = oldItem.CurrencyIsoCode; newOpp.Name = oldItem.Name; newOpp.StageName = '02'; newOpp.Type = '01'; newOpp.opportunity_planning_date__c = Date.today().addDays(1); newOpp.opportunity_origin_name__c = '01'; newOpp.Field_Sup_Closing_Date__c = Date.today().addDays(1); newOpp.Pricebook2Id = oldRelatedItem.opportunity_id__r.Pricebook2Id; newOpp.opportunity_product__c = oldRelatedItem.opportunity_id__r.opportunity_product__c; newOpp.opportunity_product_family__c = oldRelatedItem.opportunity_id__r.opportunity_product_family__c;
            oppCDInsert.put(item, newOpp);
            
            /*  Setear valores de la OLI  */
            final OpportunityLineItem newOppItem = new OpportunityLineItem();
            newOppItem.Product2Id = oldItem.product_id__c; newOppItem.Quantity = 1; nOpItemIn.put(item, newOppItem);
            
            /*  Setear valores al Calce Detail hijo  */
            final Calce_Details__c newDetail = new Calce_Details__c();
            newDetail.CheckDate__c = true; newDetail.Name = oldItem.Name; newDetail.ParentCD__c = item; newDetail.account_id__c = oldItem.account_id__c; newDetail.amount__c = amountCancelled; newDetail.amount_cancelled__c = amountCancelled; newDetail.calce_id__c =  calceId; newDetail.close_date__c = Date.today().addDays(1); newDetail.product_code__c = oldItem.product_code__c; newDetail.product_id__c = oldItem.product_id__c; newDetail.product_name__c = oldItem.product_name__c; newDetail.sub_type__c = '02'; newDetail.type__c = oldItem.type__c;
			nCDIn.put(item, newDetail);
        }
        
        if(oppCDInsert.size() > 0) {
            insert oppCDInsert.values();
        }          
        /* Enlaza las oportunidades con los Calce Details   */
        mapOpportunityWithCalceDetails(verifyCDMap, oppCDInsert, nCDIn, nOpItemIn);
    }
    
        /* Enlaza las oportunidades con los Calce Details   */
    private static void mapOpportunityWithCalceDetails(Map<Id, Decimal> verifyCDMap, Map<Id, Opportunity> oppCDInsert, Map<Id, Calce_Details__c> nCDIn, Map<Id, OpportunityLineItem> nOpItemIn) {
        for(Id item : verifyCDMap.keySet()) { 
            final Opportunity opp = oppCDInsert.get(item);
            final Calce_Details__c calceDetail = nCDIn.get(item);
            final OpportunityLineItem oppItem = nOpItemIn.get(item);
            
            oppItem.OpportunityId = opp.Id;
            calceDetail.opportunity_id__c = opp.Id;
        }
        
        if(nCDIn.size() > 0) {
        	insert nCDIn.values();    
        }
        
        if(nOpItemIn.size() > 0) {
            insert nOpItemIn.values();
        }
        
    }
}