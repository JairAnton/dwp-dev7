@istest
public class Commitment_ctrl_Test {
    
    static Account acctest;
    static Opportunity opptest;
    static OpportunityLineItem olitest;
    static Product2 prodtest;
    static User quoteOwner;
    
    @testSetup
    static void setData() {
            
            acctest = TestFactory.createAccount();
            opptest = TestFactory.createOpportunity(acctest.Id, UserInfo.getUserId());
            prodtest = TestFactory.createProduct();
            olitest = TestFactory.createOLI(opptest.Id, prodtest.Id);
    }

    @isTest
    static void test_method_one(){

        List<Product2> lstProd = [SELECT Id, Type_of_quote__c FROM Product2];
        lstProd[0].Type_of_quote__c = 'Tarifario';
        update lstProd;
        Map<String,Object> mapReturnInfo = Commitment_ctrl.getInfo('Tarifario');
        System.assert(mapReturnInfo.containsKey('schemaSetup'));

        List<Opportunity> lstOpp = [SELECT Id FROM Opportunity];
        Map<String,Object> mapReturnInfoTable = Commitment_ctrl.getInfoTable(lstOpp[0].Id);
        System.assert(mapReturnInfoTable.containsKey('schemaSetup'));

        List<Object> lstData = new List<Object>();
        lstData.add('Prod');
        lstData.add('PEN');
        lstData.add(34);
        lstData.add(12);
        lstData.add(3);
        lstData.add(null);
        lstData.add(null);
        Map<String,Object> mapReturnSave = Commitment_ctrl.saveCommitment(lstOpp[0].Id,lstData,null);
        System.assertEquals(true, (Boolean)mapReturnSave.get('isOK'));

        List<Opportunity_Solution_Commitment__c> lstOppSol = [SELECT Id FROM Opportunity_Solution_Commitment__c];
        Map<String,Object> mapReturnDelete = Commitment_ctrl.deleteCommitment(lstOppSol[0].Id);
        System.assertEquals(true, (Boolean)mapReturnDelete.get('isOK'));
        
    }
    
    @isTest
    static void test_createQuoteRequest_Success(){
        
        List<Profile> profileList = new List<Profile>([SELECT Id, Name FROM Profile where Name = 'Migracion']);
        
        if(!profileList.isEmpty()){
            User quoteOwner = new User();
            Double random = Math.random();
            quoteOwner.Username = 'analista1' +'u2@u.com.u'+random;
            quoteOwner.LastName = 'analista1' +'uLast2';
            quoteOwner.Email = 'analista1' +'u2@u.com';
            quoteOwner.Alias= String.valueOf(random).substring(0, 3)+'uAas2';
            quoteOwner.TimeZoneSidKey='America/Mexico_City';
            quoteOwner.IsActive=true;
            quoteOwner.LocaleSidKey='en_US';
            quoteOwner.EmailEncodingKey='ISO-8859-1';
            quoteOwner.ProfileId=  profileList[0].Id;
            quoteOwner.LanguageLocaleKey='es';
            quoteOwner.user_id__c = 'P012677';
            
            insert quoteOwner;
            
            List<User> userToExecuteWith = [SELECT Id, user_id__c FROM User WHERE user_id__c = 'P012677'];
            
            if(!userToExecuteWith.isEmpty()){
                System.runAs(userToExecuteWith[0]) {
        			setData();
        
                    insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'ServicesPartition');
                    insert new iaso__GBL_Rest_Services_Url__c(Name = 'CreateQuotationRequest', iaso__Url__c = 'https://CreateRequestElevated/OK', iaso__Cache_Partition__c = 'ServicesPartition');
                    Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
                    iaso.GBL_Mock.setMock(new Integration_MockGenerator());
                    
                    Test.startTest();

                    Map<String,Object> mapResultReturn = Commitment_ctrl.requestQuote(opptest.Id);
                    System.assertEquals('true', mapResultReturn.get('success'));
                    System.assertEquals(Label.PriceCreateQuotationRequestSentForApprovalMessage, mapResultReturn.get('quotationStatusMessage'));
 
                    Test.stopTest();
                }
        	}
        }
    }
    
    @isTest
    static void test_createQuoteRequest_Error_1(){
        
        setData();
        
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'ServicesPartition');
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'CreateQuotationRequest', iaso__Url__c = 'https://CreateRequest/KO_500', iaso__Cache_Partition__c = 'ServicesPartition');
        Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
        iaso.GBL_Mock.setMock(new Integration_MockGenerator());
        
        Test.startTest();
        
        Map<String,Object> mapResultReturn = Commitment_ctrl.requestQuote(opptest.Id);
        
        System.assertEquals('false', mapResultReturn.get('success'));
        System.assertEquals(Label.PriceCreateQuotationRequestUnknowError, mapResultReturn.get('errorMessage'));
            
        Test.stopTest();
        
    }
    @isTest
    static void test_createQuoteRequest_Error_2(){
        
        setData();
        
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'ServicesPartition');
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'CreateQuotationRequest', iaso__Url__c = 'https://CreateRequest/KO_409', iaso__Cache_Partition__c = 'ServicesPartition');
        Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
        iaso.GBL_Mock.setMock(new Integration_MockGenerator());
        
        Test.startTest();
        
        Map<String,Object> mapResultReturn = Commitment_ctrl.requestQuote(opptest.Id);
        
        System.assertEquals('false', mapResultReturn.get('success'));
            
        Test.stopTest();
        
    }
}