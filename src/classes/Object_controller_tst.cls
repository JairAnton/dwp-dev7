/*
   @Autor: Arsenio Perez Lopez
   @Proyect: BBVA PERU
   @Version:1
   @description: test class from Object_Controller.apx
   @log:
   - Creacion del Handler
 */
@isTest
public class Object_controller_tst {
	static List<SObject> mamlon;
	static ID idmamlon;
	static String strmamlon;

	@testSetup static void loadData() {
		Account cliente = new Account(Name = 'Ejemplo',
		                              main_code_id__c = '12345678');
		Insert cliente;
		Opportunity a = new Opportunity(name = 'Cuenta',
		                                AccountID = cliente.Id, Amount = 2000,
		                                CloseDAte = system.today(),
		                                stageName = '01',
		                                opportunity_status_type__c = '01',
		                                CurrencyIsoCode = 'USD'
		                                );
		insert a;
		Product2 p1 = new Product2(Name = 'Product Monthly 1111', Family = 'Monthly', isActive = true, CurrencyIsoCode = 'USD');
		insert p1;
		Id pricebookId = Test.getStandardPricebookId();
		PricebookEntry pbe1 = new PricebookEntry(Pricebook2id = pricebookId, Product2id = p1.ID, isActive = true, CurrencyIsoCode = 'USD', unitPrice = 100);
		insert pbe1;
		OpportunityLineItem oppLine = new OpportunityLineItem(pricebookentryid = pbe1.Id, TotalPrice = 2000, Quantity = 1, OpportunityID = a.Id, SioCode__c = '123Xemo', product2Id = p1.ID);
		insert oppLine;
		task lstTasks = new Task(Subject = 'SIO1234567##er Ingreso a Controller##', Status = 'Inbound Email', whatId = a.Id);
		insert lstTasks;
		Date x = system.Date.today();

		Account_BBVA_Information__c BBVA_Information = new Account_BBVA_Information__c(account_id__c = cliente.Id, product_group_classification_id__c = 'Directa', type__c = '01', product_desc__c = 'Netcash', year_month_day_date__c = x.addMonths(-1));
		insert BBVA_Information;
		Account_Banking_System_Debt__c Bank_Syste = new Account_Banking_System_Debt__c(account_id__c = cliente.Id, product_group_classification_id__c = 'Directa', product_desc__c = 'netcash', entity_name__c = 'BBVA', year_month_day_date__c = x.addMonths(-1));
		insert Bank_Syste;
	}

	/* @isTest static void getOportunityLineItemID_Test() {
	     Opportunity a =[select id from Opportunity limit 1];
	     test.startTest();
	     idmamlon=Object_Controller.getOportunityLineItemID(a.Id);
	     test.stopTest();
	   }
	   @isTest static void getOportunidadSytem_Test() {
	     Opportunity a =[select id from Opportunity limit 1];
	     test.startTest();
	     strmamlon=Object_Controller.getOportunidadSytem(a.Id);
	     test.stopTest();
	   }
	   @isTest static void getOportunityModality_Test() {
	     Opportunity a =[select id from Opportunity limit 1];
	     test.startTest();
	     idmamlon=Object_Controller.getOportunityModality(a.Id);
	     test.stopTest();
	   }
	   @isTest static void setSanction_Test() {
	     Opportunity a =[select id from Opportunity limit 1];
	     test.startTest();
	     a.StageName='04';
	     a.opportunity_status_type__c='08';
	     update a;
	     Object_Controller.setSanction(a.Id);
	     test.stopTest();
	   }
	   @isTest static void getVflasClient_test() {
	     Account cliente = [select id from Account limit 1];
	     Product2 ProdId =[select id from Product2 limit 1];
	     OpportunityLineItem OLI =[select id from OpportunityLineItem limit 1];
	     test.startTest();
	     Object_Controller.getVflasClient(cliente.Id,'Directa');
	     test.stopTest();
	   }
	   @isTest static void getVflasClient_test2() {
	     Account cliente = [select id from Account limit 1];
	     Product2 ProdId =[select id from Product2 limit 1];
	     OpportunityLineItem OLI =[select id from OpportunityLineItem limit 1];
	     test.startTest();
	     Object_Controller.getVflasClient(null,'Directa');
	     test.stopTest();
	   }*/
       
	@isTest static void getProduct2_test() {
		//Product2 ProdId =[select id from Product2 limit 1];//Yuliño: correcion
		OpportunityLineItem OLI = [select id from OpportunityLineItem limit 1];
		test.startTest();
		Product2 empuet = new Product2();
		empuet = Object_Controller.getProduct2(OLI.Id);
		system.assertNotEquals(null, empuet);
		test.stopTest();
	}
}
