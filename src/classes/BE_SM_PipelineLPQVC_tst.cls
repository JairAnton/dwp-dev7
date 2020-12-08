/**
   -------------------------------------------------------------------------------------------------
   @Name BE_SM_PipelineLPQVC_tst
   @Author Diego Carbajal Pastor (diego.carbajal@bbva.com)
   @Date 2020-11-11
   @Description
   @Changes
   Date        Author   Email                  Type
   2020-11-11  DCP     diego.carbajal@bbva.com    Creation
   -------------------------------------------------------------------------------------------------
 */
@isTest
public class BE_SM_PipelineLPQVC_tst {

    /** @Description  variable ASSERT_ERROR*/
    private static Final String ASSERT_ERROR = 'Assertion Error';

    /*
	 * @Description  method setUp
	 */
    @TestSetup
    static void setUp() {
        BE_SM_Factory_tst.generalSetUp();
    }
    
    /*
	 * @Description  method getCardDetails
	 */
    @isTest
    static void getCardDetails() {
        Final slmt__Sales_Meeting__c salesMeeting = [SELECT Id, slmt__management_plan_meeting_date__c, Collaborator__c FROM slmt__Sales_Meeting__c LIMIT 1];
        Test.startTest();
        Final List<Map<String,String>> lstCard = new BE_SM_PipelineLPQVC_Cls().getCardDetails(salesMeeting, 'cardId');
        Test.stopTest();
        System.assertEquals(4, lstCard.size(), ASSERT_ERROR);
    }
    
    /*
	 * @Description  method updateRecordsSuccessTest
	 */
    @isTest
    static void updateRecordsSuccessTest() {
        Final Opportunity opp = [SELECT Id FROM Opportunity WHERE StageName = '02' LIMIT 1];
        opp.Amount = 9999;
        Test.startTest();
        Final BE_SingleRelatedListCRUD_Cls.Response response = new BE_SM_Pipeline_Update_cls().updateRecords(new SObject[]{opp});
        Test.stopTest();
        Final SObject obj = response.data[0];
        System.assertEquals(opp.Amount, obj.get('Amount'), ASSERT_ERROR);
    }
    
    /*
	 * @Description  method updateRecordsErrorTest
	 */
    @isTest
    static void updateRecordsErrorTest() {
        Test.startTest();
        Final BE_SingleRelatedListCRUD_Cls.Response response = new BE_SM_Pipeline_Update_cls().updateRecords(new SObject[]{new Opportunity()});
        Test.stopTest();
        System.assert(!response.isSuccess, ASSERT_ERROR);
    }
}