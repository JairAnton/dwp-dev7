/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_CalceEarlyCancellations_Tst>
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-06-21
   @Description Test class from BE_CalceEarlyCancellations_Ctr
   @Changes
   Date        Author   Email                  				Type		Description
   2020-06-21  MAMC     martin.mori.contractor@bbva.com    	Creation
   2020-07-14  MAMC     martin.mori.contractor@bbva.com    	Modify		add data to correct coverage test
   -------------------------------------------------------------------------------------------------
 */
@isTest
private class BE_CalceEarlyCancellations_Tst {
    /** variable Indirect */
    private static final String INDIRECT = 'indirect';
    
    /**
    @Description test method readRecords
    */
    @isTest
    public static void readRecordsTest() {
        final Account acc = TestFactory.createAccount();
        final Opportunity opp1 = new Opportunity(
            Name = 'OPP Test',
            CloseDate = Date.today(),
            Field_Sup_Closing_Date__c = Date.today(),
            StageName = 'Prospecting',
            Amount = 111111,
            AccountId = acc.id,
            opportunity_expiry_date__c = Date.today().addDays(5),
            Type='02'
        );
        final Opportunity opp2 = opp1.clone();
        insert opp1;
        insert opp2;
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
        final OpportunityLineItem oli1 = TestFactory.createOLI(opp1.Id, prd.Id);
        final OpportunityLineItem oli2 = oli1.clone();
        oli2.OpportunityId = opp2.Id;
        insert oli2;
        
        final Calce__c calce = new Calce__c();
        calce.Name = 'Test Calce';
        calce.close_date__c = Date.today();
        calce.start_date__c = Date.today();
        calce.status__c = 'Iniciado';
        insert calce;
        Final List<Calce_Details__c> ltsCalceDetail = new List<Calce_Details__c>();
        final Calce_Details__c detail1 = new Calce_Details__c();
        detail1.calce_id__c=calce.Id;
        detail1.account_id__c=acc.Id;
        detail1.opportunity_id__c=opp1.Id;
        detail1.Name='detail1';
        detail1.CurrencyIsoCode='PEN';
        detail1.amount__c=50000;
        detail1.close_date__c=date.today();
        detail1.type__c=INDIRECT;
        detail1.product_code__c='CODE001';
        detail1.sub_type__c='03';
        ltsCalceDetail.add(detail1);
        final Calce_Details__c detail2 = new Calce_Details__c();
        detail2.calce_id__c=calce.Id;
        detail2.account_id__c=acc.Id;
        detail2.Name='detail2';
        detail2.CurrencyIsoCode='PEN';
        detail2.amount__c=50000;
        detail2.close_date__c=date.today();
        detail2.type__c=INDIRECT;
        detail2.product_code__c='CODE002';
        detail2.sub_type__c='03';
        ltsCalceDetail.add(detail2);
        insert ltsCalceDetail;
        Final Map<String,Object> mapCalce = new Map<String,Object>();
        mapCalce.put('recordId', calce.Id);
        Test.StartTest();
        final BE_CalceEarlyCancellations_Ctr cancellEarly = new BE_CalceEarlyCancellations_Ctr();
        Final BE_SingleRelatedListCRUD_Cls.Response resp = cancellEarly.readRecords(mapCalce);
        System.assert(resp.isSuccess, 'success!!!');
        test.stopTest();
    }
    
    /**
    @Description test method updateRecords
    */
    @isTest
    public static void updateRecordsTest() {
        final Calce__c calce = new Calce__c();
        calce.Name = 'Test Calce3';
        calce.close_date__c = Date.today().addDays(-45);
        insert calce;
        final Calce_Details__c detail = new Calce_Details__c();
        detail.calce_id__c=calce.Id;
        detail.Name='detail3';
        detail.CurrencyIsoCode='PEN';
        detail.amount__c=50000;
        detail.close_date__c=date.today();
        detail.type__c=INDIRECT;
        detail.product_code__c='CODE003';
        detail.sub_type__c='01';
        insert detail;
        final List<sObject> lts = new List<sObject>();
        detail.amount__c=40000;
        lts.add(detail);
        Test.StartTest();
        final BE_CalceEarlyCancellations_Ctr cancellEarly = new BE_CalceEarlyCancellations_Ctr();
        final BE_SingleRelatedListCRUD_Cls.Response resp = cancellEarly.updateRecords(lts);
        System.assert(resp.isSuccess, 'success!!!');
        test.stopTest();
    }
}
