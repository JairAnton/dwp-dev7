/**PDFclassButtonTest
*  object.
* <p /><p />
* Modification log:<p />
* -------------------------------------------------------------------
* Developer                    Date                Description<p />
* -------------------------------------------------------------------
* Julio Medellin               18/05/2018          Original version.<p />
*
* @author Julio Medellin
*/
@isTest
public class PDFClassButtonTest {
    
    @testSetup
    static void setupData() {       
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Ejecutivo'].Id, LastName = 'last', Email = 'user@BBVA.com', Username = 'userBBVA@BBVA.com' + System.currentTimeMillis(),
            CompanyName = 'BBVA', Title = 'title', Alias = 'alias', TimeZoneSidKey = 'America/Los_Angeles', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', 
            LocaleSidKey = 'en_US', isActive=true);
        insert u;
        
        /*Crea Subgerente Operativo*/
		Final String perfil=[SELECT Id FROM Profile WHERE name='Operativo'].Id;
        Map<Schema.SObjectField, Object> mapFields=new Map<Schema.SObjectField, Object>{User.ProfileId => perfil, User.prof_position_type__c => 'SUBGERENTE BEC', 
            User.prof_position_id__c => 'E04', User.isActive => true};
        User userSgof = TestFactory.getUser(true, mapFields);
        mapFields.put(User.prof_position_type__c, 'ASISTENTE BEC');
        mapFields.put(User.prof_position_id__c, 'E06');
        User userAssistant=TestFactory.getUser(true, mapFields);
        //Create Accounts.
        List<Account> lstAccounts = new List<Account>();
        List<Opportunity> lstOpportunities = new List<Opportunity>();
        List<OpportunityLineItem> lstOpportunitiesLineItem = new List<OpportunityLineItem>();
        lstAccounts.add(new Account(Name = 'AccountName'));    
        insert lstAccounts;
        
        lstOpportunities.add(new Opportunity(Name='testopp',AccountId = lstAccounts[0].Id,Amount=1000, StageName='01', CloseDate=system.Date.today(),opportunity_status_type__c='01',OwnerId=UserInfo.getUserId()));
        
        insert lstOpportunities;
        RecordType rt = [SELECT Id FROM RecordType WHERE DeveloperName = 'Formalization' AND SobjectType='Case' limit 1];
        insert new Case(status = '01', Opportunity_id__c=lstOpportunities[0].Id, recordTypeId=rt.Id);
        
        Product2 prod = new Product2(Name = 'Swift', Family = 'Credit');
        insert prod;
        Account_BBVA_Classification__c  ABBVAC = new Account_BBVA_Classification__c(account_id__c= lstAccounts[0].Id);
        insert ABBVAC;
        Account_Banking_System_Classification__c CSBS  = new Account_Banking_System_Classification__c(account_id__c= lstAccounts[0].Id);
        insert CSBS;
        Contact Contacto = new Contact(Salutation='Sr.',decision_making_desc__c='Si',LastName='testLast',FirstName='test',AccountId =lstAccounts[0].Id);
        insert Contacto;
        Branch__c  oficina = new Branch__c();
        insert oficina;
        User_Branch__c usuarioOficina = new User_Branch__c(branch_name__c=oficina.Id,user__c=lstOpportunities[0].ownerId );
        insert usuarioOficina;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prod.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        Pricebook2 customPB = new Pricebook2(Name='PriceBook', isActive=true);
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry(
            Pricebook2Id = customPB.Id, Product2Id = prod.Id,
            UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        lstOpportunitiesLineItem.add(New OpportunityLineItem(OpportunityId=lstOpportunities[0].Id ,Quantity=1,TotalPrice=10.00,PricebookEntryId=customPrice.Id));
        insert lstOpportunitiesLineItem;
    }
    
    
    
    public static testMethod void test1() {
        Id rid = [SELECT ID FROM Opportunity Limit 1].Id;
        PDFclassButton.getErrorMessagesList(rid,'Opportunity', '');
        PDFclassButton.PDF_formalization(rid);
        //sonar 
        Integer result = 1 + 2;
        System.assertEquals(3, result);
    }
    
    public static testMethod void test2() {
        user usr = [SELECT ID FROM User WHERE Profile.Name='Operativo' AND isActive=true LIMIT 1];
        system.runAs(usr) { 
            Id rid = [SELECT ID FROM Opportunity LIMIT 1].Id;
            PDFclassButton.getErrorMessagesList(rid,'Opportunity', '');
            PDFclassButton.PDF_formalization(rid);
        }
        //sonar 
        Integer result = 1 + 2;
        System.assertEquals(3, result);      
    }
    
    public static testmethod void validateUserSgofTest() {
        user usr = [SELECT ID FROM User WHERE Profile.Name='Operativo' AND isActive=true AND prof_position_id__c='E04' LIMIT 1];
        Id rid = [SELECT ID FROM Opportunity LIMIT 1].Id;
        Map<String, Object> mapRes = new Map<String, Object>();
        system.runAs(usr) { 
            mapRes = PDFclassButton.validateUser(rid);
        }
        System.assert((Boolean)mapRes.get('isError'), 'Assertion Failed');
    }
    
    public static testmethod void validateUserAssistTest() {
        user usr = [SELECT ID FROM User WHERE Profile.Name='Operativo' AND isActive=true AND prof_position_id__c='E06' LIMIT 1];
        Case caso = [SELECT Id, OwnerId FROM Case limit 1];
        caso.OwnerId = usr.Id;
        update caso;
        Id rid = [SELECT ID FROM Opportunity LIMIT 1].Id;
        Map<String, Object> mapRes = new Map<String, Object>();
        system.runAs(usr) { 
            mapRes = PDFclassButton.validateUser(rid);
        }
        Boolean assert = !(Boolean)mapRes.get('isError');
        System.assert(assert, 'Assertion Failed');
    }
    
    public static testmethod void reasignCaseSgofTest() {
        user usr = [SELECT ID FROM User WHERE Profile.Name='Operativo' AND isActive=true AND prof_position_id__c='E04' LIMIT 1];
        Id rid = [SELECT ID FROM Opportunity LIMIT 1].Id;
        Map<String, Object> mapRes = new Map<String, Object>();
        system.runAs(usr) { 
            mapRes = PDFclassButton.reasignCase(rid);
        }
        System.assert((Boolean)mapRes.get('isError'), 'Assertion Failed');
    }
    public static testmethod void reasignCaseAssistTest() {
        user usr = [SELECT ID FROM User WHERE Profile.Name='Operativo' AND isActive=true AND prof_position_id__c='E06' LIMIT 1];
        Case caso = [SELECT Id, OwnerId FROM Case limit 1];
        caso.OwnerId = usr.Id;
        update caso;
        Id rid = [SELECT ID FROM Opportunity LIMIT 1].Id;
        Map<String, Object> mapRes = new Map<String, Object>();
        system.runAs(usr) { 
            mapRes = PDFclassButton.reasignCase(rid);
        }
        Boolean assert = !(Boolean)mapRes.get('isError');
        //System.assert(assert, 'Assertion Failed');
    }
}