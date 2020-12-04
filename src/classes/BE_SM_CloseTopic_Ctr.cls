/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_SM_PendingTopic_Ctr>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2020-11-15
   @Description 
   @Changes
   Date        Author   Email                  Type
   2020-11-15  LMBR     lolo.bravo@bbva.com    Creation
   -------------------------------------------------------------------------------------------------
 */
public without sharing class BE_SM_CloseTopic_Ctr  extends BE_SingleRelatedListCRUD_Cls {
    /** Close Topic */
    final static String CLOSE_TOPIC='Completed';
    /**
    @Description createRecords
    @param  List<SObject> sObjs
    @return BE_SingleRelatedListCRUD_Cls.Response response
    */
    public override BE_SingleRelatedListCRUD_Cls.Response readRecords(Map<String,Object> params) {
        final BE_SingleRelatedListCRUD_Cls.Response res= new BE_SingleRelatedListCRUD_Cls.Response();
        final slmt__Sales_Meeting__c salesMeeting= [SELECT slmt__mngmt_plan_meeting_user_id__c,Collaborator__c,auxiliar_collaborator__c,auxiliar_manager__c FROM slmt__Sales_Meeting__c WHERE Id=:(String)params.get('recordId')];
        final String collaborator=salesMeeting.Collaborator__c;
        final String manager=salesMeeting.slmt__mngmt_plan_meeting_user_id__c;
        final String auxColl=salesMeeting.auxiliar_collaborator__c;
        final String auxMana=salesMeeting.auxiliar_manager__c;
        System.debug('###DATOS:collaborator'+collaborator+ ' auxColl:'+auxColl  +' manager:'+manager+
					 ' auxMana:'+auxMana);
		if(String.isNotBlank(collaborator) && String.isNotBlank(manager)) {
            final String query = 'SELECT '+ params.get('sObjFields')+ ' FROM '+ params.get('sObjName') + ' WHERE Status=:CLOSE_TOPIC AND (OwnerId=: collaborator OR OwnerId=:manager OR OwnerId=:auxColl OR OwnerId=:auxMana) AND slmt__management_plan_meeting_id__r.Collaborator__c=:collaborator AND ActivityDate>= LAST_N_DAYS:30';
            res.isSuccess=true;
            res.data=Database.query(String.escapeSingleQuotes(query));
        } else {
            res.isSuccess=false;
        }
        return res;
    }
}