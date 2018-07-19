@istest
public  class ReevaluateButtonClassTest {
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
     static void testPositive(){
         setData();
         
         
         Test.startTest();
         opptest.StageName = '04';
         opptest.opportunity_status_type__c ='16';
         update opptest;
         prod.risk_sanction__c = true;
         update prod;
         ReevaluateButtonClass.start(opptest.Id);
         opptest.opportunity_status_type__c ='13';
         update opptest;
         prod.risk_sanction__c = true;
         prod.price_penalty__c= true;
         update prod;         
         ReevaluateButtonClass.start(opptest.Id);
         prod.risk_sanction__c = false;
         prod.price_penalty__c= true;
         update prod;
         ReevaluateButtonClass.start(opptest.Id);
         opptest.StageName = '05';
         opptest.opportunity_status_type__c ='20';
         update opptest;
         prod.formalization__c = true;
         update prod;
         ReevaluateButtonClass.start(opptest.Id);
         prod.risk_sanction__c= true;
         update prod;
         ReevaluateButtonClass.start(opptest.Id);
         prod.price_penalty__c= false;
         update prod;
         ReevaluateButtonClass.start(opptest.Id);
         ReevaluateButtonClass.getErrorMessagesList(opptest.Id,'Opportunity','');
         ReevaluateButtonClass.setToPrice(opptest.Id);
         ReevaluateButtonClass.setToRisk(opptest.Id);
         Test.stopTest();
        
     }
    
    

}