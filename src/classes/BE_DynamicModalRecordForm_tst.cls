/*
* ------------------------------------------------------------------------------------------------
* @Name BE_DynamicModalRecordForm_tst
* @Author Diego Carbajal diego.carbajal@bbva.com
* @Date Created: 2020-02-28
* @Group 
* @Description Esta clase valida la funcionalidad de los metodos de la clase BE_DynamicModalRecordForm_ctr
* 
*/
@isTest
public with sharing class BE_DynamicModalRecordForm_tst {
    @testSetup
    public static void setUp() {
        //Create Account record for Test
        Account acc = new Account(Name = 'Cliente Test BE_DynamicModalRecordForm_tst', unique_id__c = '1234567890');
        insert acc;
        System.debug(acc);
        Opportunity[] lstOpp = new Opportunity[]{};
        for(Integer i=0; i < 3; i++) {
            lstOpp.add(new Opportunity(Name='Opp '+ i, Amount = 1000 * i, AccountId = acc.Id, StageName = '01'));
        }
        insert lstOpp;
    }
    
    @isTest
    private static void getHeaderSuccess() {
        Test.startTest();
		Map<String, Object> mapRes = BE_DynamicModalRecordForm_ctr.getHeader('Form_Class_Test');
        Test.stopTest();
        System.assert((Boolean) mapRes.get('isSuccess'));
    }
    
    @isTest
    private static void getHeaderError() {
        Test.startTest();
		Map<String, Object> mapRes = BE_DynamicModalRecordForm_ctr.getHeader('Test_Error');
        Test.stopTest();
        System.assert(!(Boolean) mapRes.get('isSuccess'));
    }
    
    @isTest
    private static void getInfoSuccess() {
        Account acc = [SELECT Id FROM Account WHERE unique_id__c ='1234567890' LIMIT 1];
        Test.startTest();
		BE_DynamicModalRecordForm_ctr.Response res = BE_DynamicModalRecordForm_ctr.getInfo( acc.Id,'Form_Class_Test');
        Test.stopTest();
        System.assert(res.isSuccess);
    }
    
    @isTest
    private static void getInfoError() {
        Account acc = [SELECT Id FROM Account WHERE unique_id__c ='1234567890' LIMIT 1];
        Test.startTest();
		BE_DynamicModalRecordForm_ctr.Response res = BE_DynamicModalRecordForm_ctr.getInfo( acc.Id,'Test_Error');
        Test.stopTest();
        System.assert(!res.isSuccess);
    }
    
    @isTest
    private static void deletesobjectSuccess() {
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Test.startTest();
		Map<String, Object> mapRes = BE_DynamicModalRecordForm_ctr.deletesobject( opp.Id,'Form_Class_Test');
        Test.stopTest();
        System.assert((Boolean)mapRes.get('isSuccess'));
    }
    
    @isTest
    private static void deletesobjectError() {
        Test.startTest();
		Map<String, Object> mapRes = BE_DynamicModalRecordForm_ctr.deletesobject( '','Form_Class_Test');
        Test.stopTest();
        System.assert(!(Boolean)mapRes.get('isSuccess'));
    }
}