/**
 * Handler class of Trigger handler of the AccountPlanning object.
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		15/05/2020          Original version.<p />
 *
 * @author Diego Carbajal
 */
public without sharing class AP_Trigger_Helper {
    
    /**
	 * @Description AP_Trigger_Helper
	 */
    private AP_Trigger_Helper() {}
    /**
	 * @Description Obtiene la estrategia rellenada en el AP pasado y validado
	 */
	public static Map<Id, String> getStrategicHistorial(Set<Id> idsAccount) {
		Final Map<Id, String> mapStrategic = new Map<Id, String>();
		for(acpl__Account_Planning__c apAux:[SELECT Id, acpl__participant_id__c, Strategic_desc__c, acpl__gf_ap_status_type_name__c, createdDate FROM acpl__Account_Planning__c
		                                     WHERE acpl__participant_id__c IN:idsAccount AND acpl__gf_ap_status_type_name__c = 'Validated' ORDER BY createdDate ASC]) {
			mapStrategic.put(apAux.acpl__participant_id__c, apAux.Strategic_desc__c);
		}
		return mapStrategic;
	}

	/*
	 * @Description  Crea APT propietarios a los AP's
	 */
	public static void createAptOwner(Map<Id, Id> ownersAPT) {
		Final Integer ownersAPTSize = ownersAPT.size();
		if(ownersAPTSize > 0) {
			Final bupl__AP_Team__c[] lstAPTOwners = new bupl__AP_Team__c[] {};
			bupl__AP_Team__c aptOwner;
			for(Id key:ownersAPT.keySet()) {
				aptOwner = new bupl__AP_Team__c(acpl__gf_account_planning_id__c = key, account_planning_Owner__c = true, bupl__gf_ap_team_role_user_name__c = 'Gestor del Plan',
				                                bupl__gf_ap_team_user_id__c = ownersAPT.get(key));
				lstAPTOwners.add(aptOwner);
			}
			Final Integer lstAPTOwnersSize = lstAPTOwners.size();
			if(lstAPTOwnersSize > 0) {
				insert lstAPTOwners;
			}
		}
	}

	/*
	 * @Description  Elimina fieldsConfig
	 */
	public static void deleteFieldsConfig(Map<Id, acpl__Account_Planning__c> triggerOldMap) {
		Final List<String> lstDeveloperNames = new List<String>();
		for(String apId:triggerOldMap.keySet()) {
			for(Integer i = 1; i <= triggerOldMap.get(apId).acpl__gf_ap_question_form_number__c; i++) {
				Final String dvName = apId + '_Q' + i;
				lstDeveloperNames.add(dvName);
			}
		}
		delete [SELECT Id FROM dyfr__Field_Config__c WHERE dyfr__DeveloperName__c IN : lstDeveloperNames];
	}

	/*
	 * @Description  Crea BusinessPlanVersion a cada BusinessPlan
	 */
	public static void createBPV(List<bupl__BusinessPlan__c> lstNewBP) {
		Final List<bupl__BusinessPlan_Version__c> lstNewBPV = new List<bupl__BusinessPlan_Version__c>();
		bupl__BusinessPlan_Version__c newBPV;
		for(bupl__BusinessPlan__c bp: lstNewBP) {
			newBPV = new bupl__BusinessPlan_Version__c(bupl__gf_business_plan_id__c = bp.Id, Name = bp.Name + ' V1', bupl__gf_business_plan_act_ind_type__c = 'Yes');
			lstNewBPV.add(newBPV);
		}
		Final Integer lstNewBPVSize = lstNewBPV.size();
		if(lstNewBPVSize > 0) {
			insert lstNewBPV;
		}
	}

	/*
	 * @Description  Asocia valores de lista del catalogo a cada pregunta clonada
	 */
	public static void relateListValues(List<List<dyfr__Field_Config__c>> fieldsConfig, List<dyfr__Field_Config__c> catalogCnfig) {
		Final Set<Id> ctlgCnfigSet = new Set<Id>();
		for(dyfr__Field_Config__c fieldConfigAux : catalogCnfig) {
			if(!ctlgCnfigSet.contains(fieldConfigAux.Id)) {
				ctlgCnfigSet.add(fieldConfigAux.Id);
			}
		}
		//Obtengo los dependent values del AP Catalog
		final List<dyfr__Dependent_value__c> catalogListValues = [SELECT Id, dyfr__LoV_labels__c, dyfr__LoV_values__c, dyfr__Values_control_value__c,
		                                                          dyfr__Field_Config__c, dyfr__Field_Config__r.Id, dyfr__Field_Config__r.dyfr__DeveloperName__c
		                                                          FROM dyfr__Dependent_value__c WHERE dyfr__Field_Config__r.Id IN :ctlgCnfigSet];

		final List<dyfr__Dependent_value__c> depValuesToInsert = new List<dyfr__Dependent_value__c>();

		//recorro los fieldconfig a insertar
		for(Integer i = 0; i < fieldsConfig.size(); i++) {
			for(dyfr__Field_Config__c fieldConfigAux : fieldsConfig[i]) {
				//cojo el correspondiente fieldConfig del catálogo - bueno cojo los dep values con LIKE en el dyfr__Field_Config__r.dyfr__DeveloperName__c.dev
				for(dyfr__Dependent_value__c depValueAux : catalogListValues) {
					final List<String> developerNameFC = fieldConfigAux.dyfr__DeveloperName__c.split('_');
					final List<String> developerNameDV = depValueAux.dyfr__Field_Config__r.dyfr__DeveloperName__c.split('_');
					//  y voy creando sus dependent values
					if(developerNameFC.get(1) == developerNameDV.get(1)) {
                        Final dyfr__Dependent_value__c depValue = new dyfr__Dependent_value__c(dyfr__LoV_labels__c = depValueAux.dyfr__LoV_labels__c, dyfr__LoV_values__c = depValueAux.dyfr__LoV_values__c,
					                                        dyfr__Values_control_value__c = depValueAux.dyfr__Values_control_value__c, dyfr__Field_Config__c = fieldConfigAux.Id);
						depValuesToInsert.add(depValue);
					}
				}
			}
		}
		//inserto los dependent values
		insert depValuesToInsert;
	}
    
    /*
	 * @Description  putValues
	 */
    public static void putValues(Final Map<Id, Set<Id>> mapAPTs, acpl__Account_Planning__c apR, acpl__AP_PeriodConfiguration__c[] config) {
        Final Boolean userInAPT = (mapAPTs.get(apR.Id) == null ? false : mapAPTs.get(apR.Id).contains(UserInfo.getUserId()) );
        if(userInAPT && apR.acpl__gf_ap_status_type_name__c == 'Not started' && apR.acpl__gf_ap_substatus_type_name__c != Label.acpl.AP_Timed_Out) {
            apR.acpl__gf_ap_status_type_name__c = 'In Progress';
            apR.acpl__gf_ap_substatus_type_name__c = 'AP team not invited';
        }
        if(!config.isEmpty() && apR.acpl__gf_ap_status_type_name__c == 'Validated' && apR.acpl__gf_ap_substatus_type_name__c != Label.acpl.AP_Timed_Out) {
            apR.acpl__gf_ap_bus_pl_guide_desc__c = config[0].acpl__gf_ap_bus_pl_guide_desc__c;
            apR.acpl__gf_ap_comm_plan_guide_desc__c = config[0].acpl__gf_ap_comm_plan_guide_desc__c;
            apR.acpl__gf_ap_strat_anlys_guide_desc__c = config[0].acpl__gf_ap_strat_anlys_guide_desc__c;
        }
    }
    
    /*
	 * @Description  Convierte las acciones comerciales cuando se validan los AP's
	 */
	public static void postValidated(Map<Id, acpl__Account_Planning__c> triggerNewMap) {
		Final Map<Id, acpl__Account_Planning__c> validatedAP = new Map<Id, acpl__Account_Planning__c>();
		for(acpl__Account_Planning__c ap:triggerNewMap.values()) {
			//Verifica que el AP se ha validado y esta asociado a un cliente
			if(!ap.acpl__gf_ap_indvi_lock_edit_ind_type__c && ap.acpl__gf_ap_status_type_name__c == 'Validated' &&
			   ap.acpl__gf_ap_substatus_type_name__c == 'In place' && String.isNotBlank(ap.acpl__participant_id__c)) {
				validatedAP.put(ap.Id, ap);
			}
		}
        Final Integer validateSize = validatedAP.size();
		if(validateSize > 0) {
			//Obtiene las acciones comerciales relacionadas al AP
			Final Map<Id, acpl__Commercial_Plan_Event__c> mapCPE = new Map<Id, acpl__Commercial_Plan_Event__c>([SELECT Id, acpl__gf_account_planning_id__c, Comments__c, Name, acpl__gf_event_date__c,
			                                                                                                    acpl__gf_account_planning_id__r.acpl__participant_id__r.Name, acpl__gf_comm_plan_event_type_name__c, Asiggned_User__c,
																												acpl__gf_account_planning_id__r.acpl__proposal_manager_id__c, acpl__gf_account_planning_id__r.acpl__participant_id__c, 
																												acpl__gf_account_planning_id__r.acpl__participant_id__r.RecordType.DeveloperName, ClientAssigned__c, ClientAssigned__r.Name 
			                                                                                                    FROM acpl__Commercial_Plan_Event__c WHERE acpl__gf_account_planning_id__c IN: validatedAP.keySet()]);
			Final Integer mapCPESize = mapCPE.size();
			if(mapCPESize > 0) {
				//Convierte las acciones comerciales
				AP_ConvertCPE_cls.convertCPERecords(mapCPE);
			}
		}
	}
}