/**
----------------------------------------------------------------------------------------------------
@Name <BE_DynamicTreeGrid_Tst>
@Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
@Date 2019-09-13
@Description Test class for the Classes BE_DynamicTreeGrid_Ctrl,BE_TreeData_Helper,BE_TreeDataGroup_Helper,BE_TreeGrid_Utils
@Changes
    Date        Author   Email                  Type        
    2019-09-13  LMBR     lolo.bravo@bbva.com    Creation   
----------------------------------------------------------------------------------------------------
 */
@IsTest
public with sharing class BE_DynamicTreeGrid_Tst {
    /**
     @Description TestSetup for generated data to use in the test methods
     */
    @TestSetup
    static void makeData() {
        final String uniqueCode='203658756EEFF'+String.valueOf(Date.today());
        final Account acc=new Account(Name='FINANCIAL STATEMENT',unique_id__c=uniqueCode);
        insert acc;
        List<Account_Accounting__c> listAccAcc = new List<Account_Accounting__c>();
        for (Integer i = 0; i < 10; i++) {
             final String indicator=String.valueOf(i);
             final Account_Accounting__c accAcc=new Account_Accounting__c(Name='Account',
             account_id__c=acc.Id,
             gl_account_amount__c=200,
             year_month_day_date__c=Date.today(),
             parent_gl_account_id__c='',
             gl_account_id__c='PARENT'+indicator,
             gl_account_id_path_desc__c='1',
             gl_account_path_position_id__c=indicator
             );
            final Account_Accounting__c accAccChild=new Account_Accounting__c(Name='Account',
             account_id__c=acc.Id,
             gl_account_amount__c=200,
             year_month_day_date__c=Date.today(),
             parent_gl_account_id__c='PARENT'+indicator,
             gl_account_id__c='CHILD'+indicator,
             gl_account_id_path_desc__c='2',
             gl_account_path_position_id__c=indicator
             );
            listAccAcc.add(accAccChild);
            listAccAcc.add(accAcc);
        }
        insert listAccAcc;
    }

    /**
    @Description test method for  successs getDynamicResponse() with normal Data.
    @Class BE_DynamicTreeGrid_Ctrl,BE_TreeData_Helper,BE_TreeGrid_Utils
     */
    @IsTest
    static void dynamicResponseTest() {
        final String uniqueCode='203658756EEFF'+String.valueOf(Date.today());
        Test.startTest();
        final Account acc=[SELECT Id FROM Account WHERE unique_id__c=:uniqueCode LIMIT 1];
        final BE_DynamicTreeGrid_Ctrl.Response ObjResponse=BE_DynamicTreeGrid_Ctrl.getDynamicResponse(acc.Id,
        'Account_Accounting__c',
        'Name,gl_account_amount__c',
        'gl_account_id__c',
        'parent_gl_account_id__c',
        'account_id__c=:recordId',
        'gl_account_id_path_desc__c',
         false,
        'year_month_day_date__c',
        '',
        '',
        '',
        null,
        'gl_account_path_position_id__c');
        System.assertEquals(ObjResponse.SizeData, 2);
        System.assertEquals(true,ObjResponse.IsSuccess,'Its match');
        Test.stopTest();  
    }

    /**
    @Description test method for  successs getDynamicResponse() with group data.
    @Class BE_DynamicTreeGrid_Ctrl,BE_TreeDataGroup_Helper,BE_TreeGrid_Utils
     */
    @IsTest
    static void dynamicResponseGroupTest() {
        final String uniqueCode='203658756EEFF'+String.valueOf(Date.today());
        Test.startTest();
        final Account acc=[SELECT Id FROM Account WHERE unique_id__c=:uniqueCode LIMIT 1];
        final BE_DynamicTreeGrid_Ctrl.Response ObjResponse=BE_DynamicTreeGrid_Ctrl.getDynamicResponse(acc.Id,
        'Account_Accounting__c',
        'Name,gl_account_amount__c',
        'gl_account_id__c',
        'parent_gl_account_id__c',
        'account_id__c=:recordId',
        'gl_account_id_path_desc__c',
        true,'year_month_day_date__c',
        'account_id__c=:recordId GROUP BY year_month_day_date__c',
        'MMMM YYYY',
        'gl_account_amount__c',1,'gl_account_path_position_id__c');
        System.assertEquals(ObjResponse.SizeData, 2);
        System.assertEquals(true,ObjResponse.IsSuccess,'Its match');
        Test.stopTest();  
    }
    
    /**
    @Description test method for exception getDynamicResponse().
    @Class BE_DynamicTreeGrid_Ctrl,BE_TreeData_Helper,BE_TreeGrid_Utils
     */
    @IsTest
    static void dynamicResponsErrorTest() {
        final String uniqueCode='203658756EEFF'+String.valueOf(Date.today());
        Test.startTest();
        final Account acc=[SELECT Id FROM Account WHERE unique_id__c=:uniqueCode LIMIT 1];
        final BE_DynamicTreeGrid_Ctrl.Response ObjResponse=BE_DynamicTreeGrid_Ctrl.getDynamicResponse(acc.Id,
        'Account_Accounting__c',
        'Name',
        '',
        '',
        'account_id__c=:recordId',
        null,
        false,
        null,
        null,
        null,
        null,
        null,
        null);
        System.assertEquals(false,ObjResponse.IsSuccess,'Its match');
        Test.stopTest();  
    }

}