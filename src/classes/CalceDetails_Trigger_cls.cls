public without sharing  class CalceDetails_Trigger_cls {     

/*  Metodo para crear nuevos Calces Details, el cual recibe una lista de los Calce Details que disparan el trigger
    tanto antes como despues de hacer la actualizaciòn                                                               */

	public static void createNewCalceDetails(List<Calce_Details__c> triggerNew, Map<Id, Calce_Details__c> triggerOldMap) {
        /*  Lista de IDs de los owners de cada calce__c  */
		Final Set<Id> ownersId = new Set<Id>();
        /*  Mapa para verificar si hay calces details pendientes de actualizaciòn y los actualiza  */
    	Final Map<Id, Decimal> verifyCalceDetailMap = new Map<Id, Decimal>();
        /*  Mapa para verificar si hay nuevos calces details y los inserta en mañana (tambien le crea opportunity & product) */
        Final Map<Id, Decimal> calceDetailMapToInsert = new Map<Id, Decimal>();
        Final Map<Id, Decimal> oppMapToUpdate = new Map<Id, Decimal>();
        
        /* Para cada calce detail nuevo, obtener la versiòn anterior y validar el cumplimiento de las condiciones    */
        for(Calce_Details__c item : triggerNew) {
            Calce_Details__c oldItem = triggerOldMap.get(item.Id);
            
            if(item.sub_type__c == '01' && oldItem.amount_cancelled__c <> item.amount_cancelled__c) {
                verifyCalceDetailMap.put(item.Id, item.Pending_amount__c);
                
            }
        }
		/*  Si el mapa de calce details tiene registros, entonces actualiza el padre  */
        if(verifyCalceDetailMap.size() > 0) {
            updateParent(verifyCalceDetailMap, oppMapToUpdate, triggerOldMap);
        } 
    }
    
    /*  Metodo que actualiza el calce detail original  */
    private static void updateParent(Map<Id, Decimal> verifyCalceDetailMap, Map<Id, Decimal> oppMapToUpdate, Map<Id, Calce_Details__c> triggerOldMap) {
       
     /*  Lista que obtiene los calcedetails originales y revisa si estan dentro del mapa a actualizar  */  
        List<Calce_Details__c> parentCalceDetailList = [SELECT Id, Name, calce_id__c, ParentCD__c, opportunity_id__c, calce_id__r.OwnerId
                             FROM Calce_Details__c WHERE ParentCD__c IN : verifyCalceDetailMap.keySet()];
	 /*  Lista que obtiene los calcedetails originales y revisa si estan dentro del mapa a actualizar  */ 	
        for(Calce_Details__c item : parentCalceDetailList) {
             /*  Lista que obtiene los calcedetails originales y revisa si estan dentro del mapa a actualizar
                 Ademàs, la condicional setea los nuevos valores del monto cancellado (para que figure en la tabla)  */
            if(verifyCalceDetailMap.containsKey(item.ParentCD__c)){
                Decimal amountCancelled = verifyCalceDetailMap.get(item.ParentCD__c);
                item.amount_cancelled__c = amountCancelled;
                item.amount__c = amountCancelled;
                /*  coloca el id de la oportunidad y el monto cancelado dentro del mapa oppMapToUpdate  */
                oppMapToUpdate.put(item.opportunity_id__c, amountCancelled);
                verifyCalceDetailMap.remove(item.ParentCD__c);
            }
        }
         /*  Si se tiene registros en la lista de calce details originales, entonces los actualiza  */
        if(parentCalceDetailList.size() > 0) {
			update parentCalceDetailList;            
        }
        
        /*  Lista las oportunidades que tienen el Id dentro del mapa oppMapTopUpdate (que contienen las opp a actualizar)  */
        List<Opportunity> oppListToUpdate = [SELECT Id, Amount FROM Opportunity WHERE Id IN : oppMapToUpdate.keySet()];
        
        /*  Setea el valor de los montos para cada oportunidad que se deba actualizar  */
        for(Opportunity opp : oppListToUpdate) { 
            Decimal amountCancelled = oppMapToUpdate.get(opp.Id);
            opp.Amount = amountCancelled;
        }
        
        validateOpportunities(oppListToUpdate, verifyCalceDetailMap, triggerOldMap);
    }
    
    private static void validateOpportunities(List<Opportunity> oppListToUpdate, Map<Id, Decimal> verifyCalceDetailMap, Map<Id, Calce_Details__c> triggerOldMap) {
        if(oppListToUpdate.size() > 0){
            update oppListToUpdate;
        }
        /*  Lista de calce donde la fecha de cierre es mañana, y el owner es el current user  */
        Final List<Calce__c> calceList = [SELECT Id, Name, OwnerId, close_date__c FROM Calce__c
                                    WHERE OwnerId =: UserInfo.getUserId() AND close_date__c =: Date.today().addDays(1) LIMIT 1];
        /*  Mapa de Calce Details y IDs que selecciona la data que prevalece desde el calce detail antiguo al nuevo */
        Final Map<Id, Calce_Details__c> calceDetailOldList = new Map<Id, Calce_Details__c>([SELECT Id, Name, opportunity_id__c,
         opportunity_id__r.Pricebook2Id, opportunity_id__r.opportunity_product__c, opportunity_id__r.opportunity_product_family__c
                                                                 FROM Calce_Details__c WHERE Id IN : verifyCalceDetailMap.keySet()]); 
        
        /*  Mapa de oportunidades a insertar  */
        Final Map<Id, Opportunity> oppCalceDetailToInsert = new Map<Id, Opportunity>();
        /*  Mapa de Calce Detail a insertar   */
		Final Map<Id, Calce_Details__c> newCalceDetailToInsert = new Map<Id, Calce_Details__c>();
        /*  Mapa de Olis a insertar           */
        Final Map<Id, OpportunityLineItem> newOppItemToInsert = new Map<Id, OpportunityLineItem>();
        
        Id calceId = null;
            
        if(calceList.size() > 0) {
            calceId = calceList[0].Id;
        }
        
        for(Id item : verifyCalceDetailMap.keySet()) {
            Calce_Details__c oldItem = triggerOldMap.get(item);
            Calce_Details__c oldRelatedItem = calceDetailOldList.get(item);
            
        	Decimal amountCancelled = verifyCalceDetailMap.get(item);
            
            /*  Setear valores de la oportunidad  */
            Opportunity newOpp = new Opportunity();
            newOpp.AccountId = oldItem.account_id__c;
            newOpp.Amount = amountCancelled;
            newOpp.CloseDate = Date.today().addDays(1);
            newOpp.CurrencyIsoCode = oldItem.CurrencyIsoCode;
            newOpp.Name = oldItem.Name;
            newOpp.StageName = '02';
            newOpp.Type = '01';
            newOpp.opportunity_planning_date__c = Date.today().addDays(1);
            newOpp.opportunity_origin_name__c = '01';
            newOpp.Field_Sup_Closing_Date__c = Date.today().addDays(1);
            newOpp.Pricebook2Id = oldRelatedItem.opportunity_id__r.Pricebook2Id;
            newOpp.opportunity_product__c = oldRelatedItem.opportunity_id__r.opportunity_product__c;
            newOpp.opportunity_product_family__c = oldRelatedItem.opportunity_id__r.opportunity_product_family__c;
            oppCalceDetailToInsert.put(item, newOpp);
            
            /*  Setear valores de la OLI  */
            OpportunityLineItem newOppItem = new OpportunityLineItem();
            newOppItem.Product2Id = oldItem.product_id__c;
            newOppItem.Quantity = 1;
            newOppItemToInsert.put(item, newOppItem);
            
            /*  Setear valores al Calce Detail hijo  */
            Calce_Details__c newDetail = new Calce_Details__c();
            newDetail.CheckDate__c = true;
            newDetail.Name = oldItem.Name;
            newDetail.ParentCD__c = item;
            newDetail.account_id__c = oldItem.account_id__c;
            newDetail.amount__c = amountCancelled;
            newDetail.amount_cancelled__c = amountCancelled;
            newDetail.calce_id__c =  calceId;
            newDetail.close_date__c = Date.today().addDays(1);
            newDetail.product_code__c = oldItem.product_code__c;
            newDetail.product_id__c = oldItem.product_id__c;
            newDetail.product_name__c = oldItem.product_name__c;
            newDetail.sub_type__c = '02';
            newDetail.type__c = oldItem.type__c;
            newCalceDetailToInsert.put(item, newDetail);
        }
        
        if(oppCalceDetailToInsert.size() > 0) {
            insert oppCalceDetailToInsert.values();
        }          
        /* Enlaza las oportunidades con los Calce Details   */
        mapOpportunityWithCalceDetails(verifyCalceDetailMap, oppCalceDetailToInsert, newCalceDetailToInsert, newOppItemToInsert);
    }
    
        /* Enlaza las oportunidades con los Calce Details   */
    private static void mapOpportunityWithCalceDetails(Map<Id, Decimal> verifyCalceDetailMap, Map<Id, Opportunity> oppCalceDetailToInsert, Map<Id, Calce_Details__c> newCalceDetailToInsert, Map<Id, OpportunityLineItem> newOppItemToInsert) {
        for(Id item : verifyCalceDetailMap.keySet()) { 
            Opportunity opp = oppCalceDetailToInsert.get(item);
            Calce_Details__c calceDetail = newCalceDetailToInsert.get(item);
            OpportunityLineItem oppItem = newOppItemToInsert.get(item);
            
            oppItem.OpportunityId = opp.Id;
            calceDetail.opportunity_id__c = opp.Id;
        }
        
        if(newCalceDetailToInsert.size() > 0) {
        	insert newCalceDetailToInsert.values();    
        }
        
        if(newOppItemToInsert.size() > 0) {
            insert newOppItemToInsert.values();
        }
        
    }
}