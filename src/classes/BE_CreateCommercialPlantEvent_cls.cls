/**
 * BE_CreateCommercialPlantEvent_cls
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		15/05/2020          Original version.<p />
 *
 * @author Diego Carbajal
 */
public with sharing class BE_CreateCommercialPlantEvent_cls extends BE_SingleRelatedListCRUD_Cls {
    
    /*
    * @Description  method createRecords
    */
    public override BE_SingleRelatedListCRUD_Cls.Response createRecords(List<SObject> sObjs) {
        BE_SingleRelatedListCRUD_Cls.Response response = new BE_SingleRelatedListCRUD_Cls.Response(false, 'No se ha encontrado plan de cuenta relacionado.');
        try {
            Final List<acpl__Commercial_Plan_Event__c> lstCPE = (List<acpl__Commercial_Plan_Event__c>) sObjs;
            Final List<acpl__Account_Planning__c> lstAP = BE_AP_Administration_helper.getAP(lstCPE[0].acpl__gf_account_planning_id__c);
            Final Integer apSize = lstAp.size();
            if(apSize > 0 && String.isNotBlank(lstAp[0].acpl__participant_id__c)) {
                Final Map<String, String> mapAU = validateAU(lstAP[0], lstCPE[0]);
                if(mapAU.get('success') == 'true') {
                    lstCPE[0].Name = lstAp[0].Name + ' - ' + String.valueOf(lstCPE[0].acpl__gf_event_date__c).left(10);
                    lstCPE[0].acpl__participant_id__c = lstAp[0].acpl__participant_id__c;
                    response = BE_SingleRelatedListModal_Ctr.returnResponse(lstCPE, 'insert');
                } else {
                    response.message = mapAU.get('msg');
                }
            }
        } catch (Exception e) {
            response.isSuccess = false;
            response.message = e.getMessage();
        }
        return response;
    }

    /*
    * @Description  method updateRecords
    */
    public override BE_SingleRelatedListCRUD_Cls.Response updateRecords(List<SObject> sObjs) {
        BE_SingleRelatedListCRUD_Cls.Response response = new BE_SingleRelatedListCRUD_Cls.Response();
        try {
            Final List<acpl__Commercial_Plan_Event__c> lstCPE = (List<acpl__Commercial_Plan_Event__c>) sObjs;
            Final List<acpl__Account_Planning__c> lstAP = BE_AP_Administration_helper.getAP(lstCPE[0].acpl__gf_account_planning_id__c);
            Final Integer apSize = lstAp.size();
            if(apSize > 0 && String.isNotBlank(lstAp[0].acpl__participant_id__c)) {
                Final Map<String, String> mapAU = validateAU(lstAP[0], lstCPE[0]);
                if(mapAU.get('success') == 'true') {
                    lstCPE[0].Name = lstAp[0].Name + ' - ' + String.valueOf(lstCPE[0].acpl__gf_event_date__c).left(10);
                    response = BE_SingleRelatedListModal_Ctr.returnResponse(lstCPE, 'update');
                } else {
                    response.isSuccess = false;
                    response.message = mapAU.get('msg');
                }
            }
        } catch (Exception e) {
            response.isSuccess = false;
            response.message = e.getMessage();
        }
        return response;
    }

    /*
    * @Description  method validateAU
    */
    public static Map<String, String> validateAU(acpl__Account_Planning__c ap, acpl__Commercial_Plan_Event__c cpe) {
        Final Map<String, String> validate = new Map<String, String>{'success' => 'true'};
        if(String.isNotBlank(cpe.Asiggned_User__c)) {
            Final Boolean isActive = [SELECT Id, isActive FROM User WHERE Id=:cpe.Asiggned_User__c].isActive;
            if(ap.acpl__proposal_manager_id__c == cpe.Asiggned_User__c) {
                validate.put('success', 'false');
                validate.put('msg', 'El gestor del plan es asignado automaticamente, por favor asigne a otro usuario.');
            } else if(!isActive) {
                validate.put('success', 'false');
                validate.put('msg', 'No puede asignar a un usuario inactivo.');
            }
        }
        return validate;
    }

}