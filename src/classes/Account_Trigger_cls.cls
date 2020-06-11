/*
 * @Name: Account_tgr
 * @Description: Trigger de Ejecucion Account
 * @Create by: Isaías Velázquez Cortés
 * @HIstorial de cambios:
    - Actualización AsignAfterUpdate y onChangeBranch para que solo se actualize la oficina de las oportunidades si la oficina de la cuenta esta cambiando
 *****************************
    Modificaciones:
    Martín Alejandro Mori Chávez  02-12-2019
 *
 */
public without sharing class Account_Trigger_cls {

	/*Reusable variable in methods*/
	static Final List<String> PROFILE_NAMES = new List<String> {'Migracion', System.Label.profAdministrator, 'System Administrator'};

	/*Method Master for trigger*/
	public void AsignAfterUpdate(list<Account>accsNew, Map<id,Account>accsNewMap, list<Account>accsOld, Map<id,Account>accsOldMap) {
		Map<id, User> userAdmins = new Map<Id,User>([SELECT Id FROM user WHERE profile.Name IN: PROFILE_NAMES AND isActive=true]);
        Map<Id, Id> mapAccsOwnersChange = new Map<Id, Id>();
        final Map<Id, Id> mapBranchIds = new Map<Id, Id>();
        for(Account acc : accsNew) {
            if(acc.Branch_id__c!=accsOldMap.get(acc.Id).Branch_id__c) {
                mapBranchIds.put(acc.Id, acc.Branch_id__c);
            }
            //Get Old Owners Ids from Account where Owner change for AP
            if(!userAdmins.containsKey(acc.OwnerId) && acc.OwnerId != accsOldMap.get(acc.Id).OwnerId) {
                mapAccsOwnersChange.put(acc.Id, acc.OwnerId);
            }
		}
		if(mapBranchIds.isEmpty() == false) {
			onChangeBranch(mapBranchIds);
		}

		/**Actualizar Primero Objeto Relacionado, despues objeto hijo del relacionado**/
        Account_Trigger_Visit_cls.updateVisit(accsNew, accsNewMap, accsOld, accsOldMap);
        updateTeamVisit(accsNewMap, accsOldMap);
        //Actualiza gestores principales de los AP's activos
        updateAPMainGestor(mapAccsOwnersChange);
	}

	/*Method to update branch*/
	public static void onChangeBranch(Map<Id, Id> mapBranchIds) {
		final List<Opportunity> listOpp = [SELECT Id, AccountId, Branch_id__c FROM Opportunity WHERE AccountId =: mapBranchIds.KeySet() AND StageName NOT IN('06', '07')];
		if(listOpp.isEmpty()) {
			return;
		}

		final List<Opportunity> updateOpps = new List<Opportunity>();
		for(Opportunity item : listOpp) {
			item.Branch_id__c = mapBranchIds.get(item.AccountId);
			updateOpps.add(new Opportunity(id = item.Id, Branch_id__c = item.Branch_id__c));
		}
		update updateOpps;
	}

	//Insert new AccountTeamMember records depend on a new Account record and User Assistant Team records with the Account Owner like user_id__c
	public void AfterInsert(List<Account> accsNew) {
		List<User_Assistant_Team__c> lstUsers =  new List<User_Assistant_Team__c>();
		Final List<String> ownerIds = new List<String>();
		Final List<AccountTeamMember> lstATM = new List<AccountTeamMember>();

		for(Account acc : accsNew) {
			//Get the Owner Ids of the new Account records
			ownerIds.add(acc.OwnerId);
		}
		//User Assistant Team list with the Owner Ids of the Account records
		lstUsers = [Select Id, user_id__c, assistant_id__c from User_Assistant_Team__c where user_id__c IN :ownerIds AND user_id__r.isActive = true];
		for(Account acc : accsNew) {
			for(User_Assistant_Team__c userAT : lstUsers) {
				//If the Owner Id of the Account record is equal than user_id__c field on User_Assistant_Team__c record, it will create a new AccountTeamMember record
				if(acc.OwnerId == userAT.user_id__c) {
					AccountTeamMember atm = new AccountTeamMember();
					atm.AccountId = acc.Id;
					atm.UserId = userAt.assistant_id__c;
					atm.TeamMemberRole = Label.TeamMemberRoleExecutive;
					atm.AccountAccessLevel = Label.AccessLevelRead;
					atm.OpportunityAccessLevel = Label.AccessLevelEdit;
					atm.CaseAccessLevel = Label.AccessLevelEdit;
					lstATM.add(atm);
				}
			}
		}
		Final Integer lstATMSize = lstATM.size();
		if(lstATMSize > 0) {
			insert lstATM;
		}
	}

	/*Method to update Owner*/
	public void AfterUpdateOwner(List<Account> accsNew, Map<Id, Account> accsOldMap) {
		List<User_Assistant_Team__c> lstUsers =  new List<User_Assistant_Team__c>();
		Final List<String> ownerIdsNew = new List<String>();
		Final List<String> accIds = new List<String>();

		for(Account acc : accsNew) {
			//If a account record has changed its OwnerId field, get its new OwnerId and its Id
			if(acc.OwnerId != accsOldMap.get(acc.Id).OwnerId) {
				ownerIdsNew.add(acc.OwnerId);
				accIds.add(acc.Id);
			}
		}
		//If some record has new OwnerId
		Final Integer ownerIdsNewSize = ownerIdsNew.size();
		if(ownerIdsNewSize > 0) {
			//Old AccountTeamMember records was searched to delete
			List<AccountTeamMember> lstAtmOld = new List<AccountTeamMember>();
			lstAtmOld = [Select Id From AccountTeamMember where AccountId IN :accIds];

			//Get the User Assistant Team records with the new OwnerId of the account
			lstUsers = [Select Id, user_id__c, assistant_id__c from User_Assistant_Team__c where user_id__c IN :ownerIdsNew AND assistant_id__r.isActive = true];

			Final List<AccountTeamMember> lstAtmNews = new List<AccountTeamMember>();
			for(Account acc : accsNew) {
				for(User_Assistant_Team__c userAT : lstUsers) {
					//If the Owner Id of the Account record is equal than user_id__c field on User_Assistant_Team__c record, it will create a new AccountTeamMember record
					if(acc.OwnerId == userAT.user_id__c) {
						AccountTeamMember atm = new AccountTeamMember();
						atm.AccountId = acc.Id;
						atm.UserId = userAt.assistant_id__c;
						atm.TeamMemberRole = Label.TeamMemberRoleExecutive;
						atm.AccountAccessLevel = Label.AccessLevelRead;
						atm.OpportunityAccessLevel = Label.AccessLevelEdit;
						atm.CaseAccessLevel = Label.AccessLevelEdit;
						lstAtmNews.add(atm);
					}
				}
			}
			Final Integer lstAtmOldSize = lstAtmOld.size();
			if(lstAtmOldSize > 0) {
				delete lstAtmOld;
			}
			Final Integer lstAtmNewsSize = lstAtmNews.size();
			if(lstAtmNewsSize > 0) {
				insert lstAtmNews;
			}
		}
	}

	/*Method to update Owners in VMT with Active Visit*/
	public static void updateTeamVisit(Map<id, Account> accsNewMap, Map<id, Account> accsOldMap) {
		Final Set<Id> idsOldOwners = new Set<Id>();
		Final Set<Id> idsAccounts = new Set<Id>();
		Final Set<Id> idsNewOwners = new Set<Id>();
		List<dwp_kitv__Visit_Management_Team__c> lstOldTeam = new List<dwp_kitv__Visit_Management_Team__c>();
		List<dwp_kitv__Visit_Management_Team__c> lstTmpTeam = new List<dwp_kitv__Visit_Management_Team__c>();

		for(Account accNew:accsNewMap.values()) {
			//Get Old Owners Ids from Account where Owner change
			if(accNew.OwnerId != accsOldMap.get(accNew.Id).OwnerId) {
				idsOldOwners.add(accsOldMap.get(accNew.Id).OwnerId);
				idsNewOwners.add(accNew.OwnerId);
				idsAccounts.add(accsOldMap.get(accNew.Id).Id);
			}
		}
		//Obtener usuarios con perfil Migracion
		Final Map<Id, User> mapUNotMig = new Map<Id, User>([SELECT Id, Email, FederationIdentifier, Name FROM User WHERE Id IN : idsNewOwners AND Profile.Name NOT IN: PROFILE_NAMES]);

		//If idsOldOwners contains values, do query
		Final Integer idsOldOwnersSize = idsOldOwners.size();
		if(idsOldOwnersSize > 0) {
			lstTmpTeam = [SELECT id, dwp_kitv__user_id__c, dwp_kitv__visit_id__r.dwp_kitv__account_id__c, dwp_kitv__Send_minutes__c, dwp_kitv__visit_id__r.dwp_kitv__account_id__r.OwnerId
			              FROM dwp_kitv__Visit_Management_Team__c WHERE dwp_owner_visit__c = true AND
			                                                                                 dwp_kitv__visit_id__r.dwp_kitv__account_id__c =:idsAccounts AND dwp_kitv__visit_id__r.Keep_Owner__c = false AND
			                                                                                                                                                                                           (dwp_kitv__visit_id__r.report_visit_status_type__c = 'No realizada' OR dwp_kitv__visit_id__r.report_visit_status_type__c = 'Pendiente de feedback')];
		}

		Final List<Id> visitIds = new List<Id>();
		Final List<Id> userIds = new List<Id>();
		dwp_kitv__Visit_Management_Team__c tmpTeam;
		Final dwp_kitv__Visit_Management_Team__c[] lstNewTeam = new dwp_kitv__Visit_Management_Team__c[] {};
		for(dwp_kitv__Visit_Management_Team__c equipo:lstTmpTeam) {
			//Validar que el propietario del VMT es el mismo que le propietario de la cuenta y que el nuevo propietario no tenga el perfil migracion
			if(mapUNotMig.containsKey(accsNewMap.get(equipo.dwp_kitv__visit_id__r.dwp_kitv__account_id__c).OwnerId)) {
				tmpTeam = new dwp_kitv__Visit_Management_Team__c();
				tmpTeam.dwp_kitv__visit_id__c = equipo.dwp_kitv__visit_id__c;
				tmpTeam.dwp_kitv__user_id__c = accsNewMap.get(equipo.dwp_kitv__visit_id__r.dwp_kitv__account_id__c).OwnerId;
				tmpTeam.dwp_kitv__Send_minutes__c = equipo.dwp_kitv__Send_minutes__c;
				tmpTeam.dwp_owner_visit__c = true;
				tmpTeam.dwp_kitv__gf_sf_external_cust_mail_desc__c = mapUNotMig.get(accsNewMap.get(equipo.dwp_kitv__visit_id__r.dwp_kitv__account_id__c).OwnerId).Email;
				tmpTeam.dwp_kitv__gf_sf_external_customer_id__c = mapUNotMig.get(accsNewMap.get(equipo.dwp_kitv__visit_id__r.dwp_kitv__account_id__c).OwnerId).FederationIdentifier;
				tmpTeam.dwp_kitv__gf_sf_external_customer_name__c = mapUNotMig.get(accsNewMap.get(equipo.dwp_kitv__visit_id__r.dwp_kitv__account_id__c).OwnerId).Name;
				visitIds.add(tmpTeam.dwp_kitv__visit_id__c);
				userIds.add(tmpTeam.dwp_kitv__user_id__c);
				lstNewTeam.add(tmpTeam);
				lstOldTeam.add(equipo);
			}
		}
		//Delete all members in VMT (delete sharing on VMT)
		lstOldTeam.addAll([SELECT Id, dwp_kitv__user_id__c, dwp_kitv__visit_id__c FROM dwp_kitv__Visit_Management_Team__c WHERE dwp_kitv__visit_id__c IN: visitIds
		                   AND dwp_owner_visit__c = false AND(dwp_kitv__visit_id__r.report_visit_status_type__c = 'No realizada' OR
		                                                                                                          dwp_kitv__visit_id__r.report_visit_status_type__c = 'Pendiente de feedback')]);
		Final Integer lstOldTeamSize = lstOldTeam.size();
		if(lstOldTeamSize > 0) {
			delete lstOldTeam;
			insert lstNewTeam;
		}
	}
	
	private void updateAPMainGestor(Map<Id,Id> mapAccsOwnersChange) {
        Final Map<Id, Id> mapNewOwnerByAP = new Map<Id, Id>();
        //Obtenemos los AP's afectados de acuerdo a los clientes actualizados, que no esten validados ni expirados y sean de RT Account_Planning
        Final Map<Id, acpl__Account_Planning__c> mapAP = new Map<Id, acpl__Account_Planning__c>(
            										[SELECT Id, acpl__participant_id__c, acpl__gf_ap_status_type_name__c, acpl__gf_ap_substatus_type_name__c, 
                                                     acpl__gf_ap_indvi_lock_edit_ind_type__c, acpl__proposal_manager_id__c FROM acpl__Account_Planning__c WHERE 
                                                     acpl__participant_id__c IN: mapAccsOwnersChange.keySet() AND RecordType.DeveloperName = 'Account_Planning' AND 
                                                     (acpl__gf_ap_status_type_name__c !='Validated' AND acpl__gf_ap_substatus_type_name__c != 'In place') 
                                                     AND acpl__gf_ap_substatus_type_name__c !=: Label.acpl.AP_Timed_Out]);
        Final Integer lstAPSize = mapAP.values().size();
        if(lstAPSize > 0) {
            for(acpl__Account_Planning__c ap:mapAP.values()) {
                //Actualizamos el nuevo gestor principal
                ap.acpl__proposal_manager_id__c = mapAccsOwnersChange.get(ap.acpl__participant_id__c);
                //Creamos un mapa para identificar si los nuevos gestores existen como miembros en los AP's a actualizar
                // key = Id record, value = Id new gestor
                mapNewOwnerByAP.put(ap.Id, mapAccsOwnersChange.get(ap.acpl__participant_id__c));
            }
            update mapAP.values();
            //Obtenemos los antiguos gestores principales para eliminarlos
            Final Map<Id, bupl__AP_Team__c> mapAPTOldGestor = new Map<Id, bupl__AP_Team__c>(
                										[SELECT Id, bupl__gf_ap_team_user_id__c, acpl__gf_account_planning_id__r.acpl__proposal_manager_id__c, 
                                                         acpl__gf_account_planning_id__c, bupl__gf_ap_team_role_user_name__c, account_planning_Owner__c 
                                                         FROM bupl__AP_Team__c WHERE acpl__gf_account_planning_id__c IN:mapAP.keySet() AND account_planning_Owner__c = true]);
            //Obtenemos los usuarios que serán nuevos gestores y se encuentren en los AP's como miembros
            Final List<bupl__AP_Team__c> lstAPTOld = [SELECT Id, bupl__gf_ap_team_user_id__c, acpl__gf_account_planning_id__r.acpl__proposal_manager_id__c, account_planning_Owner__c, 
                                                acpl__gf_account_planning_id__c, bupl__gf_ap_team_role_user_name__c FROM bupl__AP_Team__c WHERE account_planning_Owner__c = false AND
                                                acpl__gf_account_planning_id__c IN:mapAP.keySet() AND bupl__gf_ap_team_user_id__c IN:mapAccsOwnersChange.values()];
            //Usuarios antiguos que serán nuevos gestores principales
            Final List<bupl__AP_Team__c> usersInAPT = new List<bupl__AP_Team__c>();
            for(bupl__AP_Team__c apt:lstAPTOld) {
                if(mapNewOwnerByAP.get(apt.acpl__gf_account_planning_id__c) == apt.bupl__gf_ap_team_user_id__c) {
                    usersInAPT.add(apt);
                }
            }
            Final List<bupl__AP_Team__c> lstAPTNewGestor = new List<bupl__AP_Team__c>();
            for(acpl__Account_Planning__c ap:mapAP.values()) {
                lstAPTNewGestor.add(new bupl__AP_Team__c(bupl__gf_ap_team_user_id__c = mapNewOwnerByAP.get(ap.Id), account_planning_Owner__c = true,
                                              acpl__gf_account_planning_id__c = ap.Id, bupl__gf_ap_team_role_user_name__c = 'Gestor del Plan'));
            }
            //Juntamos los antiguos gestores principales con los antiguos miembros que serán nuevos gestores
            usersInAPT.addAll(mapAPTOldGestor.values());
            delete usersInAPT;
            insert lstAPTNewGestor;
        }
    }
}
