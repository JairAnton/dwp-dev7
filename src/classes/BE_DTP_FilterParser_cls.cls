/**
 * ------------------------------------------------------------------------------------------------
 * @Name BE_DTP_FilterParser_cls
 * @Author Diego Carbajal diego.carbajal@bbva.com
 * @Date Created: 2020-09-03
 * @Group
 * @Description Controller class BE_DTP_FilterParse_cls
 */
public with sharing class BE_DTP_FilterParser_cls {
    
    /**@Description private BE_DTP_FilterParser_cls Constructor*/
    private BE_DTP_FilterParser_cls() {}

    /**@Description Get Filters by Map*/
    public static Map<String, Filter> getMapRecords(Be_Dynamic_Table_Presentation__mdt mdt) {
        Final Map<String, Filter> mapFilters = new Map<String, Filter>();
        Final List<Filter> lstFilters = (List<Filter>) parseRecords(mdt.Filters__c);
        for(Filter filtro: lstFilters) {
            mapFilters.put(filtro.code, filtro);
        }
        return mapFilters;
    }

    /**@Description parseRecords*/
    public static List<Filter> parseRecords(String body) {
        return (List<Filter>) JSON.deserialize(body, List<Filter>.class);
    }

     /**@Description Filter class*/
     public without sharing class Filter extends BE_DTP_AttributeConfiguration_cls.SOQLQuery {
        
        /**@Description filterId*/
        @AuraEnabled
        public Id filterId {get; set;}
        /**@Description label*/
        @AuraEnabled
        public String label {get; set;}
        /**@Description developerName*/
        @AuraEnabled
        public String developerName {get; set;}
        /**@Description defaultFilter*/
        @AuraEnabled
        public Boolean defaultFilter {get; set;}

    }
}