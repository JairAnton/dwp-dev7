/**
 * @author Global_HUB developers
 * @date 17-07-2018
 *
 * @group Global_HUB
 *
 * @description Controller class from reevaluateButton_cmp
 * 
 * @Changes
 *  Date        Author   Email                  			Type		Description
 *  2020-11-06  MAMC     martin.mori.contractor@bbva.com	Modify		add method clearOppQuoteValues
 **/
public without sharing class ReevaluateButtonClass {
	private static boolean risk;
	private static boolean price;

	@auraenabled
	public static Map<String, Object> start(String Idopp) {
		/**
		 *  @description Method to get Risk o Price from opportunity_status_type__c to put a button Risk, Price or both buttons
		 *  @return String
		 * */
		String msg, genericError;
		Opportunity opp = [Select Id, StageName, opportunity_status_type__c, frm_ContractNumber__c, OwnerId From Opportunity where Id =:Idopp];
		List <OpportunityLineItem> lstOLI = [Select Id, product_risk_approval_indicator__c, price_quote_status_id__c, product_price_approval_indicator__c, product_formalization_indicator__c, proposed_apr_per__c, price_quote_id__c, price_quote_owner_id__c, product_price_approval_method__c From OpportunityLineItem where OpportunityId =:Idopp];
		Map<String, Object> mapReturn = new Map<String, Object>();
		try {
			if(!lstOLI.isEmpty()) {
				if(opp.StageName == '04') {
					if((opp.opportunity_status_type__c == '16' || opp.opportunity_status_type__c == '17' || opp.opportunity_status_type__c == '18' || opp.opportunity_status_type__c == '15' || opp.opportunity_status_type__c == '14') && (lstOLI[0].product_risk_approval_indicator__c == true)) {
						msg = 'Risk';
					} else if((opp.opportunity_status_type__c == '13' || opp.opportunity_status_type__c == '10' || opp.opportunity_status_type__c == '11' || opp.opportunity_status_type__c == '08') && (lstOLI[0].product_price_approval_indicator__c == true && lstOLI[0].product_risk_approval_indicator__c == false))    {
						msg = 'Price';
					} else if((opp.opportunity_status_type__c == '13' || opp.opportunity_status_type__c == '10' || opp.opportunity_status_type__c == '11' || opp.opportunity_status_type__c == '08') && (lstOLI[0].product_price_approval_indicator__c == true && lstOLI[0].product_risk_approval_indicator__c == true))    {
						msg = 'Both';
					}
				} else if(opp.StageName == '05')  {
					if(opp.opportunity_status_type__c == '20' && (lstOLI[0].product_risk_approval_indicator__c == true && lstOLI[0].product_price_approval_indicator__c == true && lstOLI[0].product_formalization_indicator__c == true)) {
						msg = 'Both';
					} else if(opp.opportunity_status_type__c == '20' && (lstOLI[0].product_risk_approval_indicator__c == true && lstOLI[0].product_price_approval_indicator__c == false && lstOLI[0].product_formalization_indicator__c == true))  {
						msg = 'Risk';
					} else if(opp.opportunity_status_type__c == '20' && (lstOLI[0].product_risk_approval_indicator__c == false && lstOLI[0].product_price_approval_indicator__c == true && lstOLI[0].product_formalization_indicator__c == true))  {
						msg = 'Price';
					}
				}
			}
		} catch(Exception e) {
			genericError = e.getMessage();
		}
		mapReturn.put('msg', msg);
		mapReturn.put('genericError', genericError);
		return mapReturn;
	}

	@auraenabled
	public static Map<String, Object> setToRisk(String Idopp) {
		/**
		 *  @description Method to update the opportunity status to reevalute to risk and insert a Action Audit
		 *  @return String
		 * */
		Map<String, Object> mapReturn = new Map<String, Object>();
		String genericError;
        Final Boolean useQuote = checkQuoteUse(Idopp);
        if(useQuote) {
            genericError = Label.ErrorReevaluate;
        } else {
            Final Opportunity opp = [SELECT Id, opportunity_status_type__c, StageName, isProcess__c, BE_UseApprovedQuote__c, sio_code__c FROM Opportunity WHERE Id =: Idopp];
			List <dwp_cvad__Action_Audit__c> lstactionRisk = new List <dwp_cvad__Action_Audit__c>();
			try {
                Map<String, Object> callServ = new Map<String, Object>();
                if(opp.BE_UseApprovedQuote__c) {
                    mapReturn = clearOppQuoteValues(Idopp);
                } else {
                    callServ = ReevaluateButtonClass.callService(Idopp);
                }
                if(callServ.get('genericError') == null) {
                    Final Opportunity oppUpdate = new Opportunity();
                    oppUpdate.Id = opp.Id;
                    oppUpdate.isProcess__c = true;
                    oppUpdate.StageName = '04';
                    oppUpdate.opportunity_status_type__c = '24';
                    oppUpdate.BE_UseApprovedQuote__c = false;
                    oppUpdate.sio_code__c = opp.sio_code__c;
                    update oppUpdate;
					mapReturn = clearOppQuoteValues(Idopp);
                    
                    lstactionRisk.add(Action_Audit_Helper.getAudit(label.reevalRisk, 'Opportunity', opp.Id, DateTime.now(), label.AuditRiskApproval, UserInfo.getUserId(), label.restudyStyle, opp.sio_code__c, false));
                    insert lstactionRisk;
                    
                    mapReturn.put('Updated', 'Updated');
                } else  {
                    genericError = callServ.get('genericError').toString();
                }
            } catch(Exception e) {
                genericError = e.getMessage();
            }
        }
		mapReturn.put('genericError', genericError);
		return mapReturn;
	}

	@auraenabled
	public static Map<String, Object> setToPrice(String Idopp) {
		/**
		 *  @description Method to update the opportunity status to reevalute to price and insert a Action Audit
		 *  @return String
		 * */
        Map<String, Object> mapReturn = new Map<String, Object>();
		String genericError;
        Final Boolean useQuote = checkQuoteUse(Idopp);
        if(useQuote) {
            genericError = Label.ErrorReevaluate;
        } else {
            Final Opportunity opp = [SELECT Id, opportunity_status_type__c, StageName, isProcess__c, BE_UseApprovedQuote__c FROM Opportunity WHERE Id =: Idopp];
			List <dwp_cvad__Action_Audit__c> lstactionPrice = new List <dwp_cvad__Action_Audit__c>();
            try {
                Map<String, Object> callServ = new Map<String, Object>();
                if(opp.BE_UseApprovedQuote__c) {
                    mapReturn = clearOppQuoteValues(Idopp);
                } else {
                    callServ = ReevaluateButtonClass.callService(Idopp);
                }
                if(callServ.get('genericError') == null) {
                    Final Opportunity oppUpdate = new Opportunity();
                    oppUpdate.Id = opp.Id;
                    oppUpdate.isProcess__c = true;
                    oppUpdate.StageName = '04';
                    oppUpdate.opportunity_status_type__c = '12';
                    oppUpdate.BE_UseApprovedQuote__c = false;
                    update oppUpdate;
					mapReturn = clearOppQuoteValues(Idopp);
                    
                    lstactionPrice.add(Action_Audit_Helper.getAudit(label.reevalPrice, 'Opportunity', opp.Id, DateTime.now(), label.AuditPriceApproval, UserInfo.getUserId(), label.restudyStyle, '', false));
                    insert lstactionPrice;
                    mapReturn.put('Updated', 'Updated');
                } else  {
                    genericError = callServ.get('genericError').toString();
                }
            } catch(Exception e) {
                genericError = e.getMessage();
            }
        }
		mapReturn.put('genericError', genericError);
		return mapReturn;
	}
    
    /**
	* @Description clear the set values when using a current quote
	* @param String oppId
	 */
    private static Map<String, Object> clearOppQuoteValues(String oppId) {
		Map<String, Object> mapReturn = new Map<String, Object>();
        Final List<OpportunityLineItem> olis = [SELECT Id, price_quote_id__c, Opportunity.Account.Name FROM OpportunityLineItem WHERE OpportunityId = :oppId LIMIT 1];
        Final String namePDF = olis[0].price_quote_id__c + ' - ' + olis[0].Opportunity.Account.Name;
        Final String nullString;
		Final Date nullDate;
        Final Decimal nullDecimal;
        Final OpportunityLineItem oli = new OpportunityLineItem();
        oli.Id = olis[0].Id;
        oli.price_quote_date__c = nullDate;
        oli.suggested_apr_per__c = nullDecimal;
        oli.validityDate__c = nullDate;
        oli.proposed_apr_per__c = nullDecimal;
        oli.minimun_apr_per__c = nullDecimal;
		oli.proposed_fee_per__c = nullDecimal;
        oli.price_quote_id__c = nullString;
        oli.Assigned_analyst__c = nullString;
        oli.price_operation_id__c = nullString;
        update oli;
        Final List<Opportunity_Solution_Commitment__c> commitments = [SELECT Id FROM Opportunity_Solution_Commitment__c WHERE opportunity_id__c = :oppId];
        if(!commitments.isEmpty()) {
            delete commitments;
        }
        Final List<ContentDocumentLink> ltsCDL = [SELECT Id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :oppId AND ContentDocument.Title =:namePDF AND ContentDocument.FileType = 'pdf'];
        if(!ltsCDL.isEmpty()) {
            update new ContentDocument(Id = ltsCDL[0].ContentDocumentId, OwnerId = System.UserInfo.getUserId());
            mapReturn.put('idDocument', ltsCDL[0].ContentDocumentId);
        }
		return mapReturn;
    }
	
	/**
	* @Description delete pdf of quotation
	* @param String oppId
	 */
    @auraenabled
    public static Map<String, Object> deleteQuotePdf(String idDoc) {
        Map<String, Object> mapReturn = new Map<String, Object>();
		String genericError;
        try {
            delete new ContentDocument(Id = idDoc);
        } catch(Exception e) {
            genericError = e.getMessage();
        }
        mapReturn.put('genericError', genericError);
        return mapReturn;
    }
    
    /**
	* @Description method to check if there are opportunities that use the quote id of the opportunity being reevaluated
	* @param String oppId
	 */
    private static boolean checkQuoteUse(String oppId) {
        final OpportunityLineItem oli = [SELECT Id, price_quote_id__c, Opportunity.AccountId, Product2Id, Opportunity.BE_UseApprovedQuote__c FROM OpportunityLineItem WHERE OpportunityId = :oppId LIMIT 1];
        Boolean exist = false;
        if(!oli.Opportunity.BE_UseApprovedQuote__c) {
            for(OpportunityLineItem oliaux : [SELECT Id, OpportunityId FROM OpportunityLineItem WHERE Opportunity.BE_UseApprovedQuote__c = TRUE AND price_quote_id__c = :oli.price_quote_id__c AND Opportunity.AccountId = :oli.Opportunity.AccountId AND Product2Id = :oli.Product2Id]) {
                if(oliaux.OpportunityId != oppId) {
                    exist = true;
                    break;
                }
            }
        }
		return exist;
    }
	
	/**
	* @Description method to call webservice
	* @param String Idopp
	*/
	@auraenabled
	public static Map<String, Object> callService(String Idopp) {
		String genericError;
		Opportunity opp = [Select Id, StageName, opportunity_status_type__c, frm_ContractNumber__c, OwnerId From Opportunity where Id =:Idopp];
		List <OpportunityLineItem> lstOLI = [Select Id, product_risk_approval_indicator__c, price_quote_status_id__c, product_price_approval_indicator__c, product_formalization_indicator__c, proposed_apr_per__c, price_quote_id__c, price_quote_owner_id__c, product_price_approval_method__c From OpportunityLineItem where OpportunityId =:Idopp];
		Map<String, Object> mapReturn = new Map<String, Object>();
		try {
			if(!lstOLI.isEmpty()) {
				//Call a RECOVER Service One product
				if(lstOLI[0].price_quote_id__c != '' && lstOLI[0].product_price_approval_method__c == 'Web' && (opp.opportunity_status_type__c == '11' || opp.opportunity_status_type__c == '13' || opp.opportunity_status_type__c == '10' || opp.opportunity_status_type__c == '08' || opp.opportunity_status_type__c == '20')) {
					//helper to call the service
					ModifyQuotationRequest_helper modifyHelper = new ModifyQuotationRequest_helper(opp.Id, 'RECOVER', lstOLI[0].proposed_apr_per__c, opp.frm_ContractNumber__c, null);
					//invoke the service
					System.HttpResponse invoke = modifyHelper.invoke();
					genericError = readResponse(invoke, lstOLI[0]);
				}
			}
		} catch(Exception e) {
			genericError = e.getMessage();
		}

		mapReturn.put('genericError', genericError);
		return mapReturn;
	}
	
	/**
	* @Description method to read response webservice
	* @param String Idopp
	*/
    private static String readResponse(System.HttpResponse invoke, OpportunityLineItem oli) {
        String genericError;
        Final OpportunityLineItem oliUpdate = new OpportunityLineItem();
        oliUpdate.Id = oli.Id;
        switch on invoke.getStatusCode() {
            when 200 {
                ModifyQuotationRequest_helper.ResponseModifyQuotationRequest_Wrapper jbody = ModifyQuotationRequest_helper.responseParse(invoke.getBody());
                if(jbody.data != null && jbody.data.status != null) {
                    oliUpdate.price_quote_status_id__c = jbody.data.status.id;
                    oliUpdate.validityDate__c = null;
                    oliUpdate.Assigned_analyst__c = null;
                    update oliUpdate;
                }
                if(jbody.data != null && jbody.data.businessAgents != null) {
                    List <User> userList = [SELECT Id FROM User where user_id__c =: jbody.data.businessAgents[0].id];
                    if(!userList.isEmpty()) {
                        oliUpdate.price_quote_owner_id__c = userList[0].Id;
                    } else  {
                        oliUpdate.price_quote_owner_id__c = null;
                    }
                    update oliUpdate;
                }
            } when 409 {
                WebServiceUtils.ResponseErrorMessage_Wrapper jerror = WebServiceUtils.parse(invoke.getBody());
                genericError = jerror.errormessage;
            } when else {
                genericError = Label.GenericError;
            }
        }
        return genericError;
    }
}
