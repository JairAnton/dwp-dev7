/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_Calce_Delete_BS>
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-06-21
   @Description Schedulable class from BE_Calce_Delete_Batch
   @Changes
   Date        Author   Email                  				Type
   2020-06-21  MAMC     martin.mori.contractor@bbva.com    	Creation
   -------------------------------------------------------------------------------------------------
 */
public without sharing class BE_Calce_Create_Batch implements Database.Batchable<sObject>, Database.Stateful {
    /*date used to process*/
    public final Date dateCalEnd;
    /*date used to process*/
    public final Date dateCalStart;
    /*date map of months*/
    public final Map<Integer, String> nameMonth = new Map<Integer, String>();
    /*date map of months*/
    private final static String STRDAY = 'Mon';
    
    /**
    @Description constructor method
	@param Date date used to create calce
    */
    public BE_Calce_Create_Batch(Date dateCal) {
        this.dateCalEnd = dateCal;
        final DateTime myDateTime = ((DateTime) this.dateCalEnd).addHours(5);
        if(myDateTime.format('E')==STRDAY) {
            this.dateCalStart = this.dateCalEnd.addDays(-2);
        } else {
            this.dateCalStart = this.dateCalEnd;
        }
    }
    
    /**
    @Description constructor method
    */
    public BE_Calce_Create_Batch() {
        this.dateCalEnd = Date.Today();
        final DateTime myDateTime = ((DateTime) this.dateCalEnd).addHours(5);
        if(myDateTime.format('E')==STRDAY) {
            this.dateCalStart = this.dateCalEnd.addDays(-2);
        } else {
            this.dateCalStart = this.dateCalEnd;
        }
    }

    /**
    @Description start method
    @param Database.BatchableContext BatchableContextof batch
    @return Database.QueryLocator QueryLocator result query of executive users
    */
    public Database.QueryLocator start(Database.BatchableContext context) {
        nameMonth.put(1,'Enero ');
        nameMonth.put(2,'Febrero ');
        nameMonth.put(3,'Marzo ');
        nameMonth.put(4,'Abril ');
        nameMonth.put(5,'Mayo ');
        nameMonth.put(6,'Junio ');
        nameMonth.put(7,'Julio ');
        nameMonth.put(8,'Agosto ');
        nameMonth.put(9,'Septiembre ');
        nameMonth.put(10,'Octubre ');
        nameMonth.put(11,'Noviembre ');
        nameMonth.put(12,'Diciembre ');
        String query;
        if(Test.isRunningTest()) {
            query = 'SELECT Id, Name, ManagerId, prof_position_id__c FROM User WHERE IsActive = TRUE AND Profile.Name = \'Ejecutivo\' AND prof_position_id__c IN (\'E03\', \'I32\',\'E01\', \'I21\') LIMIT 10';
        } else {
            query = 'SELECT Id, Name, ManagerId, prof_position_id__c FROM User WHERE IsActive = TRUE AND Profile.Name = \'Ejecutivo\' AND prof_position_id__c IN (\'E03\', \'I32\',\'E01\', \'I21\')';
        }
        return Database.getQueryLocator(query);
    }

    /**
    @Description execute method
    @param Database.BatchableContext BatchableContextof batch
	@param List<User> list of users
    */
    public void execute(Database.BatchableContext context, List<User> lstUser) {
        Map<Id, Decimal> mapGroupingRisk = new Map<Id, Decimal>();
        Map<Id, Decimal> mapGroupingCP   = new Map<Id, Decimal>();
        Map<Id, Decimal> mapGroupingLP   = new Map<Id, Decimal>();
        Map<Id, Decimal> mapGroupingRE   = new Map<Id, Decimal>();
        for(User usr : lstUser) {
            mapGroupingRisk.put(usr.Id, 0);
            mapGroupingCP.put(usr.Id, 0);
            mapGroupingLP.put(usr.Id, 0);
            mapGroupingRE.put(usr.Id, 0);
        }
        for(dwp_frct__grouping__c grouping : [SELECT Id, dwp_frct__management_plan_id__r.OwnerId, dwp_frct__original_commitment_amount__c, dwp_frct__solution_category_type__c FROM dwp_frct__grouping__c WHERE dwp_frct__management_plan_id__r.OwnerId IN :mapGroupingRisk.keySet() AND dwp_frct__solution_category_type__c IN ('Riesgo de firma','Financiamiento a corto plazo','Financiamiento a largo plazo','Recursos')
                                              AND CALENDAR_YEAR(dwp_frct__management_plan_id__r.dwp_frct__management_plan_end_date__c) = :dateCalEnd.year() AND CALENDAR_MONTH(dwp_frct__management_plan_id__r.dwp_frct__management_plan_end_date__c) = :dateCalEnd.month()]) 
                                              {  mapGroupingRisk = setMaps(mapGroupingRisk, grouping);
                                                  mapGroupingCP = setMaps(mapGroupingCP, grouping);
                                                  mapGroupingLP = setMaps(mapGroupingLP, grouping);
                                                  mapGroupingRE = setMaps(mapGroupingRE, grouping); }
        final List<Calce__c> ltsCalce = new List<Calce__c>();
        for(User usr : lstUser) {
            Final Calce__c calce = new Calce__c();
            calce.Name = nameMonth.get(dateCalEnd.month())+String.valueOf(dateCalEnd.day()).leftPad(2, '0')+'-'+dateCalEnd.year()+' - '+usr.Name;
            calce.OwnerId = usr.Id;
            if(usr.prof_position_id__c == 'E01') { calce.manager_id__c = calce.ownerid; } 
            else if (usr.prof_position_id__c == 'I21') { calce.manager_id__c = calce.ownerid;}
            else {calce.manager_id__c = usr.ManagerId;}
            calce.close_date__c          = dateCalEnd;
            calce.start_date__c          = dateCalStart;
            calce.status__c              = 'Iniciado';
            calce.Indirect_commitment__c = mapGroupingRisk.get(usr.Id);
            calce.Direct_commitment__c   = mapGroupingCP.get(usr.Id)+mapGroupingLP.get(usr.Id);
            calce.Resource__c            = mapGroupingRE.get(usr.Id);
            ltsCalce.add(calce);
        }
         insert ltsCalce;
        final Map<Id,Id> mapCalce = new Map<Id,Id>();
        for(Calce__c calce : ltsCalce) { mapCalce.put(calce.OwnerId, calce.Id); }
        final List<Calce__Share> ltsCalceShr  = new List<Calce__Share>();
        for(User_Assistant_Team__c assistant : [SELECT assistant_id__c, user_id__c FROM User_Assistant_Team__c WHERE user_id__c = :mapGroupingRisk.keySet() AND assistant_id__r.IsActive = TRUE]) {
            final Calce__Share calceShr  = new Calce__Share();
            calceShr.ParentId = mapCalce.get(assistant.user_id__c);
            calceShr.UserOrGroupId = assistant.assistant_id__c;
            calceShr.AccessLevel = 'Edit';
            ltsCalceShr.add(calceShr);
        }
        if(!ltsCalceShr.isEmpty()) { insert ltsCalceShr; }
    } 

    /**
    @Description finish method
	*/
    public void finish(Database.BatchableContext context) {
        
    }
    
    /**
    @Description set maps to groupings
	*/
    public Map<Id, Decimal> setMaps(Map<Id, Decimal> mapGrouping, dwp_frct__grouping__c grouping) {
        Map<Id, Decimal> mapReturn = mapGrouping;
        if(grouping.dwp_frct__solution_category_type__c  == 'Riesgo de firma'  && grouping.dwp_frct__original_commitment_amount__c>0) {
            mapReturn.put(grouping.dwp_frct__management_plan_id__r.OwnerId, grouping.dwp_frct__original_commitment_amount__c);
        } else if(grouping.dwp_frct__solution_category_type__c == 'Financiamiento a corto plazo' && grouping.dwp_frct__original_commitment_amount__c>0) {
            mapReturn.put(grouping.dwp_frct__management_plan_id__r.OwnerId, grouping.dwp_frct__original_commitment_amount__c);
        } else if(grouping.dwp_frct__solution_category_type__c == 'Financiamiento a largo plazo' && grouping.dwp_frct__original_commitment_amount__c>0) {
            mapReturn.put(grouping.dwp_frct__management_plan_id__r.OwnerId, grouping.dwp_frct__original_commitment_amount__c);
        } else if(grouping.dwp_frct__solution_category_type__c == 'Recursos'                     && grouping.dwp_frct__original_commitment_amount__c>0) {
            mapReturn.put(grouping.dwp_frct__management_plan_id__r.OwnerId, grouping.dwp_frct__original_commitment_amount__c);
        }
        return mapReturn;
    }



}