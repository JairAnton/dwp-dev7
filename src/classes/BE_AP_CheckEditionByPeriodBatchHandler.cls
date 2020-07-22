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
    /** @Description  LOCK*/
    private static Final String LOCK = 'lock';
    /** @Description  UNLOCK*/
    private static Final String UNLOCK = 'unlock';
    /** @Description  EDITION_TYPE*/
    private static Final String EDITION_TYPE = 'edition';
    /** @Description  CHANGE*/
    private static Final String CHANGE = 'change';
    /** @Description  FALSO*/
    private static Final String FALSO = 'false';
    /** @Description  V_PRIORITY*/
    private static Final String V_PRIORITY = 'Period by priority';
    /** @Description  V_GENERAL*/
    private static Final String V_GENERAL = 'General period';
	/*
	 * @author
	 * @Description  Bloqueo/Desbloqueo de AP's
	 */
	private Final static Date ACTUAL_DATE = Date.today();
	/** @Description  BE_AP_CheckEditionByPeriodBatchHandler*/
    private BE_AP_CheckEditionByPeriodBatchHandler() {}
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
			Final Map<String, acpl__AP_Period__c> mapPeriods = new Map<String, acpl__AP_Period__c>();
			for(acpl__AP_Period__c period: [SELECT Id, acpl__gf_ap_edit_start_date__c, acpl__gf_ap_edit_end_date__c, acpl__gf_ap_priority_edit_type__c FROM acpl__AP_Period__c LIMIT 20]) {
				mapPeriods.put(period.acpl__gf_ap_priority_edit_type__c, period);
			}
			iSavePoint = Database.setSavepoint();
			// For each Account Planning, if it's out of its edit period, OR out of its event days allowed to edit, block its edition
			try {
				for(acpl__Account_Planning__c apAux : apList) {
					mapGnrlOrPriority = checkGeneralOrPriotityEdition(apAux, mapPeriods, apConfigList.get(0));
					mapEventEdition = checkEventDateEdition(apAux, apConfigList.get(0));
					if(mapEventEdition.get(CHANGE) == 'true' || mapGnrlOrPriority.get(CHANGE) == 'true') {
						if(mapEventEdition.get(EDITION_TYPE) == UNLOCK || mapGnrlOrPriority.get(EDITION_TYPE) == UNLOCK) {
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
		Map<String, String> mapEditionAP = new Map<String, String> {CHANGE => FALSO, EDITION_TYPE => ''};
		if(!mapPriority.values().isEmpty() && apConfig.acpl__gf_ap_edit_prms_type_name__c == 'General') {
			mapEditionAP = getGrnlVal(apAux, mapPriority.values().get(0));
		} else if(!mapPriority.values().isEmpty() && apConfig.acpl__gf_ap_edit_prms_type_name__c == 'Wave') {
			mapEditionAP = getPrtyVal(apAux, mapPriority.get(apAux.acpl__gf_ap_priority_type_name__c));
		}
		return mapEditionAP;
	}
    
    /*
	 * @Description  getGrnlVal
	 */
    private static Map<String, String> getGrnlVal(acpl__Account_Planning__c apAux, acpl__AP_Period__c gnrlPeriod) {
        Map<String, String> mapEditionAP = new Map<String, String> {CHANGE => FALSO, EDITION_TYPE => ''};
        if(apAux.acpl__gf_ap_launch_name__c == V_GENERAL) {
            if(ACTUAL_DATE == gnrlPeriod.acpl__gf_ap_edit_start_date__c) {
                mapEditionAP = putEditionValue(mapEditionAP, UNLOCK);
            } else if(ACTUAL_DATE > gnrlPeriod.acpl__gf_ap_edit_end_date__c) {
                mapEditionAP = putEditionValue(mapEditionAP, LOCK);
            }
        }
        return mapEditionAP;
    }
    
    /*
	 * @Description  getPrtyVal
	 */
    private static Map<String, String> getPrtyVal(acpl__Account_Planning__c apAux, acpl__AP_Period__c priorityPeriod) {
        Map<String, String> mapEditionAP = new Map<String, String> {CHANGE => FALSO, EDITION_TYPE => ''};
        if(apAux.acpl__gf_ap_launch_name__c == V_PRIORITY) {
            if(priorityPeriod != null && ACTUAL_DATE == priorityPeriod.acpl__gf_ap_edit_start_date__c) {
				mapEditionAP = putEditionValue(mapEditionAP, UNLOCK);
			} else if(priorityPeriod != null && ACTUAL_DATE > priorityPeriod.acpl__gf_ap_edit_end_date__c) {
				mapEditionAP = putEditionValue(mapEditionAP, LOCK);
			}
        }
			
        return mapEditionAP;
    }

	/*
	 * @Description  method checkEventDateEdition
	 */
	public static Map<String, String> checkEventDateEdition(acpl__Account_Planning__c apAux, acpl__AP_PeriodConfiguration__c apConfig) {
		Map<String, String> mapEditionAP = new Map<String, String> {CHANGE => FALSO, EDITION_TYPE => ''};
		if(apConfig.acpl__gf_ap_edit_days_left_number__c != null && apAux.acpl__gf_event_date__c != null 
           && apAux.acpl__gf_ap_launch_name__c == 'Event driven') {
			//Si los acpl__gf_ap_edit_days_left_number__c es negativo, las fecha de AP serán:
			//la fecha de inicio =  acpl__gf_event_date__c - días en acpl__gf_ap_edit_days_left_number__c
			//fecha de fin = acpl__gf_event_date__c
			if(apConfig.acpl__gf_ap_edit_days_left_number__c < 0) {
				mapEditionAP = getEvtDaysLeftMinZero(apAux, apConfig);
				//Si los acpl__gf_ap_edit_days_left_number__c es positivo, las fecha de AP serán:
				//fecha de inicio = acpl__gf_event_date__c
				//fecha de fin = acpl__gf_event_date__c + acpl__gf_ap_edit_days_left_number__c.
			} else if(apConfig.acpl__gf_ap_edit_days_left_number__c > 0) {
				mapEditionAP = getEvtDaysLeftMayZero(apAux, apConfig);
			}
		}
		return mapEditionAP;
	}

    /*
	 * @Description  getDaysLeftMinZero
	 */
    private static Map<String, String> getEvtDaysLeftMinZero(acpl__Account_Planning__c apAux, acpl__AP_PeriodConfiguration__c apConfig) {
        Map<String, String> mapEditionAP = new Map<String, String> {CHANGE => FALSO, EDITION_TYPE => ''};
        //Si (acpl__gf_event_date__c - acpl__gf_ap_edit_days_left_number__c) es hoy y acpl__gf_event_date__c es mayor a hoy, se desbloquea el AP
        if(ACTUAL_DATE == apAux.acpl__gf_event_date__c.addDays((Integer)apConfig.acpl__gf_ap_edit_days_left_number__c) && ACTUAL_DATE < apAux.acpl__gf_event_date__c) {
            mapEditionAP = putEditionValue(mapEditionAP, UNLOCK);
			//Si la fecha de hoy es mayor a acpl__gf_event_date__c, se bloquea el AP
		} else if(ACTUAL_DATE > apAux.acpl__gf_event_date__c) {
            mapEditionAP = putEditionValue(mapEditionAP, LOCK);
        }
        return mapEditionAP;
    }
    
    /*
	 * @Description  getDaysLeftMayZero
	 */
    private static Map<String, String> getEvtDaysLeftMayZero(acpl__Account_Planning__c apAux, acpl__AP_PeriodConfiguration__c apConfig) {
        Map<String, String> mapEditionAP = new Map<String, String> {CHANGE => FALSO, EDITION_TYPE => ''};
        //Si acpl__gf_event_date__c es hoy y (acpl__gf_event_date__c + acpl__gf_ap_edit_days_left_number__c) es mayor a hoy, se desbloquea el AP
        if(ACTUAL_DATE == apAux.acpl__gf_event_date__c && ACTUAL_DATE < apAux.acpl__gf_event_date__c.addDays((Integer)apConfig.acpl__gf_ap_edit_days_left_number__c)) {
            mapEditionAP = putEditionValue(mapEditionAP, UNLOCK);
            //Si hoy es mayor a (acpl__gf_event_date__c + acpl__gf_ap_edit_days_left_number__c), se bloquea el AP
		} else if(ACTUAL_DATE > apAux.acpl__gf_event_date__c.addDays((Integer)apConfig.acpl__gf_ap_edit_days_left_number__c)) {
            mapEditionAP = putEditionValue(mapEditionAP, LOCK);
        }
        return mapEditionAP;
    }
    
	/*
	 * @Description  method putEditionValue
	 */
	public static Map<String, String> putEditionValue(Map<String, String> mapEdition, String edition) {
		return new Map<String, String> {CHANGE => 'true', EDITION_TYPE => edition};
	}
}