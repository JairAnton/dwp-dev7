public class OpportunityChatterNotifications {
    public static void statusChangeNotification(list<Opportunity> Opps_New, Map<id,Opportunity> Opps_NewMap, Map<id,Opportunity> Opps_OldMap){       
        if(!Opps_New.isEmpty()) {
            Id userId = UserInfo.getUserId();
            //recorrer las opportunidades y comprobar las oportunidades que hayan cambiado de estado
            List<Opportunity> oppStatusChangedList =new List<Opportunity>();
            for(Opportunity oppNew : Opps_New){
                if(oppNew.opportunity_status_type__c != Opps_OldMap.get(oppNew.Id).opportunity_status_type__c){                    
                    oppStatusChangedList.add(oppNew);
                }
            }
            List<Id> status10 = new List<Id>();
            List<Id> status13 = new List<Id>();
            List<Id> status19 = new List<Id>();
            List<Id> status23 = new List<Id>();
            List<Id> status12 = new List<Id>();
            List<Id> status24 = new List<Id>();
            List<Id> status18 = new List<Id>();
            List<Id> status17 = new List<Id>();
            List<Id> status08 = new List<Id>();
            List<Id> status11 = new List<Id>();
            List<Id> status09 = new List<Id>();
            List<Id> status22 = new List<Id>();
            List<Id> status21 = new List<Id>();
            List<Id> status20 = new List<Id>();
            for(Opportunity oppChanged : oppStatusChangedList) {
                switch on oppChanged.opportunity_status_type__c {
                    when '10'{
                        status10.add(oppChanged.ID);                 
                    }
                    when '13'{
                        status13.add(oppChanged.ID);                 
                    }
                    when '19'{
                        status19.add(oppChanged.ID);                      
                    }
                    when '23'{
                        status23.add(oppChanged.ID);                  
                    }
                    when '12'{
                        status12.add(oppChanged.ID);                   
                    }
                    when '24'{
                        status24.add(oppChanged.ID);                   
                    }
                    when '18'{
                        status18.add(oppChanged.ID);
                    }
                    when '17'{
                        status17.add(oppChanged.ID);                
                    }
                    when '08'{
                        status08.add(oppChanged.ID);                 
                    }
                    when '11'{
                        status11.add(oppChanged.ID);                 
                    }
                    when '09'{
                        status09.add(oppChanged.ID);                      
                    }
                    when '22'{
                        status22.add(oppChanged.ID);                  
                    }
                    when '21'{
                        status21.add(oppChanged.ID);                  
                    }
                    when '20'{
                        status20.add(oppChanged.ID);                  
                    }
                }
            }
            if(!status10.isEmpty()){
                DynamicBatchChatterNotification.getDynamicBatchChatterNotification(status10, 'Opportunity', 'AUTHORIZE_PRICE');
            }
            if(!status13.isEmpty()){
                DynamicBatchChatterNotification.getDynamicBatchChatterNotification(status13, 'Opportunity', 'DENIED_PRICE');
            }
            if(!status19.isEmpty()){
               /* DynamicBatchChatterNotification.getDynamicBatchChatterNotification(status19, 'Opportunity', 'SENT_FORMALIZATION_OPERATIVE');
                DynamicBatchChatterNotification.getDynamicBatchChatterNotification(status19, 'Opportunity', 'SENT_FORMALIZATION');*/
            }
            if(!status23.isEmpty()){
                //DynamicBatchChatterNotification.getDynamicBatchChatterNotification(status23, 'Opportunity', 'FORMALIZE');
            }
            if(!status12.isEmpty()){
                DynamicBatchChatterNotification.getDynamicBatchChatterNotification(status12, 'Opportunity', 'SENT_PRICE_REEVALUATION');
            }
            if(!status24.isEmpty()){
                DynamicBatchChatterNotification.getDynamicBatchChatterNotification(status24, 'Opportunity', 'SENT_RISK_REEVALUATION');
            }
            if(!status18.isEmpty()){
                DynamicBatchChatterNotification.getDynamicBatchChatterNotification(status18, 'Opportunity', 'APPROVE_RISK_DELEGATION');
            }
            if(!status17.isEmpty()){
                DynamicBatchChatterNotification.getDynamicBatchChatterNotification(status17, 'Opportunity', 'APPROVE_RISK');
            }
            if(!status08.isEmpty()){
                DynamicBatchChatterNotification.getDynamicBatchChatterNotification(status08, 'Opportunity', 'APPROVE_PRICE_DELEGATION');
            }
            if(!status11.isEmpty()){
                DynamicBatchChatterNotification.getDynamicBatchChatterNotification(status11, 'Opportunity', 'APPROVE_PRICE');
            }
            if(!status09.isEmpty()){
                DynamicBatchChatterNotification.getDynamicBatchChatterNotification(status09, 'Opportunity', 'SENT_PRICE_APPROVAL');
            }
            if(!status22.isEmpty()){
                DynamicBatchChatterNotification.getDynamicBatchChatterNotification(status22, 'Opportunity', 'REJECT');
            }
            if(!status21.isEmpty()){
               // DynamicBatchChatterNotification.getDynamicBatchChatterNotification(status21, 'Opportunity', 'SENT_PRODUCT_UNIT');
            }
            if(!status20.isEmpty()){
                //DynamicBatchChatterNotification.getDynamicBatchChatterNotification(status20, 'Opportunity', 'DENIED_FORMALIZATION');
            }
        }
    }
    
    public static void ownerChangeNotification(list<Opportunity> Opps_New, Map<id,Opportunity> Opps_NewMap, Map<id,Opportunity> Opps_OldMap){
        //Recorrer oportunidades lista new y comprobar en que opp ha cambiado el owner
        List<Id> oppOwnerChangedId = new List<Id>();
        if(!Opps_New.isEmpty()) {
            for(Opportunity oppNew : Opps_New) {
                //para los que ha cambiado el owner se mete un una lista sus ids
                if(oppNew.OwnerId != Opps_OldMap.get(oppNew.Id).OwnerId) {
                    oppOwnerChangedId.add(oppNew.Id);
                }
        	}
            //con la lista de ids llamamos a la clase de notificaciones
            if(!oppOwnerChangedId.isEmpty()) {
                DynamicBatchChatterNotification.getDynamicBatchChatterNotification(oppOwnerChangedId, 'Opportunity', 'OPP_CHANGE_OWNER');
            } 
            
        }
    }
    
    public static void notificationMethods(list<Opportunity> Opps_New, Map<id,Opportunity> Opps_NewMap, Map<id,Opportunity> Opps_OldMap) {
        
        List<Opportunity> oppIsProcessTrueId = new List<Opportunity>();
        for(Opportunity opp : Opps_New) {
            if(opp.isProcess__c == true) {
                oppIsProcessTrueId.add(opp);
            }
        }
        
        statusChangeNotification(oppIsProcessTrueId, Opps_NewMap, Opps_OldMap);        
        ownerChangeNotification(Opps_New, Opps_NewMap, Opps_OldMap);

    }
}