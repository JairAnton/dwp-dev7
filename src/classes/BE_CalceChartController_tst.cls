@isTest
public class BE_CalceChartController_tst {
    /*Method  1 for  test GetCalceChart */
	@isTest
    private static void testGetCalceChart(){      
            final Calce__c calce = new Calce__c();
			calce.Name = 'Test Calce'; 
            calce.close_date__c = Date.today(); 
            calce.start_date__c = Date.today();
      	    calce.status__c = 'Iniciado';  
              insert calce;
              final List<AggregateResult> cal = BE_CalceChartController.getCalceChart(); 
              test.StartTest();
        		calce.Name = 'Test Calce 1';
              test.stopTest();
            System.assertEquals(calce.close_date__c,calce.start_date__c,'Success');
        }
}