/**
 * BE_AP_CheckEditionByPeriodBatchHandler for lock/unlock AP's
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		05/05/2020          Original version.<p />
 *
 * @author Diego Carbajal
 */
public with sharing class BE_AP_CheckEditionByPeriodBatchHandler {
	/*
	 * @author
	 * @Description  Bloqueo/Desbloqueo de AP's
	 */
	Final static Date actualDate = Date.today();

	/*
	 * @Description  method editionControl
	 */
	public static void editionControl(List<acpl__Account_Planning__c> apList) {
		// Retrieve configuration for periods loaded in the org
		final List<acpl__AP_PeriodConfiguration__c> apConfigList = [SELECT Id, acpl__gf_ap_edit_prms_type_name__c, acpl__gf_ap_edit_days_left_number__c, acpl__gf_ap_genrl_lock_edit_ind_type__c
		                                                            FROM acpl__AP_PeriodConfiguration__c LIMIT 1];
		Savepoint iSavePoint;
		if(!apConfigList.isEmpty()) {
			Map<String, String> mapEventEdition;
			Map<String, String> mapGnrlOrPriority;
			// Retrieve periods loaded in the org, which are applied to the Account Plannings
			Map<String, acpl__AP_Period__c> mapPeriods = new Map<String, acpl__AP_Period__c>();
			for(acpl__AP_Period__c period: [SELECT Id, acpl__gf_ap_edit_start_date__c, acpl__gf_ap_edit_end_date__c, acpl__gf_ap_priority_edit_type__c FROM acpl__AP_Period__c]) {
				mapPeriods.put(period.acpl__gf_ap_priority_edit_type__c, period);
			}
			iSavePoint = Database.setSavepoint();
			// For each Account Planning, if it's out of its edit period, OR out of its event days allowed to edit, block its edition
			try {
				for(acpl__Account_Planning__c apAux : apList) {
					mapGnrlOrPriority = checkGeneralOrPriotityEdition(apAux, mapPeriods, apConfigList.get(0));
					mapEventEdition = checkEventDateEdition(apAux, apConfigList.get(0));
					if(mapEventEdition.get('change') == 'true' || mapGnrlOrPriority.get('change') == 'true') {
						if(mapEventEdition.get('edition') == 'unlock' || mapGnrlOrPriority.get('edition') == 'unlock') {
							apAux.acpl__gf_ap_indvi_lock_edit_ind_type__c = true;
						} else {
							apAux.acpl__gf_ap_indvi_lock_edit_ind_type__c = false;
						}
					}
				}
				update apList;
			} catch(Exception e) {
				Database.rollback(iSavePoint);
				System.debug(e.getMessage());
			}
		}
	}

	/*
	 * @Description  method checkGeneralOrPriotityEdition
	 */
	public static Map<String, String> checkGeneralOrPriotityEdition(acpl__Account_Planning__c apAux, Map<String, acpl__AP_Period__c> mapPriority, acpl__AP_PeriodConfiguration__c apConfig) {
		Map<String, String> mapEditionAP = new Map<String, String> {'change' => 'false', 'edition' => ''};
		if(!mapPriority.values().isEmpty() && apConfig.acpl__gf_ap_edit_prms_type_name__c == 'General') {
			acpl__AP_Period__c gnrlPeriod = mapPriority.values().get(0);
			if(actualDate == gnrlPeriod.acpl__gf_ap_edit_start_date__c) {
				mapEditionAP = putEditionValue(mapEditionAP, 'unlock');
			} else if(actualDate > gnrlPeriod.acpl__gf_ap_edit_end_date__c) {
				mapEditionAP = putEditionValue(mapEditionAP, 'lock');
			}
		} else if(!mapPriority.values().isEmpty() && apConfig.acpl__gf_ap_edit_prms_type_name__c == 'Priority') {
			acpl__AP_Period__c priorityPeriod = mapPriority.get(apAux.acpl__gf_ap_priority_type_name__c);
			if(priorityPeriod != null && actualDate == priorityPeriod.acpl__gf_ap_edit_start_date__c) {
				mapEditionAP = putEditionValue(mapEditionAP, 'unlock');
			} else if(priorityPeriod != null && actualDate > priorityPeriod.acpl__gf_ap_edit_end_date__c) {
				mapEditionAP = putEditionValue(mapEditionAP, 'lock');
			}
		}
		return mapEditionAP;
	}

	/*
	 * @Description  method checkEventDateEdition
	 */
	public static Map<String, String> checkEventDateEdition(acpl__Account_Planning__c apAux, acpl__AP_PeriodConfiguration__c apConfig) {
		Map<String, String> mapEditionAP = new Map<String, String> {'change' => 'false', 'edition' => ''};
		if(apConfig.acpl__gf_ap_edit_days_left_number__c != null && apAux.acpl__gf_event_date__c != null) {
			//Si los acpl__gf_ap_edit_days_left_number__c es negativo, las fecha de AP ser�n:
			//la fecha de inicio =  acpl__gf_event_date__c - d�as en acpl__gf_ap_edit_days_left_number__c
			//fecha de fin = acpl__gf_event_date__c
			if(apConfig.acpl__gf_ap_edit_days_left_number__c < 0) {
				//Si (acpl__gf_event_date__c - acpl__gf_ap_edit_days_left_number__c) es hoy y acpl__gf_event_date__c es mayor a hoy, se desbloquea el AP
				if(actualDate == apAux.acpl__gf_event_date__c.addDays((Integer)apConfig.acpl__gf_ap_edit_days_left_number__c) && actualDate < apAux.acpl__gf_event_date__c) {
					mapEditionAP = putEditionValue(mapEditionAP, 'unlock');
					//Si la fecha de hoy es mayor a acpl__gf_event_date__c, se bloquea el AP
				} else if(actualDate > apAux.acpl__gf_event_date__c) {
					mapEditionAP = putEditionValue(mapEditionAP, 'lock');
				}
				//Si los acpl__gf_ap_edit_days_left_number__c es positivo, las fecha de AP ser�n:
				//fecha de inicio = acpl__gf_event_date__c
				//fecha de fin = acpl__gf_event_date__c + acpl__gf_ap_edit_days_left_number__c.
			} else if(apConfig.acpl__gf_ap_edit_days_left_number__c > 0) {
				//Si acpl__gf_event_date__c es hoy y (acpl__gf_event_date__c + acpl__gf_ap_edit_days_left_number__c) es mayor a hoy, se desbloquea el AP
				if(actualDate == apAux.acpl__gf_event_date__c && actualDate < apAux.acpl__gf_event_date__c.addDays((Integer)apConfig.acpl__gf_ap_edit_days_left_number__c)) {
					mapEditionAP = putEditionValue(mapEditionAP, 'unlock');
					//Si hoy es mayor a (acpl__gf_event_date__c + acpl__gf_ap_edit_days_left_number__c), se bloquea el AP
				} else if(actualDate > apAux.acpl__gf_event_date__c.addDays((Integer)apConfig.acpl__gf_ap_edit_days_left_number__c)) {
					mapEditionAP = putEditionValue(mapEditionAP, 'lock');
				}
			}
		}
		return mapEditionAP;
	}

	/*
	 * @Description  method putEditionValue
	 */
	public static Map<String, String> putEditionValue(Map<String, String> mapEdition, String edition) {
		return new Map<String, String> {'change' => 'true', 'edition' => edition};
	}
}
