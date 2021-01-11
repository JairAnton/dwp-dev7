/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_CalceNewEarlyCancellations_Tst>
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-06-21
   @Description Test class from BE_CalceNewEarlyCancellations_Ctr
   @Changes
   Date        Author   Email                  				Type		Description
   2020-06-21  MAMC     martin.mori.contractor@bbva.com    	Creation
   2020-07-14  MAMC     martin.mori.contractor@bbva.com    	Modify		add fail methods to correct coverage test
   -------------------------------------------------------------------------------------------------
 */
@isTest
private class BE_CalceNewEarlyCancellations_Tst {
    /** variable Indirect */
    private static final String INDIRECT = 'indirect';
    /** PEN currecyisocode */
    private static final String CURPEN = 'PEN';
    
    /**
    @Description test method createRecords
    */
    @isTest
    public static void createRecordsTest() {
        final Account acc = TestFactory.createAccount();
        final Product2 prod = TestFactory.createProduct();
        prod.IsActive = true;
        update prod;
        final Calce__c calce = new Calce__c();
        calce.Name = 'Test Calce1';
        calce.close_date__c = Date.today();
        calce.start_date__c = Date.today();
        insert calce;
        final Calce_Details__c detail = new Calce_Details__c();
        detail.calce_id__c=calce.Id;
        detail.account_id__c=acc.Id;
        detail.product_id__c=prod.Id;
        detail.Name='detail1';
        detail.CurrencyIsoCode=CURPEN;
        detail.amount__c=50000;
        detail.close_date__c=date.today();
        detail.type__c=INDIRECT;
        detail.product_code__c='CODE001';
        detail.sub_type__c='01';
        final List<sObject> lts = new List<sObject>();
        lts.add(detail);
        Test.StartTest();
        final BE_CalceNewEarlyCancellations_Ctr cancellEarly = new BE_CalceNewEarlyCancellations_Ctr();
        final BE_SingleRelatedListCRUD_Cls.Response resp = cancellEarly.createRecords(lts);
        System.assert(resp.isSuccess, 'success!!!');
        test.stopTest();
    }
    
    /**
    @Description test method createRecords fail
    */
    @isTest
    public static void createRecordsFailTest() {
        Final User usuario = TestFactory.createUser('TestUser1', 'Ejecutivo');
        final Account acc = TestFactory.createAccount();
        final Product2 prod = TestFactory.createProduct();
        prod.IsActive = true;
        update prod;
        final Calce__c calce = new Calce__c();
        calce.Name = 'Test Calce2';
        calce.close_date__c = Date.today();
        calce.start_date__c = Date.today();
        calce.OwnerId = usuario.Id;
        insert calce;
        final Calce_Details__c detail = new Calce_Details__c();
        detail.calce_id__c=calce.Id;
        detail.account_id__c=acc.Id;
        detail.product_id__c=prod.Id;
        detail.Name='detail2';
        detail.CurrencyIsoCode=CURPEN;
        detail.amount__c=50000;
        detail.close_date__c=date.today();
        detail.type__c=INDIRECT;
        detail.product_code__c='CODE002';
        detail.sub_type__c='01';
        final List<sObject> lts = new List<sObject>();
        lts.add(detail);
        Test.StartTest();
        final BE_CalceNewEarlyCancellations_Ctr cancellEarly = new BE_CalceNewEarlyCancellations_Ctr();
        final BE_SingleRelatedListCRUD_Cls.Response resp = cancellEarly.createRecords(lts);
        System.assert(!resp.isSuccess, 'error!!!');
        test.stopTest();
    }
    
    /**
    @Description test method deleteRecords fail
    */
    @isTest
    public static void deleteRecordsFailTest() {
        final Account acc = TestFactory.createAccount();
        final Product2 prod = TestFactory.createProduct();
        prod.IsActive = true;
        update prod;
        final Opportunity opp = TestFactory.createOpportunity(acc.Id, System.UserInfo.getUserId());
        Final Calce__c calce = new Calce__c();
        calce.Name = 'Test Calce3';
        calce.close_date__c = Date.today();
        calce.start_date__c = Date.today();
        insert calce;
        final Calce_Details__c detail = new Calce_Details__c();
        detail.calce_id__c=calce.Id;
        detail.opportunity_id__c=opp.Id;
        detail.account_id__c=acc.Id;
        detail.product_id__c=prod.Id;
        detail.Name='detail3';
        detail.CurrencyIsoCode=CURPEN;
        detail.amount__c=50000;
        detail.close_date__c=date.today();
        detail.type__c=INDIRECT;
        detail.product_code__c='CODE003';
        detail.sub_type__c='01';
        Final List<sObject> lts = new List<sObject>();
        lts.add(detail);
        insert lts;
        Test.StartTest();
        final BE_CalceNewEarlyCancellations_Ctr cancellEarly = new BE_CalceNewEarlyCancellations_Ctr();
        final BE_SingleRelatedListCRUD_Cls.Response resp = cancellEarly.deleteRecords(lts);
        System.assert(!resp.isSuccess, 'error!!!');
        test.stopTest();
    }
    
    /**
    @Description test method deleteRecords
    */
    @isTest
    public static void deleteRecordsTest() {
        Final User usuario = TestFactory.createUser('TestUser1', 'Ejecutivo');
        final Account acc = TestFactory.createAccount();
        final Product2 prd = new Product2(
            Name = 'Carta de crédito de exportación',
            ProductCode = 'PC00015',
            Description = 'Producto code 15',
            IsActive = true,
            Family = 'Riesgo de firma',
            Type_of_quote__c = 'Carta de credito',
            Unique_id__c = '0292430',
            formalization__c = true,
            pdf__c = true,
            price_penalty__c = true,
            risk_sanction__c = true,
            type__c = INDIRECT);
        insert prd;
        Final Calce__c calce = new Calce__c();
        calce.Name = 'Test Calce4';
        calce.close_date__c = Date.today();
        calce.start_date__c = Date.today();
        calce.OwnerId = usuario.Id;
        insert calce;
        final Calce_Details__c detail = new Calce_Details__c();
        detail.calce_id__c=calce.Id;
        detail.account_id__c=acc.Id;
        detail.product_id__c=prd.Id;
        detail.Name='detail4';
        detail.CurrencyIsoCode=CURPEN;
        detail.amount__c=50000;
        detail.close_date__c=date.today();
        detail.type__c=INDIRECT;
        detail.product_code__c='CODE004';
        detail.sub_type__c='01';
        Final List<sObject> lts = new List<sObject>();
        lts.add(detail);
        insert lts;
        Test.StartTest();
        final BE_CalceNewEarlyCancellations_Ctr cancellEarly = new BE_CalceNewEarlyCancellations_Ctr();
        final BE_SingleRelatedListCRUD_Cls.Response resp = cancellEarly.deleteRecords(lts);
        System.assert(resp.isSuccess, 'success!!!');
        test.stopTest();
    }
}
