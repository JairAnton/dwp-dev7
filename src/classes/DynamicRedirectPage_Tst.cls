/**
   -------------------------------------------------------------------------------------------------
   @Name <DynamicRedirectPage_Tst>
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-06-04
   @Description test for DynamicRedirectPage_ctr class
   @Changes
   Date        Author   Email                  				Type
   2020-06-04  MAMC     martin.mori.contractor@bbva.com		Creation
   -------------------------------------------------------------------------------------------------
 */
@isTest
public without sharing class DynamicRedirectPage_Tst {
	/**
	   @Description test getRecordToRedirect method, correct scenary
	 */
	@isTest
	static void getRecordToRedirectTest() {
		final User userExecutive = TestFactory.createUser('userExecutiveOwner', 'Ejecutivo');
		final Account acc = TestFactory.createAccount();
		Test.startTest();
		System.runAs(userExecutive) {
			Final Map<String, Object> testObject = DynamicRedirectPage_ctr.getRecordToRedirect('{"profiles":"Operativo","users":"p0000"}', 
                                                                                               '{"sObjectType":"Account","recordId":"'+acc.Id+'", "fieldName": "Name"}');
			System.assert ((Boolean)testObject.get('isSuccess'), 'Successful!');
		}
		Test.stopTest();
	}

	/**
	   @Description test getRecordToRedirect method, fail scenary
	 */
	@isTest
	static void getRecordToRedirectFailTest() {
		Test.startTest();
		Final Map<String, Object> testObject = DynamicRedirectPage_ctr.getRecordToRedirect(null, '{"sObjectType":"Account","recordId":"", "fieldName": "Name"}');
		System.assert (!(Boolean)testObject.get('isSuccess'), 'fail!');
		Test.stopTest();
	}
}