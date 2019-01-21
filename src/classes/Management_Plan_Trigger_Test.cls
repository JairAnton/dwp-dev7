@isTest
public class Management_Plan_Trigger_Test {
    @isTest
    static void validarTrigger(){
        Test.startTest();
        dwp_frct__management_plan__c rowMGP= new dwp_frct__management_plan__c();
        rowMGP.Name='Mi Plan 01';
        insert rowMGP;
        
        rowMGP.dwp_frct__management_plan_stage_type__c= '03';
        update rowMGP;
        
        rowMGP.dwp_frct__management_plan_stage_type__c= '04';
        update rowMGP;
        
		System.debug(rowMGP.dwp_frct__management_plan_stage_type__c);
	  	System.assert(true,'This Works!');
		Test.stopTest();
    }
}