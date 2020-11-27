/**
   -------------------------------------------------------------------------------------------------
   @Name SalesMeeting_Trigger_cls
   @Author Diego Carbajal Pastor (diego.carbajal@bbva.com)
   @Date 2020-11-11
   @Description
   @Changes
   Date        Author   Email                  Type
   2020-11-11  DCP     diego.carbajal@bbva.com    Creation
   -------------------------------------------------------------------------------------------------
 */
public without sharing class SalesMeeting_Trigger_cls {
    
    /** @Description GOF_CODE*/
    static Final List<String> GOF_CODE = System.Label.lblGOFCode.split(',');
    /** @Description EJE_CODE*/
    static Final List<String> EJE_CODE = System.Label.lblEjecutivoCode.split(',');
    /** @Description GOF*/
    static Final String GOF = 'GOF';
    /** @Description EJE*/
    static Final String EJE = 'EJE';

    /**
     * @Description constructor
     */
    private SalesMeeting_Trigger_cls() {}

    /**
     * @Description salesMeetingColOwner put Colaborator like Owner
     */
    public static void salesMeetingColOwner(List<slmt__Sales_Meeting__c> triggerNew) {
        Final Set<Id> setUsersId = getColaboratorsId(triggerNew);
        Final Map<Id, User> mapUsers = new Map<Id, User>([SELECT Id FROM User WHERE Id IN:setUsersId AND isActive = true]);
        for(slmt__Sales_Meeting__c smAux: triggerNew) {
            if(mapUsers.containsKey(smAux.Collaborator__c)) {
                smAux.OwnerId = smAux.Collaborator__c;
            }
        }
    }

    /**
     * @Description addRecordAccess
     */
    public static void addRecordAccess(Map<id, slmt__Sales_Meeting__c> triggerNewMap) {
        //lstAllSMS => sharing records
        Final List<slmt__Sales_Meeting__Share> lstAllSMS = new List<slmt__Sales_Meeting__Share>();
        List<slmt__Sales_Meeting__Share> lstSMS;
        Map<Id, Set<Id>> mapUSByCol;
        Final Map<String, Set<Id>> mapUsersByType = getColaboratorsByType(triggerNewMap.values());
        if(!mapUsersByType.get(GOF).isEmpty()) {
            mapUSByCol = BE_SM_Utils.getJPNByCol(mapUsersByType.get(GOF), true);
            lstSMS = getSMSharedWithAssist(mapUSByCol, triggerNewMap.values());
            lstAllSMS.addAll(lstSMS);
        }
        if(!mapUsersByType.get(EJE).isEmpty()) {
            mapUSByCol = BE_SM_Utils.getUsersByEje(mapUsersByType.get(EJE));
            lstSMS = getSMSharedWithAssist(mapUSByCol, triggerNewMap.values());
            lstAllSMS.addAll(lstSMS);
        }
        insertSharedUser(lstAllSMS);
    }

    /**
     * @Description getColaboratorsByType
     */
    public static Map<String, Set<Id>> getColaboratorsByType(List<slmt__Sales_Meeting__c> lstSM) {
        Final Set<Id> setUsersId = getColaboratorsId(lstSM);
        Final Map<String, Set<Id>> mapUsersByType = new Map<String, Set<Id>>{GOF => new Set<Id>(), EJE => new Set<Id>()};
        Final User[] lstUsers = [SELECT Id, prof_position_id__c FROM User WHERE Id IN:setUsersId AND (prof_position_id__c IN: GOF_CODE OR 
                                prof_position_id__c IN: EJE_CODE) AND isActive = true];
        Set<Id> setIdAux;
        String type;
        for(User userAux: lstUsers) {
            type = GOF_CODE.contains(userAux.prof_position_id__c) ? GOF : EJE;
            setIdAux = mapUsersByType.get(type);
            setIdAux.add(userAux.Id);
            mapUsersByType.put(type, setIdAux);
        }
        return mapUsersByType;
    }

    /**
     * @Description getColaboratorsId
     */
    public static Set<Id> getColaboratorsId(List<slmt__Sales_Meeting__c> lstSM) {
        Final Set<Id> setUsersId = new Set<Id>();
        for(slmt__Sales_Meeting__c smAux: lstSM) {
            setUsersId.add(smAux.Collaborator__c);
        }
        return setUsersId;
    }

    /**
     * @Description getSMSharedWithAssist
     */
    private static List<slmt__Sales_Meeting__Share> getSMSharedWithAssist(Map<Id, Set<Id>> mapAssistByCol, List<slmt__Sales_Meeting__c> lstSM) {
        Final List<slmt__Sales_Meeting__Share> lstSMS = new List<slmt__Sales_Meeting__Share>();
        for(slmt__Sales_Meeting__c smAux: lstSM) {
            if(mapAssistByCol.containsKey(smAux.Collaborator__c)) {
                for(Id assistId: mapAssistByCol.get(smAux.Collaborator__c)) {
                    lstSMS.add(new slmt__Sales_Meeting__Share(ParentId = smAux.Id, UserOrGroupId = assistId, AccessLevel = 'Edit', 
                                                            RowCause = 'Manual'));
                }
            }
        }
        return lstSMS;
    }

    /**
     * @Description insertSharedUser
     */
    public static void insertSharedUser(List<slmt__Sales_Meeting__Share> lstAllSMS) {
        Final Database.SaveResult[] dbSR = Database.insert(lstAllSMS, false);
        for (Database.SaveResult sr : dbSR) {
            if (sr.isSuccess()) { // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully shared slmt__Sales_Meeting__c. slmt__Sales_Meeting__c ID: ' + sr.getId());
            } else { // Operation failed, so get all errors
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred - '+err.getStatusCode()+ ': ' + err.getMessage());                    
                }
            }
        }
    }
    
    /**
     * @Description migrateTasks
     */
    public static void migrateTasks(List<slmt__Sales_Meeting__c> triggerNew) {
        Final Map<Id, Id> slmtCollMap = new Map<Id, Id>();
        for(slmt__Sales_Meeting__c slmtAux : triggerNew) {
            slmtCollMap.put(slmtAux.Collaborator__c, slmtAux.Id);
        }
        if(!slmtCollMap.isEmpty()) {
            Database.executeBatch(new BE_SM_MigrateTask_Batch(slmtCollMap));
        }
    }
}