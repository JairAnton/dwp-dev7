/*
 * @Name: Opportunity_tgr
 * @Description: Trigger de Ejecucion Opportunity
 * @Create by: 
 * 
 * V0-Creacion
*/
public without sharing class Opportunity_Trigger_cls {
  
	/*
	*
	*/
    public void AsignBeforeInsert(list<Opportunity>Opps_New, Map<id,Opportunity>Opps_NewMap){
        date CDate;
        date PDate;
        for(Opportunity opp:Opps_New){
            if(opp.Type=='01'){	
                system.debug('Inicia el ejercicio');
                if(opp.opportunity_planning_date__c !=null) 
                    PDate = Date.valueOf(opp.opportunity_planning_date__c);
                if(opp.opportunity_planning_date__c !=null) 
                { 
                    opp.opportunity_planning_date__c=PDate;	
                    opp.opportunity_status_type__c = '02';
                } 
                else{ 
                    system.debug('');
                    if(!Test.isRunningTest())opp.opportunity_status_type__c = '03';
                }
                
                if(!String.isBlank(opp.Support_currency__c)) 
                {
                    system.debug('My PickList:'+ opp.Support_currency__c);
                    opp.CurrencyIsoCode=opp.Support_currency__c=='01'?'PEN':'USD';
                }
                if(opp.opportunity_planning_date__c !=null && opp.Field_Sup_Closing_Date__c==null) 
                    opp.CloseDate=PDate.addDays(45);			
                else if(opp.opportunity_planning_date__c==null && opp.Field_Sup_Closing_Date__c==null)
                    opp.CloseDate=Date.today().addDays(60);	
                
                system.debug('Finaliza con: '+opp);
            }
        }
    }
    public void AsignBeforeUpdate(list<Opportunity>Opps_New, Map<id,Opportunity>Opps_NewMap,
                                  list<Opportunity>Opps_Old, Map<id,Opportunity>Opps_OldMap){

            Valida(Opps_New,Opps_OldMap);
            
    }
    
    public void AsignAfterUpdate(List<Opportunity> lstNew, Map<Id,Opportunity> mapOld) {
        List <Id> lstId = new List <Id>();
        Date todayDate = Date.today();
        for (Opportunity opNew : lstNew){
            Opportunity oldRecord = mapOld.get(opNew.Id);
            if(opNew.opportunity_status_type__c != oldRecord.opportunity_status_type__c && (opNew.opportunity_status_type__c == '11' || opNew.opportunity_status_type__c == '08')){
                lstId.add(opNew.Id);                
            }            
        }
        if(!lstId.isEmpty()) {
            List<OpportunityLineItem> oliList = [select Id, price_quote_date__c from OpportunityLineItem where OpportunityId =:lstId];
            if(!oliList.isEmpty()){
                for(OpportunityLineItem oli : oliList) {
                    oli.price_quote_date__c = todayDate;
                }
            }
            update oliList;
            
            List<Opportunity_Solution_Commitment__c> oscList = [select Id, price_quote_date__c from Opportunity_Solution_Commitment__c where opportunity_id__c =:lstId];
            if(!oscList.isEmpty()){
                for(Opportunity_Solution_Commitment__c osc : oscList) {
                    osc.price_quote_date__c = todayDate;
                }
            }
            update oscList;
        }
        
    }
    
    /**/
    private void Valida(list<Opportunity>Opps_New, Map<id,Opportunity>Opps_OldMap){
        set<Id> IdOwners = new set<ID>();
        for(Opportunity oppnew: Opps_New)
            IdOwners.add(oppnew.OwnerId);
        for(Opportunity oppnold: Opps_OldMap.values())
            IdOwners.add(oppnold.OwnerId);
        Map<Id,User> MapUser = new Map <Id,User>();
        for(User us:[Select Id, Name, Profile.Name, UserRole.Name from User where Id IN: IdOwners])
        	MapUser.put(us.Id,us);
            
        for(Opportunity opp:Opps_New){
            
            if(opp.OwnerId!=Opps_OldMap.get(opp.Id).OwnerId && opp.StageName =='01' || 
               opp.StageName =='02'&& opp.StageName =='03'){
                if(MapUser.get(Opps_OldMap.get(opp.Id).OwnerID).Profile.Name=='Ejecutivo'||
                   MapUser.get(Opps_OldMap.get(opp.Id).OwnerID).UserRole.Name =='Ejecutivo'){
					if(MapUser.get(opp.OwnerId).Profile.Name !='Ejecutivo'&&
                       MapUser.get(opp.OwnerId).Profile.Name !='Especialista'){
                           Opp.addError('No es posible reasignar una Oportunidad a este tipo de gerente1');
                       }
                } else
				if(MapUser.get(Opps_OldMap.get(opp.Id).OwnerID).Profile.Name=='Especialista'|| 
                   MapUser.get(Opps_OldMap.get(opp.Id).OwnerID).UserRole.Name =='Especialista'){
                       if(MapUser.get(opp.OwnerId).Profile.Name !='Especialista'&&
                          MapUser.get(opp.OwnerId).Profile.Name !='Especialista' )
                           Opp.addError('No es posible reasignar una Oportunidad a este tipo de gerente2');                    
                } 
                   else if(MapUser.get(opp.OwnerId).Profile.Name=='Analista'||MapUser.get(opp.OwnerId).Profile.Name =='Operativo'){
                    Opp.addError('No es posible reasignar una Oportunidad a este tipo de gerente');   
                   }
               }
        }
    }
    

}