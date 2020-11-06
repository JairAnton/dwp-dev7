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
        Final String comment = '<h3 class="slds-section__title" data-aura-rendered-by="17:1678;a">Comentarios</h3><div class="slds-form-element__control" data-aura-rendered-by="19:1678;a"><span class="slds-form-element__static" data-aura-rendered-by="20:1678;a">analista: tasa aprobada</span></div><h3 class="slds-section__title" data-aura-rendered-by="22:1678;a">Precio</h3><div class="slds-grid slds-wrap" data-aura-rendered-by="3:1689;a"><div class="slds-has-divider--bottom slds-size_1-of-2" data-aura-rendered-by="5:1689;a"><div data-aura-rendered-by="9:1689;a"><span class="slds-form-element__label" data-aura-rendered-by="10:1689;a">TEA propuesta (%)</span><div class="slds-form-element__control" data-aura-rendered-by="12:1689;a"><span class="slds-form-element__static" data-aura-rendered-by="13:1689;a">7.8</span></div></div></div></div><div class="slds-m-top_medium" data-aura-rendered-by="28:1678;a"><table class="slds-table slds-table_bordered slds-table_cell-buffer cDataTable_cmp" role="grid" data-aura-rendered-by="32:1678;a" data-aura-class="cDataTable_cmp"><thead data-aura-rendered-by="33:1678;a"><tr data-aura-rendered-by="34:1678;a"><th class="slds-is-sortable slds-is-resizable" scope="col" data-aura-rendered-by="36:1678;a"></th><th class="slds-is-sortable slds-is-resizable" scope="col" data-aura-rendered-by="38:1678;a">SOLICITADO</th><th class="slds-is-sortable slds-is-resizable" scope="col" data-aura-rendered-by="40:1678;a">AUTORIZADO</th></tr></thead><tbody data-aura-rendered-by="42:1678;a"><tr class="slds-is-sortable slds-is-resizable" style="overflow-x:auto;" data-aura-rendered-by="44:1678;a"><th data-aura-rendered-by="46:1678;a">TEA (%)</th><th data-aura-rendered-by="48:1678;a">7.80</th><th data-aura-rendered-by="50:1678;a">7.80</th></tr><tr class="slds-is-sortable slds-is-resizable" style="overflow-x:auto;" data-aura-rendered-by="52:1678;a"><th data-aura-rendered-by="54:1678;a">DI (%)</th><th data-aura-rendered-by="56:1678;a">3.39</th><th data-aura-rendered-by="58:1678;a">3.39</th></tr><tr class="slds-is-sortable slds-is-resizable" style="overflow-x:auto;" data-aura-rendered-by="60:1678;a"><th data-aura-rendered-by="62:1678;a">SPREAD (%)</th><th data-aura-rendered-by="64:1678;a">4.61</th><th data-aura-rendered-by="66:1678;a">4.41</th></tr><tr class="slds-is-sortable slds-is-resizable" style="overflow-x:auto;" data-aura-rendered-by="68:1678;a"><th data-aura-rendered-by="70:1678;a">BAI (%)</th><th data-aura-rendered-by="72:1678;a">2.70</th><th data-aura-rendered-by="74:1678;a">2.50</th></tr><tr class="slds-is-sortable slds-is-resizable" style="overflow-x:auto;" data-aura-rendered-by="76:1678;a"><th data-aura-rendered-by="78:1678;a">RORC (%)</th><th data-aura-rendered-by="80:1678;a">29.28</th><th data-aura-rendered-by="82:1678;a">29.28</th></tr></tbody></table></div><br data-aura-rendered-by="84:1678;a"><div class="slds-grid slds-wrap" data-aura-rendered-by="3:1703;a"><div class="slds-size_1-of-2" data-aura-rendered-by="5:1703;a"><div data-aura-rendered-by="9:1703;a"><span class="slds-form-element__label" data-aura-rendered-by="10:1703;a">Fecha de sanción</span><div class="slds-form-element__control" data-aura-rendered-by="12:1703;a"><span class="slds-form-element__static" data-aura-rendered-by="13:1703;a">28/10/2020</span></div></div></div><div class="slds-size_1-of-2" data-aura-rendered-by="15:1703;a"><div data-aura-rendered-by="19:1703;a"><span class="slds-form-element__label" data-aura-rendered-by="20:1703;a">Validez TEA</span><div class="slds-form-element__control" data-aura-rendered-by="22:1703;a"><span class="slds-form-element__static" data-aura-rendered-by="23:1703;a">12/11/2020</span></div></div></div><div class="slds-size_1-of-2" data-aura-rendered-by="25:1703;a"><div data-aura-rendered-by="29:1703;a"><span class="slds-form-element__label" data-aura-rendered-by="30:1703;a">Analista asignado</span><div class="slds-form-element__control" data-aura-rendered-by="32:1703;a"><span class="slds-form-element__static" data-aura-rendered-by="33:1703;a">IRMA BEATRIZ COLLANTES BOHORQUEZ</span></div></div></div><div class="slds-size_1-of-2" data-aura-rendered-by="35:1703;a"><div data-aura-rendered-by="39:1703;a"><span class="slds-form-element__label" data-aura-rendered-by="40:1703;a">Id Cotiza</span><div class="slds-form-element__control" data-aura-rendered-by="42:1703;a"><span class="slds-form-element__static" data-aura-rendered-by="43:1703;a">279856</span></div></div></div></div>';
		insert new dwp_cvad__Action_Audit_Detail__c(dwp_cvad__action_audit_id__c = action_audit_list[0].Id, 
                                                    dwp_cvad__action_audit_detail_content__c = comment,
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
        String comment = BE_SanctionUseQuotation_Ctr.getComments(opp.Id);
        System.assert(String.isNotBlank(comment), 'success!!!');
	}
    
    @isTest
    static void useQuotationPriceSuccessTest() {
		Final OpportunityLineItem oli = [SELECT Id, OpportunityId FROM OpportunityLineItem ORDER BY CreatedDate ASC LIMIT 1];
        BE_CreateQuotation_cls.generatePDF(oli.OpportunityId);
        BE_CreateQuotation_cls.generatePDF(oli.OpportunityId);
        Final Opportunity opp = [SELECT Id FROM Opportunity WHERE Id <> : oli.OpportunityId LIMIT 1];
        opp.StageName = '04';
        update opp;
        Map<String, Object> mapReturn = BE_SanctionUseQuotation_Ctr.useQuotationPrice(opp.Id, oli.Id);
        System.assert(Boolean.valueOf(mapReturn.get('isOk')), 'success!!!');
	}
    
    @isTest
    static void useQuotationPriceFailTest() {
		Final Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        opp.StageName = '04';
        update opp;
        Map<String, Object> mapReturn = BE_SanctionUseQuotation_Ctr.useQuotationPrice(opp.Id, null);
        System.assert(!Boolean.valueOf(mapReturn.get('isOk')), 'fail!!!');
	}
}