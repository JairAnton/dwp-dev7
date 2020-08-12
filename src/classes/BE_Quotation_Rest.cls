/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_Quotation_Rest>
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-08-10
   @Description Class rest from quotation
   @Changes
   Date        Author   Email                  				Type		Description
   2020-08-10  MAMC     martin.mori.contractor@bbva.com    	Creation
   -------------------------------------------------------------------------------------------------
 */
public with sharing class BE_Quotation_Rest {
    /* static variable */
    private static final String QUOSTATUSMSG = 'quotationStatusMessage';
    /* static variable */
    private static final String QUOSTATUSICON = 'quotationStatusIcon';
    /* ok code of call webservice */
    final static Integer OKCODE = 200;
    /* ko code of call webservice */
    final static Integer KOCODE = 409;
    /* string error */
    final static String STRINGERROR = 'errorMessage';
    /* string success */
    final static String STRINGSUCCESS = 'success';
    /* string false */
    final static String STRINGFALSE = 'false';
    /* string caseOwner */
    final static String CASEOWN = 'caseOwner';
    /* string false */
    final static String RECID = 'recordid';
    
    /**
     * constructor of class
     */
    private BE_Quotation_Rest() {
    }
    
    /**
     * Method that invoke the ws to create a quotation and, if successful response, 
     * updates the opportunity and opportunity line item with the response
     */
    public static Map<String,Object> invokeCreateQuo(String recordId) {
        Map<String,Object> mapReturn = new Map<String,Object>();
		// Invoke WS
		try {
			final CreateQuotationRequest_helper createReqHelper = new CreateQuotationRequest_helper(recordId);
			final HttpResponse createReqResp = createReqHelper.invoke();
			//Check the ws response status
			final Integer wsRespCode = createReqResp.getStatusCode();
			if(wsRespCode == OKCODE) {
				// Set the status to return
				mapReturn.put(STRINGSUCCESS, 'true');
				// Update the opportunity status
				List<Opportunity> oppList = [SELECT StageName, opportunity_status_type__c, isProcess__c, AccountId FROM Opportunity WHERE Id =: recordId];
                if(oppList.isEmpty() == false) {
                    mapReturn = updateOppCreate(oppList[0], createReqResp, mapReturn, recordId);
                }
			} else if(wsRespCode == KOCODE) {
				// Set the status to return
				mapReturn.put(STRINGSUCCESS, STRINGFALSE);
				// Get the ws error message
				final WebServiceUtils.ResponseErrorMessage_Wrapper errorDetails = WebServiceUtils.parse(createReqResp.getBody());
				// Set the error message
				final String errorMessage = Label.PriceCreateQuotationRequestKnowError + ' ' + errorDetails.errormessage;
				mapReturn.put(STRINGERROR, errorMessage);
			} else {
				// Set the status to return
				mapReturn.put(STRINGSUCCESS, STRINGFALSE);
				// Set the error message
				final String errorMessage = Label.PriceCreateQuotationRequestUnknowError;
				mapReturn.put(STRINGERROR, errorMessage);
			}
		} catch(Exception e) {
			// Set the status to return
			mapReturn.put(STRINGSUCCESS, STRINGFALSE);
			// Set the error message
			final String errorMessage = Label.PriceCreateQuotationRequestUnknowError;
			mapReturn.put(STRINGERROR, errorMessage);
		}
		return mapReturn;
	}
    
    /**
     * Method that invoke the ws to recover a quotationupdates the opportunity and opportunity line item with the response
     */
    public static Map<String,Object> invokeRecoverQuo(String recordId) {
		Final Map<String,Object> mapReturn = new Map<String,Object>();
		// Invoke WS
		try {
			final ModifyQuotationRequest_helper mqHelper = new ModifyQuotationRequest_helper(recordId, 'RECOVER', null, '', null);
			final HttpResponse mqResponse = mqHelper.invoke();
			//Check the ws response status
			final Integer wsRespCode = mqResponse.getStatusCode();
			if(wsRespCode == OKCODE) {
				// Set the status to return
				mapReturn.put(STRINGSUCCESS, 'true');
				List<OpportunityLineItem> oppProductsList = [SELECT Id, price_quote_status_id__c, price_quote_owner_id__c 
															FROM OpportunityLineItem WHERE OpportunityId = :recordId];
                if(oppProductsList.isEmpty() == false) {
                    // Get the response body
					final ModifyQuotationRequest_helper.ResponseModifyQuotationRequest_Wrapper responseBody = ModifyQuotationRequest_helper.responseParse(mqResponse.getBody());
					// Update the quoation status and owner
					final ModifyQuotationRequest_helper.Response_data mqData = responseBody.data;
					final ModifyQuotationRequest_helper.Response_status mqStatus = mqData.status;
					oppProductsList[0].price_quote_status_id__c = mqStatus.id;
					final List<ModifyQuotationRequest_helper.Response_businessAgents> mqBusAgeLts = mqData.businessAgents;
					if(mqBusAgeLts.isEmpty() == false) {
						final List<User> userList = [SELECT Id FROM User WHERE user_id__c = : mqBusAgeLts[0].id AND IsActive = true];
						if(userList.isEmpty() == false) {
							oppProductsList[0].price_quote_owner_id__c = userList[0].Id;
                        }
					}
					update oppProductsList;
				}
			} else if(wsRespCode == KOCODE) {
				// Set the status to return
				mapReturn.put(STRINGSUCCESS, STRINGFALSE);
				// Get the ws error message
				final WebServiceUtils.ResponseErrorMessage_Wrapper errorDetails = WebServiceUtils.parse(mqResponse.getBody());
				// Set the error message
				final String errorMessage = Label.PriceRecoverRequestKnownError + ' ' + errorDetails.errormessage;
				mapReturn.put(STRINGERROR, errorMessage);
			} else {
				// Set the status to return
				mapReturn.put(STRINGSUCCESS, STRINGFALSE);
				// Set the error message
				final String errorMessage = Label.PriceRecoverRequestUnknownError;
				mapReturn.put(STRINGERROR, errorMessage);
			}
		} catch(Exception e) {
			// Set the status to return
			mapReturn.put(STRINGSUCCESS, STRINGFALSE);
			// Set the error message
			final String errorMessage = Label.PriceRecoverRequestUnknownError;
			mapReturn.put(STRINGERROR, errorMessage);
		}
		return mapReturn;
	}
    
    /**
     * Method that invoke the ws to request approval of a quotation and, if successful response, 
     * updates the opportunity and opportunity line item with the response
     */
    public static Map<String,Object> invokeApprovalQuo(String recordId) {
		Map<String,Object> mapReturn = new Map<String,Object>();
		try {
            // Invoke WS
			final ModifyQuotationRequest_helper mqHelper = new ModifyQuotationRequest_helper(recordId, 'REQUEST_APPROVAL', null, '', null);
			final HttpResponse mqResponse = mqHelper.invoke();
			//Check the ws response status
			final Integer wsRespCode = mqResponse.getStatusCode();
			if(wsRespCode == OKCODE) {
                // Set the status to return
				mapReturn.put(STRINGSUCCESS, 'true');
				// Update the opportunity status
				List<Opportunity> oppList = [SELECT StageName, opportunity_status_type__c, isProcess__c, AccountId FROM Opportunity WHERE Id =: recordId];
				if(oppList.isEmpty() == false) {
                    mapReturn = updateOppModify(oppList[0], mqResponse, mapReturn, recordId);
				}
			} else if(wsRespCode == KOCODE) {
				// Set the status to return
				mapReturn.put(STRINGSUCCESS, STRINGFALSE);
				// Get the ws error message
				final WebServiceUtils.ResponseErrorMessage_Wrapper errorDetails = WebServiceUtils.parse(mqResponse.getBody());
				// Set the error message
				final String errorMessage = Label.PriceRequestQuotationApprovalKnownError + ' ' + errorDetails.errormessage;
				mapReturn.put(STRINGERROR,errorMessage);
			} else {
				// Set the status to return
				mapReturn.put(STRINGSUCCESS, STRINGFALSE);
				// Set the error message
				final String errorMessage = Label.PriceRequestQuotationApprovalUnknownError;
				mapReturn.put(STRINGERROR,errorMessage);
			}
		} catch(Exception e) {
			// Set the status to return
			mapReturn.put(STRINGSUCCESS, STRINGFALSE);
			// Set the error message
			final String errorMessage = Label.PriceRequestQuotationApprovalUnknownError;
			mapReturn.put(STRINGERROR,errorMessage);
		}
		return mapReturn;
	}

    /**
     * Method used to update opportunity when create quotation
     */
    public static Map<String,Object> updateOppCreate(Opportunity opp, HttpResponse createReqResp, Map<String,Object> mapReturnAux, String recordId) {
        Map<String,Object> mapReturn = mapReturnAux;
        Opportunity oppToUpdate = opp;
        oppToUpdate.StageName = '04';
        oppToUpdate.isProcess__c = true;
        // Get the response body
        final CreateQuotationRequest_helper.ResponseCreateQuotationRequest_Wrapper responseBody = CreateQuotationRequest_helper.parse(createReqResp.getBody());
        // Retrieve the quotation status from the ws response
        final CreateQuotationRequest_helper.Response_Data data = responseBody.data;
        if(data.quotations.isEmpty() == false) {
            final CreateQuotationRequest_helper.Response_Status quotationStatus = data.quotations[0].status;
            if(quotationStatus.id == Label.WebPriceQuotationRequestStatus01) {
                // Update status to Price approved
                oppToUpdate.opportunity_status_type__c = '08';
                mapReturn.put(QUOSTATUSMSG, Label.PriceCreateQuotationRequestApprovedMessage);
                mapReturn.put(QUOSTATUSICON, 'utility:check');
            } else {
                // Update status to Sent for price approval
                oppToUpdate.opportunity_status_type__c = '09';
                mapReturn.put(QUOSTATUSMSG, Label.PriceCreateQuotationRequestSentForApprovalMessage);
                mapReturn.put(QUOSTATUSICON, 'utility:share');
            }
            update oppToUpdate;
            mapReturn = updateOliCreate(recordId, data.quotations, mapReturn, quotationStatus.id, oppToUpdate, data);
        }
        return mapReturn;
    }
    
    /**
     * Method used to update opportunitylineitem when create quotation
     */
    public static Map<String,Object> updateOliCreate(String recordId, List<CreateQuotationRequest_helper.Response_Quotations> quotationsList, Map<String,Object> mapReturnAux, String quotationStatus, Opportunity oppToUpdate, CreateQuotationRequest_helper.Response_Data data) {
        Map<String,Object> mapReturn = mapReturnAux;
        List<OpportunityLineItem> oppProductList = [SELECT price_quote_id__c, price_operation_id__c, price_quote_status_id__c, price_quote_owner_id__c, price_quote_date__c FROM OpportunityLineItem WHERE OpportunityId = : recordId];
        if(oppProductList.isEmpty() == false) {
            String oppStatusLabel;
            String oppStatusIcon;
            if(quotationStatus == Label.WebPriceQuotationRequestStatus01) {
                oppStatusLabel = Label.OppStatusLabel08;
                oppStatusIcon = Label.AuditStyleApproveTop;
            } else {
                oppStatusLabel = Label.OppStatusLabel09;
                oppStatusIcon = Label.AuditStyleElevate;
            }
            OpportunityLineItem oppProdUpdate = oppProductList[0];
            oppProdUpdate.price_quote_id__c = data.id;
            oppProdUpdate.price_operation_id__c = quotationsList[0].id;
            oppProdUpdate.price_quote_status_id__c = quotationStatus;
            if(quotationStatus == Label.WebPriceQuotationRequestStatus01) {
                oppProdUpdate.price_quote_date__c = System.today();  
            }
            String caseOwner;
            final List<Group> queueGroup = [SELECT Id, 
                                            DeveloperName,
                                            Type 
                                            FROM Group 
                                            WHERE Type = 'Queue' 
                                            AND DeveloperName = 'Tier_1'];
            if(queueGroup.isEmpty() == false) {
                caseOwner = queueGroup[0].id;
            }
            final List<CreateQuotationRequest_helper.Response_BusinessAgents> quotationAgents = quotationsList[0].businessAgents;
            // Check if the quotation owner exists as a user in DWP
            if(quotationAgents.isEmpty() == false) {
                final List<User> quotationUserList = [SELECT Id, FirstName, LastName FROM User WHERE user_id__c =: quotationAgents[0].id AND IsActive = true];
                if(quotationUserList.isEmpty()) {
                    if(quotationStatus != Label.WebPriceQuotationRequestStatus01) {
                        oppProdUpdate.Assigned_analyst__c=quotationAgents[0].firstName+' '+quotationAgents[0].lastName+' '+quotationAgents[0].secondLastName;
                    }
                } else {
                    oppProdUpdate.price_quote_owner_id__c = quotationUserList[0].id;
                    caseOwner =  quotationUserList[0].id;                                  
                    if(quotationStatus != Label.WebPriceQuotationRequestStatus01) {
                        oppProdUpdate.Assigned_analyst__c=quotationUserList[0].FirstName+' '+quotationUserList[0].LastName;
                    }
                }		
            }
            update oppProdUpdate;
            Final Map<String, String> params = new Map<String, String>();
            params.put(RECID, recordId);
            params.put('quotationStatus', quotationStatus);
            params.put(CASEOWN, caseOwner);
            params.put('oppStatusLabel', oppStatusLabel);
            params.put('oppStatusIcon', oppStatusIcon);
            mapReturn = createCaseAudit(params, mapReturn, oppToUpdate);
        }
        return mapReturn;
    }
    
    /**
     * Method used to update opportunity when modify quotation
     */
    public static Map<String,Object> updateOppModify(Opportunity opp, HttpResponse mqResponse, Map<String,Object> mapReturnAux, String recordId) {
        Map<String,Object> mapReturn = mapReturnAux;
        Opportunity oppToUpdate = opp;
        oppToUpdate.StageName = '04';
        oppToUpdate.isProcess__c = true;
        // Get the response body
        final ModifyQuotationRequest_helper.ResponseModifyQuotationRequest_Wrapper responseBody = ModifyQuotationRequest_helper.responseParse(mqResponse.getBody());
        // Retrieve the quotation status from the ws response
        final ModifyQuotationRequest_helper.Response_data mqData = responseBody.data;
        final ModifyQuotationRequest_helper.Response_status mqStatus = mqData.status;
        if(mqStatus.id == Label.WebPriceQuotationRequestStatus01) {
            // Update status to Price approved
            oppToUpdate.opportunity_status_type__c = '08';
            mapReturn.put(QUOSTATUSMSG, Label.PriceCreateQuotationRequestApprovedMessage);
            mapReturn.put(QUOSTATUSICON, 'utility:check');
        } else {
            // Update status to Sent for price approval
            oppToUpdate.opportunity_status_type__c = '09';
            mapReturn.put(QUOSTATUSMSG, Label.PriceCreateQuotationRequestSentForApprovalMessage);
            mapReturn.put(QUOSTATUSICON, 'utility:share');
        }
        update oppToUpdate;
        mapReturn = updateOliModify(recordId, mapReturn, mqStatus.id, oppToUpdate, mqData);
        return mapReturn;
    }
    
    /**
     * Method used to update opportunitylineitem when modify quotation
     */
    public static Map<String,Object> updateOliModify(String recordId, Map<String,Object> mapReturnAux, String priceQuoStatus, Opportunity oppToUpdate, ModifyQuotationRequest_helper.Response_data mqData) {
        Map<String,Object> mapReturn = mapReturnAux;
        final List<OpportunityLineItem> oppProductList = [SELECT price_quote_status_id__c, price_quote_owner_id__c, price_quote_date__c FROM OpportunityLineItem WHERE OpportunityId = : recordId];
        if(oppProductList.isEmpty() == false) {
            String oppStatusLabel;
            String oppStatusIcon;
            if(priceQuoStatus == Label.WebPriceQuotationRequestStatus01) {
                oppStatusLabel = Label.OppStatusLabel08;
                oppStatusIcon = Label.AuditStyleApproveTop;
            } else {
                oppStatusLabel = Label.OppStatusLabel09;
                oppStatusIcon = Label.AuditStyleElevate;
            }
            final OpportunityLineItem oppProdUpdate = oppProductList[0];
            oppProdUpdate.price_quote_status_id__c = priceQuoStatus;
            if(priceQuoStatus == Label.WebPriceQuotationRequestStatus01) {
                oppProdUpdate.price_quote_date__c = System.today();
            }    
            String caseOwner;
            final List<Group> queueGroup = [SELECT Id, DeveloperName, Type 
                                            FROM Group 
                                            WHERE Type = 'Queue' 
                                            AND DeveloperName = 'Tier_1'];
            if(queueGroup.isEmpty() == false) {
                caseOwner = queueGroup[0].id;
            }
            final List<ModifyQuotationRequest_helper.Response_businessAgents> mqBusAgeLts = mqData.businessAgents;
            // Check if the quotation owner exists as a user in DWP	
            if(mqBusAgeLts.isEmpty() == false) {
                final List<User> userList = [SELECT Id FROM User WHERE user_id__c = : mqBusAgeLts[0].id AND IsActive = true];
                if(userList.isEmpty() == false) {
                    oppProdUpdate.price_quote_owner_id__c = userList[0].Id;
                    caseOwner =  userList[0].id;
                }
            }
            update oppProdUpdate;
            Final Map<String, String> params = new Map<String, String>();
            params.put(RECID, recordId);
            params.put('quotationStatus', priceQuoStatus);
            params.put(CASEOWN, caseOwner);
            params.put('oppStatusLabel', oppStatusLabel);
            params.put('oppStatusIcon', oppStatusIcon);
            mapReturn = createCaseAudit(params, mapReturn, oppToUpdate);
        }
        return mapReturn;
    }
    
    /**
     * Method used to create case and audit
     */
    public static Map<String,Object> createCaseAudit(Map<String,String> params, Map<String,Object> mapReturnAux, Opportunity oppToUpdate) {
        Map<String,Object> mapReturn = mapReturnAux;
        if(params.get('priceQuoStatus') == Label.WebPriceQuotationRequestStatus02) {
            final Case caseToInsert = new Case();
            caseToInsert.Status = '01';
            caseToInsert.Type = '01';
            caseToInsert.AccountId = oppToUpdate.AccountId;
            caseToInsert.opportunity_id__c = params.get(RECID);
            if(String.isNotBlank(params.get(CASEOWN))) {
                caseToInsert.OwnerId = params.get(CASEOWN);
            }
            insert caseToInsert;
        }
        
        // Create audit record
        final dwp_cvad__Action_Audit__c auditToInsert = Action_Audit_Helper.getAudit(params.get('oppStatusLabel'), 'Opportunity', params.get(RECID), System.now(), Label.AuditPriceApproval, UserInfo.getUserId(), params.get('oppStatusIcon'), '', false);
        insert auditToInsert;
        mapReturn.put('auditId',auditToInsert.Id);
        
        return mapReturn;
    }
}
