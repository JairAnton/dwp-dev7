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
public without sharing class BE_SM_PendingTopic_Ctr  extends BE_SingleRelatedListCRUD_Cls {
    /** OPEN_TOPIC */
    final static String OPEN_TOPIC='Open';
    /**
    @Description createRecords
    @param  List<SObject> sObjs
    @return BE_SingleRelatedListCRUD_Cls.Response response
    */
    public override BE_SingleRelatedListCRUD_Cls.Response readRecords(Map<String,Object> params) {
        final BE_SingleRelatedListCRUD_Cls.Response res= new BE_SingleRelatedListCRUD_Cls.Response();
        final slmt__Sales_Meeting__c salesMeeting= [SELECT slmt__management_plan_meeting_date__c,slmt__mngmt_plan_meeting_user_id__c,Collaborator__c FROM slmt__Sales_Meeting__c WHERE Id=:(String)params.get('recordId')];
        final String collaborator=salesMeeting.Collaborator__c;
        final String manager=salesMeeting.slmt__mngmt_plan_meeting_user_id__c;
        final Date myDate =  Date.valueOf(salesMeeting.slmt__management_plan_meeting_date__c);
        if(String.isNotBlank(collaborator) && String.isNotBlank(manager) && String.isNotBlank(myDate.format())) {
            final String query = 'SELECT '+ params.get('sObjFields')+ ' FROM '+ params.get('sObjName') + ' WHERE Status=:OpenTopic AND (OwnerId=: collaborator OR OwnerId=:manager) AND slmt__management_plan_meeting_id__r.Collaborator__c=:collaborator AND  ActivityDate <=:myDate';
            res.isSuccess=true;
            res.data=Database.query(String.escapeSingleQuotes(query));
        } else {
            res.isSuccess=false;
        }
        return res;
    }
}