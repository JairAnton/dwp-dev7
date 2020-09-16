/**
 * ------------------------------------------------------------------------------------------------
 * @Name BE_DTP_AttributeConfiguration_cls
 * @Author Diego Carbajal diego.carbajal@bbva.com
 * @Date Created: 2020-09-03
 * @Group
 * @Description Controller class BE_DTP_FilterParse_cls
 */
public with sharing class BE_DTP_AttributeConfiguration_cls {

    /**@Descriptions sonar*/
    @AuraEnabled
	public static String sonar {get; set;}
    
    /**@Description private BE_DTP_AttributeConfiguration_cls Constructor*/
    private BE_DTP_AttributeConfiguration_cls() {}

    /*
	 * @Description  Class SOQLQuery
	 */
    public virtual class SOQLQuery {

        /**@Descriptions code*/
        @AuraEnabled
        public String code {get; set;}
        /**@Descriptions ObjectType*/
        @AuraEnabled
        public String sObjectType {get; set;}
        /**@Description queryFields*/
        @AuraEnabled
        public String queryFields {get; set;}
        /**@Description queryFilters*/
        @AuraEnabled
        public String queryFilters {get; set;}

    }

}