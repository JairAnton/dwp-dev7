/**
 * BE_SM_Pipeline_Update_cls
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		12/11/2020          Original version.<p />
 *
 * @author Diego Carbajal
 */
public with sharing class BE_SM_Pipeline_Update_cls extends BE_SingleRelatedListCRUD_Cls {
    
    /*
    * @Description  method updateRecords
    */
    public override BE_SingleRelatedListCRUD_Cls.Response updateRecords(List<SObject> sObjs) {
        BE_SingleRelatedListCRUD_Cls.Response response = new BE_SingleRelatedListCRUD_Cls.Response(true, '');
        Final List<Opportunity> lstOpp = (List<Opportunity>) sObjs;
        try {
            Final OpportunityLineItem[] lstOli = [SELECT Id, UnitPrice, Opportunity.Amount FROM OpportunityLineItem WHERE 
                                                    OpportunityId =:lstOpp[0].Id AND Opportunity.stageName IN ('02', '03')];
            update lstOpp;
            if(!lstOli.isEmpty() && (lstOli[0].Opportunity.Amount != lstOpp[0].Amount)) {
                lstOli[0].UnitPrice = lstOpp[0].Amount;
                update lstOli;
            }
            response.isSuccess = true;
            response.data = lstOpp;
        } catch (Exception e) {
            response.isSuccess = false;
            response.message = e.getMessage();
        }
        return response;
    }
}