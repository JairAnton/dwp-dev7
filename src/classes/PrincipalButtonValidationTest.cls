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
 * 
 * *  * Modification cobertura de condiciones:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Jair Anton    			27/05/2021         modificación para alcance de cobertura de test<p />
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
	 * @Description  initData like started
	 */
    public static void initData() {
		Final Dwp_FormalizationProducts_AAC__c[] prdAssistForm = new Dwp_FormalizationProducts_AAC__c[] {};
		Final Set<String> prdToForm = new Set<String> {'PC00012', 'PC00011', 'PC00001_Depre', 'PC00005', 'PC00009', 'PC00001'};
		for(String prd:prdToForm) {
			prdAssistForm.add(new Dwp_FormalizationProducts_AAC__c(Name = prd, Product_Code__c = prd));
		}
		insert prdAssistForm;
		Final User admin = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId()];
		/*Crea Asistente Operativo*/
		Final String perfil = [SELECT Id FROM Profile WHERE name = 'Operativo'].Id;
		Map<Schema.SObjectField, Object> mapFields = new Map<Schema.SObjectField, Object> {User.ProfileId => perfil, User.prof_position_type__c => 'ASISTENTE BEC', User.prof_position_id__c => 'E06'};
		createUser(true, mapFields);
		mapFields.put(User.prof_position_type__c, 'SUBGERENTE BEC');
		mapFields.put(User.prof_position_id__c, 'E04');
		createUser(true, mapFields);
		Final String perfilExecutive = [SELECT Id FROM Profile WHERE name = 'Ejecutivo'].Id;
		mapFields = new Map<Schema.SObjectField, Object> {User.ProfileId => perfilExecutive, User.prof_position_type__c => 'EJECUTIVO BEC'};
		Final User userExecutive = TestFactory.getUser(true, mapFields);
		//Create Account's
		Account acc;
		System.runAs(admin) {
			mapFields = new Map<Schema.SObjectField, Object> {Account.OwnerId => userExecutive.Id, Account.Name => 'CLIENTE OPORTUNIDAD'};
			acc = TestFactory.getAccount(true, mapFields);

			//Crear Oportunidad con Producto - 1
			Final Opportunity testOP = new Opportunity(Name = 'TEST Formalization', stageName = '02', AccountId = acc.Id, CloseDate = Date.today(), Amount = 10000, OwnerId = userExecutive.Id);
			insert testOP;
			//Opp 2
			Final Opportunity testOP2 = new Opportunity(Name = 'TEST Formalization 2', stageName = '02', AccountId = acc.Id, CloseDate = Date.today(), Amount = 10000, OwnerId = userExecutive.Id);
			insert testOP2;

			Final Product2 testPr = new Product2(Name = 'TestProd', type_of_quote__c = 'COTIZADOR', ProductCode = 'PC00012');
			insert testPr;
			//product 2
			Final Product2 testPr2 = new Product2(Name = 'TestProd', type_of_quote__c = 'COTIZADOR');
			insert testPr2;

			Final Pricebook2 testPB = new Pricebook2(CurrencyIsoCode = 'PEN', Name = 'MyPrice');
			insert testPB;
			Final Id pricebookId = Test.getStandardPricebookId();

			Final PricebookEntry testPE = new PricebookEntry(UnitPrice = 120, CurrencyIsoCode = 'PEN', Pricebook2Id = pricebookId, Product2Id = testPr.Id, IsActive = true);
			insert testPE;

			Final PricebookEntry testPE2 = new PricebookEntry(UnitPrice = 120, CurrencyIsoCode = 'PEN', Pricebook2Id = pricebookId, Product2Id = testPr2.Id, IsActive = true);
			insert testPE2;

			Final OpportunityLineItem testLOPP = new OpportunityLineItem(TotalPrice = 120, OpportunityId = testOP.Id, PricebookEntryId = testPE.Id, Quantity = 1, gipr_Tipo_Garantia__c = '03',
			                                                             Product2Id = testPr.Id);
			insert testLOPP;

			Final OpportunityLineItem testLOPP2 = new OpportunityLineItem(TotalPrice = 120, OpportunityId = testOP2.Id, PricebookEntryId = testPE2.Id, Quantity = 1, gipr_Tipo_Garantia__c = '03',
			                                                              Product2Id = testPr2.Id);
			insert testLOPP2;
		}
	}
    
    /* Create User with Dynamic Fields*/
	public static void createUser(Boolean doInsert, Map<Schema.SObjectField, Object> mapFields) {
        Final Double random = Math.random();
		Final User obj = new User(LastName = 'User' + random, Username = 'User' + random + '@user.com.u', Email = 'User' + random + 'user@u.com.u', EmailEncodingKey = 'ISO-8859-1', 
                                  Alias = String.valueOf(random).substring(0, 3) + 'uAas2', TimeZoneSidKey = 'America/Mexico_City', IsActive = true, LocaleSidKey = 'en_US', LanguageLocaleKey = 'es');
        
		for(Schema.SObjectField sfield : mapFields.keySet()) {
			obj.put(sfield, mapFields.get(sfield));
		}
        
		if(doInsert) {
			insert obj;
		}
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
    
    /*
	 * @Description  Test Condition1
	 */
	/*@isTest
    static void testCondition1() {
		methodForTesting();
		oli1.gipr_Tipo_Garantia__c = '01';//dineraria
		oli1.gipr_Garantia__c = '01';//cuenta en garantia
		oli1.cpliq_Tipo_amortizacion__c = '02';//En cuotas
		oli1.cpliq_Amortizacion__c = '01';//Mensual
		update oli1;
        Boolean response;
        Test.startTest();
		System.runAs(executive) {
			response = PrincipalValidationHub.condition1(opp1.Id);
		}
        Test.stopTest();
        System.assertEquals(false, response, 'Correcto');
	}*/
    
    /*
	 * @Description  Test Condition3
	 */
	@isTest
    static void testCondition3() {
		methodForTesting();
        oli1.gipr_Tipo_Garantia__c = '03';//dineraria
		oli1.gipr_Garantia__c = '03';//cuenta en garantia
		oli1.cpliq_Tipo_amortizacion__c = '02';//En cuotas
		oli1.cpliq_Amortizacion__c = '01';//Mensual
		update oli1;
        
        Final fprd__GBL_Guarantee__c nRow = new fprd__GBL_Guarantee__c();
        nRow.fprd__GBL_Opportunity_product__c = oli1.OpportunityId;
        nRow.guarantee_type__c = oli1.gipr_Tipo_Garantia__c;
        nRow.guarantee_desc__c = oli1.gipr_Garantia__c;
        nRow.isMaster__c = true;
        insert nRow;
        
        Final fprd__GBL_Intervener__c testInterview = new fprd__GBL_Intervener__c();
        testInterview.fprd__GBL_Opportunity_product__c = opp1.Id;
        insert testInterview;
        
        List<String> response;
        Test.startTest();
		System.runAs(executive) {
			response = PrincipalValidationHub.condition3(opp1.Id);
		}
        Test.stopTest();
        System.assertEquals(0, response.size(), 'Correcto');
	}
    
     /*
	 * @Description  Test Condition6
	 */
	@isTest
    static void testCondition6() {
		methodForTesting();
		oli1.gipr_Tipo_Garantia__c = '01';//dineraria
		oli1.gipr_Garantia__c = '01';//cuenta en garantia
		oli1.cpliq_Tipo_amortizacion__c = '02';//En cuotas
		oli1.cpliq_Amortizacion__c = '01';//Mensual
		update oli1;
        Boolean response;
        Test.startTest();
		System.runAs(executive) {
			response = PrincipalValidationHub.condition6(opp1.Id);
		}
        Test.stopTest();
        System.assertEquals(true, response, 'Correcto');
	}
    
     /*
	 * @Description  Test Condition7
	 */
    @isTest
	public static void testCondition7() {
        initData();
		Final User ejecutivo = [SELECT ID, isActive FROM User WHERE prof_position_type__c = 'EJECUTIVO BEC' AND isActive = True limit 1];
		Final User asistente = [SELECT ID, isActive, Name FROM User WHERE prof_position_type__c = 'ASISTENTE BEC' AND isActive = True limit 1];
		Final Opportunity opp = [SELECT ID FROM Opportunity WHERE Name = 'TEST Formalization' limit 1];
		System.runAs(ejecutivo) {
			Product_cls.setFormalization_2(opp.Id, 'btnApprove', 'Comentarios', '');
		}
		delete [SELECT Id, Group.DeveloperName FROM GroupMember WHERE UserOrGroupId = : asistente.id];
		Final Case caso = [SELECT Id FROM Case WHERE RecordType.DeveloperName = 'Formalization'];
		Boolean validate;
		Test.startTest();
		System.runAs(asistente) {
			validate = PrincipalValidationHub.condition7(caso.id);
		}
		Test.stopTest();
		System.assert(validate, 'Fail');
	}
}