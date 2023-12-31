/*
   ------------------------------------------------------------------------------------------------
   @Name Formalization_helper
   @Author Diego Carbajal diego.carbajal.contractor@bbva.com
   @Date Created: 2019-08-28
   @Group
   @Description Esta clase general gestiona las multiples fases del proceso de formalización
 */
public without sharing class Formalization_helper {
	/*Campo MSG_ERROR inicializado para soluciones del SonarQ*/
	public static Final String MSG_ERROR = 'msgError';
	/*Campo IS_ERROR inicializado para soluciones del SonarQ*/
	public static Final String IS_ERROR = 'isError';
	/*Campo MSG inicializado para soluciones del SonarQ*/
	public static Final String MSG = 'msg';
	/*Campo LST_QUEUE utilizado en los multiples metodos*/
	public static Final List<Group> LST_QUEUE = [SELECT ID, developerName FROM Group WHERE developerName IN('Tier_1_Formalization', 'Tier_2_Formalization') limit 2];
	/*Campo ASSIST_GROUP utilizado en los multiples metodos*/
	public static Final String ASSIST_GROUP = 'Asistentes_Operativos';
	/*Campo SUBG_GROUP utilizado en los multiples metodos*/
	public static Final String SUBG_GROUP = 'Subgerentes_Operativos';

	/* Public Method Class createOrUpdateCase */
	public static void createOrUpdateCase(Opportunity opp, String cola, String status) {
		Final Case[] caso = [SELECT Id FROM Case WHERE opportunity_id__c =:opp.Id AND recordType.Name = 'Formalization' AND status NOT IN('03', '04', '10', '11') limit 1];
		Final Integer casoSize = caso.size();
		if(casoSize > 0) {
			Formalization_helper.updateCase(opp.Id, 'Formalization');
		} else {
			Formalization_helper.createCase(opp.Id, cola, status, 'Formalization');
		}
	}

	/* Private Method Class createCase */
	private static void createCase(Id oppId, String cola, String status, String rtName) {
		try {
			Final List<RecordType> lstRT = [SELECT Id, Name FROM RecordType WHERE sObjectType = 'Case' AND DeveloperName =:rtName];
			Final List<Group> queue = [SELECT Id, DeveloperName FROM Group WHERE Type = 'Queue' AND DeveloperName =:cola];
			Final Opportunity opp = [SELECT Id, AccountId FROM Opportunity WHERE Id =:oppId];
			Final Case caso = new Case(AccountId = opp.AccountId, OwnerId = queue[0].Id, Status = status, opportunity_id__c = oppId, recordTypeId = lstRT[0].Id);
			caso.Dwp_ElevatedDate__c = (status == '07' ? System.now() : null);
			insert caso;
		} catch(Exception e) {
			System.debug('***No se pudo generar el caso***');
			System.debug('e.getMessage() => ' + e.getMessage());
		}
	}

	/* Private Method Class updateCase */
	private static void updateCase(Id oppId, String rtName) {
		Final Case caso = [SELECT Id, OwnerId, status, DWP_AssistantOwner__c, DWP_SGofOwner__c FROM Case WHERE opportunity_id__c =:oppId AND recordType.Name =:rtName AND
		                                                                                                                                                       status = '06' limit 1];
		Final Map<String, String> mapGroups = getGroup(LST_QUEUE, 'Tier_1_Formalization');
		Final String estado = (String.isEmpty(caso.DWP_AssistantOwner__c) && caso.OwnerId != mapGroups.get('grp1') ? '08' : '05');
		dynamicUpdateCase(caso, new Map<Schema.SObjectField, Object> {Case.status => estado});
	}

	/* Public Method Class reasignCase */
	@AuraEnabled
	public static Map<String, Object> reasignCase(Id caseId) {
		Map<String, Object> mapRes = new Map<String, Object> {IS_ERROR => true, MSG_ERROR => Label.Dwp_msgGenericError};
		try {
			//Roles de Asistentes y Subgerentes
			Final Set<String> rolAsis = getRolTeam(ASSIST_GROUP);
			Final Set<String> rolSG = getRolTeam(SUBG_GROUP);
			//Obtener Registro de Miembro en el equipo de formalización correcto
			Final GroupMember[] lstMember = [SELECT Id, Group.DeveloperName FROM GroupMember WHERE Group.DeveloperName IN('Asistentes_Operativos', 'Subgerentes_Operativos') AND
			                                 UserOrGroupId =:UserInfo.getUserId()];
			Final Integer lstMemberSize = lstMember.size();
			Final User usuario = [SELECT Id, Profile.Name, prof_position_id__c FROM User WHERE Id =:UserInfo.getUserId()];
			Final Case[] caso = [SELECT Id, OwnerId, status, Opportunity_id__c, DWP_AssistantOwner__c, DWP_SGofOwner__c FROM Case WHERE Id =:caseId];
			Final Map<Schema.SObjectField, Object> mapValues = new Map<Schema.SObjectField, Object> {Case.OwnerId => UserInfo.getUserId(), Case.bypass__c => true};
			if(lstMemberSize > 0 && rolAsis.contains(usuario.prof_position_id__c) && usuario.profile.Name == 'Operativo' &&
			   (caso[0].status == '01' || (caso[0].status == '05' || caso[0].status == '09' && String.isEmpty(caso[0].DWP_AssistantOwner__c)))) {
				mapValues.put(Case.status, '05');
				mapValues.put(Case.DWP_AssistantOwner__c, UserInfo.getUserId());
				mapRes = reasignAssOrSG(caso[0], ASSIST_GROUP, mapValues);
			} else if(lstMemberSize > 0 && rolSG.contains(usuario.prof_position_id__c) && usuario.profile.Name == 'Operativo' &&
			          (caso[0].status == '07' || (caso[0].status == '08' && String.isEmpty(caso[0].DWP_SGofOwner__c)))) {
				mapValues.put(Case.status, '08');
				mapValues.put(Case.DWP_SGofOwner__c, UserInfo.getUserId());
				mapRes = reasignAssOrSG(caso[0], SUBG_GROUP, mapValues);
			}
		} catch(AuraHandledException e) {
			System.debug('e.getMessage() => ' + e.getMessage());
			throw e;
		}
		return mapRes;
	}

	/* Public Method Class reasignAssOrSG */
	public static Map<String, Object> reasignAssOrSG(Case caso, String equipo, Map<Schema.SObjectField, Object> mapFields) {
		Final Map<String, Object> mapRes = new Map<String, Object>();
		Final List<Group> grupo = [SELECT Id, DeveloperName FROM Group WHERE DeveloperName =:equipo];
		Final List<GroupMember> members = [SELECT Id, GroupId, UserOrGroupId FROM GroupMember WHERE GroupId =:grupo[0].Id AND UserOrGroupId =:UserInfo.getUserId()];
		Final Integer memberSize = members.size();
		if(memberSize > 0) {
			mapRes.put(IS_ERROR, false);
			mapRes.put('oppId', caso.opportunity_id__c);
			dynamicUpdateCase(caso, mapFields);
			if(mapFields.get(Case.status) == '08') {
				Opportunity opp = [SELECT Id, opportunity_status_type__c FROM Opportunity WHERE Id =:caso.Opportunity_id__c];
				Map<Schema.SObjectField, Object> mapOpp = new Map<Schema.SObjectField, Object> {Opportunity.opportunity_status_type__c => '19'};
				dynamicUpdateOpp(opp, mapOpp);
			}
		} else {
			mapRes.put(IS_ERROR, true);
			mapRes.put(MSG_ERROR, 'Su usuario no esta registrado en el Equipo de Formalización.');
		}
		return MapRes;
	}

	/* Public Method Class validateUser */
	public static Map<String, Object> validateUser(Map<String, String> owner, Boolean assistant) {
		Final Map<String, Object> mapRes = new Map<String, Object>();
		if(owner.get('id') == UserInfo.getUserId()) {
			mapRes.put('property', 'Agree');
		} else if(String.isEmpty(owner.get('id'))) {
			mapRes.put('property', 'Empty');
			mapRes.put(MSG, assistant ? Label.lblEmptyAssistant_1 : Label.lblEmptySgof_1);
			mapRes.put('dialog', assistant ? Label.lblEmptyAssistant_2 : Label.lblEmptySgof_2);
		} else {
			mapRes.put('property', 'Assigned');
			mapRes.put(MSG, assistant ? String.format(Label.lblAssignedAssistant_1, new List<String> {owner.get('name').toUpperCase()}) : String.format(Label.lblAssignedSgof_1, new List<String> {owner.get('name').toUpperCase()}));
			mapRes.put('dialog', assistant ? Label.lblAssignedAssistant_2 : Label.lblAssignedSgof_2);
		}
		return mapRes;
	}

	/* Public Method Class getInfo */
	public static Map<String, Object> getInfo(Id oppId) {
		Final Map<String, Object> mapRes = new Map<String, Object> {IS_ERROR => true};
		Final Opportunity[] lstOpp = [SELECT Id, frm_ContractNumber__c FROM Opportunity WHERE Id =:oppId];
		Final Integer oppSize = lstOpp.size();
		if(oppSize > 0) {
			mapRes.put('contractNumber', String.isEmpty(lstOpp[0].frm_ContractNumber__c) ? '0011-' : lstOpp[0].frm_ContractNumber__c);
			mapRes.put('picklistValues', Dwp_Utils_helper.getPicklistValues('Opportunity', 'devolutionReason__c'));
			mapRes.put(IS_ERROR, false);
			//Si el caso esta en estado "Asignado AAC" o "Devuelta AAC" será TRUE
			Final Case caso = [SELECT Id, status FROM Case WHERE Opportunity_id__c =:oppId AND recordType.Name = 'Formalization' AND status IN('05', '08', '09') limit 1];
			Final Boolean lblButtons = caso.status == '05' || caso.status == '09' ? true : false;
			mapRes.put('lblSend', lblButtons ? 'Solicitar Formalización' : 'Formalizar');
			mapRes.put('lblReturn', lblButtons ? 'Devolver a ejecutivo' : 'Devolver');
		}
		return mapRes;
	}

	/* Public Method Class sendProductUnit */
	@AuraEnabled
	public static Map<String, Object> sendProductUnit(Id oppId) {
		Final Map<String, Object> mapRes = new Map<String, Object> {IS_ERROR => false};
		try {
			Opportunity opp = [SELECT Id FROM Opportunity WHERE Id =:oppId];
			Final Map<Schema.SObjectField, Object> mapOppFields = new Map<Schema.SObjectField, Object> {Opportunity.stageName => '05', Opportunity.opportunity_status_type__c => '21'};
			opp = dynamicUpdateOpp(opp, mapOppFields);
			//Por requerimiento actual de negocio, no se genera historial de seguimiento
			//new OpportunityTraceability_cls().addOpportunityTraceability(getStatusLabel(opp.opportunity_status_type__c),'<b>Comentarios:</b> '+
			//Body,'Opportunity',opp.Id,'elevate','TRFO00001',UserInfo.getUserId(),'embedded',1,true);
			mapRes.put(MSG, '¡Oportunidad enviada a la unidad de producto exitoso!');
		} catch(Exception e) {
			System.debug('e.getMessage() => ' + e.getMessage());
			mapRes.put(IS_ERROR, true);
			mapRes.put(MSG, Label.Dwp_msgGenericError);
		}
		return mapRes;
	}

	/* Public Method Class validateDevolutionReason */
	public static Map<String, Object> validateDevolutionReason(String reason, String comments) {
		Final Map<String, Object> mapRes = new Map<String, Object> {IS_ERROR => true, 'validateError' => 'Reason', MSG_ERROR => 'Elige un motivo por el cual estás devolviendo la petición.'};
		Final Map<String, String> mapValues = Dwp_Utils_helper.getPicklistValues('Opportunity', 'devolutionReason__c');
		if(mapValues.containsKey(reason)) {
			mapRes.put(IS_ERROR, false);
			mapRes.put('validateError', 'false');
			if(reason == '08') {
				mapRes.put(IS_ERROR, String.isEmpty(comments) ? true : false);
				mapRes.put('validateError', String.isEmpty(comments) ? 'Comments' : 'false');
				mapRes.put(MSG_ERROR, 'Detalla el motivo de devolución en los comentarios.');
			}
		}
		return mapRes;
	}

	/* Public Method Class validateAssistant */
	public static void dynamicUpdateCase(Case caso, Map<Schema.SObjectField, Object> mapFields) {
		for(Schema.SObjectField sField:mapFields.keySet()) {
			caso.put(sField, mapFields.get(sField));
		}
		caso.bypass__c = true;
		update caso;
		caso.bypass__c = false;
		update caso;
	}

	/* Public Method Class dynamicUpdateOpp */
	public static Opportunity dynamicUpdateOpp(Opportunity opp, Map<Schema.SObjectField, Object> mapFields) {
		for(Schema.SObjectField sField:mapFields.keySet()) {
			opp.put(sField, mapFields.get(sField));
		}
		opp.isProcess__c = true;
		update opp;
		opp.isProcess__c = false;
		update opp;
		return opp;
	}

	/* Public Method Class getRolTeam */
	public static Set<String> getRolTeam(String team) {
		Final Dwp_FormalizationRoles__mdt[] lstRol = [SELECT MasterLabel, DeveloperName, Dwp_AssignedTeam__c FROM Dwp_FormalizationRoles__mdt WHERE Dwp_AssignedTeam__c =:team];
		Final Set<String> setRol = new Set<String>();
		for(Dwp_FormalizationRoles__mdt rol: lstRol) {
			setRol.add(rol.DeveloperName);
		}
		return setRol;
	}

	/* Public Method Class getGroup */
	public static Map<String, String> getGroup(List<Group> lstGroup, String group1) {
		//Id de grupos
		Final Map<String, String> mapGrupos = new Map<String, String>();
		if(lstGroup[0].DeveloperName == group1) {
			mapGrupos.put('grp1', lstGroup[0].Id);
			mapGrupos.put('grp2', lstGroup[1].Id);
		} else {
			mapGrupos.put('grp1', lstGroup[1].Id);
			mapGrupos.put('grp2', lstGroup[0].Id);
		}
		return mapGrupos;
	}
}
