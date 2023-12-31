/**
 * ------------------------------------------------------------------------------------------------
 * @Name SgofFormalization_helper
 * @Author Diego Carbajal diego.carbajal.contractor@bbva.com
 * @Date Created: 2019-08-17
 * @Group
 * @Description Esta clase controla el proceso de formalización para el SGOF
 */
public without sharing class SgofFormalization_helper {
	/*Campo MSG_ERROR inicializado para soluciones del SonarQ*/
	public static Final String MSG_ERROR = 'errorMessage';
	/*Campo IS_ERROR inicializado para soluciones del SonarQ*/
	public static Final String IS_ERROR = 'isError';
	/*Campo SUCCESS inicializado para soluciones del SonarQ*/
	public static Final String SUCCESS = 'success';
	/*Campo GET_MESSAGE inicializado para soluciones del SonarQ*/
	public static Final String GET_MESSAGE = 'e.getmessage() => ';

	/* Public Method Class validateSGof */
	@AuraEnabled
	public static Map<String, Object> validateSGof(Id oppId) {
		Final Map<String, Object> mapRes = new Map<String, Object> {IS_ERROR => false, 'msgError' => Label.Dwp_msgGenericError};
		try {
			//Roles de Subgerentes
			Final Set<String> rolSG = Formalization_helper.getRolTeam('Subgerentes_Operativos');
			Final User usuario = [SELECT Id, Profile.Name, prof_position_id__c FROM User WHERE Id =:UserInfo.getUserId()];
			Final Case[] caso = [SELECT Id, DWP_SGofOwner__c, DWP_SGofOwner__r.Name FROM Case WHERE Opportunity_id__c =:oppId AND recordType.Name = 'Formalization' AND status IN('07', '08') limit 1];
			Final Integer casoSize = caso.size();
			if(rolSG.contains(usuario.prof_position_id__c) && usuario.profile.Name == 'Operativo' && casoSize > 0) {
				Final Map<String, String> owner = new Map<String, String> {'id' => caso[0].DWP_SGofOwner__c, 'name' => caso[0].DWP_SGofOwner__r.Name};
				mapRes.putAll(Formalization_helper.validateUser(owner, false));
			} else {
				mapRes.put(IS_ERROR, true);
			}
		} catch(AuraHandledException e) {
			System.debug(GET_MESSAGE + e.getMessage());
			throw e;
		}
		return mapRes;
	}

	/* Public Method Class reasignCaseFromOpp */
	@AuraEnabled
	public static Map<String, Object> reasignCaseFromOpp(Id oppId) {
		Map<String, Object> mapRes = validateSGof(oppId);
		try {
			Final Boolean isError = (Boolean)mapRes.get(IS_ERROR) ? false : true;
			if(isError) {
				Final Case[] caso = [SELECT Id, opportunity_id__c FROM Case WHERE Opportunity_id__c =:oppId AND recordType.Name = 'Formalization' AND status IN('07', '08') limit 1];
				Final Map<Schema.SObjectField, Object> mapValues = new Map<Schema.SObjectField, Object> {Case.OwnerId => UserInfo.getUserId(), Case.bypass__c => true,
					                                                                                     Case.DWP_SGofOwner__c => UserInfo.getUserId(), Case.status => '08'};
				mapRes = Formalization_helper.reasignAssOrSG(caso[0], 'Subgerentes_Operativos', mapValues);
				mapRes.put('msgSuccess', '¡Te asignaste la petición exitosamente! Ahora puedes formalizar esta oportunidad.');
			}
		} catch(AuraHandledException e) {
			System.debug(GET_MESSAGE + e.getMessage());
			throw e;
		}

		return mapRes;
	}

	/* Public Method Class sendProductUnitSgof */
	@AuraEnabled
	public static Map<String, Object> sendProductUnitSgof(string recordId) {
		Map<String, Object> mapRes = new Map<String, Object> {IS_ERROR => false, 'msgError' => Label.Dwp_msgGenericError};
		Final Case[] caso = [SELECT Id, OwnerId FROM Case WHERE Opportunity_id__c =:recordId AND RecordType.DeveloperName = 'Formalization'
		                                                                                                                    AND status NOT IN('03', '04', '10', '11') AND OwnerId =:UserInfo.getUserId() limit 1];
		if(caso.size() > 0) {
			mapRes = Formalization_helper.sendProductUnit(recordId);
		}
		return mapRes;
	}

	/* Public Method Class getData */
	@AuraEnabled
	public static Map<String, Object> getData(Id oppId) {
		try {
			return Formalization_helper.getInfo(oppId);
		} catch(AuraHandledException e) {
			System.debug(GET_MESSAGE + e.getMessage());
			throw e;
		}
	}

	/* Public Method Class sentToFormalize */
	@AuraEnabled
	public static Map<String, Object> sentToFormalize(Id oppId, String values) {
		Map<String, Object> mapRes = new Map<String, Object> {SUCCESS => false};
		Final Map<String, Object> mapInputs = (Map<String, Object>) JSON.deserializeUntyped(values);
		Map<Schema.SObjectField, Object> mapCaseFields;
		Map<Schema.SObjectField, Object> mapOppFields;
		Opportunity opp = [SELECT Id, StageName, opportunity_status_type__c, (SELECT Id, product2.type_of_quote__c, ProductCode FROM OpportunityLineItems) FROM Opportunity WHERE Id =: oppId limit 1];
		Final Case[] caso = [SELECT Id, caseNumber, DWP_AssistantOwner__c, DWP_AssistantOwner__r.Name, OwnerId, status, Opportunity_id__c, DWP_SGofOwner__c FROM Case WHERE Opportunity_id__c =:oppId AND
		                                                                                                                                                                                        recordType.Name = 'Formalization' AND status IN('08') limit 1];
		Final Map<String, Object> lstView = Dwp_Utils_helper.getListView('Case', 'Tier_2_Formalization_Case');
		Final List<ListView> view = ((Boolean)lstView.get(IS_ERROR) ? new List<ListView>() : (List<ListView>) lstView.get('listView'));
		Final String contractNumber = (String)mapInputs.get('contractNumber');
		Final String devolutionReason = (String)mapInputs.get('devolutionReason');
		Final String comments = (String)mapInputs.get('comments');
		Final String option = (String)mapInputs.get('option');
		switch on option {
			when 'sentToFormalize' {
				Final Map<String, Object> mapFormatt = Dwp_Utils_helper.validateFormatt('[0-9]{4}-[0-9]{4}-[0-9]{10}', contractNumber);
				Final Boolean vFormat = (Boolean)mapFormatt.get(IS_ERROR) ? false : true;
				if(vFormat) {
					mapOppFields = new Map<Schema.SObjectField, Object> {Opportunity.frm_ContractNumber__c => contractNumber, Opportunity.opportunity_status_type__c => '23',
						                                                 Opportunity.stageName => '06'};
					mapCaseFields = new Map<Schema.SObjectField, Object> {Case.status => '10'};
					if(opp.OpportunityLineItems[0].product2.type_of_quote__c == 'Web') {
						mapRes = Product_cls.disburseQuotation(oppId, contractNumber);
					} else {
						mapRes.put(SUCCESS, true);
					}
					mapRes.put('msgSuccess', '¡Has formalizado la oportunidad exitosamente!');
					mapRes.put('listView', ((Boolean)lstView.get(IS_ERROR) ? '' : view[0].Id));
				} else {
					mapRes.put(SUCCESS, false);
					mapRes.put(MSG_ERROR, 'Coloca un número de contrato para enviar a formalizar la oportunidad.');
				}
			}
			when 'returnByDocumentation' {
				Final Map<String, Object> mapReason = Formalization_helper.validateDevolutionReason(devolutionReason, comments);
				Final Boolean vReason = (Boolean)mapReason.get(IS_ERROR) ? false : true;
				if(vReason) {
					//Si tiene Asistente y el producto forma parte del flujo del asistente, se devuelve al asistente o Tier 1, sino se devuelve al ejecutivo
					Final Dwp_FormalizationProducts_AAC__c[] prdAssistForm = Dwp_FormalizationProducts_AAC__c.getAll().values();
					Final Set<String> prdToForm = new Set<String>();
					for(Dwp_FormalizationProducts_AAC__c prd:prdAssistForm) {
						prdToForm.add(prd.Product_Code__c);
					}
					if(String.isEmpty(caso[0].DWP_AssistantOwner__c) && !prdToForm.contains(opp.OpportunityLineItems[0].ProductCode)) {
						mapCaseFields = new Map<Schema.SObjectField, Object> {Case.status => '06', Case.dwp_returned_date__c => DateTime.now()};
						mapOppFields = new Map<Schema.SObjectField, Object> {Opportunity.devolutionReason__c => devolutionReason, Opportunity.opportunity_status_type__c => '20',
							                                                 Opportunity.Dwp_DevolutionUser__c => UserInfo.getUserId()};
						mapRes.put('msgSuccess', '¡Has devuelto exitosamente la petición N° ' + caso[0].CaseNumber + ' al ejecutivo!');
					} else {
						Final String reasign = (String.isEmpty(caso[0].DWP_AssistantOwner__c) ? [SELECT ID FROM Group WHERE DeveloperName = 'Tier_1_Formalization'].Id : caso[0].DWP_AssistantOwner__c);
						mapCaseFields = new Map<Schema.SObjectField, Object> {Case.status => '09', Case.OwnerId => reasign, Case.dwp_returned_date__c => DateTime.now()};
						mapOppFields = new Map<Schema.SObjectField, Object> {Opportunity.devolutionReason__c => devolutionReason, Opportunity.opportunity_status_type__c => '25',
							                                                 Opportunity.Dwp_DevolutionUser__c => UserInfo.getUserId()};
						mapRes.put('msgSuccess', '¡Has devuelto exitosamente la petición N° ' + caso[0].CaseNumber + ' al asistente!');
					}
					mapRes.put(SUCCESS, true);
					mapRes.put('listView', ((Boolean)lstView.get(IS_ERROR) ? '' : view[0].Id));
				} else {
					mapRes.put(SUCCESS, false);
					mapRes.put(MSG_ERROR, (String)mapReason.get('msgError'));
				}
			}
			when else {
				mapRes.put(SUCCESS, false);
				mapRes.put(MSG_ERROR, Label.Dwp_msgGenericError);
			}
		}

		if((Boolean)mapRes.get(SUCCESS)) {
			Formalization_helper.dynamicUpdateCase(caso[0], mapCaseFields);
			opp = Formalization_helper.dynamicUpdateOpp(opp, mapOppFields);
			if(option == 'sentToFormalize') {
				new OpportunityTraceability_cls().addOpportunityTraceability(Product_cls.getStatusLabel(opp.opportunity_status_type__c), '<b>Número de contrato:</b> ' + contractNumber
				                                                             + (comments == null ? '' : '<br/><b>Comentarios:</b> ' + comments), 'Opportunity', opp.Id, 'approve', 'TRFO00001', UserInfo.getUserId(), 'embedded', 1, true);
			} else if(option == 'returnByDocumentation') {
				Final Map<String, String> devolution = Dwp_Utils_helper.getPicklistValues('Opportunity', 'devolutionReason__c');
				Final OpportunityLineItem[] oli = Product_cls.getIdProductByOpportunity(opp.Id);
				new OpportunityTraceability_cls().addOpportunityTraceability(Product_cls.getStatusLabel(opp.opportunity_status_type__c), '<b>Razón de devolución: </b>'
				                                                             + devolution.get(devolutionReason) + (comments == null ? '' : '<br/><b>Comentarios:</b> ' + comments) +
				                                                             (oli[0].Product2.Type_of_quote__c == 'Web' ? '<br/><b>Validez TEA:</b> ' + oli[0].validityDate__c : ''),
				                                                             'Opportunity', opp.Id, 'sendBack', 'TRFO00001', UserInfo.getUserId(), 'embedded', 1, true);
			}
		}
		return mapRes;
	}
}
