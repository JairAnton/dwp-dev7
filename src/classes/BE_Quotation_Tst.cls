/**BE_Quotation_Tst
 *  object.
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                       Date                Description<p />
 * -------------------------------------------------------------------
 * Martin Alejandro Mori Chavez    18/06/2018          Original version.<p />
 *
 * @author Martin Alejandro Mori Chavez
 */
@istest
public class BE_Quotation_Tst {
	@testSetup
	static void setupData() {
		Final Account acc = TestFactory.createAccount();
		Final User user = TestFactory.createUser_1('TestAdmin', 'Migracion');
		TestFactory.createUserBranch(user.Id);
		Final Opportunity opp = TestFactory.createOpportunity(acc.Id, user.Id);
		Final List<dwp_cvad__Action_Audit__c> action_audit_list = TestFactory.create_Action_Audit(opp.id);
		for(dwp_cvad__Action_Audit__c item : action_audit_list) {
			TestFactory.create_Action_Audit_Detail(item.Id);
		}
		Final Product2 prod = TestFactory.createProduct();
		TestFactory.productConfiguration_1(Prod.ID);
		TestFactory.createOLI(opp.id, prod.id);
	}

	/**
	   @Description test success method
	 */
	public static testMethod void unitTest() {
		Final Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
		Final PageReference pageRef = Page.BE_Quotation_vfp;
		pageRef.getParameters().put('id', opp.id);
		pageRef.getParameters().put('validDate', '2020-10-10');
		test.setCurrentPage(pageRef);
		Final ApexPages.StandardController standardCont = new ApexPages.standardController(opp);
		Final BE_Quotation_Ctr pdf = new BE_Quotation_Ctr(standardCont);
        
        Final List<Opportunity_Solution_Commitment__c> commitments = pdf.commitments;
        System.assert(commitments.isEmpty(), 'success!!!');
	}
}
