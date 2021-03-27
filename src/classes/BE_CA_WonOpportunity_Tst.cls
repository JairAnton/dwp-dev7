/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_CA_WonOpportunity_Tst>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2020-03-03
   @Description BE_CA_WonOpportunity_Tst class
   @Changes
   Date        Author   Email                  Type
   2020-03-03  LMBR     lolo.bravo@bbva.com    Creation
   -------------------------------------------------------------------------------------------------
 */
@isTest
public with sharing class BE_CA_WonOpportunity_Tst {
    /**
     @Description test UpdateWonCommAlert
     @return void
  	*/
    @isTest
	static void updateToWonCommAlertTest() {
        final Account acc = new Account(Name='TEST Account');
        insert acc;
        final altm__Commercial_Alert__c commAlert = new altm__Commercial_Alert__c(Name='TEST CommAlert',altm__participant_id__c=acc.Id);
        insert commAlert;
        final Opportunity opp = new Opportunity(Name = 'TestCommAlertOpp', CloseDate = system.today(), Stagename = '02', AccountId = acc.id,commercial_alert_id__c=commAlert.id);
        insert opp;
        Test.startTest();
        opp.StageName='06';
        opp.opportunity_status_type__c='23';
        update opp;
        System.assertEquals(opp.IsWon,false, 'Sucess message');
        Test.stopTest();
    }
}