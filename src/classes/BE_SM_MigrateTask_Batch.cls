/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_SM_MigrateTask_Batch>
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-11-27
   @Description Schedulable class from BE_SM_MigrateTask_Batch
   @Changes
   Date        Author   Email                  				Type
   2020-11-27  MAMC     martin.mori.contractor@bbva.com    	Creation
   -------------------------------------------------------------------------------------------------
 */
public with sharing class BE_SM_MigrateTask_Batch implements Database.Batchable<sObject>, Database.Stateful {
    /*set ids of collaborators*/
    private final Map<Id, Id> slmtCollMap;
    
    /**
    @Description constructor method
	@param Set<Id> ids of collaborators
    */
    public BE_SM_MigrateTask_Batch(Map<Id, Id> slmtCollMapAux) {
        this.slmtCollMap = slmtCollMapAux;
    }

    /**
    @Description start method
    @param Database.BatchableContext BatchableContextof batch
    @return Database.QueryLocator QueryLocator result query of executive users
    */
    public Database.QueryLocator start(Database.BatchableContext context) {
        Final Set<Id> ids = slmtCollMap.keySet();
        return Database.getQueryLocator('SELECT Id, Collaborator__c, slmt__mngmt_plan_meeting_status_name__c FROM slmt__Sales_Meeting__c WHERE Collaborator__c IN :ids AND slmt__management_plan_meeting_date__c = LAST_N_DAYS:60 AND (slmt__mngmt_plan_meeting_status_name__c = \'Finalized\' OR slmt__mngmt_plan_meeting_status_name__c = \'Unrealized\') ORDER BY slmt__management_plan_meeting_date__c DESC');
    }

    /**
    @Description execute method
    @param Database.BatchableContext BatchableContextof batch
	@param List<slmt__Sales_Meeting__c> list of sales meetings
    */
    public void execute(Database.BatchableContext context, List<slmt__Sales_Meeting__c> salesMeetings) {
        Final Map<Id, Id> slmtMap = new Map<Id, Id>();
        Final Set<Id> slmtSetIds = new Set<Id>();
        for(slmt__Sales_Meeting__c slmt : salesMeetings) {
            if(!slmtMap.containsKey(slmt.Collaborator__c)) {
                slmtMap.put(slmt.Collaborator__c, slmt.Id);
                slmtSetIds.add(slmt.Id);
            }
        }
        if(!slmtMap.isEmpty() && !slmtSetIds.isEmpty()) {
            Final Map<Id, Id> remplaceIdMap = new Map<Id, Id>();
            for(Id idAux : slmtMap.keySet()) {
                remplaceIdMap.put(slmtMap.get(idAux), slmtCollMap.get(idAux));
            }
            Final List<Task> taskUpd = new List<Task>();
            for(Task tskAux : [SELECT Id, slmt__management_plan_meeting_id__c FROM Task WHERE Status = 'Open' AND slmt__management_plan_meeting_id__c IN :slmtSetIds]) {
                tskAux.slmt__management_plan_meeting_id__c = remplaceIdMap.get(tskAux.slmt__management_plan_meeting_id__c);
                taskUpd.add(tskAux);
            }
            if(!taskUpd.isEmpty()) {
                update taskUpd;
            }
        }
    }

    /**
    @Description finish method
	*/
    public void finish(Database.BatchableContext context) {
        
    }
}