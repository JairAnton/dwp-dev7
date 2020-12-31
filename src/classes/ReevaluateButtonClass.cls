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
	/** status code price */
    final private static List<String> statusPrice = new List<String> {'13', '10', '11', '08'};
    /** status code risk */
    final private static List<String> statusRisk = new List<String> {'14', '15', '16', '17', '18'};

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
					msg = evalStageFour(opp, lstOLI);
				} else if(opp.StageName == '05')  {
					msg = evalStageFive(opp, lstOLI);
				}
			}
		} catch(Exception e) {
			genericError = e.getMessage();
		}
		mapReturn.put('msg', msg);
		mapReturn.put('genericError', genericError);
		return mapReturn;
	}
	
	/**
	* @Description method to evaluate stage 04
	* @param Opportunity opp
	* @param List<OpportunityLineItem> lstOLI
	*/
    private static String evalStageFour(Opportunity opp, List<OpportunityLineItem> lstOLI) {
        String msg;
        return msg;
    }
    
    /**
	* @Description method to evaluate stage 05
	* @param Opportunity opp
	* @param List<OpportunityLineItem> lstOLI
	*/
    private static String evalStageFive(Opportunity opp, List<OpportunityLineItem> lstOLI) {
        String msg;
        return msg;
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
	* @param System.HttpResponse invoke
	* @param OpportunityLineItem oli
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
