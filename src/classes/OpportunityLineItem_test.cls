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
 * @description OpportunityLineItem_test
 */
@isTest
public class OpportunityLineItem_test {
    
    /** @Description  PC_041*/
    Final static String PC_041 = 'PC00041';
    /** @Description  PC_002*/
    Final static String PC_002 = 'PC00002';
    
    /** @Description  Setup*/
	@testSetup
    static void setUp() {
		Final Account acc = new Account(Name = 'MyAccount');
		insert acc;
		Final Opportunity opp = new Opportunity(Name = 'XXX Test', CloseDate = Date.today().addDays(1), StageName = 'Prospecting', Amount = 111111, AccountId = acc.id);
		insert opp;

		Final Product2 prd = new Product2(Name = 'Test Product', ProductCode = 'TEST', Family = 'Family', IsActive = true);
		insert prd;

		PriceBookEntry pbe = new PriceBookEntry(Product2Id = prd.Id, PriceBook2Id = Test.getStandardPricebookId(), UnitPrice = 1, UseStandardPrice = false, 
                                                IsActive = true);
		insert pbe;
		TestFactory.createGuarantee(opp.Id);

		Final OpportunityLineItem oli = new OpportunityLineItem( OpportunityId = opp.Id, Product2Id = prd.Id, Quantity = 1, TotalPrice = 123, PriceBookEntryId = pbe.Id);
		insert oli;
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
        System.assertNotEquals(null, oli2.Id);
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
		system.assertEquals(oppLI.gipr_Plazo__c, 4);
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
		system.assertEquals(oppLI.gipr_Plazo__c, 4);
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
		system.assertEquals(oppLI.cpliq_Fecha_Vencimiento__c, System.today().addDays(12));
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
		system.assertEquals(oppLI.gipr_Plazo__c, 3);
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
		system.assertEquals(oppLI.gipr_Plazo__c, 3);
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
		system.assertEquals(oppLI.gipr_Plazo__c, 3);
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
		system.assertEquals(oppLI.cpliq_Fecha_Vencimiento__c, system.today().addDays(12));
	}

    /** @Description  beforeUpdateV6*/
	@isTest
    static void beforeUpdateV6() {
        updateProduct(PC_002);
		OpportunityLineItem oppLI = [Select id, OpportunityId, Product2Id from OpportunityLineItem limit 1];
        Test.startTest();
		oppLI.cpliq_Fecha_Vencimiento__c = system.today().addDays(442);
		update oppLI;
        Test.stopTest();
		system.assertEquals(oppLI.cpliq_Fecha_Vencimiento__c, system.today().addDays(442));
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
		system.assertEquals(oppLI.cpliq_n__c, 13);
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
		system.assertEquals(oppLI.cpliq_n__c, 13);
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
		system.assertEquals(oppLI.cpliq_n__c, 13);
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
        system.assertNotEquals(opsolcom.Id, null);
	}
}