/**
 * ------------------------------------------------------------------------------------------------
 * @Name BE_DTP_ReplaceConfigParser_cls
 * @Author Diego Carbajal diego.carbajal@bbva.com
 * @Date Created: 2020-09-03
 * @Group
 * @Description Controller class BE_DTP_FilterParse_cls
 */
public with sharing class BE_DTP_ReplaceConfigParser_cls {
    
    /**@Description sonar*/
	@AuraEnabled
	public String sonar {get; set;}
    
    /**@Description private BE_DTP_ReplaceConfigParser_cls Constructor*/
    private  BE_DTP_ReplaceConfigParser_cls() {}

    /**@Description Get Filters by Map*/
    public static Map<String, ReplaceConfig> getMapRecords(Be_Dynamic_Table_Presentation__mdt mdt) {
        Final Map<String, ReplaceConfig> mapReplaceConfig = new Map<String, ReplaceConfig>();
        Final List<ReplaceConfig> lstReplaceConfig = (List<ReplaceConfig>) parseRecords(mdt.Replace_Fields_Configuration__c);
        for(ReplaceConfig replace: lstReplaceConfig) {
            mapReplaceConfig.put(replace.code, replace);
        }
        return mapReplaceConfig;
    }

    /**@Description parseRecords*/
    public static List<ReplaceConfig> parseRecords(String body) {
        return (List<ReplaceConfig>) JSON.deserialize(body, List<ReplaceConfig>.class);
    }

    /**@Description parseRecord*/
    public static ReplaceConfig parseRecord(String body) {
        return (ReplaceConfig) JSON.deserialize(body, ReplaceConfig.class);
    }

    /**@Description Filter class*/
    public without sharing class ReplaceConfig extends BE_DTP_AttributeConfiguration_cls.SOQLQuery {

        /**@Description replaceField*/
        @AuraEnabled
        public String replaceField {get; set;}
        
        /**@Description ReplaceConfig*/
        private ReplaceConfig() {
            super();
        }
    }
}