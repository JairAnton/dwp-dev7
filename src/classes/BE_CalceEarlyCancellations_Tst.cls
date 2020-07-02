/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_CalceEarlyCancellations_Tst>
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-06-21
   @Description Test class from BE_CalceEarlyCancellations_Ctr
   @Changes
   Date        Author   Email                  				Type
   2020-06-21  MAMC     martin.mori.contractor@bbva.com    	Creation
   -------------------------------------------------------------------------------------------------
 */
@isTest
private class BE_CalceEarlyCancellations_Tst {
    /**
    @Description test method readRecords
    */
    @isTest
    public static void readRecordsTest() {
        final Account acc = TestFactory.createAccount();
        final Calce__c calce = new Calce__c();
        calce.Name = 'Test Calce';
        calce.close_date__c = Date.today();
        calce.start_date__c = Date.today();
        calce.status__c = 'Iniciado';
        insert calce;
        final Calce_Details__c detail = new Calce_Details__c();
        detail.calce_id__c=calce.Id;
        detail.account_id__c=acc.Id;
        detail.Name='detail';
        detail.CurrencyIsoCode='PEN';
        detail.amount__c=50000;
        detail.close_date__c=date.today();
        detail.type__c='Indirect';
        detail.product_code__c='CODE001';
        detail.sub_type__c='01';
        insert detail;
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
        calce.Name = 'Test Calce';
        calce.close_date__c = Date.today().addDays(-45);
        calce.status__c = 'Iniciado';
        insert calce;
        final Calce_Details__c detail = new Calce_Details__c();
        detail.calce_id__c=calce.Id;
        detail.Name='detail';
        detail.CurrencyIsoCode='PEN';
        detail.amount__c=50000;
        detail.close_date__c=date.today();
        detail.type__c='Indirect';
        detail.product_code__c='CODE001';
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