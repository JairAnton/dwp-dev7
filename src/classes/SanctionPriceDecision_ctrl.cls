/**
 * @author Global_HUB developers
 * @date 01-08-2018
 *
 * @group Global_HUB
 *
 * @description Controller class from SanctionPriceDecision_ctrl
 * @Changes
 *  Date        Author   Email                  			Type		Description
 *  2020-11-06  MAMC     martin.mori.contractor@bbva.com	Modify		add method to create quote pdf
 **/
public with sharing class SanctionPriceDecision_ctrl {
	/**
	 * Label status Approved
	 */
	Final Static String SAPPROVED = '08';
	/**
	 * Label status Sent
	 */
	Final Static String SSENT = '09';
	/**
	 * Label status Authorized
	 */
	Final Static String SAUTHORIZED = '10';
	/**
	 * Label status Denied
	 */
	Final Static String SDENIED = '13';
	/**
	 * Label web method
	 */
	Final Static String SWEB = 'web';
	/**
	 * Map label id analist
	 */
	Final Static String IDANALIST = 'idAnalist';
	/**
	 * Map label newStoreHtml
	 */
	Final Static String NEWSTOREHTML = 'newStoreHtml';
	/**
	 * Map label regular expresion
	 */
	Final Static String REGEX = '(0[1-9]|[12][0-9]|3[01])/(0[1-9]|1[012])/(19|2[0-9])[0-9]{2}?';

	/**Method for get information of price process **/
	@AuraEnabled
	public static Map<String, Object> getInfo(String oliId, String uniqueNameTable) {
		Map<String, Object> mapReturn = new Map<String, Object>();
        List<OpportunityLineItem> lstOppLineItem = [SELECT Id,
		                                            Product2.Name,
		                                            Product2Id,
		                                            proposed_fee_per__c,
		                                            minimun_fee_per__c,
		                                            OpportunityId,
		                                            Opportunity.opportunity_status_type__c,
		                                            Opportunity.CurrencyIsoCode,
                                                    RORC_Client__c
		                                            FROM OpportunityLineItem
		                                            WHERE Id = :oliId];
		
		try {
			if(!lstOppLineItem.isEmpty() && lstOppLineItem[0].Opportunity.opportunity_status_type__c == SAPPROVED) {
				//helper to call the service
				Final GetQuotationRequest_helper getquoteHelper = new GetQuotationRequest_helper(lstOppLineItem[0].OpportunityId);
				//invoke the service
				Final System.HttpResponse invoke = getquoteHelper.invoke();
				switch on invoke.getStatusCode() {
					when 200 {
						//get json body
						Final GetQuotationRequest_helper.ResponseGetQuotationRequest_Wrapper jbody = GetQuotationRequest_helper.parse(invoke.getBody());
						if(jbody.data.quotations[0].validityDate != null && jbody.data.quotations[0].validityDate != '') {
							mapReturn.put('validityDate', Date.valueOf(jbody.data.quotations[0].validityDate.substring(0, 10)));
							mapReturn.put('changeDate', false);
							lstOppLineItem[0].validityDate__c = Date.valueOf(jbody.data.quotations[0].validityDate.substring(0, 10));
							update lstOppLineItem[0];
						}
					}
				}
			}
		} catch(Exception e) {
			System.debug('error: ' + e);
		}

		mapReturn.put('lstOppLineItem', lstOppLineItem);
		mapReturn.put('lstSummarize', JSON.serialize(BE_CustomListField_Cls.createListField(oliId, uniqueNameTable)));
		mapReturn.put('sanctionPriceInfo', getSanctionPriceInfo(oliId));

		return mapReturn;
	}

	/**Method for save decision of ejecutive **/
	@AuraEnabled
	public static Map<String, Object> saveDecision(String recordId, String status_opp, String stageName, Boolean createCase, String styleAudit, String nameAudit, String strComments, String storeHtml) {
		Map<String, Object> mapReturn = new Map<String, Object>();
		List<dwp_cvad__Action_Audit__c> lstAudit = new List<dwp_cvad__Action_Audit__c>();
		Opportunity opp = new Opportunity();
		opp.Id = recordId;
		opp.StageName = stageName;
		opp.opportunity_status_type__c = status_opp;
		opp.isProcess__c = true;
		try {
			update opp;
			lstAudit.add(Action_Audit_Helper.getAudit(nameAudit, 'Opportunity', recordId, DateTime.now(), label.AuditPriceApproval, UserInfo.getUserId(), styleAudit, null, false));
			lstAudit[0].dwp_cvad__audit_audit_comments__c = strComments;
			insert lstAudit;

			List<dwp_cvad__Action_Audit_Detail__c> lstDetails = new List<dwp_cvad__Action_Audit_Detail__c>();
			lstDetails.add(Action_Audit_Helper.getAuditDetail(lstAudit[0].Id, storeHtml, 1, '', 'Embedded'));
			insert lstDetails;

			if(createCase) {
				List<RecordType> rt = [SELECT Id, DeveloperName FROM RecordType WHERE DeveloperName = 'Sanction_Price' AND SobjectType = 'Case' limit 1];
				List<Group> queueGroup = [SELECT Id,
				                          DeveloperName,
				                          Type
				                          FROM Group
				                          WHERE Type = 'Queue'
				                                       AND DeveloperName = 'Tier_1'];
				List<Opportunity> lstOpp = [SELECT Id,
				                            AccountId
				                            FROM Opportunity
				                            WHERE Id = :recordId];
				Case caseInsert = new Case();
				caseInsert.Status = '01';
				caseInsert.OwnerId = queueGroup[0].Id;
				caseInsert.Type = 'Other';
				caseInsert.AccountId = lstOpp[0].AccountId;
				caseInsert.opportunity_id__c = recordId;
				caseInsert.RecordTypeId = rt[0].Id;
				insert caseInsert;
			}
			mapReturn.put('isOk', true);
		} catch(Exception e) {
			mapReturn.put('isOk', false);
		}
		return mapReturn;
	}

	/**Method for save decision of analist **/
	@AuraEnabled
	public static Map<String, Object> saveDecisionAnalist(String jsonParams, Boolean elevateCase, List<String> lstApiField, List<Object> lstValue) {
		Final Parameters params = (Parameters)JSON.deserialize(jsonParams, Parameters.class);
		Map<String, Object> mapReturn = new Map<String, Object>();
		Opportunity opp = new Opportunity();
		opp.Id = params.recordId;
		opp.StageName = params.stageName;
		opp.opportunity_status_type__c = params.statusOpp;
		opp.isProcess__c = true;
		Boolean isOk = true;
		mapReturn.put(NEWSTOREHTML, params.storeHtml);
		mapReturn.put(IDANALIST, null);
		try {
			if(params.approvalMethod == SWEB) {
				Final ModifyQuotationRequest_helper modifyHelper = new ModifyQuotationRequest_helper(params.recordId, params.wsPhase, (lstValue[1] == null ? null : Double.valueOf(lstValue[1])), '', null);
				try {
					Final System.HttpResponse invokeModify = modifyHelper.invoke();
					switch on invokeModify.getStatusCode() {
						when 200 {
							mapReturn = updateOli(params, invokeModify.getBody(), opp, mapReturn);
						}
						when 409 {
							WebServiceUtils.ResponseErrorMessage_Wrapper errorW = WebServiceUtils.parse(invokeModify.getBody());
							isOk = false;
							mapReturn.put('isOk', false);
							mapReturn.put('errorMessage', Label.DecisionPriceActionError + ' ' + errorW.errormessage);
						}
						when else {
							isOk = false;
							mapReturn.put('isOk', false);
							mapReturn.put('errorMessage', Label.PriceGenericError);
						}
					}
				} catch(Exception e) {
					isOk = false;
					mapReturn.put('isOk', false);
					mapReturn.put('errorMessage', Label.PriceGenericError);
				}
			}
			if(isOk) {
				update opp;
				mapReturn = saveAuditCase(params, mapReturn, elevateCase, (String)mapReturn.get(IDANALIST), lstApiField, lstValue);
			}
		} catch(Exception e) {
			mapReturn.put('isOk', false);
		}
		return mapReturn;
	}

	/**Method for get information used to analist **/
	@AuraEnabled
	public static Map<String, Object> getInfoAnalist(String oliId, String uniqueNameTable) {
        Map<String, Object> mapReturn = new Map<String, Object>();

		List<OpportunityLineItem> lstOppLineItem = [SELECT Id,
		                                            Product2.Name,
		                                            Product2Id,
		                                            proposed_fee_per__c,
		                                            minimun_fee_per__c,
		                                            OpportunityId,
		                                            Opportunity.CurrencyIsoCode
		                                            FROM OpportunityLineItem
		                                            WHERE Id = :oliId];
		mapReturn.put('lstOppLineItem', lstOppLineItem);
		mapReturn.put('lstSummarize', JSON.serialize(BE_CustomListField_Cls.createListField(oliId, uniqueNameTable)));

		List<Case> lstCases = [SELECT Id,
		                       opportunity_id__c,
		                       IsClosed
		                       FROM Case
		                       WHERE opportunity_id__c = :lstOppLineItem[0].OpportunityId
		                                                 AND IsClosed = false
		                                                                AND Status = '01'];
		mapReturn.put('caseOpen', !lstCases.isEmpty());

		return mapReturn;
	}

	/**Method for save audit web **/
	@AuraEnabled
	public static Map<String, Object> saveAuditWeb(String auditRecordId,  String storeHtml) {
		Map<String, Object> mapReturn = new Map<String, Object>();
		String html = storeHtml;
		Final List<dwp_cvad__Action_Audit__c> ltsAudit = [SELECT Id, dwp_cvad__action_audit_record_id__c FROM dwp_cvad__Action_Audit__c WHERE Id = :auditRecordId];
		if(!ltsAudit.isEmpty()) {
			Final List<Opportunity> ltsOpp = [SELECT Id, opportunity_status_type__c FROM Opportunity WHERE Id = :ltsAudit[0].dwp_cvad__action_audit_record_id__c];
			if(!ltsOpp.isEmpty() && ltsOpp[0].opportunity_status_type__c == SSENT) {
				html = storeHtml.replaceAll(REGEX, '');
			}
		}

		List<dwp_cvad__Action_Audit_Detail__c> lstDetails = new List<dwp_cvad__Action_Audit_Detail__c>();
		lstDetails.add(Action_Audit_Helper.getAuditDetail(auditRecordId, html, 1, '', 'Embedded'));
		insert lstDetails;

		mapReturn.put('isOk', true);
		return mapReturn;
	}

	/**Method to redirect to Case List View **/
	@AuraEnabled
	public static Map<String, Object> redirect() {
		Final Map<String, Object> mapRes = new Map<String, Object>();
		mapRes.put('isError', true);
		Final List<ListView> listViews = [SELECT Id, Name FROM ListView WHERE SobjectType = 'Case' AND DeveloperName = 'MyPendingRequest'];
		Final Integer listViewsSize = listViews.size();
		if(listViewsSize > 0) {
			mapRes.put('isError', false);
			mapRes.put('listView', listViews[0]);
		}
		return mapRes;
	}

	/**Method to getSanctionPriceInfo for History **/
	private static List<Map<String, Object>> getSanctionPriceInfo(Id oliId) {
		Final List<Map<String, Object>> lstMapRes = new List<Map<String, Object>>();
		Final OpportunityLineItem[] oli = [SELECT Product2Id, Product2.Name, UnitPrice, PE_List_Product_mode__c, gipr_Plazo__c, gipr_Periodicidad__c, gipr_Tipo_Garantia__c,
		                                   gipr_Garantia__c, gipr_Cobertura__c, Opportunity.CurrencyIsoCode FROM OpportunityLineItem WHERE Id =: oliId];
		Final Integer oliSize = oli.size();
		if(oliSize > 0) {
			Final Set<String> lstPicklist = new Set<String> {'PE_List_Product_mode__c', 'gipr_Tipo_Garantia__c', 'gipr_Garantia__c', 'gipr_Periodicidad__c'};
			Final Map<String, Object> mapPC = new Map<String, Object>();
			fprd__GBL_Product_Configuration__c[] lstProductConf = [SELECT id, fprd__DeveloperName__c, fprd__LoV_labels__c, fprd__LoV_values__c, fprd__Product__r.Name,
			                                                       fprd__Map_field__c FROM fprd__GBL_Product_Configuration__c WHERE fprd__Product__c =: oli[0].Product2Id
			                                                                                                                                           AND fprd__Map_field__c IN: lstPicklist];
			for(fprd__GBL_Product_Configuration__c pc:lstProductConf) {
				if(!String.isEmpty(pc.fprd__LoV_values__c)) {
					String[] strLabelTmp = pc.fprd__LoV_labels__c.split(',');
					String[] strValueTmp = pc.fprd__LoV_values__c.split(',');
					Integer position = strValueTmp.indexOf('' + oli[0].get(pc.fprd__Map_field__c));
					if(position >= 0) {
						mapPC.put(pc.fprd__Map_field__c, strLabelTmp[position]);
					}
				}
			}
			String stringAmount = (Decimal.valueOf(String.valueOf(oli[0].UnitPrice) == null || String.valueOf(oli[0].UnitPrice).trim() == '' ? '0' : String.valueOf(oli[0].UnitPrice)).setScale(2) + 0.001).format();
			stringAmount = stringAmount.substring(0, stringAmount.length() - 1);
			lstMapRes.add(new Map<String, Object> { 'label' => 'Importe', 'value' => oli[0].Opportunity.CurrencyIsoCode + ' ' + stringAmount, 'type' => 'STRING', 'position' => 1});
			lstMapRes.add(new Map<String, Object> { 'label' => 'Modalidad', 'value' => mapPC.get('PE_List_Product_mode__c'), 'type' => 'STRING', 'position' => 2});
			lstMapRes.add(new Map<String, Object> { 'label' => 'Plazo', 'value' => oli[0].gipr_Plazo__c, 'type' => 'INTEGER', 'position' => 3});
			lstMapRes.add(new Map<String, Object> { 'label' => 'Periodicidad', 'value' => mapPC.get('gipr_Periodicidad__c'), 'type' => 'STRING', 'position' => 4});
			lstMapRes.add(new Map<String, Object> { 'label' => 'Tipo de garantía', 'value' => mapPC.get('gipr_Tipo_Garantia__c'), 'type' => 'STRING', 'position' => 5});
			if(oli[0].gipr_Tipo_Garantia__c != '03' && oli[0].gipr_Tipo_Garantia__c != null) {
				lstMapRes.add(new Map<String, Object> { 'label' => 'Garantía', 'value' => mapPC.get('gipr_Garantia__c'), 'type' => 'STRING', 'position' => 6});
				lstMapRes.add(new Map<String, Object> { 'label' => 'Cobertura (%)', 'value' => (oli[0].gipr_Cobertura__c != null ? oli[0].gipr_Cobertura__c.setScale(2) : null), 'type' => 'PERCENT', 'position' => 7});
			}
		}
		return lstMapRes;
	}

	/**Method for save audit and case **/
	@AuraEnabled
	public static Map<String, Object> saveAuditCase(Parameters params, Map<String, Object> mapReturn, Boolean elevateCase, Id idAnalist, List<String> lstApiField, List<Object> lstValue) {
		List<dwp_cvad__Action_Audit__c> lstAudit = new List<dwp_cvad__Action_Audit__c>();
		lstAudit.add(Action_Audit_Helper.getAudit(params.nameAudit, 'Opportunity', params.recordId, DateTime.now(), label.AuditPriceApproval, UserInfo.getUserId(), params.styleAudit, null, false));
		lstAudit[0].dwp_cvad__audit_audit_comments__c = params.strComments;
		insert lstAudit;

		List<dwp_cvad__Action_Audit_Detail__c> lstDetails = new List<dwp_cvad__Action_Audit_Detail__c>();
		lstDetails.add(Action_Audit_Helper.getAuditDetail(lstAudit[0].Id, (String)mapReturn.get(NEWSTOREHTML), 1, '', 'Embedded'));
		insert lstDetails;
		mapReturn.put('auditDetailId', lstDetails[0].Id);

		List<Case> lstCases = [SELECT Id,
		                       opportunity_id__c,
		                       IsClosed,
		                       OwnerId,
		                       Status,
		                       bypass__c
		                       FROM Case
		                       WHERE opportunity_id__c = :params.recordId
		                                                 AND IsClosed = false];
		lstCases[0].Status = params.statusCase;
		lstCases[0].bypass__c = true;
		if(elevateCase && idAnalist == null) {
			List<Group> queueGroup = [SELECT Id,
			                          DeveloperName,
			                          Type
			                          FROM Group
			                          WHERE Type = 'Queue'
			                                       AND DeveloperName = 'Tier_2'];
			lstCases[0].OwnerId = queueGroup[0].Id;
		} else if(elevateCase && idAnalist != null) {
			lstCases[0].OwnerId = idAnalist;
		}
		update lstCases;
		Final Map<String, Object> mapReturnSaveOli = FieldForm_ctrl.doSave(params.recordOli, 'OpportunityLineItem', lstApiField, lstValue);

		mapReturn.put('isOk', (Boolean)mapReturnSaveOli.get('isOk'));
		return mapReturn;
	}

	/**Method for save the opportunitylineitem **/
	@AuraEnabled
	public static Map<String, Object> updateOli(Parameters params, String body, Opportunity opp, Map<String, Object> mapReturn) {
		String assignedAnalyst = '';
		Final ModifyQuotationRequest_helper.ResponseModifyQuotationRequest_Wrapper responseBody = ModifyQuotationRequest_helper.responseParse(body);
		ModifyQuotationRequest_helper.Response_data mqData = responseBody.data;
		ModifyQuotationRequest_helper.Response_status mqStatus = mqData.status;

		Final OpportunityLineItem oliRecord = new OpportunityLineItem(Id = params.recordOli,
		                                                              price_quote_status_id__c = mqStatus.id,
		                                                              Assigned_analyst__c = assignedAnalyst,
		                                                              price_quote_date__c = null,
		                                                              validityDate__c = null);

		List<ModifyQuotationRequest_helper.Response_businessAgents> mqBusinessAgentsList = mqData.businessAgents;
		if(!mqBusinessAgentsList.isEmpty()) {
			Final List<User> userList = [SELECT Id, FirstName, LastName FROM User WHERE user_id__c = : mqBusinessAgentsList[0].id AND IsActive = true];
			if(!userList.isEmpty()) {
				oliRecord.price_quote_owner_id__c = userList[0].Id;
				mapReturn.put(IDANALIST, userList[0].Id);
				assignedAnalyst = userList[0].FirstName + ' ' + userList[0].LastName;
			} else {
				oliRecord.price_quote_owner_id__c = null;
				assignedAnalyst = mqBusinessAgentsList[0].firstName + ' ' + mqBusinessAgentsList[0].lastName + ' ' + mqBusinessAgentsList[0].secondLastName;
			}
		}

		if(opp.opportunity_status_type__c == SSENT) {
			oliRecord.price_quote_owner_id__c = (String)mapReturn.get(IDANALIST);
			oliRecord.Assigned_analyst__c = assignedAnalyst;
			oliRecord.validityDate__c = Date.valueOf(params.validDate);
		} else if(opp.opportunity_status_type__c == SAUTHORIZED) {
			oliRecord.price_quote_date__c = System.today();
			oliRecord.validityDate__c = Date.valueOf(params.validDate);
			assignedAnalyst = System.UserInfo.getFirstName() + ' ' + System.UserInfo.getLastName();
			oliRecord.Assigned_analyst__c = assignedAnalyst;
			mapReturn.put(NEWSTOREHTML, ((String)mapReturn.get(NEWSTOREHTML)).replace('#validityDate#', params.validDate.substring(8, 10) + '/' + params.validDate.substring(5, 7) + '/' + params.validDate.substring(0, 4)));
        } else if(opp.opportunity_status_type__c == SDENIED) {
			oliRecord.price_quote_date__c = System.today();
			assignedAnalyst = System.UserInfo.getFirstName() + ' ' + System.UserInfo.getLastName();
			oliRecord.Assigned_analyst__c = assignedAnalyst;
			mapReturn.put(NEWSTOREHTML, ((String)mapReturn.get(NEWSTOREHTML)).replace('#validityDate#', ''));
		}
		update oliRecord;
        if(opp.opportunity_status_type__c == SAUTHORIZED) {
            BE_CreateQuotation_cls.generatePDF(opp.Id, String.valueOf(oliRecord.validityDate__c));
        }
		mapReturn.put(NEWSTOREHTML, ((String)mapReturn.get(NEWSTOREHTML)).replace('#Assigned_analyst#', assignedAnalyst));

		return mapReturn;
	}
    
	/**Method for map parameters **/
	public class Parameters {
		/**
		 * record id param
		 */
		private String recordId;
		/**
		 * status of opportunity param
		 */
		private String statusOpp;
		/**
		 * stage opportunity param
		 */
		private String stageName;
		/**
		 * style audit param
		 */
		private String styleAudit;
		/**
		 * name audit param
		 */
		private String nameAudit;
		/**
		 * comments param
		 */
		private String strComments;
		/**
		 * OpportunityLineItem id param
		 */
		private String recordOli;
		/**
		 * status of case param
		 */
		private String statusCase;
		/**
		 * html audit param
		 */
		private String storeHtml;
		/**
		 * aprroval method param
		 */
		private String approvalMethod;
		/**
		 * phase param
		 */
		private String wsPhase;
		/**
		 * validity date of quotation param
		 */
		private String validDate;
	}
}