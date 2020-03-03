/*
* ------------------------------------------------------------------------------------------------
* @Name Dwp_Utils_helper
* @Author Diego Carbajal diego.carbajal.contractor@bbva.com
* @Date Created: 2019-08-28
* @Group 
* @Description Esta clase contiene metodos de ayuda reutilizables y genericos
*/
public with sharing class Dwp_Utils_helper {

    /*Campo IS_ERROR inicializado para soluciones del SonarQ*/
    public static Final String IS_ERROR = 'isError';
    
    /*Method for validate Regex Format*/
    public static Map<String, Object> validateFormatt(String regex, String input) {
        Final Map<String, Object> mapRes = new Map<String, Object>{IS_ERROR => true, 'validateError' => 'Empty'};
        if(!String.isEmpty(input)) {
            if(Pattern.matches(regex, input)) {
                mapRes.put(IS_ERROR, false);
            } else {
                mapRes.put('validateError', 'NoMatches');
            }
        }
        return mapRes;
    }
    
    /*Method to get Picklist values from Picklist field*/
    public static Map<String, String> getPicklistValues(String objectName, String fieldApiname) {
        Final Map<String, String> mapValues = new Map<String, String>();
        Final Map<String,Schema.SObjectType> ggd = Schema.getGlobalDescribe(); 
        Final Map<String, Schema.SObjectField> fieldMap = ggd.get(objectName.toLowerCase()).getDescribe().fields.getMap(); 
        Final List<Schema.PicklistEntry> picklistValues = fieldMap.get(fieldApiname).getDescribe().getPickListValues();
        for (Schema.PicklistEntry pv : picklistValues) {
            mapValues.put(pv.getValue(), pv.getLabel());
        }
        return mapValues;
    }
    
    /*Method to get List View Id*/
    public static Map<String, Object> getListView(String sobj, String devName) {
        Final Map<String, Object> mapRes=new Map<String, Object>{IS_ERROR => true};
        Final List<ListView> listViews = [SELECT Id, Name FROM ListView WHERE SobjectType =: sobj AND DeveloperName =: devName];
        Final Integer listViewsSize= listViews.size();
        if(listViewsSize > 0) {
            mapRes.put(IS_ERROR, false);
            mapRes.put('listView', listViews);
        }
        return mapRes;
    }
    
    /*Method to get formatAmount*/
    public static String formatAmount(Decimal importe, String iso){
        String stringAmount = ( Decimal.valueOf(importe == null || String.valueOf(importe).trim() == '' ? '0' : String.valueOf(importe)).setScale(2) + 0.001 ).format();
        stringAmount = stringAmount.substring(0, stringAmount.length()-1);
        return iso + ' ' + stringAmount;
    }
    
    public static Boolean sObjectAccessCRUD(String sObjName, String access) {
        Boolean result;
        Schema.DescribeSObjectResult sObjResult = Schema.getGlobalDescribe().get(sObjName).getDescribe();
        switch on access {
            when 'isCreateable' {
                result = sObjResult.isCreateable();
            }
            when 'isAccessible' {
                result = sObjResult.isAccessible();
            }
            when 'isUpdateable' {
                result = sObjResult.isUpdateable();
            }
            when 'isDeletable' {
                result = sObjResult.isDeletable();
            }
        }
        return result;
    }
    
    public static Map<String, Object> deletesObjectRecord(String sObj, String recordId) {
        Map<String, Object> resDelete = new Map<String, Object>{'isSuccess' => false};
        List<SObject> sObjDel = Database.query('SELECT Id FROM '+sObj+' WHERE Id=:recordId');
        if(sObjDel.size() > 0) {
            delete sObjDel;
            resDelete.put('isSuccess', true);
        } else {
            resDelete.put('message', 'No se ha podido encontrar el registro seleccionado.');
        }
        return resDelete;
    }
}