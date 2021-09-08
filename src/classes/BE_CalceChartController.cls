public with sharing class BE_CalceChartController {
    @TestVisible
    private BE_CalceChartController(){
        // constructor
      }
    /* controlador para el dashboard calce */
    @AuraEnabled(cacheable=true)
    public static List<AggregateResult> getCalceChart() {
        /*obtener data de calce neto (recursos, directo e indirecto)*/   
     return [SELECT SUM(net_direct_calce__c) netDirect, SUM(net_indirect_calce__c) netIndirect, SUM(net_resource_calce__c) netResource from Calce__c where Get_Date__c=TODAY and CheckUser__c = true];
    }  
}
