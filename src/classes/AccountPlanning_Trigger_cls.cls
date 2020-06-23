/**
 * Logic class of Handler Trigger of the AccountPlanning object.
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		15/05/2020          Original version.<p />
 * @SuppressWarnings("PMD.CyclomaticComplexity"): Se utiliza para excluir del sonar para el metodo relateAPQuestions
 * implementado por Global
 * @author Diego Carbajal
 */
@SuppressWarnings('PMD.CyclomaticComplexity')
public without sharing class AccountPlanning_Trigger_cls {
	/* @Description guarda id del RecordType de AP*/
	private static Final Id RT_AP = [SELECT Id FROM RecordType WHERE developerName = 'Account_Planning' AND SobjectType = 'acpl__Account_Planning__c' LIMIT 1].Id;

    /* @Description AccountPlanning_Trigger_cls*/
    private AccountPlanning_Trigger_cls() {}
	/**
	 * @Description Execute various methods according to different criteria
	 */
	public static void beforeInsert(List<acpl__Account_Planning__c> triggerNew) {
		Final Set<Id> idsGestor = new Set<Id>();
		Final Set<Id> idsAccount = new Set<Id>();
		for(acpl__Account_Planning__c ap: triggerNew) {
			//Only AP's with RecordType 'Account_Planning'
			if(ap.RecordTypeId == RT_AP) {
				idsGestor.add(ap.acpl__proposal_manager_id__c);
				idsAccount.add(ap.acpl__participant_id__c);
			}
		}
		//Obtienen los validadores de acuerdo al jefe directo de cada gestor del AP asignado
		Final Map<Id, User> mapGestor = new Map<Id, User>([SELECT Id, ManagerId, isActive, Manager.isActive FROM User WHERE Id IN: idsGestor]);
		//Obtiene el valor de la estrategia del ultimo AP validado
		Final Map<Id, String> mapStrategic = AP_Trigger_Helper.getStrategicHistorial(idsAccount);
		for(acpl__Account_Planning__c ap: triggerNew) {
			//Only AP's with RecordType 'Account_Planning'
			if(ap.RecordTypeId == RT_AP) {
				//Coloca validadores correspondientes
				if(String.isNotBlank(ap.acpl__proposal_manager_id__c) && String.isNotBlank(mapGestor.get(ap.acpl__proposal_manager_id__c).ManagerId)) {
					ap.acpl__gf_ap_validator_user_id__c = mapGestor.get(ap.acpl__proposal_manager_id__c).ManagerId;
				}
				//Coloca la estrategia pasada
				if(String.isNotBlank(ap.acpl__participant_id__c) && mapStrategic.containsKey(ap.acpl__participant_id__c)) {
					ap.Strategic_desc__c = mapStrategic.get(ap.acpl__participant_id__c);
				}
			}
		}
	}

	/**
	 * @Description Agrega los validadores a los AP's de acuerdo al ejecutivo asignado
	 */
	public static void afterInsert(List<acpl__Account_Planning__c> triggerNew) {
		//Variable for createRelatedBP() method
		Final List<bupl__BusinessPlan__c> lstNewBP = new List<bupl__BusinessPlan__c>();
		//Variable for createAptOwner() method
		Final Map<Id, Id> ownersAPT = new Map<Id, Id>();
		for(acpl__Account_Planning__c ap: triggerNew) {
			if(ap.RecordTypeId == RT_AP) {
				lstNewBP.add(new bupl__BusinessPlan__c(acpl__gf_account_planning_id__c = ap.Id, Name = 'Plan de Negocio ' + ap.Name, bupl__gf_ap_public_ind_type__c = false,
				                                       bupl__status_type__c = ap.acpl__gf_ap_status_type_name__c));
				if(String.isNotBlank(ap.acpl__proposal_manager_id__c)) {
					ownersAPT.put(ap.Id, ap.acpl__proposal_manager_id__c);
				}
			}
		}
		//Crea BP relacionados al AP
		if(!lstNewBP.isEmpty()) {
			insert lstNewBP;
			AP_Trigger_Helper.createBPV(lstNewBP);
		}
		//Requiere que exista BP antes de ejecutarse
		AP_Trigger_Helper.createAptOwner(ownersAPT);
	}

	/*
	 * @Description  Previene la modificación/eliminación de AP de acuerdo a diferentes usuarios/estados del AP
	 */
	public static void beforeDML(Map<Id, acpl__Account_Planning__c> triggerMap, Map<Id, acpl__Account_Planning__c> triggerOldMap, String actionType) {
		AccountPlanning_Trigger_Validation_cls.preventModifyAP(triggerMap, triggerOldMap, actionType);
	}

	/*
	 * @Description  Cambia el estado del AP de 'Not Started' a 'In Progress' cuando el AP no esta bloqueado o expirado y el usuario se encuentra en el APT
	 */
	public static void updateStatusOnAPnotStarted(List<acpl__Account_Planning__c> triggerNew, Map<Id, acpl__Account_Planning__c> triggerOldMap) {
		//Obtenemos guías de exito
		Final acpl__AP_PeriodConfiguration__c[] config = [SELECT Id, acpl__gf_ap_bus_pl_guide_desc__c, acpl__gf_ap_comm_plan_guide_desc__c,
		                                                  acpl__gf_ap_strat_anlys_guide_desc__c FROM acpl__AP_PeriodConfiguration__c
		                                                  WHERE Name = 'Configuration' LIMIT 1];
		Final BE_AP_Permission_helper permission = new BE_AP_Permission_helper(UserInfo.getUserId());
		Final Map<Id, Set<Id>> mapAPTs = permission.getAPTs(triggerOldMap.keySet());
		for(acpl__Account_Planning__c apR : triggerNew) {
			if(apR.RecordTypeId == RT_AP) {
				AP_Trigger_Helper.putValues(mapAPTs, apR, config);
			}
		}
	}

	/*
	 * @Description  Elimina registros relacionados al AP
	 */
	public static void beforeDeleteRelatedRecords(Map<Id, acpl__Account_Planning__c> triggerOldMap) {
		//Elimina el historial del AP
		delete [Select id From dwp_cvad__Action_Audit__c Where dwp_cvad__action_audit_record_id__c in : triggerOldMap.keySet()];
		//Elimina los los registros del objeto dyfr__Field_Config__c relacionados AP
		AP_Trigger_Helper.deleteFieldsConfig(triggerOldMap);
		//Elimina el Business Plan asociado al AP
		delete [SELECT ID, acpl__gf_account_planning_id__c, name FROM bupl__BusinessPlan__c WHERE acpl__gf_account_planning_id__c IN : triggerOldMap.keySet()];
		//Elimina los APT del AP
		delete [Select id From bupl__AP_Team__c Where acpl__gf_account_planning_id__c in : triggerOldMap.keySet()];
	}

	/*
	 * @Description  Clona las preguntas del Catalogo y los asocia a cada AP insertado
	 */
	public static void relateAPQuestions(List<acpl__Account_Planning__c> triggernew) {//NOSONAR
		//Guardo las preguntas del AP Catalog
		final List<acpl__AP_Question__c> apQuestionList = [SELECT Id, acpl__gf_account_planning_id__c, acpl__gf_account_planning_id__r.Name, acpl__gf_ap_question_form_desc__c, Name,
		                                                   acpl__AA_answer_is_checkbox__c FROM acpl__AP_Question__c WHERE acpl__gf_account_planning_id__r.Name = 'Question Catalog'];
		//Obtengo los fieldConfigs del AP Catalog
		if(!apQuestionList.isEmpty()) {
			Final List<acpl__AP_Question__c> apQuestionsInsrt = new List<acpl__AP_Question__c>();
			final String catalogDevName = apQuestionList.get(0).acpl__gf_account_planning_id__c + '%';
			final List<dyfr__Field_Config__c> fieldConfigList = [SELECT Id, dyfr__Tab__c, dyfr__Section_name__c, dyfr__Section_order__c,
			                                                     dyfr__Subsection_name__c, dyfr__Subsection_order__c, dyfr__Order__c,
			                                                     acpl__gf_counter_number__c, dyfr__Map_field__c, dyfr__Type__c, dyfr__Important__c,
			                                                     dyfr__Visibility_control_field__c, dyfr__Visibility_control_value__c, dyfr__Values_control_field__c,
			                                                     dyfr__Relationship_Object_Name__c, dyfr__Relationship_Dynamic_Label_Field__c,
			                                                     dyfr__Relationship_Query_Field__c, dyfr__Relationship_Query_Content__c, dyfr__DeveloperName__c, dyfr__Mandatory__c
			                                                     FROM dyfr__Field_Config__c WHERE dyfr__DeveloperName__c LIKE :catalogDevName];
			List<dyfr__Field_Config__c> catalogCnfig = new List<dyfr__Field_Config__c>();
			catalogCnfig = fieldConfigList.deepClone(true, true);
			Final List<List<dyfr__Field_Config__c>> lstFullFConfig = new List<List<dyfr__Field_Config__c>>();
			List<dyfr__Field_Config__c> tmpFieldsConfig;
			for(acpl__Account_Planning__c apAux : triggernew) {
				tmpFieldsConfig = new List<dyfr__Field_Config__c>();
				for(acpl__AP_Question__c apQuestionAux : apQuestionList) {
					final acpl__AP_Question__c newAPQuestion = new acpl__AP_Question__c();
					newAPQuestion.acpl__gf_account_planning_id__c = apAux.Id;
					newAPQuestion.acpl__gf_ap_question_form_desc__c = apQuestionAux.acpl__gf_ap_question_form_desc__c;
					newAPQuestion.acpl__AA_answer_is_checkbox__c = apQuestionAux.acpl__AA_answer_is_checkbox__c;
					final List<String> questionName = apQuestionAux.Name.split('_');
					newAPQuestion.Name = apAux.Id + '_' + questionName.get(1);
					apQuestionsInsrt.add(newAPQuestion);
				}
				dyfr__Field_Config__c tmpFieldConfig;
				for(dyfr__Field_Config__c fieldConfigAux : fieldConfigList) {
					tmpFieldConfig = new dyfr__Field_Config__c(dyfr__Tab__c = fieldConfigAux.dyfr__Tab__c, dyfr__Section_name__c = fieldConfigAux.dyfr__Section_name__c,
					                                           dyfr__Section_order__c = fieldConfigAux.dyfr__Section_order__c, dyfr__Subsection_name__c = fieldConfigAux.dyfr__Subsection_name__c,
					                                           dyfr__Subsection_order__c = fieldConfigAux.dyfr__Subsection_order__c, dyfr__Order__c = fieldConfigAux.dyfr__Order__c,
					                                           acpl__gf_counter_number__c = fieldConfigAux.acpl__gf_counter_number__c, dyfr__Map_field__c = fieldConfigAux.dyfr__Map_field__c,
					                                           dyfr__Type__c = fieldConfigAux.dyfr__Type__c,
					                                           dyfr__Visibility_control_value__c = fieldConfigAux.dyfr__Visibility_control_value__c,
					                                           dyfr__Relationship_Object_Name__c = fieldConfigAux.dyfr__Relationship_Object_Name__c,
					                                           dyfr__Relationship_Dynamic_Label_Field__c = fieldConfigAux.dyfr__Relationship_Dynamic_Label_Field__c,
					                                           dyfr__Relationship_Query_Field__c = fieldConfigAux.dyfr__Relationship_Query_Field__c,
					                                           dyfr__Mandatory__c = fieldConfigAux.dyfr__Important__c, dyfr__Important__c = fieldConfigAux.dyfr__Important__c);
					final List<String> developerName = fieldConfigAux.dyfr__DeveloperName__c.split('_');
					tmpFieldConfig.dyfr__DeveloperName__c = apAux.Id + '_' + developerName.get(1);
					tmpFieldConfig.dyfr__Relationship_Query_Content__c = tmpFieldConfig.dyfr__DeveloperName__c;
					if(fieldConfigAux.dyfr__Visibility_control_field__c != '' && fieldConfigAux.dyfr__Visibility_control_field__c != null) {
						final List<String> visibilitycf = fieldConfigAux.dyfr__Visibility_control_field__c.split('_');
						tmpFieldConfig.dyfr__Visibility_control_field__c = apAux.Id + '_' + visibilitycf.get(1);
					}
					if(fieldConfigAux.dyfr__Values_control_field__c != '' && fieldConfigAux.dyfr__Values_control_field__c != null) {
						final List<String> valuecf = fieldConfigAux.dyfr__Values_control_field__c.split('_');
						tmpFieldConfig.dyfr__Values_control_field__c = apAux.Id + '_' + valuecf.get(1);
					}
					fieldConfigAux.Id = null; //NOSONAR
					tmpFieldsConfig.add(tmpFieldConfig);
				}
				lstFullFConfig.add(tmpFieldsConfig);
			}
			tmpFieldsConfig = new List<dyfr__Field_Config__c>();
			for(Integer i = 0; i < lstFullFConfig.size(); i++) {
				tmpFieldsConfig.addAll(lstFullFConfig[i]);
			}
			//inserto las preguntas
			insert apQuestionsInsrt;
			insert tmpFieldsConfig;
			AP_Trigger_Helper.relateListValues(lstFullFConfig, catalogCnfig);
		}
	}

}