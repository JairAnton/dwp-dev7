/**
 * BE_CreateDriveGrowth_ctr
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		15/05/2020          Original version.<p />
 *
 * @author Diego Carbajal
 */
public with sharing class BE_CreateNeed_ctr extends BE_SingleRelatedListCRUD_Cls{
    
    /*
    * @Description  method createRecords
    */
    public override BE_SingleRelatedListCRUD_Cls.Response createRecords(List<SObject> sObjs) {
        BE_SingleRelatedListCRUD_Cls.Response response = new BE_SingleRelatedListCRUD_Cls.Response(false, 'No se ha encontrado plan de negocio relacionado al plan de cuenta.');
        try {
            Final List<bupl__BP_Need__c> lstNeed = (List<bupl__BP_Need__c>) sObjs;
            if(String.isBlank(lstNeed[0].acpl__gf_account_planning_id__c)) {
                response.message = 'No se ha encontrado plan de cuenta relacionado.';
            }
            Final List<bupl__BusinessPlan__c> lstBP = [SELECT Id FROM bupl__BusinessPlan__c WHERE 
                                            acpl__gf_account_planning_id__c=:lstNeed[0].acpl__gf_account_planning_id__c LIMIT 1];
            Final Integer lstBpSize = lstBP.size();
            if(lstBpSize > 0) {
                lstNeed[0].bupl__gf_business_plan_id__c = lstBP[0].Id;
                response = BE_SingleRelatedListModal_Ctr.returnResponse(lstNeed, 'insert');
            }
        } catch(DMLException e) {
            response.message = e.getMessage();
        } catch(Exception e) {
            response.isSuccess = false;
            response.message = e.getMessage();
        }
        return response;
    }

}