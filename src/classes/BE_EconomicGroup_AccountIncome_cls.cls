/**
 * BE_EconomicGroup_AccountIncome_cls
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		04/09/2020          Original version.<p />
 *
 * @author Diego Carbajal
 */
public with sharing class BE_EconomicGroup_AccountIncome_cls extends Be_DTP_ResponseModel_cls {
    
    /*
	 * @Description  Get Custom Data for Account Income
	 */
    public override Be_DTP_ResponseModel_cls.Response getData(Map<String, String> mapParams, String columns, List<String> replaceField) {
        Final Be_DTP_ResponseModel_cls.Response response = new Be_DTP_ResponseModel_cls.Response(true);
        replaceField.add(mapParams.get('recordId'));
        Final Map<Id, Account> mapClients = new Map<Id, Account>([SELECT Id, Name FROM Account WHERE parentId IN: replaceField]);
        Final Account_Income__c[] lstAccInc = [SELECT Id, account_id__c, Period__c, Type_Label__c, gf_income_amount__c, 
                                        gf_income_movement_date__c, gf_income_type__c, unique_id__c FROM Account_Income__c WHERE 
                                        account_id__c IN: mapClients.keySet() AND Type_Label__c = 'Saldo Medio Anual' 
                                        ORDER BY gf_income_movement_date__c desc];
        Final Integer thisYear = System.today().year();
        Final Map<String, String> mapHeaders = new Map<String, String>{'CURRENT_YEAR_USD' => 'THIS_YEAR_USD', 
                                                                        'CURRENT_YEAR_PEN' => 'THIS_YEAR_PEN',
                                                                        'PAST_YEAR_USD' => 'PREV_YEAR_USD',
                                                                        'PAST_YEAR_PEN' => 'PREV_YEAR_PEN'};
        Final Map<String, String> mapDates = new Map<String, String>{'CURRENT_YEAR_USD' => thisYear + ' USD', 
                                                                    'CURRENT_YEAR_PEN' => thisYear + ' PEN', 
                                                                    'PAST_YEAR_USD' => (thisYear - 1) + ' USD',
                                                                    'PAST_YEAR_PEN' => (thisYear - 1) + ' PEN'};
        response.columns = updColumns(mapDates, mapHeaders, columns);
        Final Map<Id, List<Account_Income__c>> mapAccInc = generateMapAccInc(lstAccInc);
        Final List<Map<String, Object>> lstAccIncRecord = new List<Map<String, Object>>();
        for(Id accId: mapClients.keySet()) {
            Map<String, Object> mapValues = new Map<String, Object>{'Id' => accId, 'CLIENT_NAME' => mapClients.get(accId).Name, 
                                                                    'URL__Id' => URL.getSalesforceBaseUrl().toExternalForm() + '/' + accId, 
                                                                    'CURRENT_YEAR_USD' => 0, 'CURRENT_YEAR_PEN' => 0, 'PAST_YEAR_USD' => 0, 
                                                                    'PAST_YEAR_PEN' => 0};
            if(mapAccInc.containsKey(accId) && !mapAccInc.get(accId).isEmpty()) {
                for(Account_Income__c accInc: mapAccInc.get(accId)) {
                    mapValues = getValuesByType(mapValues, accInc, mapDates);
                }
            }
            lstAccIncRecord.add(mapValues);
        }
        response.data = lstAccIncRecord;
        return response;
    }

    /*
	 * @Description  Generate Map of Account_Income__c by Client
	 */
    private Map<Id, List<Account_Income__c>> generateMapAccInc(Account_Income__c[] lstAccInc) {
        Final Map<Id, List<Account_Income__c>> mapAccInc = new Map<Id, List<Account_Income__c>>();
        List<Account_Income__c> lstAccIncAux;
        for(Account_Income__c accInc: lstAccInc) {
            lstAccIncAux = new List<Account_Income__c>{accInc};
            if(mapAccInc.containsKey(accInc.account_id__c)) {
                lstAccIncAux.addAll(mapAccInc.get(accInc.account_id__c));
            }
            mapAccInc.put(accInc.account_id__c, lstAccIncAux);
        }
        return mapAccInc;
    }

    /*
	 * @Description  getValuesByType
	 */
    private Map<String, Object> getValuesByType(Map<String, Object> mapValues, Account_Income__c accInc, Map<String, String> mapDates) {
        for(String yearMon: mapDates.keySet()) {
            if(accInc.Period__c == mapDates.get(yearMon)) {
                mapValues.put(yearMon, accInc.gf_income_amount__c);
                break;
            }
        }
        return mapValues;
    }

    /*
	 * @Description  Update columns to be dynamic
	 */
    private String updColumns(Map<String, String> mapDates, Map<String, String> mapHeaders, String columns) {
        String updColumns = columns;
        for(String key: mapDates.keySet()) {
            updColumns = updColumns.replace(mapHeaders.get(key), mapDates.get(key));
        }
        return updColumns;
    }
}