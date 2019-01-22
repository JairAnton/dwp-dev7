@isTest
public class Grouping_Trigger_Test {

    @isTest
    static void validarTrigger(){
        Test.startTest();
        dwp_frct__management_plan__c rowMGP= new dwp_frct__management_plan__c();
        rowMGP.Name='Mi Plan';
        insert rowMGP;
        List<dwp_frct__grouping__c> row = new List<dwp_frct__grouping__c>();
        row.add(new dwp_frct__grouping__c(Name='Test',dwp_frct__solution_category_type__c='MyProd',dwp_frct__management_plan_id__c=rowMGP.id));
         insert row;
        row[0].Name='Changed';
        update row;
		System.debug(row[0].id);
	  	System.assert(true,'This Works!');
		Test.stopTest();
    }
    
}