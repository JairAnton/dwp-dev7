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
public class ReevaluateButtonClass {
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
            Opportunity opp = [SELECT Id, opportunity_status_type__c, StageName, isProcess__c, BE_UseApprovedQuote__c FROM Opportunity WHERE Id =: Idopp];
			List <dwp_cvad__Action_Audit__c> lstactionRisk = new List <dwp_cvad__Action_Audit__c>();
			try {
                Map<String, Object> callServ = new Map<String, Object>();
                if(opp.BE_UseApprovedQuote__c) {
                    clearOppQuoteValues(Idopp);
                } else {
                    callServ = ReevaluateButtonClass.callService(Idopp);
                }
                if(callServ.get('genericError') == null) {
                    opp.isProcess__c = true;
                    opp.StageName = '04';
                    opp.opportunity_status_type__c = '24';
                    opp.BE_UseApprovedQuote__c = false;
                    update opp;
                    
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
            genericError = Label.BE_ErrorReevaluate;
        } else {
            Opportunity opp = [SELECT Id, opportunity_status_type__c, StageName, isProcess__c, BE_UseApprovedQuote__c FROM Opportunity WHERE Id =: Idopp];
			List <dwp_cvad__Action_Audit__c> lstactionPrice = new List <dwp_cvad__Action_Audit__c>();
            try {
                Map<String, Object> callServ = new Map<String, Object>();
                if(opp.BE_UseApprovedQuote__c) {
                    clearOppQuoteValues(Idopp);
                } else {
                    callServ = ReevaluateButtonClass.callService(Idopp);
                }
                if(callServ.get('genericError') == null) {
                    opp.isProcess__c = true;
                    opp.StageName = '04';
                    opp.opportunity_status_type__c = '12';
                    opp.BE_UseApprovedQuote__c = false;
                    update opp;
                    
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
    private static void clearOppQuoteValues(String oppId) {
        List<OpportunityLineItem> olis = [SELECT Id, price_quote_id__c, Opportunity.Account.Name FROM OpportunityLineItem WHERE OpportunityId = :oppId LIMIT 1];
        Final String namePDF = olis[0].price_quote_id__c + ' - ' + olis[0].Opportunity.Account.Name;
        Final String nullString;
		Final Date nullDate;
        Final Decimal nullDecimal;
        olis[0].price_quote_date__c = nullDate;
        olis[0].suggested_apr_per__c = nullDecimal;
        olis[0].validityDate__c = nullDate;
        olis[0].proposed_apr_per__c = nullDecimal;
        olis[0].minimun_apr_per__c = nullDecimal;
        olis[0].price_quote_id__c = nullString;
        olis[0].Assigned_analyst__c = nullString;
        olis[0].price_operation_id__c = nullString;
        update olis;
        Final List<Opportunity_Solution_Commitment__c> commitments = [SELECT Id FROM Opportunity_Solution_Commitment__c WHERE opportunity_id__c = :oppId];
        if(!commitments.isEmpty()) {
            delete commitments;
        }
        Final List<ContentDocumentLink> ltsCDL = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :oppId AND ContentDocument.Title =:namePDF AND ContentDocument.FileType = 'pdf'];
        if(!ltsCDL.isEmpty()) {
            delete ltsCDL;
        }
    }
    
    /**
	* @Description method to check if there are opportunities that use the quote id of the opportunity being reevaluated
	* @param String oppId
	 */
    private static boolean checkQuoteUse(String oppId) {
        final OpportunityLineItem oli = [SELECT Id, price_quote_id__c, Opportunity.AccountId, Product2Id FROM OpportunityLineItem WHERE OpportunityId = :oppId LIMIT 1];
        final List<OpportunityLineItem> lts = [SELECT Id FROM OpportunityLineItem WHERE Opportunity.BE_UseApprovedQuote__c = TRUE AND price_quote_id__c = :oli.price_quote_id__c AND Opportunity.AccountId = :oli.Opportunity.AccountId AND Product2Id = :oli.Product2Id];
        Boolean exist = true; 
		if(lts.isEmpty()) {
            exist = false;
        }
		return exist;
    }

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
					//get json body
					ModifyQuotationRequest_helper.ResponseModifyQuotationRequest_Wrapper jbody = ModifyQuotationRequest_helper.responseParse(invoke.getBody());
					switch on invoke.getStatusCode() {
						when 200 {
							if(jbody.data != null && jbody.data.status != null) {
								lstOLI[0].price_quote_status_id__c = jbody.data.status.id;
								update lstOLI;
							}
							if(jbody.data != null && jbody.data.businessAgents != null) {
								List <User> userList = [SELECT Id FROM User where user_id__c =: jbody.data.businessAgents[0].id];
								if(!userList.isEmpty()) {
									lstOLI[0].price_quote_owner_id__c = userList[0].Id;
								} else  {
									lstOLI[0].price_quote_owner_id__c = null;
								}
								update lstOLI;
							}
						} when 409 {
							WebServiceUtils.ResponseErrorMessage_Wrapper jerror = WebServiceUtils.parse(invoke.getBody());
							genericError = jerror.errormessage;
						} when else {
							genericError = Label.GenericError;
						}
					}
				}
			}
		} catch(Exception e) {
			genericError = e.getMessage();
		}

		mapReturn.put('genericError', genericError);
		return mapReturn;
	}
}
