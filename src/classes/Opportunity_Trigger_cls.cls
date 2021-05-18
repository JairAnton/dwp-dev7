/*
 * @Name: Opportunity_tgr
 * @Description: Trigger de Ejecucion Opportunity
 * @Create by:
 *
 * V0-Creacion
 * @change history:
    - add addUserToOppTeam method used to add users with position code GE8 and GE9 to Opportunity Team
 *****************************
    Updates:
    Martín Alejandro Mori Chávez  2020-03-11
   @change history:
    - add Branch_id__c if is null for Opportunity from Calce y AP
 *****************************
    Updates:
    Jair Oswaldo Anton Atuncar  2021-05-18
 *
 */
public without sharing class Opportunity_Trigger_cls {
	/*
	 *   @Variable: ESPECIALISTA
	 */
	static Final String ESPECIALISTA = 'Especialista';
	/*
	 *   @Variable: temporal
	 */
	private static Final String MIGRACION {get {return 'Migracion';} set;}

	/*
	 *   @Private Constructor
	 */
	private Opportunity_Trigger_cls() {
	}

	/*
	 * asignBeforeInsert
	 */
	public static void asignBeforeInsert(list<Opportunity> oppsNew, Map<id, Opportunity> oppsNewMap) {
		//date CDate;//Yuliño: correcion
		Date pDate;
		if(!MIGRACION.equals([select Name from profile where Id = : Userinfo.getProfileId() limit 1].Name)) {
			for(Opportunity opp:oppsNew) {
				if(opp.Type == '01') {
					if(opp.opportunity_planning_date__c != null) {
						pDate = Date.valueOf(opp.opportunity_planning_date__c);
						opp.opportunity_planning_date__c = pDate;
						opp.opportunity_status_type__c = '02';
					} else if(!Test.isRunningTest()) {
						opp.opportunity_status_type__c = '03';
					}
					if(String.isNotBlank(opp.Support_currency__c)) {
						opp.CurrencyIsoCode = opp.Support_currency__c == '01' ? 'PEN' : 'USD';
					}
					if(opp.opportunity_planning_date__c != null && opp.Field_Sup_Closing_Date__c == null) {
						opp.CloseDate = pDate.addDays(45);
					} else if(opp.opportunity_planning_date__c == null && opp.Field_Sup_Closing_Date__c == null) {
						opp.CloseDate = Date.today().addDays(60);
					}
					if(opp.Field_Sup_Closing_Date__c != null) {
						opp.CloseDate = opp.Field_Sup_Closing_Date__c;
					}
				}
			}
		}
        
        /* Si el branch esta en blanco, agregará el branch del cliente*/
        for(Opportunity oppItem : oppsNew){
            if(oppItem.Branch_id__c == null){
                Account acc = [SELECT branch_id__c FROM Account WHERE Id =: oppItem.AccountId LIMIT 1];
                
                if(acc != null){
                    oppItem.Branch_id__c = acc.branch_id__c;
                }       
            }
        }
	}

	/**
	 * asignBeforeUpdate
	 */
	public static void asignBeforeUpdate(list<Opportunity> oppsNew, Map<id, Opportunity> oppsNewMap, list<Opportunity> oppsOld, Map<id, Opportunity> oppsOldMap) {
		valida(oppsNew, oppsOldMap);
	}

	/**
	 * asignAfterUpdate
	 */
	public static void asignAfterUpdate(List<Opportunity> lstNew, Map<Id, Opportunity> mapOld) {
		List <Id> lstId = new List <Id>();
		for(Opportunity opNew : lstNew) {
			Opportunity oldRecord = mapOld.get(opNew.Id);
			if(opNew.opportunity_status_type__c != oldRecord.opportunity_status_type__c && (opNew.opportunity_status_type__c == '11' || opNew.opportunity_status_type__c == '08')) {
				lstId.add(opNew.Id);
			}
		}
		Final Integer lstIdSize = lstId.size();
		if(lstIdSize > 0) {
			List<OpportunityLineItem> oliList = [select Id, price_quote_date__c from OpportunityLineItem where OpportunityId =:lstId];
			Final Integer oliListSize = oliList.size();
			if(oliListSize > 0) {
				for(OpportunityLineItem oli : oliList) {
					oli.price_quote_date__c = Date.today();
				}
				update oliList;
			}
			List<Opportunity_Solution_Commitment__c> oscList = [select Id, price_quote_date__c from Opportunity_Solution_Commitment__c where opportunity_id__c =:lstId];
			Final Integer oscListSize = oscList.size();
			if(oscListSize > 0) {
				for(Opportunity_Solution_Commitment__c osc : oscList) {
					osc.price_quote_date__c = Date.today();
				}
				update oscList;
			}
		}
	}

	/**
	 * valida
	 */
	private static void valida(list<Opportunity> oppsNew, Map<id, Opportunity> oppsOldMap) {
		set<Id> IdOwners = new set<ID>();
		for(Opportunity oppnew: oppsNew) {
			IdOwners.add(oppnew.OwnerId);
		}
		for(Opportunity oppnold: oppsOldMap.values()) {
			IdOwners.add(oppnold.OwnerId);
		}
		Map<Id, User> MapUser = new Map <Id, User>();
		for(User us:[Select Id, Name, Profile.Name, UserRole.Name from User where Id IN: IdOwners]) {
			MapUser.put(us.Id, us);
		}
		for(Opportunity opp:oppsNew) {
			if(opp.OwnerId != oppsOldMap.get(opp.Id).OwnerId && opp.StageName == '01' || opp.StageName == '02' && opp.StageName == '03') {
				if(MapUser.get(oppsOldMap.get(opp.Id).OwnerID).Profile.Name == 'Ejecutivo' || MapUser.get(oppsOldMap.get(opp.Id).OwnerID).UserRole.Name == 'Ejecutivo') {
					if(MapUser.get(opp.OwnerId).Profile.Name != 'Ejecutivo' && MapUser.get(opp.OwnerId).Profile.Name != ESPECIALISTA) {
						Opp.addError('No es posible reasignar una Oportunidad a este tipo de gerente1');
					}
				} else if(MapUser.get(oppsOldMap.get(opp.Id).OwnerID).Profile.Name == ESPECIALISTA || MapUser.get(oppsOldMap.get(opp.Id).OwnerID).UserRole.Name == ESPECIALISTA) {
					if(MapUser.get(opp.OwnerId).Profile.Name != ESPECIALISTA && MapUser.get(opp.OwnerId).Profile.Name != ESPECIALISTA) {
						Opp.addError('No es posible reasignar una Oportunidad a este tipo de gerente2');
					}
				} else if(MapUser.get(opp.OwnerId).Profile.Name == 'Analista' || MapUser.get(opp.OwnerId).Profile.Name == 'Operativo') {
					Opp.addError('No es posible reasignar una Oportunidad a este tipo de gerente');
				}
			}
		}
	}

	/**
	 * asignAfterInsert
	 */
	public static void asignAfterInsert(List <Opportunity> oppsNew) {
		Map<Id, Id> owneropp = new Map<Id, Id>();
		List<OpportunityTeamMember> oppTeam = new List<OpportunityTeamMember>();
		for(Opportunity opp : [SELECT Id, OwnerId, Account.OwnerId FROM Opportunity WHERE Id =:oppsNew AND Account.Owner.IsActive = TRUE]) {
			if(opp.OwnerId != opp.Account.OwnerId) {
				owneropp.put(opp.Id, opp.Account.OwnerId);
			}
		}
		Final Integer owneroppSize = owneropp.size();
		if(owneroppSize > 0) {
			for(String oppId : owneropp.keySet()) {
				oppTeam.add(new OpportunityTeamMember(UserId = owneropp.get(oppId), TeamMemberRole = '02', OpportunityAccessLevel = 'Edit', OpportunityId = oppId));
			}
			insert oppTeam;
		}
	}

	/**
	 * method used to add users to opportunityTeam
	 */
	public static void addUserToOppTeam(List<Opportunity> lstNew, Map<Id, Opportunity> mapOld) {
		final List<Id> lstIdOppTeam = new List<Id>();
		for(Opportunity opNew : lstNew) {
			if((opNew.opportunity_product_family__c != mapOld.get(opNew.Id).opportunity_product_family__c || opNew.CurrencyIsoCode != mapOld.get(opNew.Id).CurrencyIsoCode) && opNew.opportunity_product_family__c == 'Financiamiento a largo plazo' && opNew.CurrencyIsoCode == 'USD') {
				lstIdOppTeam.add(opNew.Id);
			}
		}
		if(!lstIdOppTeam.isEmpty()) {
			createOppTeam(lstIdOppTeam);
		}
	}

	/**
	 * method used to create opportunityTeam
	 */
	private static void createOppTeam(List<Id> lstIdOppTeam) {
		final List<OpportunityTeamMember> oppTeam = new List<OpportunityTeamMember>();
		for(User usr : [SELECT Id FROM User WHERE IsActive = true AND prof_position_id__c IN('GE8', 'GE9')]) {
			for(Id oppId : lstIdOppTeam) {
				oppTeam.add(new OpportunityTeamMember(UserId = usr.Id, TeamMemberRole = '02', OpportunityAccessLevel = 'Edit', OpportunityId = oppId));
			}
		}
		if(!oppTeam.isEmpty()) {
			insert oppTeam;
		}
	}
}