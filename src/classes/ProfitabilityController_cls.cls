/**
 * BE_EconomicGroup_Position_cls
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
* None				    		None          	Original version.<p />
 * @Class Using into a developer for a lithgning component
 * 								10/09/20		Modified Version.<p />
 *
 * @author Diego Carbajal
 */
public without sharing class ProfitabilityController_cls extends Be_DTP_ResponseModel_cls {

	/*
	 * @Description  Get Custom Data for Profitability Information
	 */
	public override Be_DTP_ResponseModel_cls.Response getData(Map<String, String> mapParams, String columns, List<String> replaceField) {
		Final Be_DTP_ResponseModel_cls.Response response = new Be_DTP_ResponseModel_cls.Response(true);
        response.columns = columns;
		replaceField.add(mapParams.get('recordId'));
		Final Map<Id, Account> mapClients = new Map<Id, Account>([SELECT Id, Name FROM Account WHERE parentId IN: replaceField]);
		Final Map<string, AggregateResult> marOrd = new Map<string, AggregateResult>([SELECT Account_id__c cuenta, account_id__c Id, 
											SUM(current_ydt_amount__c) suma FROM Account_Profitability__c WHERE account_id__r.ParentID IN: replaceField 
											AND is_type_3_last_date__c = true AND profitability_type__c = '03' AND(profitability_category_type__c = 'Comisiones' 
											OR profitability_category_type__c = 'Margen financiero')  GROUP BY Account_id__c ORDER BY Account_id__c]);
		Final Map<string, AggregateResult> comi = new Map<string, AggregateResult>([SELECT Account_id__c cuenta, account_id__c Id, 
											SUM(current_ydt_amount__c) suma FROM Account_Profitability__c WHERE account_id__r.ParentID IN: replaceField 
											AND is_type_3_last_date__c = true AND profitability_type__c = '03' AND profitability_category_type__c = 'Comisiones' 
											GROUP BY Account_id__c ORDER BY Account_id__c]);
		Final Map<string, AggregateResult> marFin = new Map<string, AggregateResult>([SELECT Account_id__c cuenta, account_id__c Id, 
											SUM(current_ydt_amount__c) suma FROM Account_Profitability__c WHERE account_id__r.ParentID IN: replaceField 
											AND is_type_3_last_date__c = true AND profitability_type__c = '03' AND profitability_category_type__c = 'Margen financiero' 
											GROUP BY Account_id__c ORDER BY Account_id__c]);
		Final List<Map<String, Object>> lstMapValues = new List<Map<String, Object>>();
		Map<String, Object> mapValues;
		for(Id accId: mapClients.keySet()) {
			mapValues = new Map<String, Object>{'Id' => accId, 'CLIENT_NAME' => mapClients.get(accId).Name, 'MARGIN_FIN' => 0, 
						'COMISION' => 0, 'MARGIN_ORD' => 0, 'URL__Id' => URL.getSalesforceBaseUrl().toExternalForm() + '/' + accId};
			if(marFin.containsKey(accId)) {
				mapValues.put('MARGIN_FIN', (Decimal) marFin.get(accId).get('suma'));
			}
			if(comi.containsKey(accId)) {
				mapValues.put('COMISION', (Decimal) comi.get(accId).get('suma'));
			}
			if(marOrd.containsKey(accId)) {
				mapValues.put('MARGIN_ORD', (Decimal) marOrd.get(accId).get('suma'));
			}
			lstMapValues.add(mapValues);
		}
		response.data = lstMapValues;
		return response;
	}

}