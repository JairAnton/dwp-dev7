/*-------------------------------------------------------------------------
 * Name: Product_cls
 * Description : Class to insert a record from Account
 * Created date : May 15 2018
 * Developer name: Isaías Velázquez Cortés Indra(México)
 * Last Modified by : Eduardo Castillo Sunahata Indra(Perú)
 * Last Modified date: Oct 01 2018
--------------------------------------------------------------------------*/

@isTest(seeAllData=true)
public class Product_cls_test {
	static List<Profile> p; 
    static List<UserRole> userRole;
    static Map<String, Profile> perfilMapa = new Map<String, Profile>();    
	static{
        p = new List<Profile>([SELECT Id, Name FROM Profile]);
        userRole = new List<UserRole>([SELECT Id, Name FROM UserRole]);
        for(Profile perfil:p){ perfilMapa.put(perfil.Name, perfil); }
    }
    
	@isTest 
	static void Product_Gurantee_test() {
		User u = new User();
	    u.Username='u2@u.com.u';
	    u.LastName='uLast2';
	    u.Email='u2@u.com';
	    u.Alias= 'uAlias2';
	    u.CommunityNickname='2uComm';
	    //u.TimeZoneSidKey='America/Mexico_City';
	    //u.LocaleSidKey='en_US';
	    u.TimeZoneSidKey='America/Lima';
	    u.LocaleSidKey='es_PE';
	    u.EmailEncodingKey='ISO-8859-1';
	    u.ProfileId=  perfilMapa.get('Ejecutivo').Id;
	    //u.LanguageLocaleKey='en_US';
	    u.LanguageLocaleKey='es';
	    //insert u;
        
        User u2 = new User();
	    u2.Username='u22@u.com.u';
	    u2.LastName='uLast22';
	    u2.Email='u22@u.com';
	    u2.Alias= 'uAlias22';
	    u2.CommunityNickname='22uComm';
	    //u2.TimeZoneSidKey='America/Mexico_City';
	    //u2.LocaleSidKey='en_US';
	    u2.TimeZoneSidKey='America/Lima';
	    u2.LocaleSidKey='es_PE';
	    u2.EmailEncodingKey='ISO-8859-1';
	    u2.ProfileId=  perfilMapa.get('Operativo').Id;
	    //u2.LanguageLocaleKey='en_US';
        u2.LanguageLocaleKey='es';
	    //insert u2;
	    //
	    List<User> newUsers = new List<User>();
        newUsers.add(u);
        newUsers.add(u2);
        insert newUsers;

		test.startTest();
        System.runAs(u){ 
            Account MyAccParent = new Account();
            MyAccParent.Name='Mi cuenta padre';
            insert MyAccParent;
            
            Account MyAcc = new Account();
            MyAcc.Name='Mi cuenta';
            MyAcc.ParentId= MyAccParent.id;
            insert MyAcc;
            
            String idcuentapadre = MyAccParent.Id;
            String idcuenta = MyAcc.Id;
            
            List<Account_BBVA_Information__c> listaABI = new  List<Account_BBVA_Information__c>();
            Account_BBVA_Information__c accbbvai= null;
            for(integer i=0;i<3;i++){
                accbbvai= new Account_BBVA_Information__c();
                accbbvai.year_month_day_date__c = date.newInstance(2018, 09, 06); 
                accbbvai.average_balance_amount__c = 1560.0;	
                if(i==0){
                	accbbvai.type__c = '01';
                    accbbvai.product_group_classification_id__c = 'DIRECTA';	
                	accbbvai.product_desc__c = 'RIESGO DIRECTO';
                } else if (i==1) {
                	accbbvai.type__c = '01';
                    accbbvai.product_group_classification_id__c = 'INDIRECTA';	
                	accbbvai.product_desc__c = 'RIESGO INDIRECTO';    
                } else if (i==2) {
                    accbbvai.type__c = '02';
                    accbbvai.product_group_classification_id__c = 'RECURSOS GESTIONADOS';	
                	accbbvai.product_desc__c = 'RECURSOS CAPTADOS';    
                } 
                accbbvai.current_balance_var_year_amount__c = 27.0;	
                accbbvai.current_balance_var_quart_amount__c = 27.0;	
                accbbvai.current_balance_var_month_amount__c = 27.0;	
                accbbvai.current_balance_var_day_amount__c = 0.0;	
                accbbvai.current_balance_var_day_amount__c = 849.9;	
                accbbvai.account_id__c = idcuenta;
                listaABI.add(accbbvai);
            }
            insert listaABI; 
            
            //Crear Oportunidad con Producto - 1 ECS
			Opportunity testOP= new Opportunity();
			testOP.Name='TESTOP';
        	testOP.StageName='02';
            testOp.AccountId=MyAcc.Id;
        	testOP.CloseDate=Date.today();
        	testOP.Amount = 10000;
			insert testOP;
        
			Product2 testPr = new Product2();
			testPr.Name='TestProd';	
            testPr.type_of_quote__c='COTIZA Beta';
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
            //Crear Oportunidad con Producto - 1 Fin
            
			fprd__GBL_Guarantee__c testPG = new fprd__GBL_Guarantee__c();
            testPG.fprd__GBL_Opportunity_product__c=testOP.Id;        	
			insert testPG;

			fprd__GBL_Intervener__c testPP = new fprd__GBL_Intervener__c();
            testPP.fprd__GBL_Opportunity_product__c=testOP.Id;
			insert testPP;

			Product_cls.getIdProductByOpportunity(testOP.Id);
			
			Product_cls.getGuaranteeDataByProduct(testOP.Id,testPr.Id);
			Product_cls.getGuaranteeDataByProductValues(testPG.Id);

			Product_cls.getParticipantDataByProduct(testOP.Id,testPr.Id);
			Product_cls.getParticipantDataByProductValues(testPG.Id);
            Product_cls.getOpportunityLineItemDataByProduct(testOP.Id,testPr.Id);
            Product_cls.verifyIfHasQuoted(testOP.Id);
			Product_cls.saveGuaranteeDataByProduct(testPG.Id,testOP.Id,testPr.Id,'01','01','01',1,'01',1,'01',1);
			Product_cls.saveGuaranteeDataByProduct(null,testOP.Id,testPr.Id,'01','01','01',1,'01',1,'01',1);//ECS
			Product_cls.saveGuaranteeDataByProduct(testPG.Id,null,testPr.Id,'01','01','01',1,'01',1,'01',1);//ECS
			Product_cls.saveParticipantDataByProduct(testPP.Id,testOP.Id,testPr.Id,'Name','01','01','01','01');
			Product_cls.saveParticipantDataByProduct(null,testOP.Id,testPr.Id,'Name','01','01','01','01');//ECS
            

       		Product_cls.deleteGuaranteeDataByProduct(testPG.Id);
       		Product_cls.deleteParticipantDataByProduct(testPP.Id);
        	Product_cls.setSanctionPrice(testOP.Id,'btnApprove','obs');
            Product_cls.setSanctionPrice(testOP.Id,'btnRaise','obs');
            Product_cls.setSanctionPrice(testOP.Id,'else','obs');
             Product_cls.setSanctionPrice('a00000000008','else','obs');//ECS
        	Product_cls.setFormalization(testOP.Id,'btnApprove','id','obs');
			Product_cls.setRejectOpportunity(testOP.Id,'01',null,null,null,null,null,null);

        	testLOPP.gipr_Tipo_Garantia__c='02';
        	update testLOPP;
        	Product_cls.getAccountBBVAInformation(MyAccParent.Id);
     		System.assert(true,'This Works!');
		test.stopTest();
        }
	}
    
    @isTest 
	static void Product_Gurantee_test_fails() {
		User u = new User();
	    u.Username='u2@u.com.u';
	    u.LastName='uLast2';
	    u.Email='u2@u.com';
	    u.Alias= 'uAlias2';
	    u.CommunityNickname='2uComm';
	    u.TimeZoneSidKey='America/Lima';
	    u.LocaleSidKey='es_PE';
	    u.EmailEncodingKey='ISO-8859-1';
	    u.ProfileId=  perfilMapa.get('Ejecutivo').Id;
	    u.LanguageLocaleKey='es';
        
        User u2 = new User();
	    u2.Username='u22@u.com.u';
	    u2.LastName='uLast22';
	    u2.Email='u22@u.com';
	    u2.Alias= 'uAlias22';
	    u2.CommunityNickname='22uComm';
	    u2.TimeZoneSidKey='America/Lima';
	    u2.LocaleSidKey='es_PE';
	    u2.EmailEncodingKey='ISO-8859-1';
	    u2.ProfileId=  perfilMapa.get('Operativo').Id;
        u2.LanguageLocaleKey='es';
	    
	    List<User> newUsers = new List<User>();
        newUsers.add(u);
        newUsers.add(u2);
        insert newUsers;

		test.startTest();
        System.runAs(u){ 
            Account MyAccParent = new Account();
            MyAccParent.Name='Mi cuenta padre';
            insert MyAccParent;
            
            Account MyAcc = new Account();
            MyAcc.Name='Mi cuenta';
            MyAcc.ParentId= MyAccParent.id;
            insert MyAcc;
            
            String idcuentapadre = MyAccParent.Id;
            String idcuenta = MyAcc.Id;
            
            //Crear Oportunidad con Producto - 1
			Opportunity testOP= new Opportunity();
			testOP.Name='TESTOP';
        	testOP.StageName='02';
            testOp.AccountId=MyAcc.Id;
        	testOP.CloseDate=Date.today();
        	testOP.Amount = 10000;
			insert testOP;
        
			Product2 testPr = new Product2();
			testPr.Name='TestProd';	
            testPr.type_of_quote__c='COTIZADOR';
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
            //Crear Oportunidad con Producto - 1 Fin
            
			fprd__GBL_Guarantee__c testPG = new fprd__GBL_Guarantee__c();
            testPG.fprd__GBL_Opportunity_product__c=testOP.Id;        	
			insert testPG;

			fprd__GBL_Intervener__c testPP = new fprd__GBL_Intervener__c();
            testPP.fprd__GBL_Opportunity_product__c=testOP.Id;
			insert testPP;
            
            Product_cls.getIdProductByOpportunity('a00127831831831');

			Product_cls.saveParticipantDataByProduct(null,'a00127831831831',testPr.Id,'Name','01','01','01','01');//ECS
			Product_cls.setFormalization(testOP.Id,'btnApprove','','obs');
            Product_cls.setFormalization('a00127831831831','btnApprove','id','obs');
            System.runAs(u2){ 
                Product_cls.setLastFormalization(testOP.Id,'btnApprove','obs','1234-1234-1234567890');
                Product_cls.setLastFormalization(testOP.Id,'btnRaise','obs','1234-1234-1234567890');                
                Product_cls.setLastFormalization(testOP.Id,'btnRaise','obs','abcd-abcd-qwertyuiop');
                Product_cls.setLastFormalization(testOP.Id,'btnBack','obs','1234-1234-1234567890');
                
                //Product_cls.setLastFormalization(testOP.Id,'btnBack','obs','1234-1234-1234567890');
                
                Product_cls.TraceabilityMessage (testOP.Id,'32','String Body','');       
            }
        	testLOPP.gipr_Tipo_Garantia__c='02';
        	update testLOPP;
     		System.assert(true,'This Works!');
		test.stopTest();
        }
	}
	
}