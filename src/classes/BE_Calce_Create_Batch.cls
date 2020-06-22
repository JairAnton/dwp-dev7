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
global without sharing class BE_Calce_Create_Batch implements Database.Batchable<sObject>, Database.Stateful {
    /*date used to process*/
    global final Date dateCalEnd;
    /*date used to process*/
    global final Date dateCalStart;
    /*date map of months*/
    global final Map<Integer, String> nameMonth = new Map<Integer, String>();
    
    /**
    @Description constructor method
	@param Date date used to create calce
    */
    global BE_Calce_Create_Batch(Date dateCal) {
        this.dateCalEnd = dateCal;
        DateTime myDateTime = ((DateTime) this.dateCalEnd).addHours(5);
        if(myDateTime.format('E')=='Mon') {
            this.dateCalStart = this.dateCalEnd.addDays(-2);
        }
    }
    
    /**
    @Description constructor method
    */
    global BE_Calce_Create_Batch() {
        this.dateCalEnd = Date.Today();
        DateTime myDateTime = (DateTime) this.dateCalEnd;
        if(myDateTime.format('E')=='Mon') {
            this.dateCalStart = this.dateCalEnd.addDays(-2);
        }
    }

    /**
    @Description start method
    @param Database.BatchableContext BatchableContextof batch
    @return Database.QueryLocator QueryLocator result query of executive users
    */
    global Database.QueryLocator start(Database.BatchableContext BC) {
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
        if(Test.isRunningTest()) {
            return Database.getQueryLocator('SELECT Id, Name, ManagerId FROM User WHERE IsActive = TRUE AND Profile.Name = \'Ejecutivo\' AND prof_position_id__c IN (\'E03\', \'I32\', \'E0B\') LIMIT 10');
        } else {
            return Database.getQueryLocator('SELECT Id, Name, ManagerId FROM User WHERE IsActive = TRUE AND Profile.Name = \'Ejecutivo\' AND prof_position_id__c IN (\'E03\', \'I32\', \'E0B\')');
        }
    }

    /**
    @Description execute method
    @param Database.BatchableContext BatchableContextof batch
	@param List<User> list of users
    */
    global void execute(Database.BatchableContext BC, List<User> lstUser) {
        final Map<Id, Decimal> mapGroupingRisk = new Map<Id, Decimal>();
        final Map<Id, Decimal> mapGroupingCP = new Map<Id, Decimal>();
        final Map<Id, Decimal> mapGroupingLP = new Map<Id, Decimal>();
        for(User usr : lstUser) {
            mapGroupingRisk.put(usr.Id, 0);
            mapGroupingCP.put(usr.Id, 0);
            mapGroupingLP.put(usr.Id, 0);
        }
        for(dwp_frct__grouping__c grouping : [SELECT Id, dwp_frct__management_plan_id__r.OwnerId, dwp_frct__original_commitment_amount__c, dwp_frct__solution_category_type__c FROM dwp_frct__grouping__c
                                              WHERE dwp_frct__management_plan_id__r.OwnerId IN :mapGroupingRisk.keySet() AND dwp_frct__solution_category_type__c IN ('Riesgo de firma','Financiamiento a corto plazo','Financiamiento a largo plazo')
                                              AND CALENDAR_YEAR(dwp_frct__management_plan_id__r.dwp_frct__management_plan_end_date__c) = :dateCalEnd.year()
                                              AND CALENDAR_MONTH(dwp_frct__management_plan_id__r.dwp_frct__management_plan_end_date__c) = :dateCalEnd.month()]) {
            if(grouping.dwp_frct__solution_category_type__c == 'Riesgo de firma' && grouping.dwp_frct__original_commitment_amount__c != NULL) {
                mapGroupingRisk.put(grouping.dwp_frct__management_plan_id__r.OwnerId, grouping.dwp_frct__original_commitment_amount__c);
            } else if(grouping.dwp_frct__solution_category_type__c == 'Financiamiento a corto plazo' && grouping.dwp_frct__original_commitment_amount__c != NULL) {
                mapGroupingCP.put(grouping.dwp_frct__management_plan_id__r.OwnerId, grouping.dwp_frct__original_commitment_amount__c);
            } else if(grouping.dwp_frct__solution_category_type__c == 'Financiamiento a largo plazo' && grouping.dwp_frct__original_commitment_amount__c != NULL) {
                mapGroupingLP.put(grouping.dwp_frct__management_plan_id__r.OwnerId, grouping.dwp_frct__original_commitment_amount__c);
            }
        }
        final List<Calce__c> ltsCalce = new List<Calce__c>();
        for(User usr : lstUser) {
            Final Calce__c calce = new Calce__c();
            calce.Name = nameMonth.get(dateCalEnd.month())+String.valueOf(dateCalEnd.day()).leftPad(2, '0')+'-'+dateCalEnd.year()+' - '+usr.Name;
            calce.OwnerId = usr.Id;
            calce.manager_id__c = usr.ManagerId;
            calce.close_date__c = dateCalEnd;
            calce.start_date__c = dateCalStart;
            calce.status__c = 'Iniciado';
            calce.Indirect_commitment__c = mapGroupingRisk.get(usr.Id);
            calce.Direct_commitment__c = mapGroupingCP.get(usr.Id)+mapGroupingLP.get(usr.Id);
            ltsCalce.add(calce);
        }
        insert ltsCalce;
        List<Calce__Share> ltsCalceShr  = new List<Calce__Share>();
        for(User_Assistant_Team__c assistant : [SELECT assistant_id__c, user_id__c FROM User_Assistant_Team__c WHERE user_id__c = :mapGroupingRisk.keySet() AND assistant_id__r.IsActive = TRUE]) {
            Calce__Share calceShr  = new Calce__Share();
            for(Calce__c calce : ltsCalce) {
                if(calce.OwnerId == assistant.user_id__c) {
                    calceShr.ParentId = calce.Id;
                    break;
                }
            }
            calceShr.UserOrGroupId = assistant.assistant_id__c;
            calceShr.AccessLevel = 'Edit';
            ltsCalceShr.add(calceShr);
        }
        insert ltsCalceShr;
    }

    /**
    @Description finish method
	*/
    public void finish(Database.BatchableContext BC) {
        
    }
}