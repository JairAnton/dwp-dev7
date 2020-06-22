/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_CalceNewEarlyCancellations_Tst>
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-06-21
   @Description Test class from BE_CalceNewEarlyCancellations_Ctr
   @Changes
   Date        Author   Email                  				Type
   2020-06-21  MAMC     martin.mori.contractor@bbva.com    	Creation
   -------------------------------------------------------------------------------------------------
 */
@isTest
private class BE_CalceNewEarlyCancellations_Tst {
    /**
    @Description test method createRecords
    */
    @isTest
    public static void createRecordsTest() {
        Account acc = TestFactory.createAccount();
        Product2 prod = TestFactory.createProduct();
        prod.IsActive = true;
        update prod;
        Final Calce__c calce = new Calce__c();
        calce.Name = 'Test Calce';
        calce.close_date__c = Date.today();
        calce.start_date__c = Date.today();
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
        Final List<sObject> lts = new List<sObject>();
        lts.add(detail);
        Test.StartTest();
        BE_CalceNewEarlyCancellations_Ctr cancellEarly = new BE_CalceNewEarlyCancellations_Ctr();
        Final BE_SingleRelatedListCRUD_Cls.Response resp = cancellEarly.createRecords(lts);
        System.assert(resp.isSuccess, 'success!!!');
        test.stopTest();
    }
    
    /**
    @Description test method deleteRecords
    */
    @isTest
    public static void deleteRecordsTest() {
        Account acc = TestFactory.createAccount();
        Product2 prod = TestFactory.createProduct();
        prod.IsActive = true;
        update prod;
        Opportunity opp = TestFactory.createOpportunity(acc.Id, System.UserInfo.getUserId());
        Final Calce__c calce = new Calce__c();
        calce.Name = 'Test Calce';
        calce.close_date__c = Date.today();
        calce.start_date__c = Date.today();
        calce.status__c = 'Iniciado';
        insert calce;
        final Calce_Details__c detail = new Calce_Details__c();
        detail.calce_id__c=calce.Id;
        detail.opportunity_id__c=opp.Id;
        detail.account_id__c=acc.Id;
        detail.product_id__c=prod.Id;
        detail.Name='detail';
        detail.CurrencyIsoCode='PEN';
        detail.amount__c=50000;
        detail.close_date__c=date.today();
        detail.type__c='Indirect';
        detail.product_code__c='CODE001';
        detail.sub_type__c='01';
        Final List<sObject> lts = new List<sObject>();
        lts.add(detail);
        insert lts;
        Test.StartTest();
        BE_CalceNewEarlyCancellations_Ctr cancellEarly = new BE_CalceNewEarlyCancellations_Ctr();
        Final BE_SingleRelatedListCRUD_Cls.Response resp = cancellEarly.deleteRecords(lts);
        System.assert(!resp.isSuccess, 'success!!!');
        test.stopTest();
    }
}