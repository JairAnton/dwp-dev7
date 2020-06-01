/*
   @Author: Arsenio Perez Lopez
   @Proyect: BBVA PERU
   @CreatedDate: 04-05-2018
   @Version:1
   @Hysteresis of changes:
   - Creation of the class
   -(04-07-2018) The methods for the FlashClient object are added
 */
public with sharing class Object_Controller {
	/**
	 * Method of get contacts register.
	 *   Yulino 11/12/2018 : Se modificó getOportunityLineItemID, getOportunityModality y getOportunidadSytem a RETURN en una sola linea, asimismo el contructor al final de la clase
	 **/
	@AuraEnabled
	public static Id getOportunityLineItemID(String Filtro) {
		return [SELECT Id FROM OpportunityLineItem where OpportunityId = : Filtro][0].Id;
	}

	/**
	 * Method of get contacts register.
	 *
	 **/
	@AuraEnabled
	public static String getOportunityModality(String Filtro) {
		return [SELECT Risk_modality_type__c FROM Opportunity WHERE Id = : Filtro LIMIT 1].Risk_modality_type__c;
	}

	/**
	 * Method of get contacts register.
	 *
	 **/
	@AuraEnabled
	public static String getOportunidadSytem(String Filtro) {
		return [SELECT Id, Product2.Type_of_quote__c FROM OpportunityLineItem where OpportunityId = : Filtro][0].Product2.Type_of_quote__c;
	}

	/**
	 * Method of get contacts register.
	 *
	 **/
	@AuraEnabled
	public static void  setSanction(String Idopp) {
		Opportunity op  = new Opportunity();
		//Map<string,string> MapStatus = getMapOppStatus(); // Yulino 11/12/2018 : Se comentó
		Task t = [SELECT Id, Subject, Status FROM Task WHERE whatId = : idopp ORDER BY CreatedDate DESC];
		op = [SELECT StageName, Risk_modality_type__c, opportunity_status_type__c FROM Opportunity WHERE ID =:Idopp];
		op.opportunity_status_type__c = '10';
		String[] valStatus = t.Subject.split('##');
		//String filter = '%'+valStatus[0]+'%'; // Yulino 11/12/2018 : Se comentó
		Integer totalTrace;
		update op;
		AggregateResult[] countTrace  = [SELECT Count(Id) total FROM dwp_cvad__Action_Audit__c];
		new OpportunityTraceability_cls().addOpportunityTraceability(valStatus[1], 'Código SIO:' + valStatus[0], 'Opportunity', op.Id, 'Aprove', ('AT-' + totalTrace), UserInfo.getUserId(), 'embedded', 1, true);
	}
    
	/**
	 * Method of get Status register of opportu.
	 *
	 **/
	private static Map<string, string> getMapOppStatus() {
		Map<string, string> MapStatus = new Map<string, string>();
		Schema.DescribeFieldResult fieldResult = Opportunity.opportunity_status_type__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for(Schema.PicklistEntry f : ple) {
			MapStatus.put(f.getLabel(), f.getValue());
		}
		return MapStatus;
	}

	/**
	 *
	 *
	 **/
	@AuraEnabled
	public static List<String>  getVflasClient(String Idopp, string tipex) {
		List<String> ret = new List<String>();
		String Tip = tipex == 'Recursos gestionados' ? '02' : '01';
		AggregateResult[] scop = [SELECT FORMAT(SUM(average_balance_amount__c)) average_balance_amount__c,
		                          FORMAT(SUM(current_balance_var_month_amount__c)) current_balance_var_month_amount__c,
		                          FORMAT(SUM(current_balance_var_year_amount__c)) current_balance_var_year_amount__c
		                          FROM Account_BBVA_Information__c WHERE type__c =: Tip AND
		                                                                           product_group_classification_id__c != '' AND product_desc__c != ''
		                                                                           AND account_id__c =: Idopp AND is_last_date__c = true AND
		                                                                                                                            product_group_classification_id__c =:tipex
		                                                                                                                                                                 Group By product_group_classification_id__c limit 1];
		List<Account_Banking_System_Debt__c> banking = new List<Account_Banking_System_Debt__c>();
		banking = [select id, debt_quote_amount__c from Account_Banking_System_Debt__c
		           where product_group_classification_id__c != '' and
		           entity_name__c LIKE '%BBVA%' AND product_desc__c = '' AND is_last_date__c = true AND
		                                                                                       entity_name__c != '' and
		                                                                                       account_id__c =: Idopp and product_group_classification_id__c =:tipex limit 1];
		for(AggregateResult ar :scop) {
			ret.add(String.valueOf(ar.get('average_balance_amount__c')));
			ret.add(banking.isEmpty() ? 'N/A' : String.valueOf(banking[0].debt_quote_amount__c) + '%');
			ret.add(String.valueOf(ar.get('current_balance_var_month_amount__c')));
			ret.add(String.valueOf(ar.get('current_balance_var_year_amount__c')));
		}
		if(ret.isEmpty()) {
			ret.add('0');
			ret.add(banking.isEmpty() ? 'N/A' : String.valueOf(banking[0].debt_quote_amount__c) + '%');
			ret.add('0'); ret.add('0');
		}
		return ret;
	}

	/**
	**/
	@AuraEnabled
	public static Product2 getProduct2(String ProdId) {
		Product2 prodreturn = new Product2();
		if(!String.isEmpty(ProdId)) {
			List<OpportunityLineItem> temp = [select product2Id from OpportunityLineItem where id =: ProdId limit 1];
			if(!temp.isEmpty())
				prodreturn = [select id, risk_sanction__c, price_penalty__c, formalization__c from Product2 where id =: temp[0].product2Id limit 1];
		}
		return prodreturn;
	}
}
