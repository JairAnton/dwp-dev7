@istest
public class approveButtonClass_Test {
static Account acctest;
    static Opportunity opptest;
    static Product2 prod;
    static OpportunityLineItem oli;
    
    @testSetup
    static void setData() {
        acctest = TestFactory.createAccount();
        opptest = TestFactory.createOpportunity(acctest.Id,UserInfo.getUserId());
        prod = testFactory.createProduct();
        oli = testFactory.createOLI(opptest.Id, prod.Id);
        }
     @isTest
     static void approve(){
         setData();
         
         Test.startTest();
         opptest.StageName = '04';
         opptest.opportunity_status_type__c ='15';
         update opptest;
         approveButtonClass.start(opptest.Id);
         
         opptest.opportunity_status_type__c ='10';
         update opptest;
         approveButtonClass.start(opptest.Id);
         
         opptest.opportunity_status_type__c ='11';
         update opptest;
         approveButtonClass.approvePrice(opptest.Id);
         
         opptest.opportunity_status_type__c ='17';
         update opptest;
         approveButtonClass.approveRisk(opptest.Id);

         Test.stopTest();  
     }
}