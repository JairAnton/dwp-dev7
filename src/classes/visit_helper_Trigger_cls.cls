/*
 * Helper visit kit v1
 * 17/09/2018
 *
 */
public without sharing class visit_helper_Trigger_cls {
	/**
	 * static variable PROFILE_NAMES
	 */
	static Final List<String> PROFILE_NAMES = new List<String> {'Migracion', System.Label.profAdministrator, 'System Administrator'};

	/*
	 * Method prevent deleted data
	 */
	public void comunMethod1(List<SObject> objectInsert) {
		Map<id, String> stagea = new Map<id, String>();
		List<id> opa = new List<id>();
		List<SObject> opa2 = new List<SObject>();
		Final String profileName = [SELECT id, Name FROM Profile WHERE Id =:UserInfo.getProfileId()].Name;
		for(SObject a : objectInsert) {
			opa.add((Id)a.get('dwp_kitv__visit_id__c'));
		}
		Final Schema.SObjectType sobjectType = Opa[0].getSObjectType();
		Final String sobjectName = String.escapeSingleQuotes(sobjectType.getDescribe().getName());
		opa2 = Database.query('Select Id, dwp_kitv__visit_status_type__c From ' + sobjectName + ' Where Id IN:Opa');
		for(SObject obs : opa2) {
			stagea.put((id)obs.get('Id'), (String)obs.get('dwp_kitv__visit_status_type__c'));
		}
		for(SObject a : objectInsert) {
			if('06'.equals(stagea.get((Id)a.get('dwp_kitv__visit_id__c'))) && !PROFILE_NAMES.contains(profileName)) {
				a.addError(System.Label.ErrorVisitManagementTeam);
			}
		}
	}

	/*
	 * Method prevent deleted owner
	 */
	public void deleteOwner(List<dwp_kitv__Visit_Management_Team__c> lstvmt) {
		Final Id profileId = UserInfo.getProfileId();
		Final String profileName = [SELECT id, Name FROM Profile WHERE Id =:profileId].Name;
		if(!PROFILE_NAMES.contains(profileName)) {
			for(dwp_kitv__Visit_Management_Team__c vmt : lstvmt) {
				if(vmt.dwp_owner_visit__c) {
					vmt.addError(System.Label.Msg_DeleteOwner_VMT);
				}
			}
		}
	}

	/*
	 * Method to deleted Sharing with Visit Managment Team
	 */
	public static void deleteVMTShare(Map<Id, dwp_kitv__Visit_Management_Team__c> mapVMT) {
		//Id visit - List Id Users in VMT to delete
		Final Map<Id, List<Id>> mapVM = new Map<Id, List<Id>>();
		Final List<Id> idsUser = new List<Id>();
		List<Id> idsUserByVisit;
		//Fill mapVM with id Visit and List Id Users by visit
		for(dwp_kitv__Visit_Management_Team__c vmt:mapVMT.values()) {
			idsUserByVisit = new List<Id>();
			//If visit exist in mapVM
			if(mapVM.containsKey(vmt.dwp_kitv__visit_id__c)) {
				idsUserByVisit = mapVM.get(vmt.dwp_kitv__visit_id__c);
				idsUserByVisit.add(vmt.dwp_kitv__user_id__c);
				mapVM.put(vmt.dwp_kitv__visit_id__c, idsUserByVisit);
			} else {//If not, put in mapVM
				idsUserByVisit.add(vmt.dwp_kitv__user_id__c);
				mapVM.put(vmt.dwp_kitv__visit_id__c, idsUserByVisit);
			}
			idsUser.add(vmt.dwp_kitv__user_id__c);
		}
		Final List<dwp_kitv__Visit__Share> lstVisitShare = [SELECT Id, ParentID, RowCause, UserOrGroupId FROM dwp_kitv__Visit__Share WHERE RowCause = 'Manual' AND
		                                                                                                                                              ParentID IN:mapVM.keySet() AND UserOrGroupId IN:idsUser];
		Final List<dwp_kitv__Visit__Share> visitShareDelete = new List<dwp_kitv__Visit__Share>();
		//Validate records to delete
		for(dwp_kitv__Visit__Share vShare:lstVisitShare) {
			idsUserByVisit = mapVM.get(vShare.ParentID);
			if(idsUserByVisit.contains(vShare.UserOrGroupId)) {
				visitShareDelete.add(vShare);
			}
		}
		Final Integer visitShareSize = visitShareDelete.size();
		if(visitShareSize > 0) {
			delete visitShareDelete;
		}
	}
	
	/*
	 * Method to check that description field is required for launch visit
	 */
    public static void validateDesc(List<dwp_kitv__Visit__c> visits) {
        for(dwp_kitv__Visit__c visit : visits) {
        	if(!Test.isRunningTest() && visit.dwp_kitv__visit_desc__c == NULL && visit.dwp_kitv__visit_status_type__c == '02') {
                visit.addError(System.Label.BE_VisitErrorDescField);
            }
        }
    }
    
    /*
	 * Method to check contacts in a visit
	 */
    public void validateInvite(List<dwp_kitv__Visit_Contact__c> visitsNew, Map<Id, dwp_kitv__Visit_Contact__c> visitsOld) {
        Integer countContacts = 0;
        Boolean anychange = false;
        
        for(dwp_kitv__Visit_Contact__c visitnew :visitsNew) {
            if(visitnew.dwp_kitv__contact_called_type__c != visitsOld.get(visitnew.Id).dwp_kitv__contact_called_type__c) {
                anychange = true;                
            }
            if(visitnew.dwp_kitv__contact_called_type__c) {
                countContacts++;
            }            
        }
        
        if(countContacts==0 && anychange) {
            visitsNew.get(0).addError(System.Label.BE_VisitValidateInvite);                      
        }        
    }
    
    /*
	 * Method to assign dwp_kitv__contact_called_type__c field for launch visit
	 */
    public void asiggnInvite(List<dwp_kitv__Visit_Contact__c> visitContacts) {
        for(dwp_kitv__Visit_Contact__c visitContact: visitContacts) {
            visitContact.dwp_kitv__contact_called_type__c = true;            
        }
    }
}