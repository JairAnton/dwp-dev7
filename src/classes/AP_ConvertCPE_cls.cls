/**
 * Logic class for Convert Commercial Actions.
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		15/05/2020          Original version.<p />
 *
 * @author Diego Carbajal
 */
public without sharing class AP_ConvertCPE_cls {
    /** @Description  TASK*/
    private static Final String TASK = 'Task';
	/*
	 * @Description  private constructor
	 */
	private AP_ConvertCPE_cls() {}

	/*
	 * @Description  Convierte las acciones comerciales
	 */
	public static void convertCPERecords(Map<Id, acpl__Commercial_Plan_Event__c> mapCPE) {
		Final Set<Id> idsCPEVisit = createdActions(mapCPE.keySet(), 'dwp_kitv__Visit__c');
		Final Set<Id> idsCPEOpp = createdActions(mapCPE.keySet(), 'Opportunity');
		Final Set<Id> idsCPETask = createdActions(mapCPE.keySet(), TASK);
		List<dwp_kitv__Visit__c> newVisitCPE = new List<dwp_kitv__Visit__c>();
		List<Opportunity> newOppCPE = new List<Opportunity>();
		List<Task> newTaskCPE = new List<Task>();
		Final Map<Id, Id> mapCPEPartner = new Map<Id, Id>();
		for(acpl__Commercial_Plan_Event__c cpe:mapCPE.values()) {
			if(String.isNotBlank(cpe.Asiggned_User__c)) {
				mapCPEPartner.put(cpe.Id, cpe.Asiggned_User__c);
			}
			newVisitCPE = setNewVisit(cpe, idsCPEVisit, newVisitCPE);
			newOppCPE = setNewOpp(cpe, idsCPEOpp, newOppCPE);
			newTaskCPE = setNewTask(cpe, idsCPETask, newTaskCPE);
		}
		Final Integer newVisitCPESize = newVisitCPE.size();
		Final Integer newOppCPESize = newOppCPE.size();
		Final Integer newTaskCPESize = newTaskCPE.size();
		Final Map<Id, User> mapUser = new Map<Id, User>([SELECT Id, Name, isActive FROM User WHERE Id IN: mapCPEPartner.values() AND isActive = true]);
		//Crea visitas
		if(newVisitCPESize > 0) {
			insert newVisitCPE;
			createVMT(mapCPE, mapCPEPartner, newVisitCPE, mapUser);
		}
		//Crea oportunidades
		if(newOppCPESize > 0) {
			insert newOppCPE;
			createATM(mapCPE, mapCPEPartner, newOppCPE, mapUser);
		}
		//Crea Tareas
		if(newTaskCPESize > 0) {
			insert newTaskCPE;
		}
	}

	/*
	 * @Description  Obtiene las acciones comerciales por tipo
	 */
	public static Set<Id> createdActions(Set<Id> idsCPE, String sobjType) {
		Final Set<Id> setCPEId = new Set<Id>();
		switch on sobjType {
			when 'dwp_kitv__Visit__c' {
				for(dwp_kitv__Visit__c visit: [SELECT Id, commercial_plan_event__c FROM dwp_kitv__Visit__c WHERE commercial_plan_event__c IN: idsCPE]) {
					setCPEId.add(visit.commercial_plan_event__c);
				}
			}
			when 'Opportunity' {
				for(Opportunity opp: [SELECT Id, commercial_plan_event__c FROM Opportunity WHERE commercial_plan_event__c IN: idsCPE]) {
					setCPEId.add(opp.commercial_plan_event__c);
				}
			}
			when 'Task' {
				for(Task tarea: [SELECT Id, WhatId FROM Task WHERE WhatId IN: idsCPE]) {
					setCPEId.add(tarea.WhatId);
				}
			}
		}
		return setCPEId;
	}

	/*
	 * @Description  Crea Visit Managment Team asociados a las visitas creadas
	 */
	public static void createVMT(Map<Id, acpl__Commercial_Plan_Event__c> mapCPE, Map<Id, Id> mapCPEPartner, List<dwp_kitv__Visit__c> newVisitCPE, Map<Id, User> mapUser) {
		Final Map<Id, Set<Id>> mapVMT = new Map<Id, Set<Id>>();
		Set<Id> idsUsers;
		//Obtengo los VMT que se crearon automaticamente en las visitas creadas
		for(dwp_kitv__Visit_Management_Team__c vmt: [SELECT Id, dwp_kitv__user_id__c, dwp_kitv__visit_id__c FROM dwp_kitv__Visit_Management_Team__c WHERE
		                                             dwp_kitv__user_id__c IN:mapUser.keySet() AND dwp_kitv__visit_id__r.commercial_plan_event__c IN:mapCPE.keySet()]) {
			idsUsers = new Set<Id>();
			if(mapVMT.containsKey(vmt.dwp_kitv__visit_id__c)) {
				idsUsers = mapVMT.get(vmt.dwp_kitv__visit_id__c);
			}
			idsUsers.add(vmt.dwp_kitv__user_id__c);
			mapVMT.put(vmt.dwp_kitv__visit_id__c, idsUsers);
		}
		Final List<dwp_kitv__Visit_Management_Team__c> newVMT = new List<dwp_kitv__Visit_Management_Team__c>();
		for(dwp_kitv__Visit__c visit: newVisitCPE) {
			//1. mapCPEPartner contiene los Asiggned_User__c de los acpl__Commercial_Plan_Event__c
			//2. mapUser verifica si el usuario en Asiggned_User__c esta activo
			//3. Verifica que el Asiggned_User__c no se encuentre como VMT en el equipo de la visita (creaci�n automatica)
			if(mapCPEPartner.containsKey(visit.commercial_plan_event__c) && mapUser.containsKey(mapCPEPartner.get(visit.commercial_plan_event__c)) &&
			   (mapVMT.isEmpty() || !mapVMT.get(visit.Id).contains(mapCPEPartner.get(visit.commercial_plan_event__c)))) {
				newVMT.add(new dwp_kitv__Visit_Management_Team__c(dwp_kitv__user_id__c = mapCPEPartner.get(visit.commercial_plan_event__c), dwp_kitv__visit_id__c = visit.Id));
			}
		}
		insert newVMT;
	}

	/*
	 * @Description  Crea Opportunity Team asociados a las Opportunity creadas
	 */
	public static void createATM(Map<Id, acpl__Commercial_Plan_Event__c> mapCPE, Map<Id, Id> mapCPEPartner, List<Opportunity> newOppCPE, Map<Id, User> mapUser) {
		Final Map<Id, Set<Id>> mapATM = new Map<Id, Set<Id>>();
		Set<Id> idsUsers;
		//Obtengo los ATM que se crearon automaticamente en las Oportunidades creadas
		for(OpportunityTeamMember atm: [SELECT Id, OpportunityId, UserId FROM OpportunityTeamMember WHERE UserId IN:mapUser.keySet() AND Opportunity.commercial_plan_event__c IN:mapCPE.keySet()]) {
			idsUsers = new Set<Id>();
			if(mapATM.containsKey(atm.OpportunityId)) {
				idsUsers = mapATM.get(atm.OpportunityId);
			}
			idsUsers.add(atm.UserId);
			mapATM.put(atm.OpportunityId, idsUsers);
		}
		Final List<OpportunityTeamMember> newATM = new List<OpportunityTeamMember>();
		for(Opportunity opp: newOppCPE) {
			//1. mapCPEPartner contiene los Asiggned_User__c de los acpl__Commercial_Plan_Event__c
			//2. mapUser verifica si el usuario en Asiggned_User__c esta activo
			//3. Verifica que el Asiggned_User__c no se encuentre como VMT en el equipo de la visita (creaci�n automatica)
			if(mapCPEPartner.containsKey(opp.commercial_plan_event__c) && mapUser.containsKey(mapCPEPartner.get(opp.commercial_plan_event__c)) &&
			   (mapATM.isEmpty() || !mapATM.get(opp.Id).contains(mapCPEPartner.get(opp.commercial_plan_event__c)))) {
				newATM.add(new OpportunityTeamMember(UserId = mapCPEPartner.get(opp.commercial_plan_event__c), OpportunityId = opp.Id));
			}
		}
		insert newATM;
	}

	/*
	 * @Description  setNewVisit for sonar
	 */
	private static List<dwp_kitv__Visit__c> setNewVisit(acpl__Commercial_Plan_Event__c cpe, Set<Id> idsCPEVisit, List<dwp_kitv__Visit__c> newVisitCPE) {
		if(cpe.acpl__gf_comm_plan_event_type_name__c == 'Visit' && !idsCPEVisit.contains(cpe.Id)) {
			newVisitCPE.add(new dwp_kitv__Visit__c(dwp_kitv__visit_purpose_type__c = '01', dwp_kitv__account_id__c = cpe.acpl__gf_account_planning_id__r.acpl__participant_id__c,
			                                       Name = 'Visita AP - ' + cpe.acpl__gf_account_planning_id__r.acpl__participant_id__r.Name + ' ' + String.valueOf(cpe.acpl__gf_event_date__c).left(10),
			                                       OwnerId = cpe.acpl__gf_account_planning_id__r.acpl__proposal_manager_id__c, dwp_kitv__visit_desc__c = cpe.Comments__c, dwp_kitv__visit_duration_number__c = '30',
			                                       dwp_kitv__visit_start_date__c = Date.today().addMonths(2), commercial_plan_event__c = cpe.Id));
		}
		return newVisitCPE;
	}

	private static List<Opportunity> setNewOpp(acpl__Commercial_Plan_Event__c cpe, Set<Id> idsCPEOpp, List<Opportunity> newOppCPE) {
		if(cpe.acpl__gf_comm_plan_event_type_name__c == 'Opportunity' && !idsCPEOpp.contains(cpe.Id)) {
			newOppCPE.add(new Opportunity(AccountId = cpe.acpl__gf_account_planning_id__r.acpl__participant_id__c, StageName = '02', opportunity_status_type__c = '03',
			                              Name = 'Oportunidad AP - ' + cpe.acpl__gf_account_planning_id__r.acpl__participant_id__r.Name + ' ' + String.valueOf(cpe.acpl__gf_event_date__c).left(10),
			                              CloseDate = Date.today().addMonths(2), Field_Sup_Closing_Date__c = Date.today().addMonths(2), Description = cpe.Comments__c, commercial_plan_event__c = cpe.Id,
			                              opportunity_planning_date__c = Date.today().addDays(14), OwnerId = cpe.acpl__gf_account_planning_id__r.acpl__proposal_manager_id__c));
		}
		return newOppCPE;
	}

	private static List<Task> setNewTask(acpl__Commercial_Plan_Event__c cpe, Set<Id> idsCPETask, List<Task> newTaskCPE) {
		if((cpe.acpl__gf_comm_plan_event_type_name__c == TASK || cpe.acpl__gf_comm_plan_event_type_name__c == 'Call') && !idsCPETask.contains(cpe.Id)) {
			newTaskCPE.add(new Task(OwnerId = (String.isBlank(cpe.Asiggned_User__c) ? cpe.acpl__gf_account_planning_id__r.acpl__proposal_manager_id__c : cpe.Asiggned_User__c),
			                        Subject = (cpe.acpl__gf_comm_plan_event_type_name__c == TASK ? 'Other' : 'Call'), ActivityDate = Date.today().addMonths(2), WhatId = cpe.Id));
		}
		return newTaskCPE;
	}
}
