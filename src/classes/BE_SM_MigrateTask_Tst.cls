/**
   -------------------------------------------------------------------------------------------------
   @Name BE_SM_MigrateTask_Tst
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-11-27
   @Description
   @Changes
   Date        Author   Email                  				Type
   2020-11-27  MAMCH    martin.mori.contractor@bbva.com    	Creation
   -------------------------------------------------------------------------------------------------
 */
@isTest
public with sharing class BE_SM_MigrateTask_Tst {
    /** @Variable STREJE*/
    public static Final String STREJE = 'Ejecutivo';
    /** @Variable STROPEN*/
    public static Final String STROPEN = 'Open';
    
    /*
	 * @Description  method setUp
	 */
    @TestSetup
    static void setUp() {
        /** USER */
        final User ejecutivo = TestFactory.createUser(STREJE, STREJE);
        ejecutivo.prof_position_id__c = 'E03';
        update ejecutivo;
        final User ejecutivo2 = TestFactory.createUser(STREJE, STREJE);
        ejecutivo2.prof_position_id__c = 'E03';
        update ejecutivo2;
        final User manager = TestFactory.createUser('Manager', STREJE);
        manager.prof_position_id__c = 'E01';
        update manager;
        final Date initDate = Date.newInstance(System.today().addMonths(1).year(), System.today().addMonths(1).month(), 04);
        /** SALES MEETING */
        final slmt__Sales_Meeting__c slm1=new slmt__Sales_Meeting__c(DateTime__c=initDate,Collaborator__c=ejecutivo.Id);
        insert slm1;
        final slmt__Sales_Meeting__c slm2=new slmt__Sales_Meeting__c(DateTime__c=initDate,Collaborator__c=ejecutivo2.Id);
        insert slm2;
        /** TASK */
        final Map<String, Schema.RecordTypeInfo> recordType = BE_General_Utils.getRecordTypeInfo(new List<String> {'Task'});
        final String taskRTSlmt =  recordType.get('Sales_Meeting').getRecordTypeId();
        insert new List<Task>{
            new Task(RecordTypeId=taskRTSlmt,Subject='TASK01',slmt__management_plan_meeting_id__c=slm1.Id,Status=STROPEN,OwnerId=ejecutivo.Id,ActivityDate=initDate.addDays(-2)),
            new Task(RecordTypeId=taskRTSlmt,Subject='TASK02',slmt__management_plan_meeting_id__c=slm1.Id,Status=STROPEN,OwnerId=ejecutivo.Id,ActivityDate=initDate.addDays(-2)),
            new Task(RecordTypeId=taskRTSlmt,Subject='TASK03',slmt__management_plan_meeting_id__c=slm1.Id,Status='Completed',OwnerId=ejecutivo.Id,ActivityDate=initDate),
            new Task(RecordTypeId=taskRTSlmt,Subject='TASK04',slmt__management_plan_meeting_id__c=slm2.Id,Status=STROPEN,OwnerId=ejecutivo2.Id,ActivityDate=initDate.addDays(-2)),
            new Task(RecordTypeId=taskRTSlmt,Subject='TASK05',slmt__management_plan_meeting_id__c=slm2.Id,Status=STROPEN,OwnerId=ejecutivo2.Id,ActivityDate=initDate.addDays(-2))
        };
    }
    
    /*
	 * @Description method unitTest
	 */
    @isTest
    static void unitTest() {
        final List<slmt__Sales_Meeting__c> ltsSlmt = [SELECT Id, Name, DateTime__c, OwnerId, Collaborator__c, slmt__mngmt_plan_meeting_status_name__c, Type_of_meeting__c FROM slmt__Sales_Meeting__c LIMIT 2];
        update new slmt__Sales_Meeting__c(Id = ltsSlmt[0].Id, DateTime__c=System.today().addDays(-5), slmt__mngmt_plan_meeting_status_name__c = 'Finalized');
        update new slmt__Sales_Meeting__c(Id = ltsSlmt[1].Id, DateTime__c=System.today().addDays(-5), slmt__mngmt_plan_meeting_status_name__c = 'Finalized');
        Test.startTest();
        final List<slmt__Sales_Meeting__c> newSlmts = new List<slmt__Sales_Meeting__c>();
        newSlmts.add(new slmt__Sales_Meeting__c(DateTime__c = ltsSlmt[0].DateTime__c.addDays(7), Collaborator__c = ltsSlmt[0].Collaborator__c, Type_of_meeting__c = ltsSlmt[0].Type_of_meeting__c));
        newSlmts.add(new slmt__Sales_Meeting__c(DateTime__c = ltsSlmt[1].DateTime__c.addDays(7), Collaborator__c = ltsSlmt[1].Collaborator__c, Type_of_meeting__c = ltsSlmt[1].Type_of_meeting__c));
        insert newSlmts;
        Test.stopTest();
        final List<Task> ltsTask = [SELECT Id FROM Task WHERE (slmt__management_plan_meeting_id__c = :newSlmts[0].Id)];
        System.assertEquals(ltsTask.size(), 2, 'success!!!');
    }
}