/**
   -------------------------------------------------------------------------------------------------
   @Name BE_SM_WonAlerts_tst
   @Author Gerson R. Diaz Alvarado (gerson.diaz@bbva.com)
   @Date 2021-05-20
   @Description
   @Changes
   Date        Author   Email                  Type
   2021-05-20  GRDA     gerson.diaz@bbva.com    Creation
   -------------------------------------------------------------------------------------------------
 */
@isTest
public class BE_SM_WonAlerts_tst {

    /*
	 * @Description  method setUp
	 */
    @TestSetup
    static void setUp() {
        BE_SM_Factory_tst.createSalesMeeting(DateTime.newInstance(System.today().addMonths(1).year(), System.today().addMonths(1).month(), 2, 3, 3, 3), UserInfo.getUserId(), 'Planning', true);

        Final Account acc = new Account(Name='Test Account');
        insert acc;
        Final altm__Commercial_Alert__c commAlert = new altm__Commercial_Alert__c(Name='TEST CommAlert',altm__participant_id__c=acc.Id, altm__alert_stage_type__c = '03', OwnerId = UserInfo.getUserId(), altm__commercial_alert_end_date__c = system.today());
        insert commAlert;
    }
    
     /*
	 * @Description method getSMWonAlerts
	 */
    @isTest
    static void getSMWonAlerts() {
        Final slmt__Sales_Meeting__c salesMeeting = [SELECT Id, slmt__management_plan_meeting_date__c, Collaborator__c FROM slmt__Sales_Meeting__c LIMIT 1];
        Final BE_SingleRelatedList_Setting__mdt srl = [SELECT Id, FieldsQuery__c, Filter__c, sObjectApiName__c FROM BE_SingleRelatedList_Setting__mdt WHERE DeveloperName = 'BE_SM_WonAlerts'];
        Test.startTest();
        Final BE_SingleRelatedListCRUD_Cls.Response response = new BE_SM_WonAlerts_cls().readRecords(new Map<String, Object>{'recordId' => salesMeeting.Id, 'sObjName' => srl.sObjectApiName__c, 
            'sObjFields' => srl.FieldsQuery__c, 'filterSQOL' =>srl.Filter__c});
        Test.stopTest();
        System.assertEquals(response.data.size()>0, true, 'Won Alertas!!!');
    }
    
}