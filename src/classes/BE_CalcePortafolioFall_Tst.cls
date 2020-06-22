/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_CalcePortafolioFall_Tst>
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-06-21
   @Description Test class from BE_CalcePortafolioFall_Ctr
   @Changes
   Date        Author   Email                  				Type
   2020-06-21  MAMC     martin.mori.contractor@bbva.com    	Creation
   -------------------------------------------------------------------------------------------------
 */
@isTest
private class BE_CalcePortafolioFall_Tst {
    /**
    @Description test method readRecords
    */
    @isTest
    public static void readRecordsTest() {
        final Account acc = TestFactory.createAccount();
        final Account_Contract__c contract = new Account_Contract__c();
        contract.account_id__c = acc.Id;
        contract.CurrencyIsoCode = 'USD';
        contract.contract_end_date__c = Date.today().addDays(-17);
        contract.contract_id__c = '001109499600108767';
        contract.gf_lc_contract_lc_amount__c = 120823.84;
        contract.gf_tl_bal_contract_oc_amount__c = 35715;
        contract.product_type__c = '01';
        contract.solution_category_name__c = 'PRESTAMOS EMPRESAS';
        contract.solution_expiry_type__c = '02';
        contract.subproduct_type__c = '01';
        insert contract;
        Test.setCreatedDate(contract.Id, System.now().addHours(-6));
        final Calce__c calce = new Calce__c();
        calce.Name = 'Test Calce';
        calce.close_date__c = Date.today();
        calce.start_date__c=date.today();
        calce.status__c = 'Iniciado';
        insert calce;
        final Calce_Details__c detail = new Calce_Details__c();
        detail.calce_id__c=calce.Id;
        detail.account_contract_id__c=contract.Id;
        detail.account_id__c=acc.Id;
        detail.Name='detail';
        detail.CurrencyIsoCode='PEN';
        detail.amount__c=50000;
        detail.Contract_Number__c='23212312321';
        detail.close_date__c=date.today();
        detail.type__c='Direct';
        detail.product_code__c='CODE001';
        detail.sub_type__c='04';
        insert detail;
        final Map<String,Object> mapCalce = new Map<String,Object>();
        mapCalce.put('recordId', calce.Id);
        Test.StartTest();
        final BE_CalcePortafolioFall_Ctr portafolioFall = new BE_CalcePortafolioFall_Ctr();
        Final BE_SingleRelatedListCRUD_Cls.Response resp = portafolioFall.readRecords(mapCalce);
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
        detail.Contract_Number__c='23212312321';
        detail.close_date__c=date.today();
        detail.type__c='Direct';
        detail.product_code__c='CODE001';
        detail.sub_type__c='04';
        insert detail;
        final List<sObject> lts = new List<sObject>();
        detail.amount__c=40000;
        lts.add(detail);
        Test.StartTest();
        final BE_CalcePortafolioFall_Ctr portafolioFall = new BE_CalcePortafolioFall_Ctr();
        final BE_SingleRelatedListCRUD_Cls.Response resp = portafolioFall.updateRecords(lts);
        System.assert(resp.isSuccess, 'success!!!');
        test.stopTest();
    }
}