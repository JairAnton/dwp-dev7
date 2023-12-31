/**
   -------------------------------------------------------------------------------------------------
   @Name BE_SM_ActivesAlerts_tst
   @Author Gerson R. Diaz Alvarado (gerson.diaz@bbva.com)
   @Date 2021-05-20
   @Description
   @Changes
   Date        Author   Email                  Type
   2021-05-20  GRDA     gerson.diaz@bbva.com    Creation
   -------------------------------------------------------------------------------------------------
 */
@isTest
public class BE_SM_ActivesAlerts_tst {

    /*
	 * @Description  method setUp
	 */
    @TestSetup
    static void setUp() {
        BE_SM_Factory_tst.createSalesMeeting(DateTime.newInstance(System.today().year(), System.today().month(), 1, 3, 3, 3), UserInfo.getUserId(), 'Planning', true);

        Final Account acc = new Account(Name='Test Account');
        insert acc;
        Final altm__Commercial_Alert__c commAlert = new altm__Commercial_Alert__c(Name='TEST CommAlert',altm__participant_id__c=acc.Id, altm__alert_stage_type__c = '01', OwnerId = UserInfo.getUserId(), altm__commercial_alert_end_date__c = system.today());
        insert commAlert;
    }
    
     /*
	 * @Description method getSMActiveAlerts
	 */
    @isTest
    static void getSMActiveAlerts() {
        Final slmt__Sales_Meeting__c salesMeeting = [SELECT Id, slmt__management_plan_meeting_date__c, Collaborator__c FROM slmt__Sales_Meeting__c LIMIT 1];
        Final BE_SingleRelatedList_Setting__mdt srl = [SELECT Id, FieldsQuery__c, Filter__c, sObjectApiName__c FROM BE_SingleRelatedList_Setting__mdt WHERE DeveloperName = 'BE_SM_ActivesAlerts'];
        Test.startTest();
        Final BE_SingleRelatedListCRUD_Cls.Response response = new BE_SM_ActivesAlerts_cls().readRecords(new Map<String, Object>{'recordId' => salesMeeting.Id, 'sObjName' => srl.sObjectApiName__c, 
            'sObjFields' => srl.FieldsQuery__c, 'filterSQOL' =>srl.Filter__c});
        Test.stopTest();
        System.assert(response.data.size()>0, 'Active Alerts!!!');

    }
    
}