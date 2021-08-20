/**
 * BE_CreateCommercialPlantEvent_cls
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		15/05/2020          Original version.<p />
 * Jair Anton               13/07/2021          Modificar el comentario de un Growth Driver
 * @author Diego Carbajal
 */
public with sharing class BE_CreateCommercialPlantEvent_cls extends BE_SingleRelatedListCRUD_Cls {
    /** @Description  MSG*/
    private static Final String MSG = 'msg';
    /** @Description  V_TRUE*/
    private static Final String V_TRUE = 'true';
    /** @Description  V_SUCCESS*/
    private static Final String V_SUCCESS = 'success';
    /** @Description  V_LIT*/
    private static Final String V_LIT = ' - ';

    /*
    * @Description  method readRecords
    */
    public override BE_SingleRelatedListCRUD_Cls.Response readRecords(Map<String,Object> param) {
        Final BE_SingleRelatedListCRUD_Cls.Response response = new BE_SingleRelatedListCRUD_Cls.Response();
        Final Map<String, String> messageMap = new Map<String,String>();

        try {   
            Final Map<Id, acpl__Commercial_Plan_Event__c> cplanMap = new Map<Id, acpl__Commercial_Plan_Event__c>([SELECT Id, GrowthDriver__c, Name, toLabel(acpl__gf_comm_plan_event_type_name__c), CreatedDate,
                                                                                                                acpl__gf_event_date__c, Product__c, Comments__c, ClientAssigned__r.Name FROM acpl__Commercial_Plan_Event__c
                                                                                                                WHERE acpl__gf_account_planning_id__c =: (String)param.get('recordId')
                                                                                                                ORDER BY CreatedDate DESC]);

            for(acpl__Commercial_Plan_Event__c item : cplanMap.values()) {
                item.Name = null;
            }

            for(Opportunity item : [SELECT Id, commercial_plan_event__c, CreatedDate FROM Opportunity WHERE commercial_plan_event__c IN : cplanMap.keySet()]) {
                if(cplanMap.containsKey(item.commercial_plan_event__c)) {
                    Final acpl__Commercial_Plan_Event__c cplanItem = cplanMap.get(item.commercial_plan_event__c);
                    cplanItem.Name = item.CreatedDate.format('yyyy-MM-dd');
                }
            }

            searchVisit(cplanMap);
            searchTask(cplanMap);

            response.data = cplanMap.values();
            response.isSuccess = true;
            response.message = messageMap.get(UserInfo.getLanguage());
        } catch (DMLException ex) {
            response.isSuccess = false;
            response.message = ex.getDmlMessage(0);
        }

        return response;
    }

    private static void searchVisit(Map<Id, acpl__Commercial_Plan_Event__c> cplanMap) {
        for(dwp_kitv__Visit__c item : [SELECT Id, commercial_plan_event__c, CreatedDate FROM dwp_kitv__Visit__c WHERE commercial_plan_event__c IN : cplanMap.keySet()]) {
            if(cplanMap.containsKey(item.commercial_plan_event__c)) {
                Final acpl__Commercial_Plan_Event__c cplanItem = cplanMap.get(item.commercial_plan_event__c);
                cplanItem.Name = item.CreatedDate.format('yyyy-MM-dd');
            }
        }
    }

    private static void searchTask(Map<Id, acpl__Commercial_Plan_Event__c> cplanMap) {
        for(Task item : [SELECT Id, WhatId, CreatedDate FROM Task WHERE WhatId IN : cplanMap.keySet()]) {
            if(cplanMap.containsKey(item.WhatId)) {
                Final acpl__Commercial_Plan_Event__c cplanItem = cplanMap.get(item.WhatId);
                cplanItem.Name = item.CreatedDate.format('yyyy-MM-dd');
            }
        }   
    }
    
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

                if(mapAU.get(V_SUCCESS) == V_TRUE) {
                    lstCPE[0].Name = getNameCPE(lstAP, lstCPE);
                    lstCPE[0].acpl__participant_id__c = lstAp[0].acpl__participant_id__c;
                    response = BE_SingleRelatedListModal_Ctr.returnResponse(lstCPE, 'insert');
                } else {
                    response.message = mapAU.get(MSG);
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
        Final List<acpl__Commercial_Plan_Event__c> lstCPE = (List<acpl__Commercial_Plan_Event__c>) sObjs;
        Final Savepoint sPoint = Database.setSavePoint();

        try {
            Final List<acpl__Account_Planning__c> lstAP = BE_AP_Administration_helper.getAP(lstCPE[0].acpl__gf_account_planning_id__c);
            Final Integer apSize = lstAp.size();

            if(apSize > 0 && String.isNotBlank(lstAp[0].acpl__participant_id__c)) {
                Final Map<String, String> mapAU = validateAU(lstAP[0], lstCPE[0]);

                if(mapAU.get(V_SUCCESS) == V_TRUE) {
                    lstCPE[0].Name = getNameCPE(lstAP, lstCPE);
                    response = BE_SingleRelatedListModal_Ctr.returnResponse(lstCPE, 'update');

                    Final Set<Id> typeActionSet = verifyTypeAction(lstCPE[0], 'Visit');
                    typeActionSet.addAll(verifyTypeAction(lstCPE[0], 'Task'));
                    typeActionSet.addAll(verifyTypeAction(lstCPE[0], 'Call'));
                    
                    evaluateRollback(typeActionSet, lstCPE, sPoint, response);               
                    BE_CreateDriveGrowth_ctr.validateOpportunity(lstCPE, response, sPoint);
                } else {
                    response.isSuccess = false;
                    response.message = mapAU.get(MSG);
                }
            }
        } catch (Exception e) {
            response.isSuccess = false;
            response.message = e.getMessage();
        }
        return response;
    }

    /*
    * @Description  method deleteRecords
    */
    public override BE_SingleRelatedListCRUD_Cls.Response deleteRecords(List<SObject> sObjsIds) {
        Final List<acpl__Commercial_Plan_Event__c> lstCPE = (List<acpl__Commercial_Plan_Event__c>) sObjsIds;
        BE_SingleRelatedListCRUD_Cls.Response response = new BE_SingleRelatedListCRUD_Cls.Response();
        Final Savepoint sPoint = Database.setSavePoint();

        try {
            Final Set<Id> typeActionSet = verifyTypeAction(lstCPE[0], 'Visit');
            typeActionSet.addAll(verifyTypeAction(lstCPE[0], 'Task'));
            typeActionSet.addAll(verifyTypeAction(lstCPE[0], 'Call'));
            typeActionSet.addAll(verifyTypeAction(lstCPE[0], 'Opportunity'));
    
            if(typeActionSet.size() > 0) {            
                Database.rollback(sPoint);
                response.isSuccess = false;
                response.message = 'No puedes eliminar una oportunidad, visita, llamada o tarea creada en una validación anterior.';
            } else {
                response = BE_SingleRelatedListModal_Ctr.returnResponse(lstCPE, 'delete');
                
                if(!response.isSuccess) {
                    Database.rollback(sPoint);
                    response.message = 'Ocurrió un error.';
                }
            }
        } catch(Exception e) {
            response.isSuccess = false;
            response.message = e.getMessage();
        }

        return response;
    }

    private static void evaluateRollback(Set<Id> typeActionSet, List<acpl__Commercial_Plan_Event__c> lstCPE, Savepoint sPoint, BE_SingleRelatedListCRUD_Cls.Response response) {
        if(typeActionSet.size() > 0) {            
            Database.rollback(sPoint);
            response.isSuccess = false;
            response.message = 'No puedes editar una visita, llamada o tarea creada en una validación anterior, debes generar una nueva.';
        } else {
            Final List<acpl__Commercial_Plan_Event__c> lstCPEAux = [SELECT Id, ClientAssigned__c, acpl__gf_event_date__c, GrowthDriver__c, Comments__c FROM acpl__Commercial_Plan_Event__c WHERE Id =: lstCPE[0].Id LIMIT 1];

            if(response.isSuccess && !lstCPEAux.isEmpty() && String.isNotBlank(lstCPEAux[0].GrowthDriver__c)) {
                Final List<bupl__BP_GrowthDriver__c> growthList = [SELECT Id, ExpectedDate__c, ClientAssigned__c FROM bupl__BP_GrowthDriver__c WHERE Id =: lstCPEAux[0].GrowthDriver__c LIMIT 1];
                growthList[0].ExpectedDate__c = lstCPEAux[0].acpl__gf_event_date__c;
                growthList[0].ClientAssigned__c = lstCPEAux[0].ClientAssigned__c;
                growthList[0].bupl__gf_growth_drvr_prdt_desc__c = lstCPEAux[0].Comments__c;
                update growthList;
            }
        }
    }

    private static String getNameCPE(List<acpl__Account_Planning__c> lstAP, List<acpl__Commercial_Plan_Event__c> lstCPE) {
        Final String name;

        if(lstAp[0].Name != null && lstAp[0].Name.length() > 66) {
            name = lstAp[0].Name.substring(0,66) + V_LIT + String.valueOf(lstCPE[0].acpl__gf_event_date__c).left(10);
        } else {
            name = lstAp[0].Name + V_LIT + String.valueOf(lstCPE[0].acpl__gf_event_date__c).left(10);
        }
         
        return name;
    }

    private static Set<Id> verifyTypeAction(acpl__Commercial_Plan_Event__c cpeItem, String action) {
        Final Set<Id> cpeIdSet = new Set<Id>();

        switch on action {
			when 'Visit' {
				for(dwp_kitv__Visit__c visit: [SELECT Id, commercial_plan_event__c FROM dwp_kitv__Visit__c WHERE commercial_plan_event__c =: cpeItem.Id]) {
                    cpeIdSet.add(visit.commercial_plan_event__c);
                }
			}
			when 'Opportunity' {
				for(Opportunity opp: [SELECT Id, commercial_plan_event__c FROM Opportunity WHERE commercial_plan_event__c =: cpeItem.Id]) {
					cpeIdSet.add(opp.commercial_plan_event__c);
				}
			}
			when 'Task', 'Call' {
				for(Task tarea: [SELECT Id, WhatId FROM Task WHERE WhatId =: cpeItem.Id]) {
                    cpeIdSet.add(tarea.WhatId);
                }
			}
		}

		return cpeIdSet;
	}

    /*
    * @Description  method validateAU
    */
    public static Map<String, String> validateAU(acpl__Account_Planning__c apR, acpl__Commercial_Plan_Event__c cpe) {
        Final Map<String, String> validate = new Map<String, String>{V_SUCCESS => V_TRUE};

        if(String.isNotBlank(cpe.Asiggned_User__c)) {
            Final Boolean isActive = [SELECT Id, isActive FROM User WHERE Id=:cpe.Asiggned_User__c].isActive;

            if(apR.acpl__proposal_manager_id__c == cpe.Asiggned_User__c) {
                validate.put(V_SUCCESS, 'false');
                validate.put(MSG, 'El gestor del plan es asignado automaticamente, por favor asigne a otro usuario.');
            } else if(!isActive) {
                validate.put(V_SUCCESS, 'false');
                validate.put(MSG, 'No puede asignar a un usuario inactivo.');
            }
        }

        return validate;
    }
}