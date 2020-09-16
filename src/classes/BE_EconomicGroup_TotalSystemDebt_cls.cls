/**
 * BE_EconomicGroup_TotalSystemDebt_cls
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		04/09/2020          Original version.<p />
 *
 * @author Diego Carbajal
 */
public with sharing class BE_EconomicGroup_TotalSystemDebt_cls extends Be_DTP_ResponseModel_cls {
    
    /** @Description  SCOTIA*/
    static Final String SCOTIA = 'SCOTIA';
    /** @Description  OTROS*/
    static Final String OTROS = 'OTROS';
    /** @Description  IBK*/
    static Final String IBK = 'IBK';
    /** @Description  BCP*/
    static Final String BCP = 'BCP';
    /** @Description  BBVA*/
    static Final String BBVA = 'BBVA';
    
    /*
	 * @Description  Get Custom Data for Total System Debt
	 */
    public override Be_DTP_ResponseModel_cls.Response getData(Map<String, String> mapParams, String columns, List<String> replaceField) {
        Final Be_DTP_ResponseModel_cls.Response response = new Be_DTP_ResponseModel_cls.Response(true);
        response.columns = columns;
        replaceField.add(mapParams.get('recordId'));
        Final Map<Id, Account> mapClients = new Map<Id, Account>([SELECT Id, Name FROM Account WHERE parentId IN: replaceField]);
        Final Account_Banking_System_Debt__c[] lstSystDebt = [SELECT account_id__c, debt_current_balance_amount__c, 
                                                            entity_name__c, is_last_date__c, product_group_classification_id__c, 
                                                            CurrencyIsoCode FROM Account_Banking_System_Debt__c WHERE 
                                                            account_id__c IN: mapClients.keySet() AND product_desc_calc__c = '' 
                                                            AND product_desc__c = '' AND is_last_date__c = true AND 
                                                            product_group_classification_id__c = 'TOTAL' ORDER BY account_id__c];
        //Generate map by client and their SystDebt
        Final Map<Id, List<Account_Banking_System_Debt__c>> mapSystDebtByAcc = BE_EconomicGroup_DebtAndFee_cls.generateMapSystDebt(lstSystDebt);
        //Generate Data to show
        Final List<Map<String, Object>> lstSystDebtRecord = new List<Map<String, Object>>();
        Map<String, Object> mapTotalValues = new Map<String, Object>{'Id' => 'TOTAL', 'CLIENT_NAME' => 'TOTAL', BBVA => 0, BCP => 0, 
                                                                    SCOTIA => 0, IBK => 0, OTROS => 0, 'TOTAL_SBS' => 0, 
                                                                    'URL__Id' => URL.getSalesforceBaseUrl().toExternalForm() + '/' + replaceField.get(0)};
        for(Id accId: mapClients.keySet()) {
            //Get ClientId and Name
            Map<String, Object> mapValues = new Map<String, Object>{'Id' => accId, 'CLIENT_NAME' => mapClients.get(accId).Name, BBVA => 0, 
                                                                    BCP => 0, SCOTIA => 0, IBK => 0, OTROS => 0, 'TOTAL_SBS' => 0, 
                                                                    'URL__Id' => URL.getSalesforceBaseUrl().toExternalForm() + '/' + accId};
            //If a client have SystDebt
            if(mapSystDebtByAcc.containsKey(accId) && !mapSystDebtByAcc.get(accId).isEmpty()) {
                Decimal totalSBSRecord = 0;
                for(Account_Banking_System_Debt__c systDebt: mapSystDebtByAcc.get(accId)) {
                    mapValues = updSystDebtByBanking(mapValues, systDebt);
                    totalSBSRecord += systDebt.debt_current_balance_amount__c;
                }
                mapValues.put('TOTAL_SBS', totalSBSRecord);
                mapTotalValues = getFixedTotal(mapValues, mapTotalValues);
            }
            lstSystDebtRecord.add(mapValues);
        }
        lstSystDebtRecord.add(mapTotalValues);
        response.data = lstSystDebtRecord;
        return response;
    }

    /*
	 * @Description  get debt by Bank
	 */
    private Map<String, Object> updSystDebtByBanking(Map<String, Object> mapValues, Account_Banking_System_Debt__c systDebt) {
        switch on systDebt.entity_name__c {
            when 'BBVA' {
                mapValues.put(BBVA, systDebt.debt_current_balance_amount__c);
            }
            when 'BCP' {
                mapValues.put(BCP, systDebt.debt_current_balance_amount__c);
            }
            when 'SCOTIA' {
                mapValues.put(SCOTIA, systDebt.debt_current_balance_amount__c);
            }
            when 'IBK' {
                mapValues.put(IBK, systDebt.debt_current_balance_amount__c);
            }
            when 'OTROS' {
                mapValues.put(OTROS, systDebt.debt_current_balance_amount__c);
            }
        }
        return mapValues;
    }

    /*
	 * @Description  fix value
	 */
    private Map<String, Object> getFixedTotal(Map<String, Object> mapValues, Map<String, Object> mapTotalValues) {
        for(String key: mapValues.keySet()) {
            if(key != 'Id' && key != 'CLIENT_NAME' && key != 'URL__Id') {
                mapTotalValues.put(key, (Decimal) mapValues.get(key));
            }
        }
        return mapTotalValues;
    }
}