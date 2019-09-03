/**
* ------------------------------------------------------------------------------------------------
* @Name Dwp_Utils_helper
* @Author Diego Carbajal diego.carbajal.contractor@bbva.com
* @Date Created: 2019-08-28
* @Group 
* @Description Esta clase contiene metodos de ayuda reutilizables y genericos
*/
public class Dwp_Utils_helper {

    /*Method for validate Regex Format*/
    public static Map<String, Object> validateFormatt(String regex, String input) {
        Map<String, Object> mapRes = new Map<String, Object>{'isError' => true, 'validateError' => 'Empty'};
        if(!String.isEmpty(input)) {
            if(Pattern.matches(regex, input)) {
                mapRes.put('isError', false);
            }else {
                mapRes.put('validateError', 'NoMatches');
            }
        }
        return mapRes;
    }
    
    /*Method to get Picklist values from Picklist field*/
    public static Map<String, String> getPicklistValues(String objectName, String field_apiname) {
        Map<String, String> mapValues = new Map<String, String>();
        Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
        Map<String, Schema.SObjectField> field_map = gd.get(objectName.toLowerCase()).getDescribe().fields.getMap(); 
        List<Schema.PicklistEntry> picklistValues = field_map.get(field_apiname).getDescribe().getPickListValues();
        for (Schema.PicklistEntry pv : picklistValues) {
            mapValues.put(pv.getValue(), pv.getLabel());
        }
        return mapValues;
    }
    
    /*Method to get List View Id*/
    public static Map<String, Object> getListView(String sobj, String devName) {
        Final Map<String, Object> mapRes=new Map<String, Object>{'isError' => true};
        Final List<ListView> listViews = [SELECT Id, Name FROM ListView WHERE SobjectType =: sobj AND DeveloperName =: devName];
        Final Integer listViewsSize= listViews.size();
        if(listViewsSize > 0) {
            mapRes.put('isError', false);
            mapRes.put('listView', listViews);
        }
        return mapRes;
    }
    
}