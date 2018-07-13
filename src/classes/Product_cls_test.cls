/*-------------------------------------------------------------------------
 * Name: Product_cls
 * Description : Class to insert a record from Account
 * Created date : May 15 2018
 * Developer name: Isaías Velázquez Cortés Indra(México)
--------------------------------------------------------------------------*/

@isTest
public class Product_cls_test {
	static List<Profile> p; 
    static List<UserRole> userRole;
    static Map<String, Profile> perfilMapa = new Map<String, Profile>();    
	static{
        p = new List<Profile>([SELECT Id, Name FROM Profile]);
        userRole = new List<UserRole>([SELECT Id, Name FROM UserRole]);
        for(Profile perfil:p){ perfilMapa.put(perfil.Name, perfil); }
    }
    
	@isTest static void Product_Gurantee_test() {

		User u = new User();
	    u.Username='u2@u.com.u';
	    u.LastName='uLast2';
	    u.Email='u2@u.com';
	    u.Alias= 'uAlias2';
	    u.CommunityNickname='2uComm';
	    u.TimeZoneSidKey='America/Mexico_City';
	    u.LocaleSidKey='en_US';
	    u.EmailEncodingKey='ISO-8859-1';
	    u.ProfileId=  perfilMapa.get('Ejecutivo').Id;
	    u.LanguageLocaleKey='en_US';
	    insert u;
        
        User u2 = new User();
	    u2.Username='u22@u.com.u';
	    u2.LastName='uLast22';
	    u2.Email='u22@u.com';
	    u2.Alias= 'uAlias22';
	    u2.CommunityNickname='22uComm';
	    u2.TimeZoneSidKey='America/Mexico_City';
	    u2.LocaleSidKey='en_US';
	    u2.EmailEncodingKey='ISO-8859-1';
	    u2.ProfileId=  perfilMapa.get('Operativo').Id;
	    u2.LanguageLocaleKey='en_US';
	    insert u2;


		test.startTest();
        System.runAs(u){ 
            Account MyAcc = new Account();
            MyAcc.Name='Mi cuenta';
            insert MyAcc;
            
			Opportunity testOP= new Opportunity();
			testOP.Name='TESTOP';
        	testOP.StageName='02';
            testOp.AccountId=MyAcc.Id;
        	testOP.CloseDate=Date.today();
        	testOP.Amount = 10000;
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
        	
        	testPE.UnitPrice=120;
        	testPE.CurrencyIsoCode='PEN';
        	testPE.Pricebook2Id=pricebookId;
        	testPE.Product2Id=testPr.Id;
        	testPE.IsActive=true;
            insert testPE;
        
			OpportunityLineItem testLOPP = new OpportunityLineItem();
        	testLOPP.TotalPrice=120;
			testLOPP.OpportunityId=testOP.Id;
			testLOPP.Product2Id=testPr.Id;
        	testLOPP.PricebookEntryId=testPE.Id;
        	testLOPP.Quantity=1;
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
        	Product_cls.setSanctionPrice(testOP.Id,'btnApprove','obs');
        	Product_cls.setFormalization(testOP.Id,'btnApprove','id','obs');
            System.runAs(u2){ 
	        Product_cls.setLastFormalization(testOP.Id,'btnApprove','obs','1234-1234-1234567890');
       		Product_cls.setLastFormalization(testOP.Id,'btnRaise','obs','1234-1234-1234567890');
            Product_cls.setLastFormalization(testOP.Id,'btnBack','obs','1234-1234-1234567890');
            }
        	testLOPP.gipr_Tipo_Garantia__c='02';
        	update testLOPP;
        	Product_cls.getAccountBBVAInformation(MyAcc.Id);
     		System.assert(true,'This Works!');
		test.stopTest();
        }
	}
	
	
	
}