/**
   ---------------------------------------------------------------------------------------------
   @Name <BE_ForecastPlanGroupingManager_Tst>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2019-11-26
   @Description Test class for the Class BE_ForecastPlanGroupingManager_Queue,BE_ForecastPlanGroupingManager_Qs
   @Changes
    Date        Author   Email                  Type
    2019-11-26  LMBR     lolo.bravo@bbva.com    Created
   ----------------------------------------------------------------------------------------------------
 */
@IsTest
public with sharing class BE_ForecastPlanGroupingManager_Tst {
/** Profile Name */
final static String PROF_NAME='Ejecutivo';
/** Cron Expression */
final static String SCH = '0 0 0 * * ?';
/**@Description TestSetup for generated data to use in the test methods*/
@TestSetup
static void makeData() {
	final List<Profile>prof=new List<Profile>([SELECT Id, Name FROM Profile WHERE Name=: PROF_NAME]);
	final List<User>userLst=new List<User>();
	final List<dwp_frct__management_plan__c>planLst = new List<dwp_frct__management_plan__c>();
	final List<dwp_frct__grouping__c>groupList=new List<dwp_frct__grouping__c>();
	Map<Schema.SObjectField, Object>mapUserFields;
	for(Integer i = 0; i < 2; i++) {
		mapUserFields= new Map<Schema.SObjectField, Object>();
		mapUserFields.put(User.Username, 'user'+i+'PPG@bbva.com');
		mapUserFields.put(User.ProfileId, prof[0].Id);
		mapUserFields.put(User.user_id__c, 'P0000000000003'+i);
		userLst.add(TestFactory.getUser(false, mapUserFields));
	}
	insert userLst;
	for(Integer i = 0; i < 2; i++) {
		planLst.add(new dwp_frct__management_plan__c(Name='PlaPPGoNE',
		                                             OwnerId=userLst[i].Id,
		                                             dwp_frct__management_plan_start_date__c=Date.today(),
		                                             dwp_frct__management_plan_end_date__c=Date.today().addDays(10)));
	}
	insert planLst;
	final List<BE_FamilyGroupingForecast__c>faProdLst=new List<BE_FamilyGroupingForecast__c>();
	faProdLst.add(new BE_FamilyGroupingForecast__c(Name='Financiamiento a corto plazo'));
	faProdLst.add(new BE_FamilyGroupingForecast__c(Name='Financiamiento a largo plazo'));
	faProdLst.add(new BE_FamilyGroupingForecast__c(Name='Recursos'));
	faProdLst.add(new BE_FamilyGroupingForecast__c(Name='Riesgo de firma'));
	upsert faProdLst;
	final Map<String,BE_FamilyGroupingForecast__c>familyProductMap=BE_FamilyGroupingForecast__c.getAll();
	for(String typeFamily: familyProductMap.keySet()) {
		groupList.add(new dwp_frct__grouping__c(
				      dwp_frct__management_plan_id__c=planLst[0].Id,
				      dwp_frct__solution_category_type__c=typeFamily,
				      dwp_frct__management_expected_drop_amount__c=0,
				      dwp_frct__opportunity_amortization_amount__c=0,
				      dwp_frct__opportunity_antcp_expiry_amount__c=0,
				      dwp_frct__opportunity_cancellation_amount__c=0,
				      dwp_frct__opportunity_closed_amount__c=0,
				      dwp_frct__opportunity_selected_tot_amount__c=0,
				      dwp_frct__original_commitment_amount__c=0
				      ));
	}
	insert groupList;
}
/**
   @Description test method for  BE_ForecastPlanGroupingManager_Queue.
   @Class BE_ForecastPlanGroupingManager_Queue,ManagementPlanAfterUpdate_handler
 */
@IsTest
static void groupingManagerQueuedable() {
	Test.startTest();
	final Id jobID=System.enqueueJob(new BE_ForecastPlanGroupingManager_Queue());
	final AsyncApexJob jobInfo = [SELECT Status,JobType,NumberOfErrors FROM AsyncApexJob WHERE Id=:jobID];
	System.assertEquals('Queueable',jobInfo.JobType, 'Queuedable run correctly!');
	Test.stopTest();
}
/**
   @Description test method for  BE_ForecastPlanGroupingManager_Qs.
   @Class BE_ForecastPlanGroupingManager_Qs
 */
@IsTest
static void groupingManagerSchedule() {
	Test.startTest();
	final BE_ForecastPlanGroupingManager_Qs planSch = new BE_ForecastPlanGroupingManager_Qs();
	final String jobId=System.schedule('PPG_Grouping_Test', sch, planSch);
	final CronTrigger cronTrigger= [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
	System.assertEquals(SCH,cronTrigger.CronExpression,'Scheduler PPG-Grouping run!');
	Test.stopTest();
}
}
