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
	/**APINAME of the SObject*/
	final static String SOBJNAME = 'Account_Accounting__c';
	/**@general variable*/
	final static String FIELDCODE = 'gl_account_id__c';
	/**@general variable*/
	final static String DATEFIELD = 'year_month_day_date__c';
	/**@general variable*/
	final static String UNIQUECODE = '203658756Utils' + Date.today();
	/**@general variable*/
	final static String SOBJFIELDSJOIN = 'Name,Date';
	/**@general variable*/
	final static String SOBJFIELDJOIN = 'DateTime';
	/**
	   @Description TestSetup for generated data to use in the test methods
	 */
	@TestSetup
	static void makeData() {
		final Account acc = new Account(Name = 'TREE GRID UTILS TEST', unique_id__c = uniqueCode);
		insert acc;
		final Account_Accounting__c accAcc = new Account_Accounting__c(Name = 'Account',
		                                                               account_id__c = acc.Id,
		                                                               gl_account_amount__c = 200,
		                                                               year_month_day_date__c = Date.today(),
		                                                               parent_gl_account_id__c = '',
		                                                               gl_account_id__c = 'PARENT_TEST',
		                                                               gl_account_id_path_desc__c = '1',
		                                                               gl_account_path_position_id__c = '1'
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
		final Map<String, String> sObjectFieldsMap = BE_TreeGrid_Utils.getSObjectFields(SOBJNAME);
		final String typeName = sObjectFieldsMap.get('Name');
		System.assertEquals(typeName, 'string', 'Its match Name');
		Test.stopTest();
	}

	/**
	   @Description test method for  successs getSOQLDataTest() with normal Data.
	   @Class BE_TreeGrid_Tst
	 */
	@IsTest
	static void getSOQLDataTest() {
		Test.startTest();
		final Account acc = [SELECT Id FROM Account WHERE unique_id__c =:UNIQUECODE LIMIT 1];
		final BE_TreeGrid_Utils.Params params = new BE_TreeGrid_Utils.Params('Account', 'Name', 'Id=:recordId LIMIT 1');
		final List<SObject> sObjLst = BE_TreeGrid_Utils.getSOQLData(acc.Id, params);
		System.assertEquals(sObjLst[0].get('Name'), 'TREE GRID UTILS TEST', 'Its match Grid Name');
		Test.stopTest();
	}

	/**
	   @Description test method for  successs getSOQLGroupDataTest() with groupe Data.
	   @Class BE_TreeGrid_Tst
	 */
	@IsTest
	static void getSOQLGroupDataTest() {
		Test.startTest();
		final Account acc = [SELECT Id FROM Account WHERE unique_id__c =:UNIQUECODE LIMIT 1];
		final Date dtExpected = Date.today();
		final BE_TreeGrid_Utils.Params paramsGroup = new BE_TreeGrid_Utils.Params(SOBJNAME, DATEFIELD, 'account_id__c=:recordId GROUP BY year_month_day_date__c');
		final AggregateResult[] groupedResults = BE_TreeGrid_Utils.getSOQLGroupData(acc.Id, paramsGroup);
		System.assertEquals(dtExpected, groupedResults[0].get(DATEFIELD), 'Its match DateField');
		Test.stopTest();
	}

	/**
	   @Description test method for  successs getSOQLDataWithINTest() with groupe Data.
	   @Class BE_TreeGrid_Tst
	 */
	@IsTest
	static void getSOQLDataWithINTest() {
		Test.startTest();
		final Account acc = [SELECT Id FROM Account WHERE unique_id__c =:UNIQUECODE LIMIT 1];
		final BE_TreeGrid_Utils.Params paramsGroup = new BE_TreeGrid_Utils.Params();
		paramsGroup.sObjName = SOBJNAME;
		paramsGroup.keyGroup = DATEFIELD;
		paramsGroup.sObjFields = FIELDCODE;
		paramsGroup.numGroupShow = 1;
		paramsGroup.filterSQOLGroup = 'account_id__c=:recordId GROUP BY year_month_day_date__c';
		paramsGroup.filterSQOL = 'account_id__c=:recordId';
		paramsGroup.fieldLevel = '';
		paramsGroup.isHeaderGroup = false;
		paramsGroup.formatDate = 'MMM YYYY';
		paramsGroup.fieldsHeaderGroup = 'Id';
		paramsGroup.fieldOrder = '';
		final List<Object> groupLabels = BE_TreeGrid_Utils.getGroupLabels(acc.Id, paramsGroup);
		final List<SObject> sObjLst = BE_TreeGrid_Utils.getSOQLDataWithIN(acc.Id, paramsGroup, groupLabels);
		paramsGroup.numGroupShow = -1;
		paramsGroup.filterSQOL = 'account_id__c=:recordId GROUP BY gl_account_id__c';
		final List<Object> groupLabelsTwo = BE_TreeGrid_Utils.getGroupLabels(acc.Id, paramsGroup);
		paramsGroup.filterSQOL = 'account_id__c=:recordId';
		BE_TreeGrid_Utils.getSOQLDataWithIN(acc.Id, paramsGroup, groupLabelsTwo);
		System.assertEquals('PARENT_TEST', sObjLst[0].get(FIELDCODE), 'Its match Code');
		Test.stopTest();
	}

	/**
	   @Description test method for  successs joinSobjStringTest().
	   @Class BE_TreeGrid_Tst
	 */
	@IsTest
	static void joinSobjStringTest() {
		Test.startTest();
		final String fieldsJoin = BE_TreeGrid_Utils.joinSobjString(SOBJFIELDSJOIN, SOBJFIELDJOIN);
		System.assertEquals('Name,Date,DateTime', fieldsJoin, 'Correct Fields');
		Test.stopTest();
	}
}
