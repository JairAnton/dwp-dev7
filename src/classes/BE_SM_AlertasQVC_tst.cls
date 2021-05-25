/**
   -------------------------------------------------------------------------------------------------
   @Name BE_SM_AlertasQVC_tst
   @Author Gerson R. Diaz Alvarado (gerson.diaz@bbva.com)
   @Date 2021-05-20
   @Description
   @Changes
   Date        Author   Email                  Type
   2021-05-20  GRDA     gerson.diaz@bbva.com    Creation
   -------------------------------------------------------------------------------------------------
 */
@isTest
public class BE_SM_AlertasQVC_tst {

    /*
	 * @Description  method setUp
	 */
    @TestSetup
    static void setUp() {
        BE_SM_Factory_tst.createSalesMeeting(DateTime.newInstance(System.today().year(), System.today().month(), 1, 3, 3, 3), UserInfo.getUserId(), 'Planning', true);

        Final Account acc = new Account(Name='Test Account');
        insert acc;
        Final altm__Commercial_Alert__c commAlert = new altm__Commercial_Alert__c(Name='Test CommAlert',altm__participant_id__c=acc.Id, altm__alert_stage_type__c = '01', OwnerId = UserInfo.getUserId(), altm__commercial_alert_end_date__c = system.today());
        insert commAlert;
    }
    
    /*
	 * @Description  method getCardDetails1T
	 */
    @isTest
    static void getCardDetails1T() {
        Final slmt__Sales_Meeting__c salesMeeting = [SELECT Id, slmt__management_plan_meeting_date__c, Collaborator__c FROM slmt__Sales_Meeting__c LIMIT 1];
        Test.startTest();
        Final List<Map<String,String>> lstCard = new BE_SM_AlertasQVC_Cls().getCardDetails(salesMeeting, 'cardId');
        Test.stopTest();
        System.assert(!lstCard.isEmpty(), 'get Card Details Success!!!');
    }
    
}