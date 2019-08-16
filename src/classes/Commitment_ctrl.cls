/**
* @author Global_HUB developers
* @date 01-08-2018
*
* @group Global_HUB
*
* @description Controller class from Commitment_cmp
**/
public with sharing class Commitment_ctrl {
 	@AuraEnabled
    public static Map<String,Object> getInfo(String quoteType){
        Map<String,Object> mapReturn = new Map<String,Object>();
        List<Commitment_Value__c> lstCommitmentValues = [SELECT     Id,
                                                                    commitment_product_name__c,
                                                                    web_product_code__c,
                                                                    commitment_expiry_days_number__c,
                                                                    commitment_stay_days_number__c,
                                                                    CurrencyIsoCode,
                                                                    quote_type__c,
                                                                    commitment_id__c
                                                            FROM Commitment_Value__c
                                                            WHERE quote_type__c = :quoteType
                                                            ORDER BY commitment_product_name__c];
        mapReturn.put('lstCommitments', lstCommitmentValues);
        Set<String> setApiName = new Set<String>();
        setApiName.add('opp_solution_commitment_amount__c');
        setApiName.add('opp_soln_comt_expiry_days_number__c');
        setApiName.add('opp_soln_comt_stay_days_number__c');
        setApiName.add('opp_solution_comt_product_name__c');
        setApiName.add('CurrencyIsoCode');
        mapReturn.put('schemaSetup', FieldForm_ctrl.getInfoSchema(setApiName, 'Opportunity_Solution_Commitment__c'));
        return mapReturn; 
    }
    @AuraEnabled
    public static Map<String,Object> getInfoTable(String recordId){
        Map<String,Object> mapReturn = new Map<String,Object>();
        List<Opportunity_Solution_Commitment__c> lstCommitments = [SELECT   Id,
                                                                            opp_solution_commitment_amount__c,
                                                                            opp_soln_comt_expiry_days_number__c,
                                                                            opp_soln_comt_stay_days_number__c,
                                                                            opp_solution_comt_product_name__c,
                                                                            CurrencyIsoCode
                                                                    FROM Opportunity_Solution_Commitment__c
                                                                    WHERE opportunity_id__c = :recordId];
        mapReturn.put('lstCommitments', lstCommitments); 
        Set<String> setApiName = new Set<String>();
        setApiName.add('opp_solution_commitment_amount__c');
        setApiName.add('opp_soln_comt_expiry_days_number__c');
        setApiName.add('opp_soln_comt_stay_days_number__c');
        setApiName.add('opp_solution_comt_product_name__c');
        setApiName.add('CurrencyIsoCode');
        mapReturn.put('schemaSetup', FieldForm_ctrl.getInfoSchema(setApiName, 'Opportunity_Solution_Commitment__c'));
        return mapReturn; 
    }
    
    @AuraEnabled
    public static Map<String,Object> saveCommitment(String recordId, List<Object> lstData, String oppLineItem){
        Map<String,Object> mapReturn = new Map<String,Object>();
        Opportunity_Solution_Commitment__c oppSolCommitment = new Opportunity_Solution_Commitment__c();
        oppSolCommitment.opp_solution_comt_product_name__c = String.valueOf(lstData[0]);
        oppSolCommitment.CurrencyIsoCode = String.valueOf(lstData[1]);
        oppSolCommitment.opp_soln_comt_expiry_days_number__c = Double.valueOf(lstData[2]);
        oppSolCommitment.opp_solution_commitment_amount__c = Double.valueOf(lstData[3]);
        oppSolCommitment.opp_soln_comt_stay_days_number__c = Double.valueOf(lstData[4]);
        oppSolCommitment.opp_solution_commitment_id__c = String.valueOf(lstData[5]);
		oppSolCommitment.price_quotation_method__c = String.valueOf(lstData[6]);
        oppSolCommitment.opportunity_id__c = recordId;
        oppSolCommitment.opp_solution_id__c = oppLineItem;
        insert oppSolCommitment;
        mapReturn.put('isOK', true);
        return mapReturn; 
    }

    @AuraEnabled
    public static Map<String,Object> deleteCommitment(String recordId){
        Map<String,Object> mapReturn = new Map<String,Object>();
        Opportunity_Solution_Commitment__c oppSolCommitment = new Opportunity_Solution_Commitment__c();
        oppSolCommitment.Id = recordId;
        delete oppSolCommitment;
        mapReturn.put('isOK', true);
        return mapReturn; 
    }

    @AuraEnabled
    public static Map<String,Object> requestQuote(String recordId){
        Map<String,Object> mapReturn = new Map<String,Object>();
		mapReturn.put('nextCallout',false);
		// Retrieve the opportunity product conditions, price calculation rates information and price quotation request information
		List<OpportunityLineItem> oliList = [SELECT price_quote_id__c, price_quote_owner_id__c, proposed_apr_per__c, price_rates_calculation_Id__c, gipr_Garantia__c
											FROM OpportunityLineItem WHERE OpportunityId = :recordId];
		if(!oliList.isEmpty()){
			// Check if there is already a price quotation request for the oportunity
			if(oliList[0].price_quote_id__c != '' && oliList[0].price_quote_id__c != null){
				// Check if the context user is the same user that owns the price quotation request
				if(oliList[0].price_quote_owner_id__c == UserInfo.getUserId()){
					// Invoke web service to request quotation approval
					mapReturn = invokeRequestQuotationApproval(recordId);
					createQuotationCommitments(recordId);
				}
				else{
					// Invoke web service to recover quotation 
					mapReturn = invokeRecoverQuotation(recordId); 
					mapReturn.put('nextCallout',true);
				}
			}
			else{
                // Invoke web service to create quotation
				mapReturn = invokeCreateQuotationRequest(recordId);
				createQuotationCommitments(recordId);
			}
		}
        return mapReturn; 
    }

    public static void createQuotationCommitments(String recordId){
		List<Opportunity_Solution_Commitment__c> lstCommitments = [SELECT 	Id,
																			opp_solution_id__c
																	FROM Opportunity_Solution_Commitment__c
																	WHERE opportunity_id__c = :recordId];
		if(!lstCommitments.isEmpty()){
			for(Opportunity_Solution_Commitment__c osc : lstCommitments){
				requestQuotationCommitments(osc.Id, osc.opp_solution_id__c);
			}
		}

	}

	@future(callout=true)
	public static void requestQuotationCommitments(String commitmentRecordId, String strOliId){
		Opportunity_Solution_Commitment__c commitmentRecord = new Opportunity_Solution_Commitment__c();
		List<OpportunityLineItem> lstOli = [SELECT 	Id,
											price_quote_id__c		
											FROM OpportunityLineItem 
											WHERE Id = :strOliId];
		commitmentRecord.Id = commitmentRecordId;
		commitmentRecord.price_quotation_id__c = (! lstOli.isEmpty()? lstOli[0].price_quote_id__c : ''); 
		try{
			CreateQuotationCommitment_helper createQCom = new CreateQuotationCommitment_helper(commitmentRecord.Id);
			HttpResponse createRequestResponse = createQCom.invoke();
			if(createRequestResponse.getStatusCode() == 200){
				commitmentRecord.added_to_price_quotation__c = true;
			}else{
				commitmentRecord.added_to_price_quotation__c = false;
			}

		}catch(Exception e){
			commitmentRecord.added_to_price_quotation__c = false;
		}
		update commitmentRecord;
	}
    
    // Method that invoke the ws to create a quotation and, if successful response, updates the opportunity and opportunity line item with the response
    public static Map<String,Object> invokeCreateQuotationRequest(String recordId){
	
		Map<String,Object> mapReturn = new Map<String,Object>();
		
		// Invoke WS
		try{
			CreateQuotationRequest_helper createRequestHelper = new CreateQuotationRequest_helper(recordId);
			HttpResponse createRequestResponse = createRequestHelper.invoke();
			
			//Check the ws response status
			Integer wsResponseStatusCode = createRequestResponse.getStatusCode();
			if(wsResponseStatusCode == 200){
			
				// Set the status to return
				mapReturn.put('success','true');
			
				// Get the response body
				CreateQuotationRequest_helper.ResponseCreateQuotationRequest_Wrapper responseBody = CreateQuotationRequest_helper.parse(createRequestResponse.getBody());
				
				// Update the opportunity status
				List<Opportunity> oppList = [SELECT StageName, opportunity_status_type__c, isProcess__c, AccountId FROM Opportunity WHERE Id =: recordId];
				
				if(!oppList.isEmpty()){
                    
                    String oppStatusLabel;
                    String oppStatusIcon;
                    
					Opportunity oppToUpdate = oppList[0];
					oppToUpdate.StageName = '04';
					oppToUpdate.isProcess__c = true;
					
					// Retrieve the quotation status from the ws response
					CreateQuotationRequest_helper.Response_Data data = responseBody.data;
					List<CreateQuotationRequest_helper.Response_Quotations> quotationsList = data.quotations;
					
					if(!quotationsList.isEmpty()){
					
						CreateQuotationRequest_helper.Response_Status quotationStatus = quotationsList[0].status;
						List<CreateQuotationRequest_helper.Response_BusinessAgents> quotationAgents = quotationsList[0].businessAgents;
						
						if(quotationStatus.id == Label.WebPriceQuotationRequestStatus01){
							// Update status to Price approved
							oppToUpdate.opportunity_status_type__c = '08';
                            oppStatusLabel = Label.OppStatusLabel08;
                            oppStatusIcon = Label.AuditStyleApproveTop;
							mapReturn.put('quotationStatusMessage',Label.PriceCreateQuotationRequestApprovedMessage);
                            mapReturn.put('quotationStatusIcon','utility:check');
						}
						else{
							// Update status to Sent for price approval
							oppToUpdate.opportunity_status_type__c = '09';
                            oppStatusLabel = Label.OppStatusLabel09;
                            oppStatusIcon = Label.AuditStyleElevate;
							mapReturn.put('quotationStatusMessage',Label.PriceCreateQuotationRequestSentForApprovalMessage);
                            mapReturn.put('quotationStatusIcon','utility:share');
						}
						
						update oppToUpdate;
						
						// Save the quotation details on the opportunity product
						List<OpportunityLineItem> oppProductList = [SELECT price_quote_id__c, price_operation_id__c, price_quote_status_id__c, price_quote_owner_id__c, price_quote_date__c FROM OpportunityLineItem WHERE OpportunityId = : recordId];

						if(!oppProductList.isEmpty()){
							
							OpportunityLineItem oppProductToUpdate = oppProductList[0];
							
							oppProductToUpdate.price_quote_id__c = data.id;
							oppProductToUpdate.price_operation_id__c = quotationsList[0].id;
							oppProductToUpdate.price_quote_status_id__c = quotationStatus.id;
                            if(quotationStatus.id == Label.WebPriceQuotationRequestStatus01){
                            	oppProductToUpdate.price_quote_date__c = System.today();  
                            }
                            
                            String caseOwner;
							
                            List<Group> queueGroup = [SELECT Id, 
                                                      DeveloperName,
                                                      Type 
                                                      FROM Group 
                                                      WHERE Type = 'Queue' 
                                                      AND DeveloperName = 'Tier_1'];
                            
                            if(!queueGroup.isEmpty()){
                            	caseOwner = queueGroup[0].id; 
                            }
                            
							// Check if the quotation owner exists as a user in DWP
							if(!quotationAgents.isEmpty()){
							
								List<User> quotationUserList = [SELECT Id, FirstName, LastName FROM User WHERE user_id__c =: quotationAgents[0].id AND IsActive = true];
   
								if(!quotationUserList.isEmpty()){
									oppProductToUpdate.price_quote_owner_id__c = quotationUserList[0].id;
                                    caseOwner =  quotationUserList[0].id;                                  
									if(quotationStatus.id != Label.WebPriceQuotationRequestStatus01){
                                        oppProductToUpdate.Assigned_analyst__c=quotationUserList[0].FirstName+' '+quotationUserList[0].LastName;
                                    }
								}
                                else{
                                    oppProductToUpdate.price_quote_owner_id__c = null;  
									if(quotationStatus.id != Label.WebPriceQuotationRequestStatus01){
                                        oppProductToUpdate.Assigned_analyst__c=quotationAgents[0].firstName+' '+quotationAgents[0].lastName+' '+quotationAgents[0].secondLastName;
                                    }
                                }		
							}
                            else{
                                oppProductToUpdate.price_quote_owner_id__c = null; 
                            }
							// Check if the status of quotation is REQUESTED to create a case assigned to the specific quotation owner
                            if(quotationStatus.id == Label.WebPriceQuotationRequestStatus02){
                                        
								Case caseToInsert = new Case();
                                caseToInsert.Status = '01';
                                caseToInsert.Type = '01';
                                caseToInsert.AccountId = oppToUpdate.AccountId;
                                caseToInsert.opportunity_id__c = recordId;
                                if(caseOwner != null && caseOwner != ''){
                                	caseToInsert.OwnerId = caseOwner;
                                }
                                insert caseToInsert;
      						}
                            
                            update oppProductToUpdate;
                            
							// Create audit record
							dwp_cvad__Action_Audit__c auditToInsert = Action_Audit_Helper.getAudit(oppStatusLabel, 'Opportunity', recordId, System.now(), Label.AuditPriceApproval, UserInfo.getUserId(), oppStatusIcon, '', false);
        
                            insert auditToInsert;
                            mapReturn.put('auditId',auditToInsert.Id);
						}
					}
					
				}
				
				
			}
			else if(wsResponseStatusCode == 409){
				
				// Set the status to return
				mapReturn.put('success','false');
			
				// Get the ws error message
				WebServiceUtils.ResponseErrorMessage_Wrapper errorDetails = WebServiceUtils.parse(createRequestResponse.getBody());
				
				// Set the error message
				String errorMessage = Label.PriceCreateQuotationRequestKnowError + ' ' + errorDetails.errormessage;
				mapReturn.put('errorMessage',errorMessage);
			}
			else{
				// Set the status to return
				mapReturn.put('success','false');
				
				// Set the error message
				String errorMessage = Label.PriceCreateQuotationRequestUnknowError;
				mapReturn.put('errorMessage',errorMessage);
			}
			
			
		}
		catch(Exception e){
			// Set the status to return
			mapReturn.put('success','false');
			
			// Set the error message
			String errorMessage = Label.PriceCreateQuotationRequestUnknowError;
			mapReturn.put('errorMessage',errorMessage);
		}
		
		return mapReturn;
	}
    
    // Method that invoke the ws to recover a quotationupdates the opportunity and opportunity line item with the response
    public static Map<String,Object> invokeRecoverQuotation(String recordId){
	
		Map<String,Object> mapReturn = new Map<String,Object>();
		
		// Invoke WS
		try{
			ModifyQuotationRequest_helper mqHelper = new ModifyQuotationRequest_helper(recordId, 'RECOVER', null, '', null);
			HttpResponse mqResponse = mqHelper.invoke();
			
			//Check the ws response status
			Integer wsResponseStatusCode = mqResponse.getStatusCode();
			
			if(wsResponseStatusCode == 200){
			
				// Set the status to return
				mapReturn.put('success','true');
			
				List<OpportunityLineItem> oppProductsList = [SELECT Id, price_quote_status_id__c, price_quote_owner_id__c 
															FROM OpportunityLineItem WHERE OpportunityId = :recordId];
						
                if(!oppProductsList.isEmpty()){
                    
                    // Get the response body
					ModifyQuotationRequest_helper.ResponseModifyQuotationRequest_Wrapper responseBody = ModifyQuotationRequest_helper.responseParse(mqResponse.getBody());
				
					// Update the quoation status and owner
					ModifyQuotationRequest_helper.Response_data mqData = responseBody.data;
					ModifyQuotationRequest_helper.Response_status mqStatus = mqData.status;
								
					oppProductsList[0].price_quote_status_id__c = mqStatus.id;
								
					List<ModifyQuotationRequest_helper.Response_businessAgents> mqBusinessAgentsList = mqData.businessAgents;
								
					if(!mqBusinessAgentsList.isEmpty()){
						List<User> userList = [SELECT Id FROM User WHERE user_id__c = : mqBusinessAgentsList[0].id AND IsActive = true];
						if(!userList.isEmpty()){
							oppProductsList[0].price_quote_owner_id__c = userList[0].Id;
						}else{
                            oppProductsList[0].price_quote_owner_id__c = null;
                        }
					}else{
						oppProductsList[0].price_quote_owner_id__c = null;
					}
					update oppProductsList;
				}
			}
			else if(wsResponseStatusCode == 409){
				
				// Set the status to return
				mapReturn.put('success','false');
			
				// Get the ws error message
				WebServiceUtils.ResponseErrorMessage_Wrapper errorDetails = WebServiceUtils.parse(mqResponse.getBody());
				
				// Set the error message
				String errorMessage = Label.PriceRecoverRequestKnownError + ' ' + errorDetails.errormessage;
				mapReturn.put('errorMessage',errorMessage);
			}
			else{
				// Set the status to return
				mapReturn.put('success','false');
				
				// Set the error message
				String errorMessage = Label.PriceRecoverRequestUnknownError;
				mapReturn.put('errorMessage',errorMessage);
			}
			
			
		}
		catch(Exception e){
			// Set the status to return
			mapReturn.put('success','false');
			
			// Set the error message
			String errorMessage = Label.PriceRecoverRequestUnknownError;
			mapReturn.put('errorMessage',errorMessage);
		}
		
		return mapReturn;
	}
    // Method that invoke the ws to request approval of a quotation and, if successful response, updates the opportunity and opportunity line item with the response
    public static Map<String,Object> invokeRequestQuotationApproval(String recordId){
	
		Map<String,Object> mapReturn = new Map<String,Object>();
		
		try{
		
			// Invoke WS
			ModifyQuotationRequest_helper mqHelper = new ModifyQuotationRequest_helper(recordId, 'REQUEST_APPROVAL', null, '', null);
			HttpResponse mqResponse = mqHelper.invoke();
			
			//Check the ws response status
			Integer wsResponseStatusCode = mqResponse.getStatusCode();
			if(wsResponseStatusCode == 200){
			
				// Set the status to return
				mapReturn.put('success','true');
			
				// Get the response body
				ModifyQuotationRequest_helper.ResponseModifyQuotationRequest_Wrapper responseBody = ModifyQuotationRequest_helper.responseParse(mqResponse.getBody());
				
				// Update the opportunity status
				List<Opportunity> oppList = [SELECT StageName, opportunity_status_type__c, isProcess__c, AccountId FROM Opportunity WHERE Id =: recordId];
				
				if(!oppList.isEmpty()){
                    
                    String oppStatusLabel;
                    String oppStatusIcon;
					String priceQuotationStatus;
					String priceQuotationOwnerId;
                    
					Opportunity oppToUpdate = oppList[0];
					oppToUpdate.StageName = '04';
					oppToUpdate.isProcess__c = true;
					
					// Retrieve the quotation status from the ws response
					ModifyQuotationRequest_helper.Response_data mqData = responseBody.data;
					ModifyQuotationRequest_helper.Response_status mqStatus = mqData.status;
					priceQuotationStatus = mqStatus.id;
						
					if(priceQuotationStatus == Label.WebPriceQuotationRequestStatus01){
						// Update status to Price approved
						oppToUpdate.opportunity_status_type__c = '08';
                        oppStatusLabel = Label.OppStatusLabel08;
                        oppStatusIcon = Label.AuditStyleApproveTop;
						mapReturn.put('quotationStatusMessage',Label.PriceCreateQuotationRequestApprovedMessage);
                        mapReturn.put('quotationStatusIcon','utility:check');
					}
					else{
						// Update status to Sent for price approval
						oppToUpdate.opportunity_status_type__c = '09';
                        oppStatusLabel = Label.OppStatusLabel09;
                        oppStatusIcon = Label.AuditStyleElevate;
						mapReturn.put('quotationStatusMessage',Label.PriceCreateQuotationRequestSentForApprovalMessage);
                        mapReturn.put('quotationStatusIcon','utility:share');
					}
						
					update oppToUpdate;
						
					// Save the quotation details on the opportunity product
					List<OpportunityLineItem> oppProductList = [SELECT price_quote_status_id__c, price_quote_owner_id__c, price_quote_date__c FROM OpportunityLineItem WHERE OpportunityId = : recordId];

					if(!oppProductList.isEmpty()){
							
						OpportunityLineItem oppProductToUpdate = oppProductList[0];
							
						oppProductToUpdate.price_quote_status_id__c = priceQuotationStatus;
						
						if(priceQuotationStatus == Label.WebPriceQuotationRequestStatus01){
							oppProductToUpdate.price_quote_date__c = System.today();
                        }    
                        String caseOwner;
							
                        List<Group> queueGroup = [SELECT Id, DeveloperName, Type 
                                                FROM Group 
                                                WHERE Type = 'Queue' 
                                                AND DeveloperName = 'Tier_1'];
                        if(!queueGroup.isEmpty()){
                            caseOwner = queueGroup[0].id; 
                        }
						
						List<ModifyQuotationRequest_helper.Response_businessAgents> mqBusinessAgentsList = mqData.businessAgents;
						
						// Check if the quotation owner exists as a user in DWP						
						if(!mqBusinessAgentsList.isEmpty()){
							List<User> userList = [SELECT Id FROM User WHERE user_id__c = : mqBusinessAgentsList[0].id AND IsActive = true];
							if(!userList.isEmpty()){
								oppProductToUpdate.price_quote_owner_id__c = userList[0].Id;
								caseOwner =  userList[0].id; 
							}else{
								oppProductToUpdate.price_quote_owner_id__c = null;
							}
						}else{
							oppProductToUpdate.price_quote_owner_id__c = null;
						}
						
						// Check if the status of quotation is REQUESTED to create a case assigned to the specific quotation owner
                        if(priceQuotationStatus == Label.WebPriceQuotationRequestStatus02){
                                        
							Case caseToInsert = new Case();
                            caseToInsert.Status = '01';
                            caseToInsert.Type = '01';
                            caseToInsert.AccountId = oppToUpdate.AccountId;
                            caseToInsert.opportunity_id__c = recordId;
                            if(caseOwner != null && caseOwner != ''){
                              	caseToInsert.OwnerId = caseOwner;
                            }
                            insert caseToInsert;
      					}
                            
                        update oppProductToUpdate;
                            
						// Create audit record
						dwp_cvad__Action_Audit__c auditToInsert = Action_Audit_Helper.getAudit(oppStatusLabel, 'Opportunity', recordId, System.now(), Label.AuditPriceApproval, UserInfo.getUserId(), oppStatusIcon, '', false);
        
                        insert auditToInsert;
                        mapReturn.put('auditId',auditToInsert.Id);
						
					}	
				}
			}
			else if(wsResponseStatusCode == 409){
				// Set the status to return
				mapReturn.put('success','false');
				
				// Get the ws error message
				WebServiceUtils.ResponseErrorMessage_Wrapper errorDetails = WebServiceUtils.parse(mqResponse.getBody());
					
				// Set the error message
				String errorMessage = Label.PriceRequestQuotationApprovalKnownError + ' ' + errorDetails.errormessage;
				mapReturn.put('errorMessage',errorMessage);
			}
			else{
				// Set the status to return
				mapReturn.put('success','false');
				
				// Set the error message
				String errorMessage = Label.PriceRequestQuotationApprovalUnknownError;
				mapReturn.put('errorMessage',errorMessage);
			}
	
		}
		catch(Exception e){
			// Set the status to return
			mapReturn.put('success','false');
			
			// Set the error message
			String errorMessage = Label.PriceRequestQuotationApprovalUnknownError;
			mapReturn.put('errorMessage',errorMessage);
		}
		
		return mapReturn;
	}
}