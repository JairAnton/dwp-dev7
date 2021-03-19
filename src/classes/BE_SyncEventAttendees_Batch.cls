/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_SyncEventAttendees_Batch>
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-10-14
   @Description Batchable class for sync attendees event
   @Changes
   Date        Author   Email                  				Type		Description
   2020-10-14  MAMC     martin.mori.contractor@bbva.com    	Creation
   -------------------------------------------------------------------------------------------------
 */
public without sharing class BE_SyncEventAttendees_Batch implements Database.Batchable<sObject> {
    /**
	   @Description evtIds
	 */
    public Set<Id> evtIds {get; set;}
	/**
	   @Description BE_SyncEventAttendees_Batch
	 */
	public BE_SyncEventAttendees_Batch(Set<Id> ids) {
		this.evtIds = ids;
	}
    
    /**
    @Description start method
    @param Database.BatchableContext BatchableContextof batch
    @return Database.QueryLocator QueryLocator result query of calce
    */
    public Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator('SELECT Id, EventId, RelationId, Relation.Name, Relation.Email FROM EventRelation WHERE EventId IN :evtIds');
    }
    
    /**
    @Description execute method
    @param Database.BatchableContext BatchableContextof batch
	@param List<EventRelation> list of event relation
    */
    public void execute(Database.BatchableContext context, List<EventRelation> lstEvtRel) {
        final Set<Id> userIds = new Set<Id>();
        final Map<Id, String> mapUserCodes = new Map<Id, String>();
        for(EventRelation evtRel : lstEvtRel) {
            if(String.valueOf(evtRel.RelationId).StartsWith('005')) {
                userIds.add(evtRel.RelationId);
            }
        }
        if(!userIds.isEmpty()) {
            for(User usr : [SELECT Id, User_Id__c FROM User WHERE Id IN :userIds]) {
                mapUserCodes.put(usr.Id, usr.User_Id__c);
            }
        }
        
        final List<String> sObjNames = new List<String> {'gcal__Event_Attendees__c'};
        final Map<String, Schema.RecordTypeInfo> recordType = BE_General_Utils.getRecordTypeInfo(sObjNames);
		final List<gcal__Event_Attendees__c> ltsGcalEvtAtt = new List<gcal__Event_Attendees__c>();
        for(EventRelation evtRel : lstEvtRel) {
            final gcal__Event_Attendees__c gcalEvtAtt = new gcal__Event_Attendees__c();
            gcalEvtAtt.Name = evtRel.Relation.Name;
            gcalEvtAtt.gcal__EventId__c = evtRel.EventId;
            gcalEvtAtt.gcal__EventRelationId__c = evtRel.Id;
            gcalEvtAtt.gcal__External_Key__c = evtRel.Relation.Email;
            gcalEvtAtt.gcal__RelatedToId__c = evtRel.RelationId;
            if(mapUserCodes.containsKey(evtRel.RelationId)) {
                gcalEvtAtt.gcal__Attendee_Id__c = mapUserCodes.get(evtRel.RelationId);
            } else {
                gcalEvtAtt.gcal__Attendee_Id__c = evtRel.RelationId;
            }  
            if(String.valueOf(evtRel.RelationId).StartsWith('005')) {
                gcalEvtAtt.RecordTypeId = recordType.get('User').getRecordTypeId();
            	gcalEvtAtt.gcal__Icon__c = 'standard:avatar';
            	gcalEvtAtt.gcal__Type__c = 'USER';
            }
            ltsGcalEvtAtt.add(gcalEvtAtt);
        }
        if(!ltsGcalEvtAtt.isEmpty()) {
            insert ltsGcalEvtAtt;
        }
    }
    
    /**
    @Description finish method
	*/
    public void finish(Database.BatchableContext context) {
        final gcal.GBL_Configuration_wrp googleConfig = new gcal.GBL_Configuration_wrp();
        googleConfig.synchronizeAll = true;
        googleConfig.notifications = true;
        if(!Test.isRunningTest()) {
            gcal.GBL_EventHandler.synchronizeEvent(new List<Id>(evtIds), googleConfig);
        }
        for(CronTrigger job : [SELECT Id FROM CronTrigger WHERE State = 'DELETED' AND CronJobDetail.Name LIKE 'Sync attendees started at %']) {
            system.abortJob(job.id);
        }
    }
}