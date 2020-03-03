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

    /**@Description Variable METHOD_RESULT*/
    Final static String METHOD_RESULT = 'Success';

    /**@Description Method for setUp test*/
    @testSetup
    public static void setUp() {
        //Create Account record for Test
        Final Account acc = new Account(Name = 'Cliente Test BE_DynamicModalRecordForm_tst', unique_id__c = '1234567890');
        insert acc;
        Final Opportunity[] lstOpp = new Opportunity[]{};
        for(Integer i=0; i < 3; i++) {
            lstOpp.add(new Opportunity(Name='Opp '+ i, Amount = 1000 * i, AccountId = acc.Id, StageName = '01'));
        }
        insert lstOpp;
    }
    
    /**@Description Method to test getHeaderSuccess()*/
    @isTest
    private static void getHeaderSuccess() {
        Test.startTest();
		Final Map<String, Object> mapRes = BE_DynamicModalRecordForm_ctr.getHeader('Form_Class_Test');
        Test.stopTest();
        System.assert((Boolean) mapRes.get('isSuccess'), METHOD_RESULT);
    }
    
    /**@Description Method to test getHeaderError()*/
    @isTest
    private static void getHeaderError() {
        Test.startTest();
		Final Map<String, Object> mapRes = BE_DynamicModalRecordForm_ctr.getHeader('Test_Error');
        Test.stopTest();
        Final Boolean result = (Boolean) mapRes.get('isSuccess') ? false : true;
        System.assert(result, METHOD_RESULT);
    }
    
    /**@Description Method to test getInfoSuccess()*/
    @isTest
    private static void getInfoSuccess() {
        Final Account acc = [SELECT Id FROM Account WHERE unique_id__c ='1234567890' LIMIT 1];
        Test.startTest();
		Final BE_DynamicModalRecordForm_ctr.Response res = BE_DynamicModalRecordForm_ctr.getInfo( acc.Id,'Form_Class_Test');
        Test.stopTest();
        System.assert(res.isSuccess, METHOD_RESULT);
    }
    
    /**@Description Method to test getInfoError()*/
    @isTest
    private static void getInfoError() {
        Final Account acc = [SELECT Id FROM Account WHERE unique_id__c ='1234567890' LIMIT 1];
        Test.startTest();
		Final BE_DynamicModalRecordForm_ctr.Response res = BE_DynamicModalRecordForm_ctr.getInfo( acc.Id,'Test_Error');
        Test.stopTest();
        Final Boolean result = res.isSuccess ? false : true;
        System.assert(result, METHOD_RESULT);
    }
    
    /**@Description Method to test deletesobjectSuccess()*/
    @isTest
    private static void deletesobjectSuccess() {
        Final Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Test.startTest();
		Final Map<String, Object> mapRes = BE_DynamicModalRecordForm_ctr.deletesobject( opp.Id,'Form_Class_Test');
        Test.stopTest();
        System.assert((Boolean)mapRes.get('isSuccess'), METHOD_RESULT);
    }
    
    /**@Description Method to test deletesobjectError()*/
    @isTest
    private static void deletesobjectError() {
        Test.startTest();
		Final Map<String, Object> mapRes = BE_DynamicModalRecordForm_ctr.deletesobject( '','Form_Class_Test');
        Test.stopTest();
        Final Boolean result = (Boolean)mapRes.get('isSuccess') ? false : true;
        System.assert(result, METHOD_RESULT);
    }
}