/**
 * @author bbva.com developers
 * @date 2018
 *
 * @group NONE
 *  * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		06/08/2020          modified version.<p />
 * @description PrincipalButtonValidationTest
 **/
@istest
private class PrincipalButtonValidationTest {
    
    /** @Description VALIDATION_CLASS*/
    Final static String VALIDATION_CLASS = 'validationClass';
    /** @Description OPP_TEST*/
    Final static String OPP_TEST = 'opportunity';
    /** @Description  LISTA*/
    Final static String LISTA = 'list';
    /** @Description pdfFlag for change opp2 user*/
    static Boolean pdfFlag = false;
    /** @Description reusable users*/
    static User executive, executiveBranch, operative;
    /** @Description reusable opp*/
    static Opportunity opp1, opp2;
    /** @Description reusable oli*/
    static OpportunityLineItem oli1, oli2;
    /** @Description garantías*/
    static fprd__GBL_Product_Configuration__c pcGarantia;
    
    /*
	 * @Description  methodForTesting like started
	 */
    static void methodForTesting() {
        executive = TestFactory.createUser('executive', 'Ejecutivo');
		executiveBranch = TestFactory.createUser('executiveBranch', 'Ejecutivo');
		operative = TestFactory.createUser('operative', 'Operativo');
        TestFactory.createUser('userOperative', 'Operativo');
        TestFactory.createUser('userAdmin', 'System Administrator');
		Final Account account = TestFactory.createAccount();
		opp1 = TestFactory.createOpportunity(account.Id, executive.Id);
        if(pdfFlag) {
            opp2 = TestFactory.createOpportunity(account.Id, operative.Id);
        } else {
            opp2 = TestFactory.createOpportunity(account.Id, executive.Id);
        }
		Final Product2 product = TestFactory.createProduct();
		Final Id pricebookId = Test.getStandardPricebookId();
        insert new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = product.Id, UnitPrice = 10000, IsActive = true);
		Final Pricebook2 customPB = new Pricebook2(Name = 'PriceBook', isActive = true);
		insert customPB;
		Final PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = product.Id, UnitPrice = 12000, IsActive = true);
		insert customPrice;
		oli1 = New OpportunityLineItem(OpportunityId = opp1.Id, Quantity = 1, TotalPrice = 10.00, PricebookEntryId = customPrice.Id, Product2Id = product.Id);
		insert oli1;		
        oli2 = New OpportunityLineItem(OpportunityId = opp2.Id, Quantity = 1, TotalPrice = 10.00, PricebookEntryId = customPrice.Id, Product2Id = product.Id);
		insert oli2;
		Final User_Branch__c userBranchExe = TestFactory.createUserBranch(executiveBranch.id);
		Final User_Branch__c userBranchOpe = TestFactory.createUserBranch(operative.id);
		TestFactory.createParticipants(oli1.Id);
		TestFactory.createGuarantee(oli1.Id);
		TestFactory.createParticipants(oli2.Id);
		TestFactory.createGuarantee(oli2.Id);
		opp1.Branch_id__c = userBranchExe.branch_id__c;
		opp2.Branch_id__c = userBranchOpe.branch_id__c;
		pcGarantia = new fprd__GBL_Product_Configuration__c(
            fprd__Label__c = 'Garantía', fprd__DeveloperName__c = 'gipr_Garantia_PC00005', fprd__Default_value__c = '02', fprd__Map_field__c = 'gipr_Garantia__c', 
			fprd__Product__c = product.id, fprd__Type__c = LISTA, fprd__Section_name__c = 'Información general del producto', fprd__Visibility_control_value__c = 'No dineraria,Dineraria',
			fprd__Values_control_field__c = 'gipr_Tipo_garantia_PC00005', fprd__Visibility_control_field__c = 'gipr_Tipo_garantia_PC00005', fprd__LoV_values__c = '01,02,03,04,05,06,07,09,10,11,12,13,14,15,16,17', 
			fprd__LoV_labels__c = 'Cuenta en garantía,Depósito cuenta a plazo,Super depósitos,Acciones y bono,Cartas de crédito,Certificados bancarios,Fianza bancaria,Fondos mutuos,Hipoteca,Leasing,Prenda agrícola,Prenda industrial,Prenda minera,Prenda transporte,Prenda vehicular,Warrants');
        insert pcGarantia;
		insert new fprd__GBL_Product_Configuration__c(
            fprd__Label__c = 'Tipo garantía', fprd__DeveloperName__c = 'gipr_Tipo_garantia_PC00005', fprd__Default_value__c = '03', fprd__Map_field__c = 'gipr_Tipo_Garantia__c', 
            fprd__Product__c = product.id, fprd__Section_name__c = 'Información general del producto', fprd__Type__c = LISTA, fprd__LoV_values__c = '01,02,03', 
            fprd__LoV_labels__c = 'Dineraria,No dineraria,Sin garantía');
		insert new fprd__GBL_Product_Configuration__c(
            fprd__Label__c = 'Amortización', fprd__DeveloperName__c = 'Amortizacion_PC00005', fprd__Map_field__c = 'cpliq_Amortizacion__c', fprd__Product__c = product.id, 
            fprd__Section_name__c = 'Criterios de pago y liquidación', fprd__Type__c = LISTA, fprd__Visibility_control_field__c = 'Tipo_amortizacion_PC00005', 
            fprd__Visibility_control_value__c = 'En cuotas', fprd__LoV_labels__c = 'Mensual,Trimestral,Semestral,Anual', fprd__LoV_values__c = '01,02,03,04');
		insert new fprd__GBL_Product_Configuration__c(
            fprd__Label__c = 'Tipo amortización', fprd__DeveloperName__c = 'Tipo_amortizacion_PC00005', fprd__Default_value__c = '01', fprd__Map_field__c = 'cpliq_Tipo_amortizacion__c', 
            fprd__Product__c = product.id, fprd__Section_name__c = 'Criterios de pago y liquidación', fprd__Type__c = LISTA, fprd__LoV_labels__c = 'Al vencimiento,En cuotas,Manual', fprd__LoV_values__c = '01,02,04');
    }
    
    /*
	 * @Description  rejectOwner
	 */
	@isTest
    static void rejectOwner() {
        methodForTesting();
        List<String> response;
        Test.startTest();
		System.runAs(executive) {
			response = SubmitToDiscart_ValidationClass.getErrorMessagesList(opp1.Id, OPP_TEST, 'btnReject');
		}
        Test.stopTest();
        System.assertEquals(0, response.size());
	}

    /*
	 * @Description  riskApprovalFail
	 */
	@isTest
    static void riskApprovalFail() {
        methodForTesting();
        List<String> response;
        Test.startTest();
		System.runAs(executive) {
			response = Risk_Approval_ValidationClass.getErrorMessagesList(opp1.Id, OPP_TEST, VALIDATION_CLASS);
		}
        Test.stopTest();
        System.assertEquals(0, response.size());
	}

    /*
	 * @Description  riskApprovalGood
	 */
	@isTest
    static void riskApprovalGood() {
        methodForTesting();
        oli1.gipr_Tipo_Garantia__c = '01';//dineraria
		oli1.gipr_Garantia__c = '01';//cuenta en garantia
		oli1.cpliq_Tipo_amortizacion__c = '02';//En cuotas
		oli1.cpliq_Amortizacion__c = '01';//Mensual
		update oli1;
        List<String> response;
        Test.startTest();
		System.runAs(executive) {
			response = Risk_Approval_ValidationClass.getErrorMessagesList(opp1.Id, OPP_TEST, VALIDATION_CLASS);
		}
        Test.stopTest();
        System.assertEquals(0, response.size());
	}

    /*
	 * @Description  riskApprovalFailChild
	 */
	@isTest
    static void riskApprovalFailChild() {
        methodForTesting();
		oli1.gipr_Tipo_Garantia__c = '01';//dineraria
		oli1.cpliq_Tipo_amortizacion__c = '02';//En cuotas
		oli1.cpliq_Amortizacion__c = '01';//Mensual
		update oli1;
        List <String> response;
        Test.startTest();
		System.runAs(executive) {
			response = Risk_Approval_ValidationClass.getErrorMessagesList(opp1.Id, OPP_TEST, VALIDATION_CLASS);
		}
        Test.stopTest();
        System.assertEquals(0, response.size());
	}

    /*
	 * @Description  reevaluate
	 */
	@isTest
    static void reevaluate() {
		methodForTesting();
		oli1.gipr_Tipo_Garantia__c = '01';//dineraria
		oli1.cpliq_Tipo_amortizacion__c = '02';//En cuotas
		oli1.cpliq_Amortizacion__c = '01';//Mensual
		update oli1;
        List<String> response;
        Test.startTest();
		System.runAs(executive) {
			response = Reevaluate_ValidationClass.getErrorMessagesList(opp1.Id, OPP_TEST, VALIDATION_CLASS);
		}
        Test.stopTest();
        System.assertEquals(0, response.size());
	}

    /*
	 * @Description  unlink
	 */
	@isTest
    static void unlink() {
		methodForTesting();
		oli1.gipr_Tipo_Garantia__c = '01';//dineraria
		oli1.cpliq_Tipo_amortizacion__c = '02';//En cuotas
		oli1.cpliq_Amortizacion__c = '01';//Mensual
		update oli1;
        List<String> response;
        Test.startTest();
		System.runAs(executive) {
			response = Unlink_ValidationClass.getErrorMessagesList(opp1.Id, OPP_TEST, VALIDATION_CLASS);
		}
        Test.stopTest();
        System.assertEquals(0, response.size());
	}

    /*
	 * @Description  sanctionPriceFail
	 */
	@isTest
    static void sanctionPriceFail() {
		methodForTesting();
		oli1.gipr_Tipo_Garantia__c = '01';//dineraria
		oli1.cpliq_Tipo_amortizacion__c = '02';//En cuotas
		oli1.cpliq_Amortizacion__c = '01';//Mensual
		update oli1;
        List<String> response;
        Test.startTest();
		System.runAs(executive) {
			response = SanctionPrice_ValidationClass.getErrorMessagesList(opp1.Id, OPP_TEST, VALIDATION_CLASS);
		}
        Test.stopTest();
        System.assertEquals(0, response.size());
	}

    /*
	 * @Description  sanctionPriceGood
	 */
	@isTest
    static void sanctionPriceGood() {
		methodForTesting();
		oli1.gipr_Tipo_Garantia__c = '01';//dineraria
		oli1.gipr_Garantia__c = '01';//cuenta en garantia
		oli1.cpliq_Tipo_amortizacion__c = '02';//En cuotas
		oli1.cpliq_Amortizacion__c = '01';//Mensual
		update oli1;
        List<String> response;
        Test.startTest();
		System.runAs(executive) {
			response = SanctionPrice_ValidationClass.getErrorMessagesList(opp1.Id, OPP_TEST, VALIDATION_CLASS);
		}
        Test.stopTest();
        System.assertEquals(0, response.size());
	}

    /*
	 * @Description  formalizeFail
	 */
	@isTest
    static void formalizeFail() {
        methodForTesting();
		oli1.gipr_Tipo_Garantia__c = '01';//dineraria
		oli1.cpliq_Tipo_amortizacion__c = '02';//En cuotas
		oli1.cpliq_Amortizacion__c = '01';//Mensual
		update oli1;
        List<String> response;
        Test.startTest();
		System.runAs(executive) {
			response = Formalize_ValidationClass.getErrorMessagesList(opp1.Id, OPP_TEST, VALIDATION_CLASS);
		}
        Test.stopTest();
        System.assertEquals(0, response.size());
	}

    /*
	 * @Description  formalizeGood
	 */
	@isTest
    static void formalizeGood() {
        methodForTesting();
		oli1.gipr_Tipo_Garantia__c = '01';//dineraria
		oli1.gipr_Garantia__c = '01';//cuenta en garantia
		oli1.cpliq_Tipo_amortizacion__c = '02';//En cuotas
		oli1.cpliq_Amortizacion__c = '01';//Mensual
		update oli1;
        List<String> response;
        Test.startTest();
		System.runAs(executive) {
			response = Formalize_ValidationClass.getErrorMessagesList(opp1.Id, OPP_TEST, VALIDATION_CLASS);
		}
        Test.stopTest();
        System.assertEquals(0, response.size());
	}

    /*
	 * @Description  completeFail
	 */
	@isTest
    static void completeFail() {
        methodForTesting();
		pcGarantia.fprd__Section_order__c = 1;
		pcGarantia.fprd__Visibility_control_field__c = '';
        pcGarantia.fprd__Visibility_control_value__c = '';
		update pcGarantia;
		oli1.cpliq_Tipo_amortizacion__c = '02';//En cuotas
		oli1.cpliq_Amortizacion__c = '01';//Mensual
		update oli1;
        List<String> response;
        Test.startTest();
		System.runAs(executive) {
			response = Complete_ValidationClass.getErrorMessagesList(opp1.Id, OPP_TEST, VALIDATION_CLASS);
		}
        Test.stopTest();
        System.assertEquals(1, response.size());
	}

    /*
	 * @Description  completeGood
	 */
	@isTest
    static void completeGood() {
		methodForTesting();
		oli1.gipr_Tipo_Garantia__c = '01';//dineraria
		oli1.gipr_Garantia__c = '01';//cuenta en garantia
		oli1.cpliq_Tipo_amortizacion__c = '02';//En cuotas
		oli1.cpliq_Amortizacion__c = '01';//Mensual
		update oli1;
        List<String> response;
        Test.startTest();
		System.runAs(executive) {
			response = Complete_ValidationClass.getErrorMessagesList(opp1.Id, OPP_TEST, VALIDATION_CLASS);
		}
        Test.stopTest();
        System.assertEquals(0, response.size(), 'Falla 5');
	}

    /*
	 * @Description  approve
	 */
	@isTest
    static void approve() {
        methodForTesting();
		oli1.gipr_Tipo_Garantia__c = '01';//dineraria
		oli1.gipr_Garantia__c = '01';//cuenta en garantia
		oli1.cpliq_Tipo_amortizacion__c = '02';//En cuotas
		oli1.cpliq_Amortizacion__c = '01';//Mensual
		update oli1;
        List<String> response;
        Test.startTest();
		System.runAs(executive) {
			response = Approve_ValidationClass.getErrorMessagesList(opp1.Id, OPP_TEST, VALIDATION_CLASS);
		}
        Test.stopTest();
        System.assertEquals(0, response.size());
	}

    /*
	 * @Description  formalization
	 */
	@isTest
    static void formalization() {
        methodForTesting();
		oli2.gipr_Tipo_Garantia__c = '01';//dineraria
		oli2.gipr_Garantia__c = '01';//cuenta en garantia
		oli2.cpliq_Tipo_amortizacion__c = '02';//En cuotas
		oli2.cpliq_Amortizacion__c = '01';//Mensual
		update oli2;
        List<String> response;
        Test.startTest();
		System.runAs(executiveBranch) {
			response = Formalization_ValidationClass.getErrorMessagesList(opp2.Id, OPP_TEST, VALIDATION_CLASS);
		}
        Test.stopTest();
        System.assertEquals(1, response.size());
	}

    /*
	 * @Description  doPDF
	 */
	@isTest
    static void doPDF() {
        pdfFlag = true;
        methodForTesting();
		opp2.OwnerId = operative.Id;
        update opp2;
		oli2.gipr_Tipo_Garantia__c = '01';//dineraria
		oli2.gipr_Garantia__c = '01';//cuenta en garantia
		oli2.cpliq_Tipo_amortizacion__c = '02';//En cuotas
		oli2.cpliq_Amortizacion__c = '01';//Mensual
		update oli2;
        List<String> response;
        Test.startTest();
		System.runAs(executiveBranch) {
			response = PDF_ValidationClass.getErrorMessagesList(opp2.Id, OPP_TEST, VALIDATION_CLASS);
		}
        Test.stopTest();
        System.assertEquals(1, response.size());
	}

    /*
	 * @Description  quoteGood
	 */
	@isTest
    static void quoteGood() {
		methodForTesting();
		oli1.gipr_Tipo_Garantia__c = '01';//dineraria
		oli1.gipr_Garantia__c = '01';//cuenta en garantia
		oli1.cpliq_Tipo_amortizacion__c = '02';//En cuotas
		oli1.cpliq_Amortizacion__c = '01';//Mensual
		update oli1;
        List<String> response;
        Test.startTest();
		System.runAs(executive) {
			response = Quote_ValidationClass.getErrorMessagesList(opp1.Id, OPP_TEST, VALIDATION_CLASS);
		}
        Test.stopTest();
        System.assertEquals(0, response.size());
	}
}