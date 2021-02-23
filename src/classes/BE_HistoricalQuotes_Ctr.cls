/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_HistoricalQuotes_Ctr>
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2021-02-16
   @Description Controller class of BE_HistoricalQuotes_Lwc
   @Changes
   Date        Author   Email                  				Type		Description
   2021-02-16  MAMC     martin.mori.contractor@bbva.com    	Creation
   -------------------------------------------------------------------------------------------------
 */
public with sharing class BE_HistoricalQuotes_Ctr {
    /* string grantingtickets */
    final static String STRKEYPROD = 'product';
    /* string ListQuotationRequests */
    final static String STRKEYDATE = 'dateCotiza';
    /* string six result */
    final static String FIFTEEN = '15';
    
    /* constructor of class */
    private BE_HistoricalQuotes_Ctr() {
    }
    
    /**Method used to get quotes **/
	@AuraEnabled
    public static Map<String, Object> getQuotes(String accId, String config, String numPag) {
        Final Map<String, Object> mapReturn = new Map<String, Object>();
        try {
            Final Map<String, String> mapProds = new Map<String, String>();
            for(Product2 prod : [SELECT Id, Name, PRICE_APPROVAL_WEB_SERVICE_ID__C FROM Product2 WHERE TYPE_OF_QUOTE__C='Web']) {
                if(prod.PRICE_APPROVAL_WEB_SERVICE_ID__C == FIFTEEN) {
                    prod.Name = 'Carta fianza';
                }
                mapProds.put(prod.PRICE_APPROVAL_WEB_SERVICE_ID__C, prod.Name);
            }
            Final Account acc = [SELECT Id, main_code_id__c FROM Account WHERE Id = :accId LIMIT 1];
            Final List<Field__mdt> fields = [SELECT Id, DeveloperName, Use_Product_Configuration_Value__c, Field_Custom_Label__c, default_value__c, field_api_name__c, order__c FROM Field__mdt WHERE field_form__r.unique_id__c = :config ORDER BY order__c];
            Final List<Object> columns = new List<Object>();
            for(Field__mdt field : fields) {
                columns.add(JSON.deserializeUntyped(field.default_value__c));
            }
            mapReturn.put('columns', columns);
            Final List<Object> rows = new List<Object>();
            Final BE_ListQuotationRequest_Helper listQuoteHelper = new BE_ListQuotationRequest_Helper(acc.main_code_id__c, numPag, '10');
            Final System.HttpResponse invoke = listQuoteHelper.invoke();
            switch on invoke.getStatusCode() {
                when 200 {
                    Final Map<String, Object> response = (Map<String, Object>) JSON.deserializeUntyped(invoke.getBody());
                    Final Map<String, Object> pagination = (Map<String, Object>) response.get('pagination');
                    mapReturn.put('totalPages', pagination.get('totalPages'));
                    mapReturn.put('totalElements', pagination.get('totalElements'));
                    Final List<Object> data = (List<Object>) response.get('data');
                    for(Object item : data) {
                        String row = '{';
                        Final Map<String, Object> itemMap = (Map<String, Object>) item;
                        for(Field__mdt field : fields) {
                            row = readData(row, field, itemMap, mapProds);
                        }
                        row = row.removeEnd(',')+'}';
                        rows.add(JSON.deserializeUntyped(row));
                    }
                }
            }
            mapReturn.put('rows', rows);
        } catch(Exception ex) {
            mapReturn.put('errorMessage', ex.getMessage());
        }
        return mapReturn;
    }
    
    /**Method used to read data response **/
	private static String readData(String rowAux, Field__mdt field, Map<String, Object> itemMap, Map<String, String> mapProds) {
        String row = rowAux;
        final String[] fieldSplit = field.field_api_name__c.split('\\.');
        Integer posField = 0;
        Final List<Object> quotations = (List<Object>) itemMap.get(fieldSplit[posField]);
        Map<String, Object> auxMap = (Map<String, Object>) quotations[0];
        if(!auxMap.isEmpty()) {
            posField++;
            while(posField < fieldSplit.size()) {
                if(posField == fieldSplit.size()-1) {
                    if(field.Use_Product_Configuration_Value__c) {
                        row = readArrayResponse(row, field, auxMap, fieldSplit[posField]);
                    } else {
                        String valAux = String.valueOf(auxMap.get(fieldSplit[posField]));
                        if(field.DeveloperName == STRKEYDATE) {
                            valAux = valAux.substring(0, 23)+'Z';
                        } else if(field.DeveloperName == STRKEYPROD) {
                            valAux = mapProds.get(valAux);
                        }
                        row += '"'+field.DeveloperName+'": "'+valAux+'",';
                    }
                } else {
                    auxMap = (Map<String, Object>) auxMap.get(fieldSplit[posField]);
                }
                posField++;
            }
        }
        return row;
    }
    
    /**Method used to read array of response **/
	private static String readArrayResponse(String rowAux, Field__mdt field, Map<String, Object> auxMap, String fieldObj) {
        String row = rowAux;
        Final List<Object> ltsAux = (List<Object>) auxMap.get(fieldObj);
        for(Object objList : ltsAux) {
            Final Map<String, Object> objMap = (Map<String, Object>) objList;
            if(String.valueOf(objMap.get('id'))==field.DeveloperName) {
                row += '"'+field.DeveloperName+'": "'+objMap.get(field.Field_Custom_Label__c)+'",';
                break;
            }
        }
        return row;
    }
}