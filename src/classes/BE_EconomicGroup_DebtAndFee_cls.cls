/**
 * BE_EconomicGroup_DebtAndFee_cls
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		04/09/2020          Original version.<p />
 *
 * @author Diego Carbajal
 */
public with sharing class BE_EconomicGroup_DebtAndFee_cls extends Be_DTP_ResponseModel_cls {
    
    /** @Description  TOTAL_BBVA*/
    static Final String TOTAL_BBVA = 'TOTAL_BBVA';
    /** @Description  INDIRECTA_BBVA*/
    static Final String INDIRECTA_BBVA = 'INDIRECTA_BBVA';
    /** @Description  DIRECTA_BBVA*/
    static Final String DIRECTA_BBVA = 'DIRECTA_BBVA';
    
    /*
	 * @Description  Get Custom Data for Debt and Fee
	 */
    public override Be_DTP_ResponseModel_cls.Response getData(Map<String, String> mapParams, String columns, List<String> replaceField) {
        Final Be_DTP_ResponseModel_cls.Response response = new Be_DTP_ResponseModel_cls.Response(true);
        response.columns = columns;
        replaceField.add(mapParams.get('recordId'));
        Final Map<Id, Account> mapClients = new Map<Id, Account>([SELECT Id, Name FROM Account WHERE parentId IN: replaceField]);
        Final Account_Banking_System_Debt__c[] lstSystDebt = [SELECT account_id__c, debt_current_balance_amount__c, entity_name__c, debt_quote_amount__c, is_last_date__c, 
                                                              CurrencyIsoCode, year_month_day_date__c, product_group_classification_id__c FROM Account_Banking_System_Debt__c 
                                                              WHERE account_id__c IN: mapClients.keySet() AND is_last_date__c = true AND product_desc__c = '' AND 
                                                              product_desc_calc__c = '' ORDER BY account_id__c];
        //Generate map by client and their SystDebt
        Final Map<Id, List<Account_Banking_System_Debt__c>> mapSystDebtByAcc = generateMapSystDebt(lstSystDebt);
        //Generate Data to show
        Final List<Map<String, Object>> lstSystDebtRecord = new List<Map<String, Object>>();
        Final Map<String, Object> mapTotalValues = new Map<String, Object>{'Id' => 'TOTAL', 'CLIENT_NAME' => 'TOTAL', TOTAL_BBVA => 0, DIRECTA_BBVA => 0,
																	INDIRECTA_BBVA => 0, 'URL__Id' => URL.getSalesforceBaseUrl().toExternalForm() + '/' + replaceField.get(0)};
        Decimal totalBBVA = 0, clientDirect = 0, clientIndirect = 0;
        Map<String, Object> mapValues;
        for(Id accId: mapClients.keySet()) {
            //Get ClientId and Name
            mapValues = new Map<String, Object>{'Id' => accId, 'CLIENT_NAME' => mapClients.get(accId).Name, TOTAL_BBVA => 0, DIRECTA_BBVA => 0, 
										INDIRECTA_BBVA => 0, 'CUOTA_BBVA' => '0 %', 'URL__Id' => URL.getSalesforceBaseUrl().toExternalForm() + '/' + accId};
            //If a client have SystDebt
            if(mapSystDebtByAcc.containsKey(accId) && !mapSystDebtByAcc.get(accId).isEmpty()) {
                for(Account_Banking_System_Debt__c systDebt: mapSystDebtByAcc.get(accId)) {
                    mapValues = updSystDebt(mapValues, systDebt);
                }
                //Obtain Total values by field
                totalBBVA += (Decimal) mapValues.get(TOTAL_BBVA);
                clientDirect += (Decimal) mapValues.get(DIRECTA_BBVA);
                clientIndirect += (Decimal) mapValues.get(INDIRECTA_BBVA);
            }
            lstSystDebtRecord.add(mapValues);
        }
        mapTotalValues.put(TOTAL_BBVA, totalBBVA);
        mapTotalValues.put(DIRECTA_BBVA, clientDirect);
        mapTotalValues.put(INDIRECTA_BBVA, clientIndirect);
        lstSystDebtRecord.add(mapTotalValues);
        response.data = lstSystDebtRecord;
        return response;
    }

    /*
	 * @Description  Generate Map of SystDebt by Client
	 */
    public static Map<Id, List<Account_Banking_System_Debt__c>> generateMapSystDebt(Account_Banking_System_Debt__c[] lstSystDebt) {
        Final Map<Id, List<Account_Banking_System_Debt__c>> mapSystDebtByAcc = new Map<Id, List<Account_Banking_System_Debt__c>>();
        List<Account_Banking_System_Debt__c> lstSystDebtAux;
        for(Account_Banking_System_Debt__c systDebt: lstSystDebt) {
            lstSystDebtAux = new List<Account_Banking_System_Debt__c>{systDebt};
            if(mapSystDebtByAcc.containsKey(systDebt.account_id__c)) {
                lstSystDebtAux.addAll(mapSystDebtByAcc.get(systDebt.account_id__c));
            }
            mapSystDebtByAcc.put(systDebt.account_id__c, lstSystDebtAux);
        }
        return mapSystDebtByAcc;
    }

    /*
	 * @Description  Get SystDebt Total Total BBVA, Directa BBVA, INDIRECT BBVA and Cuota BBVA
	 */
    private Map<String, Object> updSystDebt(Map<String, Object> mapValues, Account_Banking_System_Debt__c systDebt) {
        if(systDebt.product_group_classification_id__c == 'TOTAL' && systDebt.entity_name__c == 'BBVA') {
            mapValues.put(TOTAL_BBVA, systDebt.debt_current_balance_amount__c);
            mapValues.put('CUOTA_BBVA', systDebt.debt_quote_amount__c + ' %');
        } else if(systDebt.product_group_classification_id__c == 'DIRECTA' && systDebt.entity_name__c == 'BBVA') {
            mapValues.put(DIRECTA_BBVA, systDebt.debt_current_balance_amount__c);
        } else if(systDebt.product_group_classification_id__c == 'INDIRECTA' && systDebt.entity_name__c == 'BBVA') {
            mapValues.put(INDIRECTA_BBVA, systDebt.debt_current_balance_amount__c);
        }
        return mapValues;
    }
    
}