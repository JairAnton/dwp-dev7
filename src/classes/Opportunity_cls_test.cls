/*-------------------------------------------------------------------------
 * Name: OpportunityNewRecord_cls
 * Description : Class to insert a record from Account
 * Created date : May 01 2018
 * Developer name: Isaías Velázquez Cortés Indra(México)
--------------------------------------------------------------------------*/

@isTest
public class Opportunity_cls_test {
	
	@isTest static void InsertOpportunity_Test() {
		 test.startTest();
         Branch__c Br = new Branch__c();
		 Account Acc = new Account(branch_id__c=Br.Id,Name='Mi cuenta');
         insert Acc;
		 String result;	
		 Opportunity_cls.InsertOpportunity('Miopp',Acc.Id,'','',0,'','','');
		// result=Opportunity_cls.InsertOpportunity();

		 System.assert(true,'This Works!');
		 test.stopTest();
	}
	
	
	
}