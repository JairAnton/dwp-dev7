@isTest
private with sharing class BE_CalceChartController_tst {
    /*Method for test  GetCalceChartt*/
	@isTest
    private static void testGetCalceChart(){      
            final Calce__c calce = new Calce__c();
			calce.Name = 'Test Calce'; 
            calce.close_date__c = Date.today(); 
            calce.start_date__c = Date.today();
      	    calce.status__c = 'Iniciado';  
              insert calce;
              final BE_CalceChartController calChartCrl = new BE_CalceChartController();
              final List<AggregateResult> cal = BE_CalceChartController.getCalceChart(); 
              System.assert(cal.size()==1);
              calChartCrl = null;
              System.assertEquals(calChartCrl,null,'Success');
              test.StartTest();
        		calce.Name = 'Test Calce 1';
              test.stopTest();
            System.assertEquals(calce.close_date__c,calce.start_date__c,'Success');
        }

}