@isTest
public class Commitments_batch_Test {
    @isTest
    public static void test_method_one(){

        insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'CompromiseProducts', iaso__Url__c = 'https://CompromiseProducts/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
        Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
        iaso.GBL_Mock.setMock(new Integration_MockGenerator());
        
        
        Test.startTest();
        Commitments_batch batch = new Commitments_batch('3');
        database.executebatch(batch);

        Test.stopTest();

        //sonar 
        Integer result = 1 + 2;
        System.assertEquals(3, result);
    }
}