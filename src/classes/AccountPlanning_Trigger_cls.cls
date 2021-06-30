/**
 * Logic class of Handler Trigger of the AccountPlanning object.
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		15/05/2020          Original version.<p />
 * Jair Anton				07/06/2021			Compartir AP con el JPN de cada región
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
	 * @Description Agrega a los JPN a cada Plan de cuentas dependiendo de la región que pertenezca el Global Bankers
	 */
    public static void sharingWithJPN(Map<Id, acpl__Account_Planning__c> apNewMap) {
        Final Map<Id, Map<Id, UserRole>> rolesPerLevel = getRolesPerHierarchy();
        
        Final Map<Id, UserRole> jpnRole = new Map<Id, UserRole>([SELECT Id, Name, ParentRoleId FROM UserRole WHERE Name LIKE 'JEFE PROMOCION DE NEGOCIO%']);
        Final Map<Id, Map<Id, Id>> usRoles = new Map<Id, Map<Id, Id>>();
        
        for(UserRole item : jpnRole.values()) {
            /* Obtiene los roles que tienen el mismo nivel del JPN */
            Final Map<Id, UserRole> currentRole = rolesPerLevel.get(item.ParentRoleId);
            /* Guarda los primeros Id de los roles */
            Final Set<Id> currentSet = currentRole.keySet();
            Final List<Id> currentKeyList = new List<Id>();
            /* Guarda en una lista */
            currentKeyList.addAll(currentSet);
            /* Almacena todos los Id de los roles cercanos por JPN */
            Final Map<Id, Id> storageMap = new Map<Id, Id>();
            
            do {
                /* Elimina y retorna el primer registro */
                Final Id currentItem = currentKeyList.remove(0);
                /* Almacena los id que pasan por el bucle */
                storageMap.put(currentItem, currentItem);
                
                /* Verifica el Id */
                if(rolesPerLevel.containsKey(currentItem)) {
                    /* Obtiene los sub levels de los roles */
                    Final Map<Id, UserRole> currentSubRole = rolesPerLevel.get(currentItem);
                    /* Agrega los id de los roles para continuar con la búsqueda de sub level*/
                    Final Set<Id> currentSubSet = currentSubRole.keySet();
                    currentKeyList.addAll(currentSubSet);
                }
            } 
            while (!currentKeyList.isEmpty());
            
            /* Almacena los roles id que le pertenecen a cada JPN */
            usRoles.put(item.Id, storageMap);
        }
        
        sharingAP(jpnRole, apNewMap, usRoles); 
        
    }
    
    /**
	 * @Description Filtra los roles por su jerarquía obteniendo levels and sub-levels 
	 */
    public static void sharingAP(Map<Id, UserRole> jpnRole, Map<Id, acpl__Account_Planning__c> apNewMap, Map<Id, Map<Id, Id>> usRoles) {
        Final List<User> userList = [SELECT Id, Name, UserRoleId FROM User WHERE UserRoleId IN : jpnRole.keySet() AND isActive = TRUE];
        Final List<acpl__Account_Planning__c> apList = [SELECT Id, acpl__proposal_manager_id__r.UserRoleId FROM acpl__Account_Planning__c WHERE Id IN : apNewMap.keySet()];
        Final List<acpl__Account_Planning__Share> apShareList = new List<acpl__Account_Planning__Share>();
        
        for(User usItem : userList) {
            Final Map<Id, Id> currentRole = usRoles.get(usItem.UserRoleId);
            
            for(acpl__Account_Planning__c apItem : apList) {
                if(currentRole.containsKey(apItem.acpl__proposal_manager_id__r.UserRoleId)) {
                    apShareList.add(new acpl__Account_Planning__Share(ParentId = apItem.Id, UserOrGroupId = usItem.Id, AccessLevel = 'Read', RowCause = 'Manual'));
                }   
            }
        }
        
        if(!apShareList.isEmpty()) {
            insert apShareList;
        }
    }
    
    /**
	 * @Description Filtra los roles por su jerarquía obteniendo levels and sub-levels 
	 */
    public static Map<Id, Map<Id, UserRole>> getRolesPerHierarchy() {
        Final Map<Id, UserRole> firstLevel = new Map<Id, UserRole>([SELECT Id, Name, ParentRoleId FROM UserRole WHERE ParentRoleId = NULL LIMIT 1]);
        Final List<UserRole> nextLevel = [SELECT Id, Name, ParentRoleId FROM UserRole WHERE ParentRoleId NOT IN : firstLevel.keySet()];
        Final Map<Id, Map<Id, UserRole>> rolesPerLevel = new Map<Id, Map<Id, UserRole>>();
        
        Final UserRole roleItem = firstLevel.values();
        rolesPerLevel.put(roleItem.Id, firstLevel);
        
        for(UserRole item : nextLevel) {
            Map<Id, UserRole> current = new Map<Id, UserRole>();
            
            if(rolesPerLevel.containsKey(item.ParentRoleId)) {
                current = rolesPerLevel.get(item.ParentRoleId);
            }
            
            current.put(item.Id, item);
            rolesPerLevel.put(item.ParentRoleId, current);
        }
        
        return rolesPerLevel;
    }
    
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
}