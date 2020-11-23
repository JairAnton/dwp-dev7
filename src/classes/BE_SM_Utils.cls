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

    /** @Description JPNS*/
    static Final User[] JPNS = [SELECT Id, ManagerId FROM User WHERE prof_position_id__c = 'OS9' AND UserRoleId NOT IN ('') AND isActive = true];
    /** @Description GOF_CODE*/
    static Final List<String> GOF_CODE = System.Label.lblGOFCode.split(',');
    /** @Description EJE_CODE*/
    static Final List<String> EJE_CODE = System.Label.lblEjecutivoCode.split(',');
    /** @Description ASSIST_CODE*/
    static Final List<String> ASSIST_CODE = System.Label.lblAssistants.split(',');

	/** private constructor */
	private BE_SM_Utils() {}
    
	/*
	 * @Description  method getColaborators
	 */
    public static Set<Id> getColaborators(Id collaborator) {
        Final User currentUser = [SELECT Id, prof_position_id__c FROM User WHERE Id=:collaborator LIMIT 1];
        Final Set<Id> setOppCols = new Set<Id>();
        if(GOF_CODE.contains(currentUser.prof_position_id__c)) {
            Final Map<Id, User> mapCollaborators = new Map<Id, User>([SELECT Id FROM User WHERE prof_position_id__c IN:EJE_CODE AND ManagerId =:currentUser.Id]);
            if(!mapCollaborators.isEmpty()) { setOppCols.addAll(mapCollaborators.keySet()); }
        } else if(EJE_CODE.contains(currentUser.prof_position_id__c)) {
            setOppCols.add(currentUser.Id);
        }
        return setOppCols;
    }

    /*
	 * @Description  method getAssistants
	 */
    public static Map<Id, Set<Id>> getAssistantsByEje(Set<Id> setCollaborator) {
        Final Map<Id, Set<Id>> mapAssistByCol = new Map<Id, Set<Id>>();
        Final User_Assistant_Team__c[] lstAssist = [SELECT Id, user_id__c, assistant_id__c FROM User_Assistant_Team__c WHERE 
                                                    assistant_id__r.isActive = true AND user_id__c IN:setCollaborator AND 
                                                    assistant_id__r.prof_position_id__c IN: ASSIST_CODE];
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
            for(User jpnAux: JPNS) {
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

    /*
	 * @Description  method getJPNManagerGOF
	 */
    private static Set<Id> getJPNManagerGOF(Map<Id, Set<Id>> mapAux, User jpnAux, User gofAux) {
        Set<Id> setIds;
        if(String.isNotBlank(gofAux.ManagerId) && jpnAux.ManagerId == gofAux.ManagerId) {
            setIds = mapAux.containsKey(gofAux.Id) ? mapAux.get(gofAux.Id) : new Set<Id>();
            setIds.add(jpnAux.Id);
        }
        return setIds;
    }

    /*
	 * @Description  method getJPNManagerEJE
	 */
    private static Set<Id> getJPNManagerEJE(Map<Id, Set<Id>> mapAux, User jpnAux, User ejeAux) {
        Set<Id> setIds;
        if(String.isNotBlank(ejeAux.ManagerId) && String.isNotBlank(ejeAux.Manager.ManagerId) && 
            jpnAux.ManagerId == ejeAux.Manager.ManagerId) {
            setIds = mapAux.containsKey(ejeAux.Id) ? mapAux.get(ejeAux.Id) : new Set<Id>();
            setIds.add(jpnAux.Id);
        }
        return setIds;
    }

    /*
	 * @Description  method getUsersByEje
	 */
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
        final List<String> sObjNames = new List<String> {'Task'};
        final Map<String, Schema.RecordTypeInfo> recordType = BE_General_Utils.getRecordTypeInfo(sObjNames);
        return recordType.get(developerName).getRecordTypeId();
    }
    
    /*
	 * @Description  method to return recordtypeId from task sales meeting
	 */
    @AuraEnabled
    public static Map<String, String> retTypesSM() {
        Final Map<String, String> mapReturn = new Map<String, String>();
        Final Schema.DescribeFieldResult fieldResult = slmt__Sales_Meeting__c.Type_of_meeting__c.getDescribe();
        Final List<Schema.PicklistEntry> plentry = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry item : plentry) {
            mapReturn.put(item.getValue(), item.getLabel());
        }       
        return mapReturn;
    }
}