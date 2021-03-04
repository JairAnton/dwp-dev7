/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_SRL_Views_Ctr>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2020-03-03
   @Description Class to get List of Metadata Options
   @Changes
   Date        Author   Email                  Type
   2020-03-03  LMBR     lolo.bravo@bbva.com    Creation
   -------------------------------------------------------------------------------------------------
 */
public with sharing class BE_SRL_Views_Ctr {
    /** Private Views */
    private BE_SRL_Views_Ctr() {}
    /**
    @Description return about setting metadata
    @param nameMetaData developerName
    @return a List<SObject> with information setting metadata
    */
    @AuraEnabled(cacheable=true)
    public static List<ViewOptions> getConfigMeta(String nameMetaData) {
        Final List<ViewOptions> metaData= new List<ViewOptions>();
        for (BE_SingleRelatedList_Setting__mdt srlItem : [SELECT MasterLabel,DeveloperName,Order__c FROM BE_SingleRelatedList_Setting__mdt WHERE BE_SingleRetatedListView__r.DeveloperName=: nameMetaData ORDER BY Order__c,DeveloperName ASC NULLS LAST]) {
            metaData.add(new ViewOptions(srlItem.MasterLabel,srlItem.DeveloperName));
        }
        System.debug(metaData);
        return metaData;
    }
    /**
     * ViewOptions Class
     */
    public class ViewOptions {
        /** Label */
        @AuraEnabled
        public String label {set;get;}
        /** Value */
        @AuraEnabled
        public String value {set;get;}
        /** Constructor */
        public ViewOptions() {}
        /**
         * Constructor
         * @param label
         * @param value
         */
        public ViewOptions(String label, String value) {
            this.label=label;
            this.value=value;
        }
    }
}