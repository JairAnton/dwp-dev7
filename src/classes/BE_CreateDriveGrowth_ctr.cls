/** BE_CreateDriveGrowth_ctr
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		15/05/2020          Original version.<p />
 * Diego Carbajal    		07/10/2020          Modified version.<p />
 * Jair Anton               13/07/2021          Agrega datos al campo comentario del GD
 * Jair Anton               19/08/2021          Valida GD creados..
 * @author Diego Carbajal
 */
@SuppressWarnings('PMD.CyclomaticComplexity')
public with sharing class BE_CreateDriveGrowth_ctr extends BE_SingleRelatedListCRUD_Cls {
    /*
    * @Description  method readRecords
    */
    public override BE_SingleRelatedListCRUD_Cls.Response readRecords(Map<String,Object> param) {
        Final BE_SingleRelatedListCRUD_Cls.Response response = new BE_SingleRelatedListCRUD_Cls.Response();
        Final Map<String,String> messageMap = new Map<String,String>();

        try {   
            Final Map<Id, bupl__BP_GrowthDriver__c> growthMap = new Map<Id, bupl__BP_GrowthDriver__c>([SELECT Id, bupl__gf_growth_drvr_prdt_short_desc__c, acpl__gf_account_planning_id__c, CurrencyIsoCode, bupl__solution_category_id__c, CreatedDate, ExpectedDate__c,
                                                                                                        toLabel(bupl__solution_category_desc__c), Amount__c, bupl__gf_growth_drvr_prdt_desc__c, ClientAssigned__r.Name
                                                                                                        FROM bupl__BP_GrowthDriver__c WHERE acpl__gf_account_planning_id__c	=: (String)param.get('recordId')
                                                                                                        ORDER BY CreatedDate DESC]);
            
            for(bupl__BP_GrowthDriver__c item : growthMap.values()) {
                item.bupl__gf_growth_drvr_prdt_short_desc__c = '';
            }

            Final Map<Id, acpl__Commercial_Plan_Event__c> cplanMap = new Map<Id, acpl__Commercial_Plan_Event__c>([SELECT Id, GrowthDriver__c FROM acpl__Commercial_Plan_Event__c WHERE GrowthDriver__c IN : growthMap.keySet()]);
            Final List<Opportunity> oppList = [SELECT Id, commercial_plan_event__c, CreatedDate FROM Opportunity WHERE commercial_plan_event__c IN : cplanMap.keySet()];

            for(Opportunity item : oppList) {
                if(cplanMap.containsKey(item.commercial_plan_event__c)) {
                    Final acpl__Commercial_Plan_Event__c cplanItem = cplanMap.get(item.commercial_plan_event__c);

                    if(growthMap.containsKey(cplanItem.GrowthDriver__c)) {
                        Final bupl__BP_GrowthDriver__c growthItem = growthMap.get(cplanItem.GrowthDriver__c);
                        growthItem.bupl__gf_growth_drvr_prdt_short_desc__c = item.CreatedDate.format('yyyy-MM-dd');
                    }
                }
            }

            response.data = growthMap.values();
            response.isSuccess = true;
            response.message = messageMap.get(UserInfo.getLanguage());
        } catch (DMLException ex) {
            response.isSuccess = false;
            response.message = ex.getDmlMessage(0);
        }

        return response;
    }

    /*
    * @Description  method createRecords
    */
    public override BE_SingleRelatedListCRUD_Cls.Response createRecords(List<SObject> sObjs) {
        BE_SingleRelatedListCRUD_Cls.Response response = new BE_SingleRelatedListCRUD_Cls.Response(false, 'No se ha encontrado plan de negocio relacionado al plan de cuenta.');
        //Savepoint for commercial plan opportunity to be created
        Final Savepoint svp = Database.setSavePoint();
        try {
            Final List<bupl__BP_GrowthDriver__c> lstGD = (List<bupl__BP_GrowthDriver__c>) sObjs;
            
            if(String.isBlank(lstGD[0].acpl__gf_account_planning_id__c)) {
                response.message = 'No se ha encontrado plan de cuenta relacionado.';
            }

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
        BE_SingleRelatedListCRUD_Cls.Response response = new BE_SingleRelatedListCRUD_Cls.Response();
        Final Savepoint svp = Database.setSavePoint();

        try {
            response = BE_SingleRelatedListModal_Ctr.returnResponse(lstGD, 'update');
        
            Final acpl__Commercial_Plan_Event__c[] lstCPE = [SELECT Id, Name, acpl__gf_event_date__c, ClientAssigned__c FROM acpl__Commercial_Plan_Event__c WHERE GrowthDriver__c =: lstGD[0].Id LIMIT 1];
            

            if(!lstCPE.isEmpty() && lstGD[0].ExpectedDate__c == null) {
                Database.rollback(svp);
                response.isSuccess = false;
                response.message = 'No puede dejar vacio el campo de fecha estimada de cierre.';
            }

            if(response.isSuccess && !lstCPE.isEmpty()) {
                lstCPE[0].Name = lstCPE[0].Name.left(lstCPE[0].Name.length() - 10) + String.valueOf(lstGD[0].ExpectedDate__c).left(10);
                lstCPE[0].acpl__gf_event_date__c = lstGD[0].ExpectedDate__c;
                lstCPE[0].ClientAssigned__c = lstGD[0].ClientAssigned__c;
                //lstCPE[0].Comments__c = lstGD[0].bupl__gf_growth_drvr_prdt_desc__c;

                response = BE_SingleRelatedListModal_Ctr.returnResponse(lstCPE, 'update');

                if(validateProductInactive(lstGD[0].bupl__solution_category_desc__c, lstGD[0].CurrencyIsoCode)) {
                    Database.rollback(svp);
                    response.isSuccess = false;
                    response.message = 'El producto no se encuentra disponible. Seleccione otro producto y/o moneda.';
                } else if(!response.isSuccess) {
                    Database.rollback(svp);
                    response.isSuccess = false;
                    response.message = 'Ocurrió un error.';
                }     

                validateOpportunity(lstCPE, response, svp);
            }
        } catch(Exception e) {
            response.isSuccess = false;
            response.message = e.getMessage();
        }
        
        return response;
    }

    /*
    * @Description  method deleteRecords
    */
    public override BE_SingleRelatedListCRUD_Cls.Response deleteRecords(List<SObject> sObjsIds) {
        Final List<bupl__BP_GrowthDriver__c> lstGD = (List<bupl__BP_GrowthDriver__c>) sObjsIds;
        BE_SingleRelatedListCRUD_Cls.Response response = new BE_SingleRelatedListCRUD_Cls.Response();
        
        Final Savepoint sPoint = Database.setSavePoint();

        try {
            Final acpl__Commercial_Plan_Event__c[] lstCPE = [SELECT Id, Name, acpl__gf_event_date__c, ClientAssigned__c FROM acpl__Commercial_Plan_Event__c WHERE GrowthDriver__c =: lstGD[0].Id LIMIT 1];

            Final Set<Id> typeActionSet = verifyTypeAction(lstCPE);
			
            response = BE_SingleRelatedListModal_Ctr.returnResponse(lstGD, 'delete');
            
            if(typeActionSet.isEmpty() == false) {            
                Database.rollback(sPoint);
                response.isSuccess = false;
                response.message = 'No puedes eliminar una variable de crecimiento creada en una validación anterior.';
            } else if(lstCPE.size() > 0 && response.isSuccess) {
                response = BE_SingleRelatedListModal_Ctr.returnResponse(lstCPE, 'delete');
                
                if(!response.isSuccess) {
                    Database.rollback(sPoint);
                    response.isSuccess = false;
                    response.message = 'Ocurrió un error.';
                }
            }
        } catch (Exception e) {
            response.isSuccess = false;
            response.message = e.getMessage();
        }
        
        return response;
    }

    
    private static Set<Id> verifyTypeAction(List<acpl__Commercial_Plan_Event__c> cpeList) {
        Final Set<Id> cpeIdSet = new Set<Id>();

        if(!cpeList.isEmpty()) {
            for(Opportunity opp : [SELECT Id, commercial_plan_event__c FROM Opportunity WHERE commercial_plan_event__c =: cpeList[0].Id]) {
                cpeIdSet.add(opp.commercial_plan_event__c);
            }
        }
		
		return cpeIdSet;
	}

    /* valida oportunidades con clientes asignados */
    public static void validateOpportunity(List<acpl__Commercial_Plan_Event__c> cpeList, BE_SingleRelatedListCRUD_Cls.Response response, Savepoint svp) {
        Final Set<Id> cpeIdSet = new Set<Id>();
        for(Opportunity opp : [SELECT Id, commercial_plan_event__c, AccountId FROM Opportunity WHERE commercial_plan_event__c =: cpeList[0].Id]) {
            if(cpeList[0].ClientAssigned__c != null && opp.AccountId != cpeList[0].ClientAssigned__c) {
                cpeIdSet.add(opp.commercial_plan_event__c);
            }
        }

        if(cpeIdSet.isEmpty() == false) {
            Database.rollback(svp);
            response.isSuccess = false;
            response.message = 'No puedes modificar el cliente asignado creado en una validación anterior.';
        }
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
                                               
		Final BE_SingleRelatedListCRUD_Cls.Response response = BE_SingleRelatedListModal_Ctr.returnResponse(cpe, 'insert');

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