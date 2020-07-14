/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_CalceNewOppHeadAction_Tst>
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-06-21
   @Description Test class from BE_CalceNewOppHeadAction_Ctr
   @Changes
   Date        Author   Email                  				Type		Description
   2020-06-21  MAMC     martin.mori.contractor@bbva.com    	Creation
   2020-07-14  MAMC     martin.mori.contractor@bbva.com    	Modify		add fail methods to correct coverage test
   -------------------------------------------------------------------------------------------------
 */
@isTest
private class BE_CalceNewOppHeadAction_Tst {
    /**
    @Description test method createRecords
    */
    @isTest
    public static void createRecordsTest() {
        final Account acc = TestFactory.createAccount();
        final Product2 prod = TestFactory.createProduct();
        prod.IsActive = true;
        update prod;
        insert new PriceBookEntry(Product2Id=prod.Id, Pricebook2Id=Test.getStandardPricebookId(), UnitPrice=0, IsActive=true, CurrencyIsoCode='PEN');
        final fprd__GBL_Product_version__c prodVersion = new fprd__GBL_Product_version__c();
        prodVersion.fprd__Active__c = true;
        prodVersion.fprd__Product__c = prod.Id;
        prodVersion.fprd__Version_number__c = 1;
        prodVersion.CurrencyIsoCode = 'PEN';
        insert prodVersion;
        Final Calce__c calce = new Calce__c();
        calce.Name = 'Test Calce';
        calce.close_date__c = Date.today();
        calce.status__c = 'Iniciado';
        insert calce;
        final Calce_Details__c detail = new Calce_Details__c();
        detail.calce_id__c=calce.Id;
        detail.account_id__c=acc.Id;
        detail.product_id__c=prod.Id;
        detail.Name='detail';
        detail.CurrencyIsoCode='PEN';
        detail.amount__c=50000;
        detail.close_date__c=date.today();
        detail.type__c='Indirect';
        detail.product_code__c='CODE001';
        detail.sub_type__c='01';
        final List<sObject> lts = new List<sObject>();
        lts.add(detail);
        Test.StartTest();
        final BE_CalceNewOppHeadAction_Ctr newOpp = new BE_CalceNewOppHeadAction_Ctr();
        final BE_SingleRelatedListCRUD_Cls.Response resp = newOpp.createRecords(lts);
        System.assert(resp.isSuccess, 'success!!!');
        test.stopTest();
    }
    
    /**
    @Description test method createRecords fail
    */
    @isTest
    public static void createRecordsFailTest() {
        final Account acc = TestFactory.createAccount();
        Final Calce__c calce = new Calce__c();
        calce.Name = 'Test Calce';
        calce.close_date__c = Date.today();
        calce.status__c = 'Iniciado';
        insert calce;
        final Calce_Details__c detail = new Calce_Details__c();
        detail.calce_id__c=calce.Id;
        detail.account_id__c=acc.Id;
        detail.Name='detail';
        detail.CurrencyIsoCode='PEN';
        detail.amount__c=50000;
        detail.close_date__c=date.today();
        detail.type__c='Indirectas';
        detail.product_code__c='CODE001';
        detail.sub_type__c='01';
        final List<sObject> lts = new List<sObject>();
        lts.add(detail);
        Test.StartTest();
        final BE_CalceNewOppHeadAction_Ctr newOpp = new BE_CalceNewOppHeadAction_Ctr();
        final BE_SingleRelatedListCRUD_Cls.Response resp = newOpp.createRecords(lts);
        System.assert(!resp.isSuccess, 'error!!!');
        test.stopTest();
    }
    
    /**
    @Description test method createRecords fail
    */
    @isTest
    public static void createRecordsNullTest() {
        final Account acc = TestFactory.createAccount();
        final Product2 prod = TestFactory.createProduct();
        prod.IsActive = true;
        update prod;
        insert new PriceBookEntry(Product2Id=prod.Id, Pricebook2Id=Test.getStandardPricebookId(), UnitPrice=0, IsActive=true, CurrencyIsoCode='PEN');
        final fprd__GBL_Product_version__c prodVersion = new fprd__GBL_Product_version__c();
        prodVersion.fprd__Active__c = true;
        prodVersion.fprd__Product__c = prod.Id;
        prodVersion.fprd__Version_number__c = 1;
        prodVersion.CurrencyIsoCode = 'PEN';
        insert prodVersion;
        Final Calce__c calce = new Calce__c();
        calce.Name = 'Test Calce';
        calce.close_date__c = Date.today();
        calce.status__c = 'Iniciado';
        insert calce;
        final Calce_Details__c detail = new Calce_Details__c();
        detail.calce_id__c=calce.Id;
        detail.account_id__c=acc.Id;
        detail.product_id__c=prod.Id;
        detail.Name='detail';
        detail.CurrencyIsoCode='EUR';
        detail.amount__c=50000;
        detail.close_date__c=date.today();
        detail.type__c='Indirect';
        detail.product_code__c='CODE001';
        detail.sub_type__c='01';
        final List<sObject> lts = new List<sObject>();
        lts.add(detail);
        Test.StartTest();
        final BE_CalceNewOppHeadAction_Ctr newOpp = new BE_CalceNewOppHeadAction_Ctr();
        final BE_SingleRelatedListCRUD_Cls.Response resp = newOpp.createRecords(lts);
        System.assert(!resp.isSuccess, 'error!!!');
        test.stopTest();
    }
    
    /**
    @Description test method createRecords fail owner
    */
    @isTest
    public static void createRecordsFailOwnTest() {
        Final Account acc = TestFactory.createAccount();
        Final User usuario = TestFactory.createUser('TestUser1', 'Ejecutivo');
        Final Calce__c calce = new Calce__c();
        calce.Name = 'Test Calce';
        calce.close_date__c = Date.today();
        calce.status__c = 'Iniciado';
        calce.OwnerId = usuario.Id;
        insert calce;
        final Calce_Details__c detail = new Calce_Details__c();
        detail.calce_id__c=calce.Id;
        detail.account_id__c=acc.Id;
        detail.Name='detail';
        detail.CurrencyIsoCode='PEN';
        detail.amount__c=50000;
        detail.close_date__c=date.today();
        detail.type__c='Indirectas';
        detail.product_code__c='CODE001';
        detail.sub_type__c='01';
        final List<sObject> lts = new List<sObject>();
        lts.add(detail);
        Test.StartTest();
        final BE_CalceNewOppHeadAction_Ctr newOpp = new BE_CalceNewOppHeadAction_Ctr();
        final BE_SingleRelatedListCRUD_Cls.Response resp = newOpp.createRecords(lts);
        System.assert(!resp.isSuccess, 'error!!!');
        test.stopTest();
    }
}
