@isTest
public class Email_SIO_Test {
    static Account acctest;
    static Opportunity opptest;
    static User defaultUser;

    static void setData() {        
        defaultUser = TestFactory.createUser('Test','Migracion');        
    }
    @isTest
    static void handleInboundEmailWithoutOpp() {
        setData();
        
        acctest = new Account (Name = 'Acctest', main_code_id__c ='222');
        insert acctest;
        opptest = new Opportunity (ownerId=defaultUser.Id,Name='testopp', AccountId=acctest.Id,StageName='01',Amount=100 ,CloseDate=system.Date.today(),opportunity_status_type__c='01');
        insert opptest;
        
        Test.startTest();
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        email.subject = 'SIOCode##SIOStatus##??##??##222';
        email.fromAddress = 'comunicacion@p-1oflcjcwitlx140fa83tigxgbb3nmkavaczc81frgpisa8v1ih.29-8p7zeaa.cs19.apex.sandbox.salesforce.com';
        email.plainTextBody = 'comments';
        
        Email_SIO emailSIO = new Email_SIO();
        emailSIO.handleInboundEmail(email, env);
        
        Test.stopTest();        
    }
    @isTest
    static void handleInboundEmailWithOpp() {
        setData();
        Test.startTest();
        
        acctest = new Account (Name = 'Acctest', main_code_id__c ='222');
        insert acctest;
        opptest = new Opportunity (ownerId=defaultUser.Id,Name='testopp', AccountId=acctest.Id,StageName='04',Amount=100 ,CloseDate=system.Date.today(),opportunity_status_type__c='14',sio_status_type__c='Sanción Aprobado CM',sio_code__c='2222');
        insert opptest;
        
        
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        email.subject = '2222##Sanción Aprobado CM##??##??##222';
        email.fromAddress = 'comunicacion@p-1oflcjcwitlx140fa83tigxgbb3nmkavaczc81frgpisa8v1ih.29-8p7zeaa.cs19.apex.sandbox.salesforce.com';
        email.plainTextBody = 'comments';
        
        Email_SIO emailSIO = new Email_SIO();
        emailSIO.handleInboundEmail(email, env);
        
        Test.stopTest();        
    }
    @isTest
    static void handleInboundEmailWithOppstatus() {
        setData();
        Test.startTest();
        
        acctest = new Account (Name = 'Acctest', main_code_id__c ='222');
        insert acctest;
        opptest = new Opportunity (ownerId=defaultUser.Id,Name='testopp', AccountId=acctest.Id,StageName='04',Amount=100 ,CloseDate=system.Date.today(),opportunity_status_type__c='14',sio_status_type__c='Sanción Denegado',sio_code__c='2222');
        insert opptest;
        
        
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        email.subject = '2222##Sanción Denegado##??##??##222';
        email.fromAddress = 'comunicacion@p-1oflcjcwitlx140fa83tigxgbb3nmkavaczc81frgpisa8v1ih.29-8p7zeaa.cs19.apex.sandbox.salesforce.com';
        email.plainTextBody = 'comments';
        
        Email_SIO emailSIO = new Email_SIO();
        emailSIO.handleInboundEmail(email, env);
        
        Test.stopTest();        
    }
    @isTest
    static void handleInboundEmailUpdateAcc() {
        
        setData();
        
        acctest = new Account (Name = 'Acctest', main_code_id__c ='222',financial_program_expiry_date__c =date.today());
        insert acctest;
        opptest = new Opportunity (ownerId=defaultUser.Id,Name='testopp3', AccountId=acctest.Id,StageName='01',Amount=100 ,opportunity_status_type__c='01',CloseDate=system.Date.today()+2);
        insert opptest;
        
        Test.startTest();        
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        email.subject = '222##12/07/2013';
        email.fromAddress = 'comunicacion@p-1oflcjcwitlx140fa83tigxgbb3nmkavaczc81frgpisa8v1ih.29-8p7zeaa.cs19.apex.sandbox.salesforce.com';
        email.plainTextBody = 'comments';
        
        Email_SIO emailSIO = new Email_SIO();
        emailSIO.handleInboundEmail(email, env);
        
        Messaging.InboundEmail email2 = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env2 = new Messaging.InboundEnvelope();
        
        email2.subject = '222##2013/07/12';
        email2.fromAddress = 'comunicacion@p-1oflcjcwitlx140fa83tigxgbb3nmkavaczc81frgpisa8v1ih.29-8p7zeaa.cs19.apex.sandbox.salesforce.com';
        email2.plainTextBody = 'comments';
        
        Email_SIO emailSIO2 = new Email_SIO();
        emailSIO2.handleInboundEmail(email2, env2);
        
        Test.stopTest();
    }
}