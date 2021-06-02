/**
   -------------------------------------------------------------------------------------------------
   @Name BE_SM_Product_Tst
   @Author Gerson R. Díaz Alvarado (gerson.diaz@bbva.com)
   @Date 2021-06-01
   @Description
   @Changes
   Date        Author   Email                  				Type
   2021-06-01  MAMCH    gerson.diaz@bbva.com 			   	Creation
   -------------------------------------------------------------------------------------------------
 */
@isTest
public with sharing class BE_SM_Product_Tst {
    
    /*
	 * @Description  method setUp
	 */
    @TestSetup
    static void setUp() {
        Final Id ejeProfileId = BE_SM_Factory_tst.ID_EJE;
        Final User userGOF = TestFactory.getUser(true, new Map<Schema.SObjectField, Object>{User.ProfileId => ejeProfileId, User.prof_position_id__c => 'E01'});
        Final User ejecutivo = TestFactory.getUser(true, new Map<Schema.SObjectField, Object>{User.ProfileId => ejeProfileId, User.prof_position_id__c => 'E03', 
            																					User.ManagerId => userGOF.Id});
        Final Account acc = TestFactory.getAccount(true, new Map<Schema.SObjectField, Object>{Account.OwnerId => ejecutivo.Id});
        Final Date initDate = Date.newInstance(System.today().addMonths(1).year(), System.today().addMonths(1).month(), 04);
        System.runAs(ejecutivo) {
        	BE_SM_Factory_tst.createSalesMeeting(DateTime.newInstance(System.today().addMonths(1).year(), System.today().addMonths(1).month(), 4, 3, 3, 3), ejecutivo.Id, 'Planning', true);
        }
        
        Final dwp_kitv__Visit__c [] lstVisitas = new dwp_kitv__Visit__c[] {};
		for(Integer i = 0; i < 2; i++) {
			lstVisitas.add(new dwp_kitv__Visit__c(dwp_kitv__account_id__c = acc.Id, dwp_kitv__visit_duration_number__c = '15', dwp_kitv__visit_start_date__c = initDate.addDays(5)));
		}
        lstVisitas.add(new dwp_kitv__Visit__c(dwp_kitv__account_id__c = acc.Id, dwp_kitv__visit_status_type__c = '04', dwp_kitv__visit_duration_number__c = '15', dwp_kitv__visit_start_date__c = initDate.addDays(-5)));
		insert lstVisitas;
    }
    
    /*
	 * @Description method getCardDetails
	 */
    @isTest
    static void getCardDetails() {
        Final slmt__Sales_Meeting__c salesMeeting = [SELECT Id, slmt__management_plan_meeting_date__c, Collaborator__c FROM slmt__Sales_Meeting__c LIMIT 1];
        Test.startTest();
        Final List<Map<String,String>> lstCard = new BE_SM_ProductQVC_Cls().getCardDetails(salesMeeting, 'cardId');
        Test.stopTest();
        System.assert(!lstCard.isEmpty(), 'success getCardDetails!!!');
    }
    
    /*
	 * @Description method getRecordType
	 */
    @isTest
    static void getRecordTypeTask() {
        Test.startTest();
        Final String rtId = BE_SM_Utils.getRecordTypeId('Sales_Meeting');
        Test.stopTest();
        System.assert(!String.isEmpty(rtId), 'success getRecordTypeTask!!!');
    }
}