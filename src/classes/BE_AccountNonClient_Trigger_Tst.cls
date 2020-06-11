/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_AccountNonClient_Trigger_Tst>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2020-03-03
   @Description test for BE_AccountNonClient_Trigger_Cls class
   @Changes
   Date        Author   Email                  Type
   2020-03-10  LMBR     lolo.bravo@bbva.com    Creation
   -------------------------------------------------------------------------------------------------
 */
@IsTest
public without sharing class BE_AccountNonClient_Trigger_Tst {
	/**
	   @Description test BE_AccountNonClient_Trigger_Ctr.mergeNonClientToClient(), correct scenary
	 */
	@IsTest
	static void mergeNonClientToClientTest() {
		Test.startTest();
		final List<String> sObjNames = new List<String> {'Account'};
		final Map<String, Schema.RecordTypeInfo> recordType = BE_General_Utils.getRecordTypeInfo(sObjNames);
		final Account nonClient = new Account(Name = 'NO CLIENT TEST', AccountNumber = '20000000002', recordTypeId = recordType.get('Record_Type_Non_Client').getRecordTypeId());
		insert nonClient;
		final Account client = new Account(Name = 'CLIENT TEST', AccountNumber = '20000000002', recordTypeId = recordType.get('Record_Type_Client').getRecordTypeId());
		insert client;
		System.assertEquals('20000000002', client.AccountNumber, 'Success');
		Test.stopTest();
	}
}
