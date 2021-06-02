/*
   @Autor: Arsenio Perez Lopez
   @Proyect: BBVA PERU
   @Version:1
   @HIstorial de cambios:
   - Creacion del Desencadenador
 *  * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		14/08/2020          modified version.<p />
 * Jair Anton               02/06/2021          modificación para cobertura de test
 * @description OpportunityLineItem_test
 */
@isTest
public class OpportunityLineItem_test {
    
    /** @Description  PC_041*/
    Final static String PC_041 = 'PC00041';
    /** @Description  PC_002*/
	Final static String PC_002 = 'PC00002';
	/** @Description  ASSERT*/
	Final static String ASSERT = 'Assertion Error';
    /** @Description  LABEL*/
    Final static String LABEL_STRING = 'Valor Label 1';
    /** @Description  CURRENCY_CODE*/
    Final static String CUR_CODE = 'PEN';
    /** @Description  FAMILY_CODE*/
    Final static String FAMILY_CODE = 'Family';
    /** @Description  STAGE_NAME*/
    Final static String STAGE_NAME = 'Prospecting';
    
    
    /** @Description  Setup*/
	@testSetup
    static void setUp() {
		Final Account acc = new Account(Name = 'MyAccount');
		insert acc;
		Final Opportunity opp = new Opportunity(Name = 'XXX Test', CloseDate = Date.today().addDays(1), StageName = STAGE_NAME, Amount = 111111, AccountId = acc.id);
		insert opp;
        Final Opportunity opp1 = new Opportunity(Name = 'XXX Test1', CloseDate = Date.today().addDays(1), StageName = STAGE_NAME, Amount = 111111, AccountId = acc.id);
		insert opp1;
        Final Opportunity opp2 = new Opportunity(Name = 'XXX Test2', CloseDate = Date.today().addDays(1), StageName = STAGE_NAME, Amount = 111111, AccountId = acc.id, type = '02');
		insert opp2;
        Final Opportunity opp3 = new Opportunity(Name = 'XXX Test3', CloseDate = Date.today().addDays(1), StageName = STAGE_NAME, Amount = 111111, AccountId = acc.id, type = '02');
		insert opp3;
        
		Final Product2 prd = new Product2(Name = 'Test Product', ProductCode = 'TEST', Family = FAMILY_CODE, IsActive = true, risk_sanction__c = true);
		insert prd;
        Final Product2 prd1 = new Product2(Name = 'Test Product1', ProductCode = 'TEST1', Family = FAMILY_CODE, IsActive = true, risk_sanction__c = true);
		insert prd1;
        Final Product2 prd2 = new Product2(Name = 'Test Product2', ProductCode = 'TEST2', Family = FAMILY_CODE, IsActive = true, risk_sanction__c = true, Unique_Id__c = 'TEST_1_NEW', Type_of_quote__c = 'Web');
		insert prd2;
        Final Product2 prd3 = new Product2(Name = 'Test Product3', ProductCode = 'TEST3', Family = FAMILY_CODE, IsActive = true, risk_sanction__c = true, Unique_Id__c = 'TEST_1');
		insert prd3;
        Final Product2 prd4 = new Product2(Name = 'Test Product4', ProductCode = 'TEST2', Family = FAMILY_CODE, IsActive = true, risk_sanction__c = true, Unique_Id__c = 'TEST_2_NEW', Type_of_quote__c = 'Web');
		insert prd4;
        
        createProductConfiguration(prd, prd1);
        
		Final PriceBookEntry pbe = new PriceBookEntry(Product2Id = prd.Id, PriceBook2Id = Test.getStandardPricebookId(), UnitPrice = 1, UseStandardPrice = false, CurrencyIsoCode = CUR_CODE, IsActive = true);
		insert pbe;
        Final PriceBookEntry pbe1 = new PriceBookEntry(Product2Id = prd1.Id, PriceBook2Id = Test.getStandardPricebookId(), UnitPrice = 1, UseStandardPrice = false, IsActive = true);
		insert pbe1;
        Final PriceBookEntry pbe2 = new PriceBookEntry(Product2Id = prd2.Id, PriceBook2Id = Test.getStandardPricebookId(), UnitPrice = 1, UseStandardPrice = false, CurrencyIsoCode = CUR_CODE, IsActive = true);
		insert pbe2;
        Final PriceBookEntry pbe3 = new PriceBookEntry(Product2Id = prd3.Id, PriceBook2Id = Test.getStandardPricebookId(), UnitPrice = 1, UseStandardPrice = false, CurrencyIsoCode = CUR_CODE, IsActive = true);
		insert pbe3;
        Final PriceBookEntry pbe4 = new PriceBookEntry(Product2Id = prd4.Id, PriceBook2Id = Test.getStandardPricebookId(), UnitPrice = 1, UseStandardPrice = false, CurrencyIsoCode = CUR_CODE, IsActive = true);
		insert pbe4;
        
       	createIntervenerVersion(opp1, prd);
		TestFactory.createGuarantee(opp.Id);
        
		Final OpportunityLineItem oli = new OpportunityLineItem( OpportunityId = opp.Id, Product2Id = prd.Id, Quantity = 1, TotalPrice = 123, PriceBookEntryId = pbe.Id);
		insert oli;
        Final OpportunityLineItem oli1 = new OpportunityLineItem( OpportunityId = opp1.Id, Product2Id = prd1.Id, Quantity = 1, TotalPrice = 123, PriceBookEntryId = pbe1.Id);
		insert oli1;
        Final OpportunityLineItem oli2 = new OpportunityLineItem( OpportunityId = opp2.Id, Product2Id = prd2.Id, Quantity = 1, TotalPrice = 123, PriceBookEntryId = pbe2.Id);
		insert oli2;
        Final OpportunityLineItem oli3 = new OpportunityLineItem( OpportunityId = opp3.Id, Product2Id = prd3.Id, Quantity = 1, TotalPrice = 123, PriceBookEntryId = pbe3.Id);
		insert oli3;
    }
    
    static void createIntervenerVersion(Opportunity opp1, Product2 prd) {
        Final fprd__GBL_Intervener__c interview = new fprd__GBL_Intervener__c();
        interview.fprd__GBL_Opportunity_product__c = opp1.Id;
        interview.main_intervener__c = true;
        insert interview;
        
        Final fprd__GBL_Product_version__c prodVersion = new fprd__GBL_Product_version__c();
        prodVersion.fprd__Active__c = true;
        prodVersion.fprd__Product__c = prd.Id;
        prodVersion.fprd__Version_number__c = 1;
        prodVersion.CurrencyIsoCode = 'PEN';
        insert prodVersion;
    }
    
    static void createProductConfiguration(Product2 prd, Product2 prd1) {
        
        Final fprd__GBL_Product_Configuration__c newPd1 = new fprd__GBL_Product_Configuration__c();
        newPd1.fprd__LoV_labels__c = LABEL_STRING;
        newPd1.fprd__LoV_values__c = '01';
        newPd1.fprd__Map_field__c = 'cpliq_Fecha_Vencimiento__c';
        newPd1.fprd__Product__c = prd.Id;
        newPd1.fprd__Section_order__c = 1;
        insert newPd1;
        
        Final fprd__GBL_Product_Configuration__c newPd2 = new fprd__GBL_Product_Configuration__c();
        newPd2.fprd__LoV_labels__c = LABEL_STRING;
        newPd2.fprd__LoV_values__c = '01';
        newPd2.fprd__Map_field__c = 'gipr_Plazo__c';
        newPd2.fprd__Product__c = prd.Id;
        newPd2.fprd__Section_order__c = 1;
        insert newPd2;
        
        Final fprd__GBL_Product_Configuration__c newPd3 = new fprd__GBL_Product_Configuration__c();
        newPd3.fprd__LoV_labels__c = LABEL_STRING;
        newPd3.fprd__LoV_values__c = '01';
        newPd3.fprd__Map_field__c = 'gipr_Periodicidad__c';
        newPd3.fprd__Product__c = prd.Id;
        newPd3.fprd__Section_order__c = 1;
        insert newPd3;
        
        Final fprd__GBL_Product_Configuration__c newPd4 = new fprd__GBL_Product_Configuration__c();
        newPd4.fprd__LoV_labels__c = LABEL_STRING;
        newPd4.fprd__LoV_values__c = '01';
        newPd4.fprd__Map_field__c = 'cpliq_Fecha_Vencimiento__c';
        newPd4.fprd__Product__c = prd1.Id;
        newPd4.fprd__Section_order__c = 3;
        insert newPd4;
        
        Final fprd__GBL_Product_Configuration__c newPd5 = new fprd__GBL_Product_Configuration__c();
        newPd5.fprd__LoV_labels__c = LABEL_STRING;
        newPd5.fprd__LoV_values__c = '01';
        newPd5.fprd__Map_field__c = 'gipr_Plazo__c';
        newPd5.fprd__Product__c = prd1.Id;
        newPd5.fprd__Section_order__c = 3;
        insert newPd5;
        
        Final fprd__GBL_Product_Configuration__c newPd6 = new fprd__GBL_Product_Configuration__c();
        newPd6.fprd__LoV_labels__c = LABEL_STRING;
        newPd6.fprd__LoV_values__c = '01';
        newPd6.fprd__Map_field__c = 'cpliq_Periodicidad__c';
        newPd6.fprd__Product__c = prd1.Id;
        newPd6.fprd__Section_order__c = 3;
        insert newPd6;
    }
    

    /** @Description  updateProduct to update ProductCode*/
    static Product2 updateProduct(String code) {
        Final Product2 prod = [select id from Product2 limit 1];
        prod.ProductCode = code;
        update prod;
        return prod;
    }
    
    /** @Description  beforeUpdateV1*/
	@isTest
    static void beforeUpdateV1() {
		Final OpportunityLineItem oppLI = [Select id, OpportunityId, Product2Id from OpportunityLineItem limit 1];
		oppLI.gipr_Tipo_Garantia__c = '01';
		update oppLI;
		oppLI.gipr_Tipo_Garantia__c = '02';
		update oppLI;
		Final PriceBookEntry pbe = [select id from PriceBookEntry limit 1];
		Final OpportunityLineItem oli2 = new OpportunityLineItem(OpportunityId = oppLI.OpportunityId, Product2Id = oppLI.Product2Id, Quantity = 1, TotalPrice = 123, 
                                                           PriceBookEntryId = pbe.Id);
        Test.startTest();
		insert oli2;
		Test.stopTest();
        System.assertNotEquals(null, oli2.Id, ASSERT);
	}

    /** @Description  beforeUpdateV2*/
	@isTest
    static void beforeUpdateV2() { // Yulino 12/12/2018 : Se agregó system.assertEquals() en adelante de este hito
		updateProduct(PC_002);
		Final OpportunityLineItem oppLI = [Select id, OpportunityId, Product2Id from OpportunityLineItem limit 1];
        Test.startTest();
        oppLI.gipr_Plazo__c = 4;
		oppLI.gipr_Periodicidad__c = '01';
		update oppLI;
        Test.stopTest();
		system.assertEquals(oppLI.gipr_Plazo__c, 4, ASSERT);
	}

    /** @Description  beforeUpdateV2v1*/
	@isTest
    static void beforeUpdateV2v1() {
        updateProduct(PC_002);
		Final OpportunityLineItem oppLI = [Select id, OpportunityId, Product2Id from OpportunityLineItem limit 1];
        Test.startTest();
		oppLI.gipr_Plazo__c = 4;
		oppLI.gipr_Periodicidad__c = '02';
		update oppLI;
        Test.stopTest();
		system.assertEquals(oppLI.gipr_Plazo__c, 4, ASSERT);
	}

    /** @Description  beforeUpdateV3*/
	@isTest
    static void beforeUpdateV3() {
        updateProduct('PC00011');
		Final OpportunityLineItem oppLI = [Select id, OpportunityId, Product2Id from OpportunityLineItem limit 1];
        Test.startTest();
		oppLI.cpliq_Fecha_Vencimiento__c = System.today().addDays(12);
		update oppLI;
        Test.stopTest();
		system.assertEquals(oppLI.cpliq_Fecha_Vencimiento__c, System.today().addDays(12), ASSERT);
	}

    /** @Description  beforeUpdateV4*/
	@isTest
    static void beforeUpdateV4() {
        updateProduct(PC_041);
		Final OpportunityLineItem oppLI = [Select id, OpportunityId, Product2Id from OpportunityLineItem limit 1];
        Test.startTest();
		oppLI.gipr_Plazo__c = 3;
		update oppLI;
        Test.stopTest();
		system.assertEquals(oppLI.gipr_Plazo__c, 3, ASSERT);
	}

    /** @Description  beforeUpdateV4v1*/
	@isTest
    static void beforeUpdateV4v1() {
        updateProduct(PC_041);
		Final OpportunityLineItem oppLI = [Select id, OpportunityId, Product2Id from OpportunityLineItem limit 1];
        Test.startTest();
		oppLI.gipr_Plazo__c = 3;
		oppLI.cpliq_Periodicidad__c = '02';
		update oppLI;
        Test.stopTest();
		system.assertEquals(oppLI.gipr_Plazo__c, 3, ASSERT);
	}

    /** @Description  beforeUpdateV4v2*/
	@isTest
    static void beforeUpdateV4v2() {
		updateProduct(PC_041);
		Final OpportunityLineItem oppLI = [Select id, OpportunityId, Product2Id from OpportunityLineItem limit 1];
        Test.startTest();
		oppLI.gipr_Plazo__c = 3;
		oppLI.cpliq_Periodicidad__c = '03';
		update oppLI;
        Test.stopTest();
		system.assertEquals(oppLI.gipr_Plazo__c, 3, ASSERT);
	}

    /** @Description  beforeUpdateV5*/
	@isTest
    static void beforeUpdateV5() {
		updateProduct(PC_041);
		Final OpportunityLineItem oppLI = [Select id, OpportunityId, Product2Id from OpportunityLineItem limit 1];
        Test.startTest();
		oppLI.cpliq_Fecha_Vencimiento__c = system.today().addDays(12);
		update oppLI;
        Test.stopTest();
		system.assertEquals(oppLI.cpliq_Fecha_Vencimiento__c, system.today().addDays(12), ASSERT);
	}

    /** @Description  beforeUpdateV6*/
	@isTest
    static void beforeUpdateV6() {
        updateProduct(PC_002);
		Final OpportunityLineItem oppLI = [Select id, OpportunityId, Product2Id from OpportunityLineItem limit 1];
        Test.startTest();
		oppLI.cpliq_Fecha_Vencimiento__c = system.today().addDays(442);
		update oppLI;
        Test.stopTest();
		system.assertEquals(oppLI.cpliq_Fecha_Vencimiento__c, system.today().addDays(442), ASSERT);
	}

    /** @Description  beforeUpdateV7*/
	@isTest
    static void beforeUpdateV7() {
		updateProduct(PC_002);
		Final OpportunityLineItem oppLI = [Select id, OpportunityId, Product2Id from OpportunityLineItem limit 1];
        Test.startTest();
		oppLI.cpliq_n__c = 13;
		oppLI.cpliq_Periodicidad__c = '01';
		update oppLI;
        Test.stopTest();
		system.assertEquals(oppLI.cpliq_n__c, 13, ASSERT);
	}

    /** @Description  beforeUpdateV7v1*/
	@isTest
    static void beforeUpdateV7v1() {
        updateProduct(PC_002);
		Final OpportunityLineItem oppLI = [Select id, OpportunityId, Product2Id from OpportunityLineItem limit 1];
        Test.startTest();
		oppLI.cpliq_n__c = 13;
		oppLI.cpliq_Periodicidad__c = '02';
		update oppLI;
        Test.stopTest();
		system.assertEquals(oppLI.cpliq_n__c, 13, ASSERT);
	}

    /** @Description  beforeUpdateV8*/
	@isTest
    static void beforeUpdateV8() {
        updateProduct('PC00010');
		Final OpportunityLineItem oppLI = [Select id, OpportunityId, Product2Id from OpportunityLineItem limit 1];
        Test.startTest();
		oppLI.cpliq_n__c = 13;
		oppLI.cpliq_Periodicidad__c = '01';
		update oppLI;
        Test.stopTest();
		system.assertEquals(oppLI.cpliq_n__c, 13, ASSERT);
	}

    /** @Description  beforeUpdateV8v1*/
	@isTest
    static void beforeUpdateV8v1() { // Yulino 12/12/2018 : Se agregó Test.startTest() y system.assertNotEquals()
        updateProduct('PC00010');
		Final OpportunityLineItem oppLI = [Select id, OpportunityId, Product2Id from OpportunityLineItem limit 1];
        Test.startTest();
		oppLI.cpliq_n__c = 13;
		oppLI.cpliq_Periodicidad__c = '02';
		update oppLI;
		Final Opportunity_Solution_Commitment__c opsolcom = new Opportunity_Solution_Commitment__c();
		opsolcom.opp_solution_id__c = oppLI.Id;
		insert opsolcom;
		delete oppLI;
		Test.stopTest();
        system.assertNotEquals(opsolcom.Id, null, ASSERT);
	}
    
     /** @Description  beforeUpdateV9*/
	@isTest
    static void beforeUpdateV9() {
        updateProduct(PC_002);
		Final OpportunityLineItem oppLI = [Select id, OpportunityId, Product2Id from OpportunityLineItem limit 1];
        Test.startTest();
		oppLI.cpliq_Fecha_Vencimiento__c = system.today().addDays(99999);
		update oppLI;
        Test.stopTest();
		system.assertEquals(oppLI.cpliq_Fecha_Vencimiento__c, system.today().addDays(99999), ASSERT);
	}
}