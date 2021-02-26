/**
   ----------------------------------------------------------------------------------------------------
   @Name <BE_General_Utils>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2019-09-13
   @Description Class  contains generic logic to use in differents classes.
   @Changes
    Date        Author   Email                  Type
    2020-02-21  LMBR     lolo.bravo@bbva.com    Creation
   ----------------------------------------------------------------------------------------------------
 */
public without sharing class BE_CA_NewOpp_Ctr extends BE_CustomQuickActionCRUD_Cls {

    /**
    @Description createRecords
    @param  List<SObject> sObjs
    @return BE_SingleRelatedListCRUD_Cls.Response response
    */
    public override BE_CustomQuickActionCRUD_Cls.Response createRecord(sObject sObj,Map<String,Object> params) {
        BE_CustomQuickActionCRUD_Cls.Response res = new BE_CustomQuickActionCRUD_Cls.Response();
        try {
           	insert sObj;
            List<OpportunityTeamMember> oppTeam = new List<OpportunityTeamMember>();
            for (ctcp__Custom_Team__c cTeamItem:[SELECT ID, Commercial_Alert__c,ctcp__gf_team_users_desc__c FROM ctcp__Custom_Team__c WHERE Commercial_Alert__c=:(String)params.get('recordId')]) {
                oppTeam.add(new OpportunityTeamMember(OpportunityId=sObj.Id,UserId=cTeamItem.ctcp__gf_team_users_desc__c));
            }
            insert oppTeam;
            altm__Commercial_Alert__c commAlert = [SELECT ID,altm__alert_stage_type__c FROM altm__Commercial_Alert__c WHERE Id=:(String)params.get('recordId')];
            if(commAlert.altm__alert_stage_type__c=='Pending') {
                commAlert.altm__alert_stage_type__c='InManagement';
                update commAlert;
            }
            res.isSuccess=true;
            res.data=sObj;
        } catch (DmlException ex) {
            res.message=ex.getMessage();
        }
            return res;
    }
}