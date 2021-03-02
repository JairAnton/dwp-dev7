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
public without sharing class BE_CA_NewVisit_Ctr extends BE_CustomQuickActionCRUD_Cls {
	/** Stage CommAlert */
    Private Final List<String> STAGE_ALERT= new List<String>{'Pending','InManagement'};
    /**
    @Description createRecords
    @param  List<SObject> sObjs
    @return BE_SingleRelatedListCRUD_Cls.Response response
    */
    public override BE_CustomQuickActionCRUD_Cls.Response createRecord(sObject sObj,Map<String,Object> params) {
        final BE_CustomQuickActionCRUD_Cls.Response res = new BE_CustomQuickActionCRUD_Cls.Response();
        try {
            insert sObj;
            insert new Commercial_Alert_Visit_Relation__c(visit_id__c=sObj.Id,commercial_id__c=(String)params.get('recordId'));
            final altm__Commercial_Alert__c commAlert = [SELECT ID,altm__alert_stage_type__c FROM altm__Commercial_Alert__c WHERE Id=:(String)params.get('recordId')];
            if(commAlert.altm__alert_stage_type__c==STAGE_ALERT[0]) {
                commAlert.altm__alert_stage_type__c=STAGE_ALERT[1];
                update commAlert;
            }
            res.isSuccess=true;
            res.data=sObj;
        } catch (DmlException e) {
            res.isSuccess=false;
            res.message=e.getMessage();
        }
        return res;
    } 

}