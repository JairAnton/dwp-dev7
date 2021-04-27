/**
 * ProfitabilityController_cls
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

    /** @Description MARGIN_ORD */
    static Final String MARGIN_ORD = 'MARGIN_ORD';
    /** @Description COMMISION */
    static Final String COMMISION = 'COMISION';
    /** @Description MARGIN_FIN */
    static Final String MARGIN_FIN = 'MARGIN_FIN';
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
		response.data = getMapValues(replaceField, mapClients, marFin, comi, marOrd);
		return response;
	}

    private List<Map<String, Object>> getMapValues (List<String> replaceField, Map<Id, Account> mapClients, final Map<string, AggregateResult> marFin, final Map<string, AggregateResult> comi, final Map<string, AggregateResult> marOrd) {
        List<Map<String, Object>> lstMapValues = new List<Map<String, Object>>();
		Map<String, Object> mapTotalValues = new Map<String, Object>{'Id' => 'TOTAL', 'CLIENT_NAME' =>'TOTAL', MARGIN_FIN => 0, 
		COMMISION => 0, MARGIN_ORD => 0, 'URL__Id' => URL.getSalesforceBaseUrl().toExternalForm() + '/' + replaceField.get(0)};
		Map<String, Object> mapValues = null;
        Decimal suma = 0;
		for(Id accId: mapClients.keySet()) {
			mapValues = new Map<String, Object>{'Id' => accId, 'CLIENT_NAME' => mapClients.get(accId).Name, MARGIN_FIN => 0, 
						COMMISION => 0, MARGIN_ORD => 0, 'URL__Id' => URL.getSalesforceBaseUrl().toExternalForm() + '/' + accId};
			if(marFin.containsKey(accId)) {
                suma = getSumValuesMarFin(mapValues, mapTotalValues, marFin.get(accId).get('suma'));				
			}
			else if(comi.containsKey(accId)) {
				suma = getSumValuesComi(mapValues, mapTotalValues, comi.get(accId).get('suma'));
			}
			else if(marOrd.containsKey(accId)) {
                suma = getSumValuesOrd(mapValues, mapTotalValues, marOrd.get(accId).get('suma'));
			}
			lstMapValues.add(mapValues);
		}
		lstMapValues.add(mapTotalValues);        
        return lstMapValues;
    }
    
    private Decimal getSumValuesMarFin(Map<String, Object> mapValues, Map<String, Object> mapTotalValues, Object strMarfin) {
        Decimal sumaMarFin = strMarfin == null ? 0 : (Decimal) strMarfin;
        mapValues.put(MARGIN_FIN, sumaMarFin);
        mapTotalValues.put(MARGIN_FIN, (Decimal) mapTotalValues.get(MARGIN_FIN) + sumaMarFin);
        return sumaMarFin;
    }
    
    private Decimal getSumValuesComi(Map<String, Object> mapValues, Map<String, Object> mapTotalValues, Object strComi) {
        Decimal sumaComi = strComi == null ? 0 : (Decimal) strComi;
        mapValues.put(COMMISION, sumaComi);
        mapTotalValues.put(COMMISION, (Decimal) mapTotalValues.get(COMMISION) + sumaComi);
        return sumaComi;
    }
    
    private Decimal getSumValuesOrd(Map<String, Object> mapValues, Map<String, Object> mapTotalValues, Object strOrd) {
        Decimal sumaOrd = strOrd == null ? 0 : (Decimal) strOrd;
        mapValues.put(MARGIN_ORD, sumaOrd);
        mapTotalValues.put(MARGIN_ORD, (Decimal) mapTotalValues.get(MARGIN_ORD) + sumaOrd);
        return sumaOrd;
    }
}