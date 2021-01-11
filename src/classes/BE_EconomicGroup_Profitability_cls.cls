/**
 * BE_EconomicGroup_Profitability_cls
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		07/09/2020          Original version.<p />
 *
 * @author Diego Carbajal
 */
public with sharing class BE_EconomicGroup_Profitability_cls extends Be_DTP_ResponseModel_cls {
    
    /** @Description  reusable MAP_COLUMNS_MATCH*/
    static Final Map<Integer, Integer> MAP_COLUMNS_MATCH = new Map<Integer, Integer>();

    /*
	 * @Description  Get Custom Data for Profitability
	 */
    public override Be_DTP_ResponseModel_cls.Response getData(Map<String, String> mapParams, String columns, List<String> replaceField) {
        Final Be_DTP_ResponseModel_cls.Response response = new Be_DTP_ResponseModel_cls.Response(true);
        replaceField.add(mapParams.get('recordId'));
        Final Map<Id, Account> mapClients = new Map<Id, Account>([SELECT Id, Name FROM Account WHERE parentId IN: replaceField]);
        Final Account_Profitability__c[] lstBilling = [SELECT Id, account_id__c, currenct_mon_amount__c, year_month_day_date__c 
                                                FROM Account_Profitability__c WHERE account_id__c IN: mapClients.keySet() 
                                                AND product_desc__c = 'CLIENTE' AND profitability_subcategory_type__c = 'TOTAL CLIENTE' 
                                                AND year_month_day_date__c = LAST_N_MONTHS:6 AND profitability_type__c IN ('01','02') 
                                                AND profitability_category_type__c = 'Altas' ORDER BY account_id__c];
        Final Map<Id, List<Account_Profitability__c>> mapProfitability =  generateMapProfitability(lstBilling);
        Final Map<Integer, Map<Integer, String>> mapDates = calculateDates();
        response.columns = updColumns(mapDates, columns);
        Final List<Map<String, Object>> lstProfRecords = new List<Map<String, Object>>();
        Map<String, Object> mapTotalValues = new Map<String, Object>{'Id' => 'TOTAL', 'CLIENT_NAME' => 'TOTAL', 
                                                                'URL__Id' => URL.getSalesforceBaseUrl().toExternalForm() + '/' + replaceField.get(0), 
                                                                'MONTH_1' => 0, 'MONTH_2' => 0, 'MONTH_3' => 0, 'MONTH_4' => 0, 
                                                                'MONTH_5' => 0, 'MONTH_6' => 0, 'TOTAL_MONTHS' => 0};
		Map<String, Object> mapValues;
        for(Id accId: mapClients.keySet()) {
            mapValues = new Map<String, Object>{'Id' => accId, 'CLIENT_NAME' => mapClients.get(accId).Name, 
                                                                'URL__Id' => URL.getSalesforceBaseUrl().toExternalForm() + '/' + accId, 
                                                                'MONTH_1' => 0, 'MONTH_2' => 0, 'MONTH_3' => 0, 'MONTH_4' => 0, 
                                                                'MONTH_5' => 0, 'MONTH_6' => 0, 'TOTAL_MONTHS' => 0};
            if(mapProfitability.containsKey(accId) && !mapProfitability.get(accId).isEmpty()) {
                Decimal totalMonths = 0;
                for(Account_Profitability__c prof: mapProfitability.get(accId)) {
                    if(MAP_COLUMNS_MATCH.containsKey(prof.year_month_day_date__c.month())) {
                        mapValues.put('MONTH_'+ MAP_COLUMNS_MATCH.get(prof.year_month_day_date__c.month()), prof.currenct_mon_amount__c);
                        totalMonths += prof.currenct_mon_amount__c;
                    }
                }
                mapValues.put('TOTAL_MONTHS', totalMonths);
                mapTotalValues = getFixedTotal(mapValues, mapTotalValues);
            }
            lstProfRecords.add(mapValues);
        }
        lstProfRecords.add(mapTotalValues);
        response.data = lstProfRecords;
        return response;
    }

    /*
	 * @Description  Generate Map of Account_Profitability__c by Client
	 */
    public static Map<Id, List<Account_Profitability__c>> generateMapProfitability(Account_Profitability__c[] lstBilling) {
        Final Map<Id, List<Account_Profitability__c>> mapProfitability = new Map<Id, List<Account_Profitability__c>>();
        List<Account_Profitability__c> lstProfitability;
        for(Account_Profitability__c prof: lstBilling) {
            lstProfitability = new List<Account_Profitability__c>{prof};
            if(mapProfitability.containsKey(prof.account_id__c)) {
                lstProfitability.addAll(mapProfitability.get(prof.account_id__c));
            }
            mapProfitability.put(prof.account_id__c, lstProfitability);
        }
        return mapProfitability;
    }

    /*
	 * @Description  calculateDates
	 */
    private static Map<Integer, Map<Integer, String>> calculateDates() {
        Final Map<Integer, String> mapStrMonths = new Map<Integer, String>{1 => Label.Month1ShortName, 2 => Label.Month2ShortName, 3 => Label.Month3ShortName,
            4 => Label.Month4ShortName, 5 => Label.Month5ShortName, 6 => Label.Month6ShortName, 7 => Label.Month7ShortName, 8 => Label.Month8ShortName, 
            9 => Label.Month9ShortName, 10 => Label.Month10ShortName, 11 => Label.Month11ShortName, 12 => Label.Month12ShortName};
        Final Map<Integer, Map<Integer, String>> mapDates = new Map<Integer,Map<Integer, String>>();
        Integer currentMonth = System.today().month() - 1;
        for(Integer i = 1; i <= 6; i++) {
            if(currentMonth <= 0 ) {
                currentMonth = 12 - (currentMonth * -1);
            }
            MAP_COLUMNS_MATCH.put(currentMonth, i);
            mapDates.put(i, new Map<Integer, String>{currentMonth => mapStrMonths.get(currentMonth)});
            currentMonth--;
        }
        return mapDates;
    }
    
     /*
	 * @Description  updColumns
	 */
    private String updColumns(Map<Integer, Map<Integer, String>> mapDates, String columns) {
        String updColumns = columns;
        for(Integer key: mapDates.keySet()) {
            updColumns = updColumns.replace('LABEL_MONTH_'+key, mapDates.get(key).values()[0]);
        }
        return updColumns;
    }

    /*
	 * @Description  getFixedTotal
	 */
    private Map<String, Object> getFixedTotal(Map<String, Object> mapValues, Map<String, Object> mapTotalValues) {
        for(String key: mapValues.keySet()) {
            if(key != 'Id' && key != 'CLIENT_NAME' && key != 'URL__Id') {
                mapTotalValues.put(key, (Decimal) mapTotalValues.get(key) + (Decimal) mapValues.get(key));
            }
        }
        return mapTotalValues;
    }
}