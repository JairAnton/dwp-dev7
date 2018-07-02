@isTest
public class PE_DWP_Correo_tst {
    
    static List<Profile> p; 
    static List<UserRole> userRole;
    static Map<String, Profile> perfilMapa = new Map<String, Profile>();    
    
    @testSetup static void loadData(){
        p = new List<Profile>([SELECT Id, Name FROM Profile]);
        userRole = new List<UserRole>([SELECT Id, Name FROM UserRole]);
        for(Profile perfil:p){ perfilMapa.put(perfil.Name, perfil); } 
        
       	string perfilt ='ejecutivo';
        User u = new User();
        u.Username=perfilt+'u2@u.com.u';
        u.LastName=Perfilt+'uLast2';
        u.Email=Perfilt+'u2@u.com';
        u.Alias= Perfilt.substring(0, 2)+'uAas2';
        u.CommunityNickname=Perfilt+'2uComm';
        u.TimeZoneSidKey='America/Mexico_City';
        u.LocaleSidKey='en_US';
        u.EmailEncodingKey='ISO-8859-1';
        u.ProfileId=  perfilMapa.get('Ejecutivo').Id;
        u.LanguageLocaleKey='en_US';
        u.FederationIdentifier='123Xemo';
        insert u;
        
    }
    @isTest static void testProcessReplyEmails(){   
        Test.startTest();
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        email.subject = 'CódigoSIO##Estado SIO##Usuario##Fecha+Hora';
        email.fromAddress = 'comunicacion@p-1oflcjcwitlx140fa83tigxgbb3nmkavaczc81frgpisa8v1ih.29-8p7zeaa.cs19.apex.sandbox.salesforce.com';
        email.plainTextBody = 'Blah Blah Blah';        
        PE_DWP_Correo_cls catcher = new PE_DWP_Correo_cls();
        catcher.handleInboundEmail(email, env);
        Test.stopTest();
    } 
    @isTest static void testProcessReplyEmails_2(){   
        Test.startTest();
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        email.subject = 'central##fechaDvencimiento';
        email.fromAddress = 'comunicacion@p-1oflcjcwitlx140fa83tigxgbb3nmkavaczc81frgpisa8v1ih.29-8p7zeaa.cs19.apex.sandbox.salesforce.com';
        email.plainTextBody = 'Blah Blah Blah';        
        PE_DWP_Correo_cls catcher = new PE_DWP_Correo_cls();
        catcher.handleInboundEmail(email, env);
        Test.stopTest();
    } 
    @isTest static void testProcessReplyEmails_3(){   
        Test.startTest();
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        email.subject = 'central##fechaDvencimiento##Vi';
        email.fromAddress = 'comunicacion@p-1oflcjcwitlx140fa83tigxgbb3nmkavaczc81frgpisa8v1ih.29-8p7zeaa.cs19.apex.sandbox.salesforce.com';
        email.plainTextBody = 'Blah Blah Blah';        
        PE_DWP_Correo_cls catcher = new PE_DWP_Correo_cls();
        catcher.handleInboundEmail(email, env);
        Test.stopTest();
    }     
    @isTest static void testProcessReplyEmails_4(){   
        Test.startTest();
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        email.subject = 'central##fechaDvencimiento##Vi##hu##jj';
        email.fromAddress = 'comunicacion@p-1oflcjcwitlx140fa83tigxgbb3nmkavaczc81frgpisa8v1ih.29-8p7zeaa.cs19.apex.sandbox.salesforce.com';
        email.plainTextBody = 'Blah Blah Blah';        
        PE_DWP_Correo_cls catcher = new PE_DWP_Correo_cls();
        catcher.handleInboundEmail(email, env);
        Test.stopTest();
    }     
    @isTest static void testProcessReplyEmails_5(){   
        Test.startTest();
        Account cliente= new Account(Name='Ejemplo',
                                     main_code_id__c='12345678');
        Insert cliente;
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        email.subject = '12345678##12/12/2012';
        email.fromAddress = 'comunicacion@p-1oflcjcwitlx140fa83tigxgbb3nmkavaczc81frgpisa8v1ih.29-8p7zeaa.cs19.apex.sandbox.salesforce.com';
        email.plainTextBody = 'Blah Blah Blah'; 
        
        PE_DWP_Correo_cls catcher = new PE_DWP_Correo_cls();
        catcher.handleInboundEmail(email, env);
        Test.stopTest();
    }
    @isTest static void testProcessReplyEmails_6(){   
        Test.startTest();
        Account cliente= new Account(Name='Ejemplo',
                                     main_code_id__c='12345678');
        Insert cliente;
        User u=[select Username, LastName, Email, Alias, CommunityNickname, TimeZoneSidKey, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey, FederationIdentifier from user where Username='ejecutivou2@u.com.u'];
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        email.subject = '123Xemo##13##Arsenio Perez Lopez##02/05/2011##nua';
        email.fromAddress = 'comunicacion@p-1oflcjcwitlx140fa83tigxgbb3nmkavaczc81frgpisa8v1ih.29-8p7zeaa.cs19.apex.sandbox.salesforce.com';
        email.plainTextBody = 'Blah Blah Blah';  
        PE_DWP_Correo_cls catcher = new PE_DWP_Correo_cls();
        catcher.handleInboundEmail(email, env);
        Test.stopTest();
    }
    @isTest static void testProcessReplyEmails_7(){   
        Test.startTest();
        Account cliente= new Account(Name='Ejemplo',
                                     main_code_id__c='12345678');
        Insert cliente;
        Opportunity opp= new Opportunity(name='Cuenta',
                                         CloseDAte=system.today(),
                                         stageName='03');
        insert opp;
        User u=[select Username, LastName, Email, Alias, CommunityNickname, TimeZoneSidKey, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey, FederationIdentifier from user where Username='ejecutivou2@u.com.u'];
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        email.subject = '123Xemo##13##Arsenio Perez Lopez##02/05/2011';
        email.fromAddress = 'comunicacion@p-1oflcjcwitlx140fa83tigxgbb3nmkavaczc81frgpisa8v1ih.29-8p7zeaa.cs19.apex.sandbox.salesforce.com';
        email.plainTextBody = 'Blah Blah Blah';        
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
        attachment.body = blob.valueOf('my attachment text');
        attachment.fileName = 'textfileone.txt';
        attachment.mimeTypeSubType = 'text/plain';
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
            // add an Text atatchment
            Messaging.InboundEmail.TextAttachment attachmenttext = new Messaging.InboundEmail.TextAttachment();
        attachmenttext.body = 'my attachment text';
        attachmenttext.fileName = 'textfiletwo3.txt';
        attachmenttext.mimeTypeSubType = 'texttwo/plain';
        email.textAttachments =   new Messaging.inboundEmail.TextAttachment[] { attachmenttext };
            PE_DWP_Correo_cls catcher = new PE_DWP_Correo_cls();
        catcher.handleInboundEmail(email, env);
        Test.stopTest();
    }
    @isTest static void testProcessReplyEmails_8(){   
        Test.startTest();
        Account cliente= new Account(Name='Ejemplo',
                                     main_code_id__c='12345678');
        Insert cliente;
        Opportunity opp= new Opportunity(name='Cuenta',
                                         AccountID = cliente.Id,Amount = 2000,
                                         CloseDAte=system.today(),
                                         stageName='01',
                                         opportunity_status_type__c='01',
                                         CurrencyIsoCode='USD'
                                        );
        insert opp;
        opp.stageName='04';
        opp.opportunity_status_type__c='08';
        update opp;
        Product2 p1 = new Product2(Name='Product Monthly 1111', Family='Monthly', isActive=true, CurrencyIsoCode='USD');
        Product2 p2 = new Product2(Name='Product Yearly 2222', Family='Yearly', isActive=true, CurrencyIsoCode='USD');
        insert new List<Product2>{p1, p2};
            Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry pbe1 = new PricebookEntry(Pricebook2id=pricebookId, Product2id=p1.ID, isActive=true, CurrencyIsoCode='USD', unitPrice=100);
        PricebookEntry pbe2 = new PricebookEntry(Pricebook2id=pricebookId, Product2id=p2.ID, isActive=true, CurrencyIsoCode='USD', unitPrice=50);
        insert pbe1;
        insert pbe2;
        System.debug('pbe1'+pbe1.Id);
        OpportunityLineItem oppLine = new OpportunityLineItem(pricebookentryid=pbe1.Id,TotalPrice=2000,Quantity = 1,OpportunityID = opp.Id,SioCode__c='123Xemo');
        insert oppLine;
        User u=[select Username, LastName, Email, Alias, CommunityNickname, TimeZoneSidKey, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey, FederationIdentifier from user where Username='ejecutivou2@u.com.u'];
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        email.subject = '123Xemo##13##Arsenio Perez Lopez##02/05/2011';
        email.fromAddress = 'comunicacion@p-1oflcjcwitlx140fa83tigxgbb3nmkavaczc81frgpisa8v1ih.29-8p7zeaa.cs19.apex.sandbox.salesforce.com';
        email.plainTextBody = 'Blah Blah Blah';        
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
        attachment.body = blob.valueOf('my attachment text');
        attachment.fileName = 'textfileone.txt';
        attachment.mimeTypeSubType = 'text/plain';
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
            // add an Text atatchment
            Messaging.InboundEmail.TextAttachment attachmenttext = new Messaging.InboundEmail.TextAttachment();
        attachmenttext.body = 'my attachment text';
        attachmenttext.fileName = 'textfiletwo3.txt';
        attachmenttext.mimeTypeSubType = 'texttwo/plain';
        email.textAttachments =   new Messaging.inboundEmail.TextAttachment[] { attachmenttext };
            PE_DWP_Correo_cls catcher = new PE_DWP_Correo_cls();
        catcher.handleInboundEmail(email, env);
        Test.stopTest();
    }    
}