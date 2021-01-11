/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_CalceNewOpportunities_Tst>
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-06-21
   @Description Test class from BE_CalceNewOpportunities_Ctr
   @Changes
   Date        Author   Email                  				Type		Description
   2020-06-21  MAMC     martin.mori.contractor@bbva.com    	Creation
   2020-07-14  MAMC     martin.mori.contractor@bbva.com    	Modify		add data to correct coverage test
   -------------------------------------------------------------------------------------------------
 */
@isTest
private class BE_CalceNewOpportunities_Tst {
    /**
    @Description test method readRecords
    */
    @isTest
    public static void readRecordsTest() {
        final Account acc = TestFactory.createAccount();
        final Opportunity opp = new Opportunity(
            Name = 'XXX Test',
            CloseDate = Date.today(),
            Field_Sup_Closing_Date__c = Date.today(),
            StageName = 'Prospecting',
            Amount = 111111,
            AccountId = acc.id,
            Type='01'
        );
        insert opp;
        final Opportunity opp2 = new Opportunity(
            Name = 'XXX Test2',
            CloseDate = Date.today(),
            Field_Sup_Closing_Date__c = Date.today(),
            StageName = 'Prospecting',
            Amount = 111111,
            AccountId = acc.id,
            Type='01'
        );
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
            type__c = 'Indirect');
        insert prd;
        final PriceBookEntry pbe = new PriceBookEntry(
            Product2Id = prd.Id,
            PriceBook2Id = Test.getStandardPricebookId(),
            UnitPrice = 1,
            UseStandardPrice = false,
            IsActive = true
        );
        insert pbe;
        final OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId = opp.Id,
            Product2Id = prd.Id,
            Quantity = 1,
            TotalPrice = 123,
            PriceBookEntryId = pbe.Id
        );
        insert oli;
        final OpportunityLineItem oli2 = new OpportunityLineItem(
            OpportunityId = opp2.Id,
            Product2Id = prd.Id,
            Quantity = 1,
            TotalPrice = 123,
            PriceBookEntryId = pbe.Id
        );
        insert oli2;
        
        final Calce__c calce = new Calce__c();
        calce.Name = 'Test Calce';
        calce.close_date__c = Date.today();
        calce.start_date__c = Date.today();
        calce.status__c = 'Iniciado';
        insert calce;
        final List<Calce_Details__c> ltsCalceDetail = new List<Calce_Details__c>();
        final Calce_Details__c detail1 = new Calce_Details__c();
        detail1.calce_id__c=calce.Id;
        detail1.account_id__c=acc.Id;
        detail1.opportunity_id__c=opp.Id;
        detail1.Name='detail';
        detail1.CurrencyIsoCode='PEN';
        detail1.amount__c=50000;
        detail1.close_date__c=date.today();
        detail1.type__c='Direct';
        detail1.product_code__c='CODE001';
        detail1.sub_type__c='02';
        ltsCalceDetail.add(detail1);
        final Calce_Details__c detail2 = new Calce_Details__c();
        detail2.calce_id__c=calce.Id;
        detail2.account_id__c=acc.Id;
        detail2.Name='detail';
        detail2.CurrencyIsoCode='PEN';
        detail2.amount__c=50000;
        detail2.close_date__c=date.today();
        detail2.type__c='Direct';
        detail2.product_code__c='CODE001';
        detail2.sub_type__c='02';
        ltsCalceDetail.add(detail2);
        insert ltsCalceDetail;
        final Map<String,Object> mapCalce = new Map<String,Object>();
        mapCalce.put('recordId', calce.Id);
        Test.StartTest();
        final BE_CalceNewOpportunities_Ctr newOpps = new BE_CalceNewOpportunities_Ctr();
        final BE_SingleRelatedListCRUD_Cls.Response resp = newOpps.readRecords(mapCalce);
        System.assert(resp.isSuccess, 'success!!!');
        test.stopTest();
    }
    
    /**
    @Description test method updateRecords
    */
    @isTest
    public static void updateRecordsTest() {
        final Account acc = TestFactory.createAccount();
        final Opportunity opp = TestFactory.createOpportunity(acc.Id, System.UserInfo.getUserId());
        final Calce__c calce = new Calce__c();
        calce.Name = 'Test Calce';
        calce.close_date__c = Date.today().addDays(-45);
        calce.status__c = 'Iniciado';
        insert calce;
        final Calce_Details__c detail = new Calce_Details__c();
        detail.calce_id__c=calce.Id;
        detail.Name='detail';
        detail.account_id__c=acc.Id;
        detail.opportunity_id__c=opp.Id;
        detail.CurrencyIsoCode='PEN';
        detail.amount__c=50000;
        detail.close_date__c=date.today();
        detail.type__c='Direct';
        detail.product_code__c='CODE001';
        detail.sub_type__c='02';
        insert detail;
        final List<sObject> lts = new List<sObject>();
        detail.amount__c=40000;
        lts.add(detail);
        Test.StartTest();
        final BE_CalceNewOpportunities_Ctr newOpps = new BE_CalceNewOpportunities_Ctr();
        final BE_SingleRelatedListCRUD_Cls.Response resp = newOpps.updateRecords(lts);
        System.assert(resp.isSuccess, 'success!!!');
        test.stopTest();
    }
}
