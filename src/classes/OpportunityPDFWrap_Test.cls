//Modificado por Eduardo Castillo S. 2018/10/01
@istest
public class OpportunityPDFWrap_Test {

    @testSetup
    static void setupData(){
        Account acc=TestFactory.createAccount();
        TestFactory.createAccBBVAClass(acc.id);
        TestFactory.createAccBankingSystClass(acc.id);

		TestFactory.createContact(acc.id);
        User user=TestFactory.createUser_1('TestAdmin','Migracion');
        TestFactory.createUserBranch(user.Id);

        Opportunity opp=TestFactory.createOpportunity(acc.Id,user.Id);
        List<dwp_cvad__Action_Audit__c> action_audit_list = TestFactory.create_Action_Audit(opp.id);
        for(dwp_cvad__Action_Audit__c item3 : action_audit_list){
            TestFactory.create_Action_Audit_Detail(item3.Id);
        }
        TestFactory.create_guarantee(opp.id);
        Product2 prod=TestFactory.createProduct();
        TestFactory.productConfiguration_1(Prod.ID);
        TestFactory.createOLI(opp.id,prod.id);
        TestFactory.createParticipants(opp.id);
        TestFactory.createGuarantee(opp.id);
    }

    public static testMethod void generatePDF(){
		Opportunity opp = [SELECT ID FROM Opportunity LIMIT 1];
        Account acc = [SELECT ID FROM Account LIMIT 1];

        String returnMsg=OpportunityPDFWrap.setValues(opp.id);
        TestFactory.createAccRating(acc.id);
        returnMsg=OpportunityPDFWrap.setValues(opp.id);

        System.assertEquals(returnMsg, 'SUCCESS');
    }
}
