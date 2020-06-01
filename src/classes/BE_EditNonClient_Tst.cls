/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_EditNonClient_Tst>
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-03-13
   @Description test for BE_EditNonClient_Ctr class
   @Changes
   Date        Author   Email                  				Type
   2020-03-13  MAMC     martin.mori.contractor@bbva.com    	Creation
   -------------------------------------------------------------------------------------------------
 */
@IsTest
public without sharing class BE_EditNonClient_Tst {
	/**
	   @Description test BE_EditNonClient_Ctr.getFields(), correct scenary
	 */
	@IsTest
	static void getFieldsTest() {
		BE_EditNonClient_Ctr.getFields('BE_EditNonClient');
		final BE_SingleRelatedList_QuickAction__mdt configMeta = (BE_SingleRelatedList_QuickAction__mdt) JSON.deserialize('{"DeveloperName":"TESTMETADATA_TST","MasterLabel":"Phone"}', BE_SingleRelatedList_QuickAction__mdt.class);
		System.assertEquals('TESTMETADATA_TST', configMeta.DeveloperName, 'Good');
	}

	/**
	   @Description test BE_EditNonClient_Ctr.updateNonClient(),correct scenary
	 */
	@IsTest
	static void updateNonClientTest() {
		final List<String> sObjNames = new List<String> {'Account'};
		final Map<String, Schema.RecordTypeInfo> recordType = BE_General_Utils.getRecordTypeInfo(sObjNames);
		final Account nonClient = new Account(Name = 'NO CLIENT TEST', AccountNumber = '20000000002', recordTypeId = recordType.get('Record_Type_Non_Client').getRecordTypeId());
		insert nonClient;
		final String json = '{"sobejctType":"Account","id":"' + nonClient.Id + '","Name":"NON CLIENT TEST 2","AccountNumber":"10212210244"}';
		final BE_SingleRelatedListCRUD_Cls.Response res = (BE_SingleRelatedListCRUD_Cls.Response)BE_EditNonClient_Ctr.updateNonClient(json);
		System.assert (res.isSuccess, 'True');
	}

	/**
	   @Description test BE_EditNonClient_Ctr.updateNonClient(),correct scenary
	 */
	@IsTest
	static void getNonClientTest() {
		final List<String> sObjNames = new List<String> {'Account'};
		final Map<String, Schema.RecordTypeInfo> recordType = BE_General_Utils.getRecordTypeInfo(sObjNames);
		final Account nonClient = new Account(Name = 'NO CLIENT TEST', AccountNumber = '20000000002', recordTypeId = recordType.get('Record_Type_Non_Client').getRecordTypeId());
		insert nonClient;
		final List<String> fields = new List<String> {'Name', 'AccountNumber'};
		final Account nonClientRes = BE_EditNonClient_Ctr.getNonClient(nonClient.Id, fields);
		System.assertEquals(nonClient.Id, nonClientRes.Id, 'Successs Account');
	}
}
