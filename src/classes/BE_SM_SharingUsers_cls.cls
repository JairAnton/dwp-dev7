/**
 * BE_SM_SharingUsers_cls
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		11/11/2020          Original version.<p />
 *
 * @author Diego Carbajal
 */
public without sharing class BE_SM_SharingUsers_cls {

    /** @Description  GOF_CODE*/
    static Final List<String> GOF_CODE = System.Label.lblGOFCode.split(',');
    /** @Description  EJE_CODE*/
    static Final List<String> EJE_CODE = System.Label.lblEjecutivoCode.split(',');

    /*
	 * @Description  BE_SM_SharingUsers_cls
	 */
    private BE_SM_SharingUsers_cls() {}
    
    
    /*
	 * @Description  method assigmentPermission
	 */
    @future
    public static void addJPNofSMS(String jsonMap) {
        Final Map<String, Object> mapJPNByManager = (Map<String, Object>)JSON.deserializeUntyped(jsonMap);
		Final Map<Id, User> mapSMOwners = new Map<Id, User>([SELECT Id, prof_position_id__c, ManagerId, Manager.ManagerId FROM User WHERE 
                                          	(ManagerId IN: mapJPNByManager.keySet() AND prof_position_id__c IN: GOF_CODE) OR 
											(Manager.ManagerId IN: mapJPNByManager.keySet() AND prof_position_id__c IN: EJE_CODE)]);
        Final Map<Id, Set<Id>> mapJPNBySMOwner = getJPNBySMOwner(mapJPNByManager, mapSMOwners);
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
	 * @Description  method getJPNBySMOwner
	 */
    private static Map<Id, Set<Id>> getJPNBySMOwner(Map<String, Object> mapJPNByManager, Map<Id, User> mapSMOwners) {
        Final Map<Id, Set<Id>> mapJPNBySMOwner = new Map<Id, Set<Id>>();
        Set<Id> setJPNs;
        List<Object> setJPNsAux;
        for(User userAux:mapSMOwners.values()) {
            setJPNs = new Set<Id>();
			if(GOF_CODE.contains(userAux.prof_position_id__c)) {
                if(mapJPNByManager.containsKey(userAux.ManagerId)) {
                    setJPNsAux = (List<Object>)mapJPNByManager.get(userAux.ManagerId);
                    setJPNs = getSetJPN(setJPNsAux, setJPNs);
                }
            } else {
                if(mapJPNByManager.containsKey(userAux.Manager.ManagerId)) {
                    setJPNsAux = (List<Object>)mapJPNByManager.get(userAux.Manager.ManagerId);
                    setJPNs = getSetJPN(setJPNsAux, setJPNs);
                }
            }
            mapJPNBySMOwner.put(userAux.Id, setJPNs);
        }
        return mapJPNBySMOwner;
    }

    /*
	 * @Description  method reusable
	 */
    private static Set<Id> getSetJPN(List<Object> setJPNsAux, Set<Id> setJPNs) {
        for(Object idJPN: setJPNsAux) {
            setJPNs.add((Id) idJPN);
        }
        return setJPNs;
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