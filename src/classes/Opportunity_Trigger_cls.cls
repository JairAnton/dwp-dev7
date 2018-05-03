/*
 * @Name: Opportunity_tgr
 * @Description: Trigger de Ejecucion Opportunity
 * @Create by: 
 * 
 * V0-Creacion
*/
public without sharing class Opportunity_Trigger_cls {
  
    /**/
    //public void AsignBeforeInsert(list<Opportunity>Opps_New, Map<id,Opportunity>Opps_NewMap){

    //}
    /**/
    public void AsignBeforeUpdate(list<Opportunity>Opps_New, Map<id,Opportunity>Opps_NewMap,
                                  list<Opportunity>Opps_Old, Map<id,Opportunity>Opps_OldMap){

            Valida(Opps_New,Opps_OldMap);
            
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
            opp.isprocess__c = true;
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