/**
 * BE_EconomicGroup_Position_cls
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		07/09/2020          Original version.<p />
 *
 * @author Diego Carbajal
 */
public with sharing class BE_EconomicGroup_Position_cls extends Be_DTP_ResponseModel_cls {
    
    /*
	 * @Description  Get Custom Data for BBVA Information
	 */
    public override Be_DTP_ResponseModel_cls.Response getData(Map<String, String> mapParams, String columns, List<String> replaceField) {
        Final Be_DTP_ResponseModel_cls.Response response = new Be_DTP_ResponseModel_cls.Response(true);
        response.columns = columns;
        replaceField.add(mapParams.get('recordId'));
        Final Map<Id, Account> mapClients = new Map<Id, Account>([SELECT Id, Name FROM Account WHERE parentId IN: replaceField]);
        Final list<AggregateResult> listInfoBBVA = [SELECT account_id__r.Id clientId, product_group_classification_id__c, type__c, 
                                            MIN(account_id__r.bank_turnover_volume_amount__c) exp1, SUM(average_balance_amount__c) exp2 
                                            FROM Account_BBVA_Information__c where account_id__r.ParentId IN: replaceField AND
                                            type__c IN ('01', '02') AND product_group_classification_id__c != '' AND 
                                            is_last_date__c = true GROUP BY account_id__r.id, product_group_classification_id__c, 
                                            type__c ORDER BY account_id__r.Id];
        Final Map<Id, List<AggregateResult>> mapAggr = generateMapAggregate(listInfoBBVA);
        Final List<Map<String, Object>> lstMapValues = new List<Map<String, Object>>();
        for(Id accId: mapClients.keySet()) {
            if(mapAggr.containsKey(accId) && !mapAggr.get(accId).isEmpty()) {
                lstMapValues.add(getValue(mapAggr.get(accId), accId, mapClients.get(accId).Name));
            } else {
                lstMapValues.add(new Map<String, Object>{'Id' => accId, 'CLIENT_NAME' => mapClients.get(accId).Name, 
                                                        'VOLUMEN' => 0, 'DIRECTA' => 0, 'INDIRECTA' => 0, 'RECURSO' => 0, 
                                                        'URL__Id' => URL.getSalesforceBaseUrl().toExternalForm() + '/' + accId});
            }
        }
        response.data = lstMapValues;
        return response;
    }

    /*
	 * @Description  Generate Map of Aggregate by Client
	 */
    public static Map<Id, List<AggregateResult>> generateMapAggregate(AggregateResult[] lstAggregate) {
        Final Map<Id, List<AggregateResult>> mapAggregate = new Map<Id, List<AggregateResult>>();
        List<AggregateResult> lstAggreAux;
        for(AggregateResult aggr: lstAggregate) {
            lstAggreAux = new List<AggregateResult>{aggr};
            if( mapAggregate.containsKey((Id)aggr.get('clientId')) ) {
                lstAggreAux.addAll(mapAggregate.get((Id)aggr.get('clientId')));
            }
            mapAggregate.put((Id)aggr.get('clientId'), lstAggreAux);
        }
        return mapAggregate;
    }

    /*
	 * @Description  Obtain values
	 */
    private static Map<String, Object> getValue(List<AggregateResult> lstAgr, Id accId, String clientName) {
        Double vol = 0, ind = 0, dir = 0, res = 0;
        for(AggregateResult agr: lstAgr) {
            if((String)agr.get('product_group_classification_id__c') == label.LblDirectDebt && (String)agr.get('type__c') == '01') {
                dir = (Double)agr.get('exp2');
            } else if ((String)agr.get('product_group_classification_id__c') == label.LblIndirectDebt && (String)agr.get('type__c') == '01') {
                ind = (Double)agr.get('exp2');
            } else if((String)agr.get('product_group_classification_id__c') == label.LblResources && (String)agr.get('type__c') == '02') {
                res = (Double)agr.get('exp2');
            }
            vol = (Double) agr.get('exp1');
        }
        return new Map<String, Object>{'Id' => accId, 'CLIENT_NAME' => clientName, 'VOLUMEN' => vol, 
                                        'DIRECTA' => dir, 'INDIRECTA' => ind, 'RECURSO' => res, 
                                        'URL__Id' => URL.getSalesforceBaseUrl().toExternalForm() + '/' + accId};
    }
}