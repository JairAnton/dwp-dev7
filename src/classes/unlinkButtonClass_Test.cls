@isTest
public class unlinkButtonClass_Test {
	static Account acctest;
	static Opportunity opptest;
	static User defaultUser;
	static dwp_cvad__Action_Audit__c audit;

	static void setData() {
		defaultUser = TestFactory.createUser('Test', 'Migracion');
		acctest = TestFactory.createAccount();
		opptest = TestFactory.createOpportunity(acctest.Id, defaultUser.Id);
	}

	static void unlink() {
		setData();

		opptest.sio_code__c = '1111';
		opptest.sio_status_type__c = 'tttesst';
		update opptest;

		Test.startTest();
		audit = new dwp_cvad__Action_Audit__c(dwp_cvad__action_audit_name__c = 'testaudit',
		                                      dwp_cvad__action_audit_object_api_name__c  = 'Opportunity',
		                                      dwp_cvad__action_audit_record_id__c = opptest.Id,
		                                      dwp_cvad__action_audit_user_id__c = defaultUser.Id,
		                                      dwp_cvad__action_audit_style__c = label.approve,
		                                      dwp_cvad__action_audit_type__c = label.AuditRiskApproval,
		                                      action_opp_SIO_code__c = '1111');
		insert audit;

		unlinkButtonClass.unlink(opptest.Id);

		audit.action_audit_email__c = true;
		update audit;

		unlinkButtonClass.unlink(opptest.Id);

		Test.stopTest();
	}
}
