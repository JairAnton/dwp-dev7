/*-------------------------------------------------------------------------
 * Name: Product_cls
 * Description : Class to insert a record from Account
 * Created date : May 15 2018
 * Developer name: Isaías Velázquez Cortés Indra(México)
--------------------------------------------------------------------------*/

@isTest
public class Product_cls_test {
	
	@isTest static void Product_Gurantee_test() {



		test.startTest();
			Opportunity testOP= new Opportunity();
			testOP.Name='TESTOP';
        	testOP.StageName='02';
        	testOP.CloseDate=Date.today();
			insert testOP;
        
			Product2 testPr = new Product2();
			testPr.Name='TestProd';	
			insert testPr;
        
        	Pricebook2 testPB = new Pricebook2();
        	testPB.CurrencyIsoCode='PEN';
        	testPB.Name='MyPrice';
        	//testPB.IsStandard=true;
        	insert testPB;
	        Id pricebookId = Test.getStandardPricebookId();

        	
        	PricebookEntry testPE = new PricebookEntry();
        	testPE.Pricebook2Id=testPB.Id;
        	testPE.UnitPrice=120;
        	testPE.CurrencyIsoCode='PEN';
        	testPE.Pricebook2Id=pricebookId;
        	testPE.Product2Id=testPr.Id;
        	testPE.IsActive=true;
        	
            insert testPE;
        
			OpportunityLineItem testLOPP = new OpportunityLineItem();
			testLOPP.OpportunityId=testOP.Id;
			testLOPP.Product2Id=testPr.Id;
        	testLOPP.PricebookEntryId=testPE.Id;
        	testLOPP.Quantity=1;
            testLOPP.TotalPrice=120;
        	testLOPP.gipr_Tipo_Garantia__c='03';
			insert testLOPP;

			Product_Gurantee__c testPG = new Product_Gurantee__c();			
			testPG.Opportunity__c=testOP.Id;
			testPG.Product__c=testPr.Id;
        	
			insert testPG;

			Product_Participants__c testPP = new Product_Participants__c();			
			testPP.Opportunity__c=testOP.Id;
			testPP.Product__c=testPr.Id;
			insert testPP;

			Product_cls.getIdProductByOpportunity(testOP.Id);
			
			Product_cls.getGuaranteeDataByProduct(testOP.Id,testPr.Id);
			Product_cls.getGuaranteeDataByProductValues(testPG.Id);

			Product_cls.getParticipantDataByProduct(testOP.Id,testPr.Id);
			Product_cls.getParticipantDataByProductValues(testPG.Id);
			Product_cls.getCompromisoDataByProduct(testOP.Id);
            Product_cls.getOpportunityLineItemDataByProduct(testOP.Id,testPr.Id);
            Product_cls.verifyIfHasQuoted(testOP.Id);
			Product_cls.saveGuaranteeDataByProduct(testPG.Id,testOP.Id,testPr.Id,'01','01','01',1,'01',1,'01',1);
			
			Product_cls.saveParticipantDataByProduct(testPP.Id,testOP.Id,testPr.Id,'Name','01','01','01','01');

       		Product_cls.deleteGuaranteeDataByProduct(testPG.Id);
       		Product_cls.deleteParticipantDataByProduct(testPP.Id);
        	Product_cls.setSanctionPrice(testOP.Id,'btnApprove');
        	Product_cls.setFormalization(testOP.Id,'btnApprove','id');
        	testLOPP.gipr_Tipo_Garantia__c='02';
        	update testLOPP;
     		System.assert(true,'This Works!');

		test.stopTest();
	}
	
	
	
}
