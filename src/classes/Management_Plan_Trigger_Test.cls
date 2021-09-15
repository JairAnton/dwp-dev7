/** @Name <Management_Plan_Trigger_Test>
   @Date 09-Septiembre 2021
   Date        Author   Email                  				Type
   2021-09-09  JAAA		jair.anton.contractor@bbva.com		Update test
 */

@isTest
public class Management_Plan_Trigger_Test {
	
	/* Test for handler */
	@isTest
	static void validarTrigger() {
		Test.startTest();
		dwp_frct__management_plan__c rowMGP = new dwp_frct__management_plan__c();
		rowMGP.Name = 'Mi Plan 01';
		rowMGP.dwp_frct__management_plan_start_date__c = Date.today();
		rowMGP.dwp_frct__management_plan_end_date__c = Date.today().addMonths(1);
		insert rowMGP;
		rowMGP.dwp_frct__management_plan_stage_type__c = '03';
		update rowMGP;
		System.assert (true, 'This Works!');
		Test.stopTest();
	}
}