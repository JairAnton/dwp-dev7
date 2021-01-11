/**
 * BE_EconomicGroup_Spread_Rate_cls
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		07/09/2020          Original version.<p />
 *
 * @author Diego Carbajal
 */
public with sharing class BE_EconomicGroup_Spread_Rate_cls extends Be_DTP_ResponseModel_cls {
    
    /*
	 * @Description  Get Custom Data for Profitability
	 */
    public override Be_DTP_ResponseModel_cls.Response getData(Map<String, String> mapParams, String columns, List<String> replaceField) {
        Final Be_DTP_ResponseModel_cls.Response response = new Be_DTP_ResponseModel_cls.Response(true);
        response.columns = columns;
        replaceField.add(mapParams.get('recordId'));
        Final Map<Id, Account> mapClients = new Map<Id, Account>([SELECT Id, Name FROM Account WHERE parentId IN: replaceField]);
        Final Account_Profitability__c[] lstSprdRate = [SELECT Id, account_id__c, currenct_mon_amount__c, profitability_category_type__c, 
                                                currenct_mon_per__c, year_month_day_date__c ,period__c FROM Account_Profitability__c 
                                                WHERE account_id__c IN: mapClients.keySet() AND product_desc__c = 'CLIENTE' AND 
                                                profitability_subcategory_type__c IN ('TOTAL Spread', 'TOTAL Tasa') AND 
                                                is_type_3_last_date__c = true AND profitability_type__c IN ('01','02') AND 
                                                profitability_category_type__c IN ('Spread', 'Tasa') ORDER BY account_id__c, 
                                                year_month_day_date__c ASC];
        Final Map<Id, List<Account_Profitability__c>> mapSR = BE_EconomicGroup_Profitability_cls.generateMapProfitability(lstSprdRate);
        Final List<Map<String, Object>> lstSRRecords = new List<Map<String, Object>>();
        Map<String, Object> mapValues;
        for(Id accId: mapClients.keySet()) {
            mapValues = new Map<String, Object>{'Id' => accId, 'CLIENT_NAME' => mapClients.get(accId).Name, 
                                                                    'URL__Id' => URL.getSalesforceBaseUrl().toExternalForm() + '/' + accId,
                                                                    'Spread' => '0 %', 'Tasa' => '0 %'};
            if(mapSR.containsKey(accId) && !mapSR.get(accId).isEmpty()) {
                for(Account_Profitability__c prof: mapSR.get(accId)) {
                    mapValues.put(prof.profitability_category_type__c, prof.currenct_mon_per__c + ' %');
                    mapValues.put('MONTH', prof.period__c);
                }
            }
            lstSRRecords.add(mapValues);
        }
        response.data = lstSRRecords;
        return response;
    }

}