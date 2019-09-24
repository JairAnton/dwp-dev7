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
    /** Unique code of AccAccounting*/
    final static String UNIQUECODE='203658756EEFF'+Date.today();
    /**APINAME of the SObject*/ 
    final static String SOBJNAME='Account_Accounting__c';
    /**@general variable*/ 
    final static String DATEFIELD='year_month_day_date__c';
    /**@Description TestSetup for generated data to use in the test methods*/
    @TestSetup
    static void makeData() {
        final Account acc=new Account(Name='FINANCIAL STATEMENT',unique_id__c=UNIQUECODE);
        insert acc;
        final List<Account_Accounting__c> listAccAcc = new List<Account_Accounting__c>();
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
        Test.startTest();
        final Account acc=[SELECT Id FROM Account WHERE unique_id__c=:UNIQUECODE LIMIT 1];
        final BE_TreeGrid_Utils.Params params=new BE_TreeGrid_Utils.Params();
        params.sObjName=SOBJNAME;
        params.keyGroup=DATEFIELD;
        params.sObjFields='Name,gl_account_amount__c';
        params.keyField='gl_account_id__c';
        params.keyParentField='parent_gl_account_id__c';
        params.filterSQOL='account_id__c=:recordId';
        params.fieldLevel='gl_account_id_path_desc__c';
        params.fieldOrder='gl_account_path_position_id__c';
        params.isHeaderGroup=false;
        final BE_DynamicTreeGrid_Ctrl.Response ObjResponse=BE_DynamicTreeGrid_Ctrl.getDynamicResponse(acc.Id,params);
        /*
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
        'gl_account_path_position_id__c');*/
        System.assertEquals(ObjResponse.SizeData, 2, 'The size of normal reponse match');
        Test.stopTest();  
    }

    /**
    @Description test method for  successs getDynamicResponse() with group data.
    @Class BE_DynamicTreeGrid_Ctrl,BE_TreeDataGroup_Helper,BE_TreeGrid_Utils
     */
    @IsTest
    static void dynamicResponseGroupTest() {
        Test.startTest();
        final Account acc=[SELECT Id FROM Account WHERE unique_id__c=:UNIQUECODE LIMIT 1];
        final BE_TreeGrid_Utils.Params paramsGroup=new BE_TreeGrid_Utils.Params();
        paramsGroup.sObjName=SOBJNAME;
        paramsGroup.keyGroup=DATEFIELD;
        paramsGroup.sObjFields='Name,gl_account_amount__c';
        paramsGroup.keyField='gl_account_id__c';
        paramsGroup.keyParentField='parent_gl_account_id__c';
        paramsGroup.numGroupShow=1;
        paramsGroup.filterSQOLGroup='account_id__c=:recordId GROUP BY year_month_day_date__c';
        paramsGroup.filterSQOL='account_id__c=:recordId';
        paramsGroup.fieldLevel='gl_account_id_path_desc__c';
        paramsGroup.isHeaderGroup=true;
        paramsGroup.formatDate='MMMM YYYY';
        paramsGroup.fieldsHeaderGroup='gl_account_amount__c';
        paramsGroup.fieldOrder='gl_account_path_position_id__c';
        final BE_DynamicTreeGrid_Ctrl.Response ObjResponse=BE_DynamicTreeGrid_Ctrl.getDynamicResponse(acc.Id,paramsGroup);
        /*final BE_DynamicTreeGrid_Ctrl.Response ObjResponse=BE_DynamicTreeGrid_Ctrl.getDynamicResponse(acc.Id,
        'Account_Accounting__c',
        'Name,gl_account_amount__c',
        'gl_account_id__c',
        'parent_gl_account_id__c',
        'account_id__c=:recordId',
        'gl_account_id_path_desc__c',
        true,'year_month_day_date__c',
        'account_id__c=:recordId GROUP BY year_month_day_date__c',
        'MMMM YYYY',
        'gl_account_amount__c',1,'gl_account_path_position_id__c');*/
        System.assertEquals(ObjResponse.SizeData, 2,'Size is equals');
        Test.stopTest();  
    }
    
    /**
    @Description test method for exception getDynamicResponse().
    @Class BE_DynamicTreeGrid_Ctrl,BE_TreeData_Helper,BE_TreeGrid_Utils
     */
    @IsTest
    static void dynamicResponsErrorTest() {
        Test.startTest();
        final Account acc=[SELECT Id FROM Account WHERE unique_id__c=:UNIQUECODE LIMIT 1];
        final BE_TreeGrid_Utils.Params paramsGroup=new BE_TreeGrid_Utils.Params(SOBJNAME,'Name','account_id__c=:recordId');
        final BE_DynamicTreeGrid_Ctrl.Response ObjResponse=BE_DynamicTreeGrid_Ctrl.getDynamicResponse(acc.Id,paramsGroup);
        /*
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
        null);*/
        System.assert(!ObjResponse.IsSuccess,'Error');
        Test.stopTest();  
    }

}