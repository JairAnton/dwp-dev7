/**
   ----------------------------------------------------------------------------------------------------
   @Name <BE_SM_Utils>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2019-09-13
   @Description Class  contains generic logic to use in differents classes.
   @Changes
    Date        Author   Email                  Type
    2020-02-21  LMBR     lolo.bravo@bbva.com    Creation
   ----------------------------------------------------------------------------------------------------
 */
public without sharing class BE_SM_Utils {

    /** @Description lstJPN*/
    static Final User[] lstJPN = [SELECT Id, ManagerId FROM User WHERE prof_position_id__c = 'OS9' AND UserRoleId != '' AND isActive = true];
    /** @Description lstGOFCode*/
    static Final List<String> lstGOFCode = System.Label.lblGOFCode.split(',');
    /** @Description lstEjeCode*/
    static Final List<String> lstEjeCode = System.Label.lblEjecutivoCode.split(',');
    /** @Description lstAsst*/
    static Final List<String> lstAsst = System.Label.lblAssistants.split(',');
	/** private constructor */
	private BE_SM_Utils() {}
    
	/*
	 * @Description  method getColaborators
	 */
    public static Set<Id> getColaborators(Id collaborator) {
        Final User currentUser = [SELECT Id, prof_position_id__c FROM User WHERE Id=:collaborator LIMIT 1];
        Final Set<Id> setOppCollaborators = new Set<Id>();
        if(lstGOFCode.contains(currentUser.prof_position_id__c)) {
            Final Map<Id, User> mapCollaborators = new Map<Id, User>([SELECT Id FROM User WHERE prof_position_id__c IN:lstEjeCode AND ManagerId =:currentUser.Id]);
            if(!mapCollaborators.isEmpty()) { setOppCollaborators.addAll(mapCollaborators.keySet()); }
        } else if(lstEjeCode.contains(currentUser.prof_position_id__c)) {
            setOppCollaborators.add(currentUser.Id);
        }
        return setOppCollaborators;
    }

    /*
	 * @Description  method getAssistants
	 */
    public static Map<Id, Set<Id>> getAssistantsByEje(Set<Id> setCollaborator) {
        Final Map<Id, Set<Id>> mapAssistByCol = new Map<Id, Set<Id>>();
        Final User_Assistant_Team__c[] lstAssist = [SELECT Id, user_id__c, assistant_id__c FROM User_Assistant_Team__c WHERE 
                                                    assistant_id__r.isActive = true AND user_id__c IN:setCollaborator AND 
                                                    assistant_id__r.prof_position_id__c IN: lstAsst];
        Set<Id> setAssist;
        for(User_Assistant_Team__c uat: lstAssist) {
            setAssist = new Set<Id>{uat.assistant_id__c};
            if(mapAssistByCol.containsKey(uat.user_id__c)) {
                setAssist.addAll(mapAssistByCol.get(uat.user_id__c));
            }
            mapAssistByCol.put(uat.user_id__c, setAssist);
        }
        return mapAssistByCol;
    }

    /*
	 * @Description  method getJPNByCol
	 */
    public static Map<Id, Set<Id>> getJPNByCol(Set<Id> setCollaborator, Boolean byGOF) {
        Final Map<Id, Set<Id>> mapJPNByCol = new Map<Id, Set<Id>>();
        Final User[] lstCol = [SELECT Id, ManagerId, Manager.ManagerId FROM User WHERE Id IN: setCollaborator];
        Set<Id> setIds;
        for(User userAux: lstCol) {
            for(User jpnAux: lstJPN) {
                if(byGOF) {
                    setIds = getJPNManagerGOF(mapJPNByCol, jpnAux, userAux);
                } else {
                    setIds = getJPNManagerEJE(mapJPNByCol, jpnAux, userAux);
                }
                if(setIds != null) {
                    mapJPNByCol.put(userAux.Id, setIds);
                }
            }
        }
        return mapJPNByCol;
    }

    private static Set<Id> getJPNManagerGOF(Map<Id, Set<Id>> mapAux, User jpnAux, User gofAux) {
        Set<Id> setIds;
        if(String.isNotBlank(gofAux.ManagerId) && jpnAux.ManagerId == gofAux.ManagerId) {
            setIds = mapAux.containsKey(gofAux.Id) ? mapAux.get(gofAux.Id) : new Set<Id>();
            setIds.add(jpnAux.Id);
        }
        return setIds;
    }

    private static Set<Id> getJPNManagerEJE(Map<Id, Set<Id>> mapAux, User jpnAux, User ejeAux) {
        Set<Id> setIds;
        if(String.isNotBlank(ejeAux.ManagerId) && String.isNotBlank(ejeAux.Manager.ManagerId) && 
            jpnAux.ManagerId == ejeAux.Manager.ManagerId) {
            setIds = mapAux.containsKey(ejeAux.Id) ? mapAux.get(ejeAux.Id) : new Set<Id>();
            setIds.add(jpnAux.Id);
        }
        return setIds;
    }

    public static Map<Id, Set<Id>> getUsersByEje(Set<Id> setCollaborator) {
        Final Map<Id, Set<Id>> mapUsersByEje = getAssistantsByEje(setCollaborator);
        Final Map<Id, Set<Id>> mapJPNByEje = getJPNByCol(setCollaborator, false);
        Set<Id> setIds;
        for(Id idAux: mapJPNByEje.keySet()) {
            setIds = mapJPNByEje.get(idAux);
            if(mapUsersByEje.containsKey(idAux)) {
                setIds.addAll(mapUsersByEje.get(idAux));
            }
            mapUsersByEje.put(idAux, setIds);
        }
        return mapUsersByEje;
    }
    
    /*
	 * @Description  method to return recordtypeId from task sales meeting
	 */
    @AuraEnabled
    public static String getRecordTypeId(String developerName) {
        System.debug('############## developerName: '+developerName);
        final List<String> sObjNames = new List<String> {'Task'};
        final Map<String, Schema.RecordTypeInfo> recordType = BE_General_Utils.getRecordTypeInfo(sObjNames);
		final String rtId = recordType.get(developerName).getRecordTypeId();
        return rtId;
    }
}