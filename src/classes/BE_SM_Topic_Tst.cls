/**
   -------------------------------------------------------------------------------------------------
   @Name BE_SM_Topic_Tst
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2020-11-19
   @Description
   @Changes
   Date        Author   Email                  Type
   2020-11-19  LMBR    lolo.bravo@bbva.com    Creation
   -------------------------------------------------------------------------------------------------
 */
@Istest
public without sharing class BE_SM_Topic_Tst {
    /*
	 * @Description  method setUp
	 */
	@TestSetup
	static void setupData() {
        /** USER */
        final User ejecutivo = TestFactory.createUser('Ejecutivo', 'Ejecutivo');
        ejecutivo.prof_position_id__c = 'E03';
        update ejecutivo;
        final User manager = TestFactory.createUser('Manager', 'Ejecutivo');
        manager.prof_position_id__c = 'E01';
        update manager;
        final Date initDate = Date.newInstance(System.today().addMonths(1).year(), System.today().addMonths(1).month(), 04);
        /** SALES MEETING */
        final slmt__Sales_Meeting__c slm=new slmt__Sales_Meeting__c(Name='SalesMeeting202010',DateTime__c=initDate,slmt__management_plan_meeting_date__c = initDate,OwnerId=ejecutivo.Id,Collaborator__c = ejecutivo.Id,slmt__mngmt_plan_meeting_user_id__c=manager.Id);
        System.runAs(ejecutivo) {
            insert slm;
        }
        /** TASK */
        insert new List<Task>{
            new Task(Subject='TASK01',slmt__management_plan_meeting_id__c=slm.Id,Status='Open',OwnerId=ejecutivo.Id,ActivityDate=initDate.addDays(-2)),
            new Task(Subject='TASK02',slmt__management_plan_meeting_id__c=slm.Id,Status='Open',OwnerId=ejecutivo.Id,ActivityDate=initDate.addDays(-2)),
            new Task(Subject='TASK04',slmt__management_plan_meeting_id__c=slm.Id,Status='Completed',OwnerId=ejecutivo.Id,ActivityDate=initDate)
        };
    }
     /*
	 * @Description topicQVCT Class
	 */
    @isTest
    static void topicQVCTst() {
        final slmt__Sales_Meeting__c salesMeeting = [SELECT Id,Name,slmt__mngmt_plan_meeting_user_id__c,slmt__management_plan_meeting_date__c, Collaborator__c FROM slmt__Sales_Meeting__c LIMIT 1];
        final User user=[SELECT ID FROM User LIMIT 1];
        final BE_SM_TopicQVC_Cls cplan= new BE_SM_TopicQVC_Cls();
        System.runAs(user) {
            final List<Map<String,String>> results=cplan.getCardDetails((Sobject)salesMeeting, '');
            System.assertEquals(results.size(),4,'Assertion Error');
        }
    }
    /*
	 * @Description  method pendingTopic
	 */
    @isTest
    static void pendingTopicTst() {
        final slmt__Sales_Meeting__c salesMeeting = [SELECT Id,Name,slmt__mngmt_plan_meeting_user_id__c,slmt__management_plan_meeting_date__c, Collaborator__c FROM slmt__Sales_Meeting__c LIMIT 1];
        final BE_SingleRelatedList_Setting__mdt srl = [SELECT Id, FieldsQuery__c, sObjectApiName__c FROM BE_SingleRelatedList_Setting__mdt 
                                                       WHERE DeveloperName = 'BE_SM_PendingTopic'];
        final BE_SingleRelatedListCRUD_Cls.Response response=new BE_SM_PendingTopic_Ctr().readRecords(new Map<String, Object>{'recordId' => salesMeeting.Id, 'sObjName' => srl.sObjectApiName__c, 'sObjFields' => srl.FieldsQuery__c});
        System.assertEquals(response.data.size(),0, 'Success cPlanInversionRentable');
    }
    
    /*
	 * @Description  method closeTopic
	 */
    @isTest
    static void closeTopicTst() {
        final slmt__Sales_Meeting__c salesMeeting = [SELECT Id,Name,slmt__management_plan_meeting_date__c, Collaborator__c FROM slmt__Sales_Meeting__c LIMIT 1];
        final BE_SingleRelatedList_Setting__mdt srl = [SELECT Id, FieldsQuery__c, sObjectApiName__c FROM BE_SingleRelatedList_Setting__mdt 
                                                       WHERE DeveloperName = 'BE_SM_CloseTopic'];
        Test.startTest();
        final BE_SingleRelatedListCRUD_Cls.Response response=new BE_SM_CloseTopic_Ctr().readRecords(new Map<String, Object>{'recordId' => salesMeeting.Id, 'sObjName' => srl.sObjectApiName__c, 'sObjFields' => srl.FieldsQuery__c});
        Test.stopTest();
        System.assertEquals(response.data.size(), 0, 'Sucess closeTopic');
    }

}