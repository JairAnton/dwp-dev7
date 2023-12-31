/* controlador para el dashboard calce */
public with sharing class BE_CalceChartController {
    /* controlador */
        private BE_CalceChartController() { }
        /* constructor para el dashboard calce */
     
        
        /*Obtener resumen calce*/
        @AuraEnabled(cacheable=true)
        public static List<AggregateResult> getCalceChart() {      
            return [SELECT SUM(net_direct_calce__c) netDirect, SUM(net_indirect_calce__c) netIndirect, SUM(net_resource_calce__c) netResource from Calce__c where Get_Date__c=TODAY and CheckUser__c = true];     
             }
			 
		/*Obtener report ID*/
        @AuraEnabled(cacheable=true)
        public static String  getReportID(String reportName) {      
            return [SELECT Id,Name FROM Report WHERE Name=:reportName LIMIT 1]?.Id;    
             }
        }
