/**
   -------------------------------------------------------------------------------------------------
   Clase Test BE_ProdCommissionSection_Ctr_Test
   -------------------------------------------------------------------------------------------------
last change**/

@istest

public class  BE_ProdCommissionSection_Ctr_Test {
	/**
	 * Label of GrantingTickets
	 */
	static String grantTK = 'GrantingTickets';
	/**
	 * Label of url GrantingTickets
	 */
	static String urlGrantTK = 'https://validation/ok';
    /**
	 * Label of ListCommissionRequests
	 */
	static String getCommissions = 'ListCommissionRequests';
    /**
	 * Label of url ListCommissionRequests
	 */
	static String urlgetCommissions = 'https://ListCommissionRequests/OK';
    /**
	 * Label of CalculateCommission
	 */
	static String calculateCommission = 'CalculateCommission';
    /**
	 * Label of url CalculateCommission
	 */
	static String urlcalculateCommission = 'https://CalculateCommission/OK';
    /**
	 * Label of credential login
	 */
	static String credential = 'local.CredentialsPeru';
    
    
    @testSetup
    static void setup() {
        Final Account acc = TestFactory.createAccount();
        Final Opportunity opp = TestFactory.createOpportunity(acc.Id, UserInfo.getUserId());
        Final Product2 prod = TestFactory.createProduct();
        //OpportunityLineItem oli = TestFactory.createOLI(opp.Id, prod.Id);
        Final PriceBookEntry pbe = new PriceBookEntry(Product2Id = prod.Id, PriceBook2Id = Test.getStandardPricebookId(),
                                                      UnitPrice = 1, UseStandardPrice = false, IsActive = true);
        insert pbe;
        Final OpportunityLineItem oli = new OpportunityLineItem( OpportunityId = opp.Id, Product2Id = prod.Id,
                                                                Quantity = 1, TotalPrice = 123,
                                                                PriceBookEntryId = pbe.Id);
        
        insert oli;
        oli.PE_List_Product_mode__c = '01';
        
        update oli;
        
    }    
    
    @isTest
    static void testGetCommissions() {
        final OpportunityLineItem oli = [select id from OpportunityLineItem limit 1];
        
        insert new iaso__GBL_Rest_Services_Url__c(Name = grantTK, iaso__Url__c = urlGrantTK, iaso__Cache_Partition__c = credential);
		insert new iaso__GBL_Rest_Services_Url__c(Name = getCommissions, iaso__Url__c = urlgetCommissions, iaso__Cache_Partition__c = credential);
        Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
		iaso.GBL_Mock.setMock(new Integration_MockGenerator());
        
        
        Test.startTest();
        final List<Product_Commission__c> commisions = BE_ProdCommissionSection_Ctr.getCommissions(oli.Id, true, true);
        Test.stopTest();
        System.assertEquals(4, commisions.size(),'El tamaño es de 4');
    }
    
  /*  @isTest
    static void testcalculateRate() {
        final OpportunityLineItem oli = [SELECT Id FROM OpportunityLineItem LIMIT 1];
        // Set mock callout class 
		insert new iaso__GBL_Rest_Services_Url__c(Name = grantTK, iaso__Url__c = urlGrantTK, iaso__Cache_Partition__c = credential);
		insert new iaso__GBL_Rest_Services_Url__c(Name = calculateCommission, iaso__Url__c = urlcalculateCommission, iaso__Cache_Partition__c = credential);
        Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
        iaso.GBL_Mock.setMock(new Integration_MockGenerator());
        final List<Product_Commission__c> lstCommisions = BE_ProdCommissionSection_Ctr.getCommissions(oli.Id,true,true);
        
        Test.startTest();
        BE_ProdCommissionSection_Ctr.calculateRate('{"rawCommission":[{"Commission_Maximum_Amount__c":700,"Product_Commission_Name__c":"Gestión Operativa","Opportunity_Product__c":"00kq0000009S0UvAAK","Calculation_Type__c":"PERCENTAGE","Id":"a22q0000001XpR2AAK","Commission_Calculation_Amount__c":0,"Is_Negotiable__c":true,"CurrencyIsoCode":"PEN","Suggested_Rate_Value__c":20,"Commission_Minimum_Amount__c":120,"Code__c":"CO217","Suggested_Rate_Type__c":"percentage","Requested_Rate_Value__c":"15.98"},{"Product_Commission_Name__c":"Comisión de Estructuración","Opportunity_Product__c":"00kq0000009S0UvAAK","Calculation_Type__c":"PERCENTAGE","Id":"a22q0000001XpR1AAK","Commission_Calculation_Amount__c":0,"Is_Negotiable__c":true,"CurrencyIsoCode":"PEN","Suggested_Rate_Value__c":1,"Commission_Minimum_Amount__c":850,"Code__c":"CO229","Suggested_Rate_Type__c":"percentage","Requested_Rate_Value__c":"3.8899"},{"Commission_Questions__r":{"totalSize":2,"done":true,"records":[{"Answer__c":true,"Product_Commission__c":"a22q0000001XpR0AAK","output_Type__c":"YES_OR_NOT","isCurrency__c":false,"Description__c":"El tipo de prestamo es Cancelación Anticipada, Amortización Parcial o Prepago de cuotas?","BooleanValue__c":false,"Id":"a23q0000000GauRAAS","CurrencyIsoCode":"PEN","isParent__c":true,"Code__c":1,"isBoolean__c":true},{"Answer__c":true,"isCurrency__c":false,"Input_Value__c":"SI","CurrencyIsoCode":"PEN","isParent__c":true,"Code__c":2,"Product_Commission__c":"a22q0000001XpR0AAK","output_Type__c":"YES_OR_NOT","Description__c":"El Plazo es mayor a 12?","Input_Type__c":"YES_OR_NOT","BooleanValue__c":false,"Id":"a23q0000000GauQAAS","Parent_Question__c":"a23q0000000GauRAAS","isBoolean__c":true}]},"Product_Commission_Name__c":"Por Liquidación Anticipada","Opportunity_Product__c":"00kq0000009S0UvAAK","Calculation_Type__c":"PERCENTAGE","Id":"a22q0000001XpR0AAK","Commission_Calculation_Amount__c":0,"Is_Negotiable__c":false,"CurrencyIsoCode":"PEN","Suggested_Rate_Value__c":5,"Code__c":"CO235","Suggested_Rate_Type__c":"percentage"},{"Commission_Questions__r":{"totalSize":2,"done":true,"records":[{"Answer__c":true,"Product_Commission__c":"a22q0000001XpQzAAK","output_Type__c":"YES_OR_NOT","isCurrency__c":false,"Description__c":"El tipo de prestamo es Cancelación Anticipada, Amortización Parcial o Prepago de cuotas?","BooleanValue__c":false,"Id":"a23q0000000GauPAAS","CurrencyIsoCode":"PEN","isParent__c":true,"Code__c":1,"isBoolean__c":true},{"Answer__c":true,"isCurrency__c":false,"Input_Value__c":"SI","CurrencyIsoCode":"PEN","isParent__c":true,"Code__c":2,"Product_Commission__c":"a22q0000001XpQzAAK","output_Type__c":"YES_OR_NOT","Description__c":"El Plazo es mayor a 12?","Input_Type__c":"YES_OR_NOT","BooleanValue__c":false,"Id":"a23q0000000GauOAAS","Parent_Question__c":"a23q0000000GauPAAS","isBoolean__c":true}]},"Product_Commission_Name__c":"Por Liquidación Anticipada","Opportunity_Product__c":"00kq0000009S0UvAAK","Calculation_Type__c":"PERCENTAGE","Id":"a22q0000001XpQzAAK","Commission_Calculation_Amount__c":0,"Is_Negotiable__c":false,"CurrencyIsoCode":"PEN","Suggested_Rate_Value__c":5,"Code__c":"CO239","Suggested_Rate_Type__c":"percentage"}]}',lstCommisions[0].Id, '09');
		Test.stopTest();
        System.assertEquals(4, lstCommisions.size(),'El tamaño es de 4');
    }
   @isTest
    static void testSaveCommissions() {
        final OpportunityLineItem oppLineItem = [SELECT Id FROM OpportunityLineItem LIMIT 1];
        final List<Product_Commission__c> comiquestions = [SELECT Id, numberOfQuestions__c FROM Product_Commission__c LIMIT 1 ];
        Test.startTest();
        BE_ProdCommissionSection_Ctr.saveCommissions('{"rawCommission":[{"Commission_Maximum_Amount__c":700,"Product_Commission_Name__c":"Gestión Operativa","Opportunity_Product__c":"00kq0000009S0UvAAK","Calculation_Type__c":"PERCENTAGE","Id":"a22q0000001XpR2AAK","Commission_Calculation_Amount__c":0,"Is_Negotiable__c":true,"CurrencyIsoCode":"PEN","Suggested_Rate_Value__c":20,"Commission_Minimum_Amount__c":120,"Code__c":"CO217","Suggested_Rate_Type__c":"percentage","Requested_Rate_Value__c":"15.98"},{"Product_Commission_Name__c":"Comisión de Estructuración","Opportunity_Product__c":"00kq0000009S0UvAAK","Calculation_Type__c":"PERCENTAGE","Id":"a22q0000001XpR1AAK","Commission_Calculation_Amount__c":0,"Is_Negotiable__c":true,"CurrencyIsoCode":"PEN","Suggested_Rate_Value__c":1,"Commission_Minimum_Amount__c":850,"Code__c":"CO229","Suggested_Rate_Type__c":"percentage","Requested_Rate_Value__c":"3.8899"},{"Commission_Questions__r":{"totalSize":2,"done":true,"records":[{"Answer__c":true,"Product_Commission__c":"a22q0000001XpR0AAK","output_Type__c":"YES_OR_NOT","isCurrency__c":false,"Description__c":"El tipo de prestamo es Cancelación Anticipada, Amortización Parcial o Prepago de cuotas?","BooleanValue__c":false,"Id":"a23q0000000GauRAAS","CurrencyIsoCode":"PEN","isParent__c":true,"Code__c":1,"isBoolean__c":true},{"Answer__c":true,"isCurrency__c":false,"Input_Value__c":"SI","CurrencyIsoCode":"PEN","isParent__c":true,"Code__c":2,"Product_Commission__c":"a22q0000001XpR0AAK","output_Type__c":"YES_OR_NOT","Description__c":"El Plazo es mayor a 12?","Input_Type__c":"YES_OR_NOT","BooleanValue__c":false,"Id":"a23q0000000GauQAAS","Parent_Question__c":"a23q0000000GauRAAS","isBoolean__c":true}]},"Product_Commission_Name__c":"Por Liquidación Anticipada","Opportunity_Product__c":"00kq0000009S0UvAAK","Calculation_Type__c":"PERCENTAGE","Id":"a22q0000001XpR0AAK","Commission_Calculation_Amount__c":0,"Is_Negotiable__c":false,"CurrencyIsoCode":"PEN","Suggested_Rate_Value__c":5,"Code__c":"CO235","Suggested_Rate_Type__c":"percentage"},{"Commission_Questions__r":{"totalSize":2,"done":true,"records":[{"Answer__c":true,"Product_Commission__c":"a22q0000001XpQzAAK","output_Type__c":"YES_OR_NOT","isCurrency__c":false,"Description__c":"El tipo de prestamo es Cancelación Anticipada, Amortización Parcial o Prepago de cuotas?","BooleanValue__c":false,"Id":"a23q0000000GauPAAS","CurrencyIsoCode":"PEN","isParent__c":true,"Code__c":1,"isBoolean__c":true},{"Answer__c":true,"isCurrency__c":false,"Input_Value__c":"SI","CurrencyIsoCode":"PEN","isParent__c":true,"Code__c":2,"Product_Commission__c":"a22q0000001XpQzAAK","output_Type__c":"YES_OR_NOT","Description__c":"El Plazo es mayor a 12?","Input_Type__c":"YES_OR_NOT","BooleanValue__c":false,"Id":"a23q0000000GauOAAS","Parent_Question__c":"a23q0000000GauPAAS","isBoolean__c":true}]},"Product_Commission_Name__c":"Por Liquidación Anticipada","Opportunity_Product__c":"00kq0000009S0UvAAK","Calculation_Type__c":"PERCENTAGE","Id":"a22q0000001XpQzAAK","Commission_Calculation_Amount__c":0,"Is_Negotiable__c":false,"CurrencyIsoCode":"PEN","Suggested_Rate_Value__c":5,"Code__c":"CO239","Suggested_Rate_Type__c":"percentage"}]}',oppLineItem.Id);
        Test.stopTest(); 
        System.assertEquals(0, comiquestions.size(),'El tamaño es de 0');

    }
}*/
  }  