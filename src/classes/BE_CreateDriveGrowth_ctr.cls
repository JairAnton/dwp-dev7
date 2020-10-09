/**
 * BE_CreateDriveGrowth_ctr
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		15/05/2020          Original version.<p />
 * Diego Carbajal    		07/10/2020          Modified version.<p />
 *
 * @author Diego Carbajal
 */
public with sharing class BE_CreateDriveGrowth_ctr extends BE_SingleRelatedListCRUD_Cls {

    /*
    * @Description  method createRecords
    */
    public override BE_SingleRelatedListCRUD_Cls.Response createRecords(List<SObject> sObjs) {
        BE_SingleRelatedListCRUD_Cls.Response response = new BE_SingleRelatedListCRUD_Cls.Response(false, 'No se ha encontrado plan de negocio relacionado al plan de cuenta.');
        //Savepoint for commercial plan opportunity to be created
        Final Savepoint svp = Database.setSavePoint();
        try {
            Final List<bupl__BP_GrowthDriver__c> lstGD = (List<bupl__BP_GrowthDriver__c>) sObjs;
            response.message = String.isBlank(lstGD[0].acpl__gf_account_planning_id__c) ? 'No se ha encontrado plan de cuenta relacionado.' : response.message;
            Final List<bupl__BusinessPlan__c> lstBP = [SELECT Id, acpl__gf_account_planning_id__r.acpl__participant_id__c, acpl__gf_account_planning_id__r.Name
                                                     FROM bupl__BusinessPlan__c WHERE acpl__gf_account_planning_id__c = :lstGD[0].acpl__gf_account_planning_id__c LIMIT 1];
            Final Integer lstBpSize = lstBP.size();
            if(lstBpSize > 0) {
                lstGD[0].bupl__gf_business_plan_id__c = lstBP[0].Id;
                response = BE_SingleRelatedListModal_Ctr.returnResponse(lstGD, 'insert');
                if(lstGD[0].ExpectedDate__c != null && response.isSuccess) {
                    response = evaluateInsert(svp, lstBP[0], lstGD[0]);
                }
            }
        } catch(Exception e) {
            Database.rollback(svp);
            response.isSuccess = false;
            response.message = e.getMessage();
        }
        return response;
    }

    /*
    * @Description  method updateRecords
    */
    public override BE_SingleRelatedListCRUD_Cls.Response updateRecords(List<SObject> sObjs) {
        Final List<bupl__BP_GrowthDriver__c> lstGD = (List<bupl__BP_GrowthDriver__c>) sObjs;
        Final Savepoint svp = Database.setSavePoint();
        BE_SingleRelatedListCRUD_Cls.Response response = BE_SingleRelatedListModal_Ctr.returnResponse(lstGD, 'update');
        if(response.isSuccess) {
            if(lstGD[0].ExpectedDate__c == null) {
                throw new AuraException('No puede dejar vacio el campo de fecha de completación.');
            }
            Final acpl__Commercial_Plan_Event__c[] lstCPE = [SELECT Id, Name, acpl__gf_event_date__c, ClientAssigned__c 
                                                            FROM acpl__Commercial_Plan_Event__c WHERE GrowthDriver__c =: lstGD[0].Id LIMIT 1];
            if(!lstCPE.isEmpty()) {
                lstCPE[0].Name = lstCPE[0].Name.left(lstCPE[0].Name.length() - 10) + String.valueOf(lstGD[0].ExpectedDate__c).left(10);
                lstCPE[0].acpl__gf_event_date__c = lstGD[0].ExpectedDate__c;
                lstCPE[0].ClientAssigned__c = lstGD[0].ClientAssigned__c;
                response = BE_SingleRelatedListModal_Ctr.returnResponse(lstCPE, 'update');
                if(validateProductInactive(lstGD[0].bupl__solution_category_desc__c, lstGD[0].CurrencyIsoCode)) {
                    Database.rollback(svp);
                    response.isSuccess = false;
                    response.message = 'El producto no se encuentra disponible. Seleccione otro producto y/o moneda.';
                } else if(!response.isSuccess) {
                    Database.rollback(svp);
                } 
                
            }
        }
        return response;
    }

    /*
    * @Description  method deleteRecords
    */
    public override BE_SingleRelatedListCRUD_Cls.Response deleteRecords(List<SObject> sObjsIds) {
        Final List<bupl__BP_GrowthDriver__c> lstGD = (List<bupl__BP_GrowthDriver__c>) sObjsIds;
        Final Savepoint svp = Database.setSavePoint();
        Final acpl__Commercial_Plan_Event__c[] lstCPE = [SELECT Id, Name, acpl__gf_event_date__c, ClientAssigned__c 
                                                        FROM acpl__Commercial_Plan_Event__c WHERE GrowthDriver__c =: lstGD[0].Id LIMIT 1];
        BE_SingleRelatedListCRUD_Cls.Response response = BE_SingleRelatedListModal_Ctr.returnResponse(lstGD, 'delete');
        if(response.isSuccess) {
            response = BE_SingleRelatedListModal_Ctr.returnResponse(lstCPE, 'delete');
            if(!response.isSuccess) {
                Database.rollback(svp);
            }
        }
        return response;
    }

    private static Boolean validateProductInactive(String productCode, String currencyCode) {
        Final PriceBookEntry[] lstPBE = [SELECT Id FROM PriceBookEntry WHERE Product2.Unique_id__c =: productCode AND CurrencyIsoCode =: currencyCode AND IsActive = TRUE LIMIT 1];
        return lstPBE.size() < 1;
    }
    
    private static BE_SingleRelatedListCRUD_Cls.Response evaluateInsert(SavePoint svp, bupl__BusinessPlan__c bpAux, bupl__BP_GrowthDriver__c gdAux) {
        Final acpl__Commercial_Plan_Event__c[] cpe = new List<acpl__Commercial_Plan_Event__c>{
            new acpl__Commercial_Plan_Event__c(acpl__participant_id__c = bpAux.acpl__gf_account_planning_id__r.acpl__participant_id__c, 
                                               acpl__gf_comm_plan_event_type_name__c = 'Opportunity', acpl__gf_account_planning_id__c = gdAux.acpl__gf_account_planning_id__c, 
                                               Name = bpAux.acpl__gf_account_planning_id__r.Name + ' - ' + String.valueOf(gdAux.ExpectedDate__c).left(10), 
                                               GrowthDriver__c = gdAux.Id, acpl__gf_event_date__c = gdAux.ExpectedDate__c, ClientAssigned__c = gdAux.ClientAssigned__c)};
		BE_SingleRelatedListCRUD_Cls.Response response = BE_SingleRelatedListModal_Ctr.returnResponse(cpe, 'insert');
        if(validateProductInactive(gdAux.bupl__solution_category_desc__c, gdAux.CurrencyIsoCode)) {
            Database.rollback(svp);
            response.isSuccess = false;
            response.message = 'El producto no se encuentra disponible. Seleccione otro producto y/o moneda.';
        } else if(!response.isSuccess) {
            Database.rollback(svp);
        }
        return response;
    }
}