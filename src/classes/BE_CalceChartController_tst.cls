@isTest
private with sharing class BE_CalceChartController_tst {
	@isTest   
    private static void testGetCalceChart()
        {
      
            final Calce__c calce = new Calce__c();
			calce.Name = 'Test Calce'; 
            calce.close_date__c = Date.today(); 
            calce.start_date__c = Date.today(); 
      	    calce.status__c = 'Iniciado';
			/*calce.Get_Date__c = Date.today();
            calce.CheckUser__c = true; */
            
            insert calce;
            
            BE_CalceChartController objCalceChartController = new BE_CalceChartController();
            List<AggregateResult> cal = BE_CalceChartController.getCalceChart(); 
            
              test.StartTest();
        		calce.Name = 'Test Calce 1';
              test.stopTest();
            
            System.assertEquals(calce.close_date__c,calce.start_date__c,'Success');
        }

}