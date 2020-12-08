/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_SM_ManagementPlanLink_Cls>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2020-11-15
   @Description 
   @Changes
   Date        Author   Email                  Type
   2020-11-15  LMBR     lolo.bravo@bbva.com    Creation
   -------------------------------------------------------------------------------------------------
 */
public without sharing class BE_SM_ManagementPlanLink_Cls extends BE_ButtonsBarCRUD_cls {
     /**
    @Description createRecords
    @param Map<String,Object> params
    @return BE_SingleRelatedListCRUD_Cls.Response response
    */
    public override BE_ButtonsBarCRUD_cls.Response readRecords(Map<String,Object> params) {
        final BE_ButtonsBarCRUD_cls.Response res = new BE_ButtonsBarCRUD_cls.Response();
        final slmt__Sales_Meeting__c salesMeeting= [SELECT DateTime__c,Collaborator__c FROM slmt__Sales_Meeting__c WHERE Id=:(String)params.get('recordId')];
        final List<SObject> plans=[SELECT ID FROM dwp_frct__management_plan__c WHERE dwp_frct__management_plan_end_date__c>=:salesMeeting.DateTime__c AND dwp_frct__management_plan_start_date__c<=:salesMeeting.DateTime__c AND OwnerId=:salesMeeting.Collaborator__c];
        if(plans.isEmpty()) {
            res.isSuccess=false;
            res.message='No se encontraron registros de Proyección Mensual.';
        } else {
            res.data=plans;
            res.isSuccess=true;
        }
        return res;
    }
}