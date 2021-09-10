public with sharing class BE_CalceChartController {
    
    private BE_CalceChartController() { }
    /* controlador para el dashboard calce */
 
    
    /*Obtener resumen calce*/
    @AuraEnabled(cacheable=true)
    public static List<AggregateResult> getCalceChart() {  
        
   		final List<AggregateResult> resultList = [SELECT SUM(net_direct_calce__c) netDirect, SUM(net_indirect_calce__c) netIndirect, SUM(net_resource_calce__c) netResource from Calce__c where Get_Date__c=TODAY and CheckUser__c = true];
   
    	 return resultList;
 
        	
		 }  
    
    
  
	}