/**
 * AssigmentPermissionValidationAP_cls assign Validator permission to GOF
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		03/06/2020          Original version.<p />
 *
 * @author Diego Carbajal
 */
public without sharing class BE_SM_SharingUsers_cls {

    /*
	 * @Description  AssigmentPermissionValidationAP_cls
	 */
    private BE_SM_SharingUsers_cls() {}
    
    
    /*
	 * @Description  method assigmentPermission
	 */
    @future
    public static void addJPNofSMS(String jsonMap) {
        Final Map<String, Object> mapJPNByManager = (Map<String, Object>)JSON.deserializeUntyped(jsonMap);
        Final List<String> lstGOFCode = System.Label.lblGOFCode.split(',');
        Final List<String> lstEjeCode = System.Label.lblEjecutivoCode.split(',');
		Final Map<Id, User> mapSMOwners = new Map<Id, User>([SELECT Id, prof_position_id__c, ManagerId, Manager.ManagerId FROM User WHERE 
                                          	(ManagerId IN: mapJPNByManager.keySet() AND prof_position_id__c IN: lstGOFCode) OR 
											(Manager.ManagerId IN: mapJPNByManager.keySet() AND prof_position_id__c IN: lstEjeCode)]);
        Final Map<Id, Set<Id>> mapJPNBySMOwner = new Map<Id, Set<Id>>();
        Set<Id> setJPNs;
        List<Object> setJPNsAux;
        for(User userAux:mapSMOwners.values()) {
            setJPNs = new Set<Id>();
			if(lstGOFCode.contains(userAux.prof_position_id__c)) {
                if(mapJPNByManager.containsKey(userAux.ManagerId)) {
                    setJPNsAux = (List<Object>)mapJPNByManager.get(userAux.ManagerId);
                    for(Object idJPN: setJPNsAux) {
                        setJPNs.add((Id) idJPN);
                    }
                }
            } else {
                if(mapJPNByManager.containsKey(userAux.Manager.ManagerId)) {
                    setJPNsAux = (List<Object>)mapJPNByManager.get(userAux.Manager.ManagerId);
                    for(Object idJPN: setJPNsAux) {
                        setJPNs.add((Id) idJPN);
                    }
                }
            }
            mapJPNBySMOwner.put(userAux.Id, setJPNs);
        }
        Final slmt__Sales_Meeting__c[] lstSM = [SELECT Id, OwnerId FROM slmt__Sales_Meeting__c WHERE OwnerId IN: mapSMOwners.keySet()];
        Final slmt__Sales_Meeting__Share[] lstSMS = new slmt__Sales_Meeting__Share[]{};
        for(slmt__Sales_Meeting__c slmt: lstSM) {
            for(Id jpnId: mapJPNBySMOwner.get(slmt.OwnerId)) {
                lstSMS.add(new slmt__Sales_Meeting__Share(parentId = slmt.Id, AccessLevel = 'Edit', RowCause = 'Manual', UserOrGroupId = jpnId));
            }
        }
        if(!lstSMS.isEmpty()) {
            SalesMeeting_Trigger_cls.insertSharedUser(lstSMS);
        }
	}
    
	/*
	 * @Description  method assigmentPermission
	 */
    @future
    public static void removeJPNofSMS(Set<Id> setIds) {
		Final slmt__Sales_Meeting__Share[] lstSMS = [SELECT Id FROM slmt__Sales_Meeting__Share WHERE AccessLevel = 'Edit' AND 
													RowCause = 'Manual' AND UserOrGroupId IN: setIds];
		if(!lstSMS.isEmpty()) {
			delete lstSMS;
		}
	}
}