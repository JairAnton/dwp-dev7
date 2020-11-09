/**BE_SanctionUseQuotation_Tst
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
public class BE_SanctionUseQuotation_Tst {
	@testSetup
	static void setupData() {
		Final Account acc = TestFactory.createAccount();
		Final User user = TestFactory.createUser_1('TestAdmin', 'Migracion');
		TestFactory.createUserBranch(user.Id);
		Final Opportunity opp = TestFactory.createOpportunity(acc.Id, user.Id);
		Final List<dwp_cvad__Action_Audit__c> action_audit_list = TestFactory.create_Action_Audit(opp.id);
        insert new dwp_cvad__Action_Audit_Detail__c(dwp_cvad__action_audit_id__c = action_audit_list[0].Id, 
                                                    dwp_cvad__action_audit_detail_content__c = '<h3 class="slds-section__title">Comentarios</h3><div class="slds-form-element__control"><span class="slds-form-element__static">analista: tasa aprobada</span></div>',
                                                    dwp_cvad__action_audit_detail_display_order__c = 1.0, 
                                                    dwp_cvad__action_audit_detail_display_type__c = 'Price Approval');
		Final Product2 prod = TestFactory.createProduct();
		TestFactory.productConfiguration_1(Prod.ID);
		Final OpportunityLineItem oli = TestFactory.createOLI(opp.id, prod.id);
        Final Opportunity_Solution_Commitment__c comm = new Opportunity_Solution_Commitment__c();
        comm.opp_solution_commitment_id__c='10';
        comm.opp_solution_commitment_amount__c=200;
        comm.opp_soln_comt_expiry_days_number__c=30;
        comm.opp_solution_comt_product_name__c='INCR. SM VISTA + AHORRO';
        comm.CurrencyIsoCode='PEN';
        comm.opportunity_id__c=opp.Id;
        insert comm;
        
        Final Opportunity oppAux = TestFactory.createOpportunity(acc.Id, user.Id);
		Final OpportunityLineItem oliAux = oli.clone();
        oliAux.OpportunityId = oppAux.Id;
        insert oliAux;
	}

	@isTest
    static void getCommentsTest() {
		Final Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Final String comment = BE_SanctionUseQuotation_Ctr.getComments(opp.Id);
        System.assert(String.isNotBlank(comment), 'success!!!');
	}
    
    @isTest
    static void useQuotationPriceSuccessTest() {
		Final OpportunityLineItem oli = [SELECT Id, OpportunityId FROM OpportunityLineItem ORDER BY CreatedDate ASC LIMIT 1];
        BE_CreateQuotation_cls.generatePDF(oli.OpportunityId);
        BE_CreateQuotation_cls.generatePDF(oli.OpportunityId);
        Final Opportunity opp = [SELECT Id FROM Opportunity ORDER BY CreatedDate DESC LIMIT 1];
        opp.StageName = '04';
        update opp;
        Final Map<String, Object> mapReturn = BE_SanctionUseQuotation_Ctr.useQuotationPrice(opp.Id, oli.Id);
        System.assert(Boolean.valueOf(mapReturn.get('isOk')), 'success!!!');
	}
    
    @isTest
    static void useQuotationPriceFailTest() {
		Final Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        opp.StageName = '04';
        update opp;
        Final Map<String, Object> mapReturn = BE_SanctionUseQuotation_Ctr.useQuotationPrice(opp.Id, null);
        System.assert(!Boolean.valueOf(mapReturn.get('isOk')), 'fail!!!');
	}
}
