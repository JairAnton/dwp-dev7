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
        final DateTime initDateTime = DateTime.newInstance(System.today().addMonths(1).year(), System.today().addMonths(1).month(), 04, 3, 3, 3);
        /** SALES MEETING */
        final slmt__Sales_Meeting__c slm1=new slmt__Sales_Meeting__c(DateTime__c=initDateTime,Collaborator__c=ejecutivo.Id);
        insert slm1;
        final slmt__Sales_Meeting__c slm2=new slmt__Sales_Meeting__c(DateTime__c=initDateTime,Collaborator__c=ejecutivo2.Id);
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
    
}