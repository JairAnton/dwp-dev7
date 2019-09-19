/**
----------------------------------------------------------------------------------------------------
@Name <BE_DynamicTreeGrid_Tst>
@Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
@Date 2019-09-13
@Description Test class for the Class BE_TreeGrid_Utils
@Changes
    Date        Author   Email                  Type        
    2019-09-13  LMBR     lolo.bravo@bbva.com    Creation   
----------------------------------------------------------------------------------------------------
 */
@IsTest
public with sharing class BE_TreeGrid_Tst {
    /**
     @Description TestSetup for generated data to use in the test methods
     */
    @TestSetup
    static void makeData(){
        final Date dtToday=Date.today();
        final String uniqueCode='203658756Utils'+dtToday;
        Account acc=new Account(Name='TREE GRID UTILS TEST',unique_id__c=uniqueCode);
        insert acc;
        final Account_Accounting__c accAcc=new Account_Accounting__c(Name='Account',
             account_id__c=acc.Id,
             gl_account_amount__c=200,
             year_month_day_date__c=dtToday,
             parent_gl_account_id__c='',
             gl_account_id__c='PARENT_TEST',
             gl_account_id_path_desc__c='1',
             gl_account_path_position_id__c='1'
             );
        insert accAcc;
    }

    /**
    @Description test method for  successs getSObjectFieldsTest() with normal Data.
    @Class BE_TreeGrid_Tst
     */
    @IsTest
    static void getSObjectFieldsTest() {
        Test.startTest();
        final Map<String,String> sObjectFieldsMap=BE_TreeGrid_Utils.getSObjectFields('Account_Accounting__c');
        final String typeName=sObjectFieldsMap.get('Name');
        System.assertEquals(typeName, 'string');
        Test.stopTest();
    }

    /**
    @Description test method for  successs getSOQLDataTest() with normal Data.
    @Class BE_TreeGrid_Tst
     */
    @IsTest
    static void getSOQLDataTest() {
        Test.startTest();
        final String uniqueCode='203658756Utils'+Date.today();
        final Account acc=[SELECT Id FROM Account WHERE unique_id__c=:uniqueCode LIMIT 1];
        final List<SObject> sObjLst=BE_TreeGrid_Utils.getSOQLData(acc.Id, 'Account', 'Name', 'Id=:recordId LIMIT 1');
        System.assertEquals(sObjLst[0].get('Name'), 'TREE GRID UTILS TEST','Its match');
        Test.stopTest();
    }
    
    /**
    @Description test method for  successs getSOQLGroupDataTest() with groupe Data.
    @Class BE_TreeGrid_Tst
     */
    @IsTest
    static void getSOQLGroupDataTest() {
        Test.startTest();
        final String dateField='year_month_day_date__c';
        final String uniqueCode='203658756Utils'+Date.today();
        final Account acc=[SELECT Id FROM Account WHERE unique_id__c=:uniqueCode LIMIT 1];
        final Date dtExpected=Date.today();
        final AggregateResult[] groupedResults=BE_TreeGrid_Utils.getSOQLGroupData(acc.Id, 'Account_Accounting__c', dateField, 'account_id__c=:recordId GROUP BY year_month_day_date__c');
        System.assertEquals(dtExpected,groupedResults[0].get(dateField),'Its match');
        Test.stopTest(); 
    }
    
    /**
    @Description test method for  successs getSOQLDataWithINTest() with groupe Data.
    @Class BE_TreeGrid_Tst
     */
    @IsTest
    static void getSOQLDataWithINTest() {
        Test.startTest();
        final String sObjName='Account_Accounting__c';
        final String fieldCode='gl_account_id__c';
        final String dateField='year_month_day_date__c';
        final String uniqueCode='203658756Utils'+Date.today();
        final Account acc=[SELECT Id FROM Account WHERE unique_id__c=:uniqueCode LIMIT 1];
        final List<Object> groupLabels=BE_TreeGrid_Utils.getGroupLabels(acc.Id, sObjName,dateField, 'account_id__c=:recordId GROUP BY year_month_day_date__c', 1);
        final List<SObject> sObjLst=BE_TreeGrid_Utils.getSOQLDataWithIN(acc.Id, sObjName, fieldCode, 'account_id__c=:recordId',dateField, groupLabels);
        final List<Object> groupLabelsTwo=BE_TreeGrid_Utils.getGroupLabels(acc.Id, sObjName,fieldCode, 'account_id__c=:recordId GROUP BY gl_account_id__c', -1);
        final List<SObject> sObjLstTwo=BE_TreeGrid_Utils.getSOQLDataWithIN(acc.Id, sObjName, fieldCode, 'account_id__c=:recordId',fieldCode, groupLabelsTwo);
        System.assertEquals('PARENT_TEST',sObjLst[0].get(fieldCode),'Its match');  
        Test.stopTest();
    }
    
    /**
    @Description test method for  successs joinSobjStringTest().
    @Class BE_TreeGrid_Tst
     */
    @IsTest
    static void joinSobjStringTest() {
        Test.startTest();
        final String sObjFields='Name,Date';
        final String sObjField='DateTime';
        final String fieldsJoin=BE_TreeGrid_Utils.joinSobjString(sObjFields, sObjField);
        System.assertEquals('Name,Date,DateTime', fieldsJoin,'Correct Fields');
        Test.stopTest();
    }
}