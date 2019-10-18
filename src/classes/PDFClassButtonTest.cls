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
    
    static Final String IS_ERROR = 'isError';
    
    /**
     * Test Setup()
	*/
    @testSetup
    static void setupData() {       
        insert new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Ejecutivo'].Id, LastName = 'last', Email = 'user@BBVA.com', Username = 'userBBVA@BBVA.com' + System.currentTimeMillis(),
            CompanyName = 'BBVA', Title = 'title', Alias = 'alias', TimeZoneSidKey = 'America/Los_Angeles', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', 
            LocaleSidKey = 'en_US', isActive=true);
        
        /*Crea Subgerente Operativo*/
		Final String perfil=[SELECT Id FROM Profile WHERE name='Operativo'].Id;
        Map<Schema.SObjectField, Object> mapFields=new Map<Schema.SObjectField, Object>{User.ProfileId => perfil, User.prof_position_type__c => 'SUBGERENTE BEC', 
            User.prof_position_id__c => 'E04', User.isActive => true};
        //userSgof
        TestFactory.getUser(true, mapFields);
        mapFields.put(User.prof_position_type__c, 'ASISTENTE BEC');
        mapFields.put(User.prof_position_id__c, 'E06');
        //userAssistant
        TestFactory.getUser(true, mapFields);
        //Create Accounts.
        Final Account acc = new Account(Name = 'AccountName');    
        insert acc;
        Final Opportunity oppTmp = new Opportunity(Name='testopp',AccountId = acc.Id,Amount=1000, StageName='01', CloseDate=system.Date.today(),opportunity_status_type__c='01',OwnerId=UserInfo.getUserId());
		insert oppTmp;
        
        Final RecordType rtype = [SELECT Id FROM RecordType WHERE DeveloperName = 'Formalization' AND SobjectType='Case' limit 1];
        insert new Case(status = '01', Opportunity_id__c=oppTmp.Id, recordTypeId=rtype.Id);
        
        Final Product2 prod = new Product2(Name = 'Swift', Family = 'Credit');
        insert prod;
        insert new Account_BBVA_Classification__c(account_id__c= acc.Id);
        insert new Account_Banking_System_Classification__c(account_id__c= acc.Id);
        insert new Contact(Salutation='Sr.',decision_making_desc__c='Si',LastName='testLast',FirstName='test',AccountId =acc.Id);
        Branch__c oficina = new Branch__c();
        insert oficina;
        insert new User_Branch__c(branch_name__c=oficina.Id,user__c=oppTmp.ownerId );
        
        Final Id pricebookId = Test.getStandardPricebookId();
        
        insert new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
        
        Final Pricebook2 customPB = new Pricebook2(Name='PriceBook', isActive=true);
        insert customPB;
        
        Final PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        insert new OpportunityLineItem(OpportunityId=oppTmp.Id ,Quantity=1,TotalPrice=10.00,PricebookEntryId=customPrice.Id);
    }
    
    /**
     * Test PDFclassButton.getErrorMessagesList
	*/
    public static testMethod void test1() {
        Final Id rid = [SELECT ID FROM Opportunity Limit 1].Id;
        List<String> result;
        Test.startTest();
        result = PDFclassButton.getErrorMessagesList(rid,'Opportunity', '');
        Test.stopTest();
        Final String assertion = UserInfo.getLanguage() == 'Spanish' ? 'No puede generar PDF en esta etapa' : 'You can not create a PDF on this stage';
        System.assertEquals(assertion, result[0], 'Assertion Error');
    }
    
    /**
     * Test PDFclassButton.PDF_formalization
	*/
    public static testMethod void test2() {
        Final user usr = [SELECT ID FROM User WHERE Profile.Name='Operativo' AND isActive=true LIMIT 1];
        String result;
        system.runAs(usr) { 
            Final Id rid = [SELECT ID FROM Opportunity LIMIT 1].Id;
            result = PDFclassButton.PDF_formalization(rid);
        }
        System.assertEquals('SUCCESS', result, 'Error Assertion');      
    }
    
    /**
     * Test PDFclassButton.getErrorMessagesList ERROR
	*/
    public static testMethod void test3() {
        Final Id rId;
        List<String> result;
        Test.startTest();
        result = PDFclassButton.getErrorMessagesList(rId,'Opportunity', '');
        Test.stopTest();
        Final String assertion = UserInfo.getLanguage() == 'Spanish' ? 'EL PDF contiene datos incorrectos favor de verificar que toda la informacion viene correcta' : 
        'Unable to create PDF, please make sure that all information is complete';
        System.assertEquals(assertion, result[0], 'Assertion Error');
    }
    
    /**
     * Test validateUserSgofTest
	*/
    public static testmethod void validateUserSgofTest() {
        Final user usr = [SELECT ID FROM User WHERE Profile.Name='Operativo' AND isActive=true AND prof_position_id__c='E04' LIMIT 1];
        Final Id rid = [SELECT ID FROM Opportunity LIMIT 1].Id;
        Map<String, Object> mapRes = new Map<String, Object>();
        system.runAs(usr) { 
            mapRes = PDFclassButton.validateUser(rid);
        }
        System.assert((Boolean)mapRes.get(IS_ERROR), 'Assertion Failed');
    }
    
    /**
     * Test validateUserAssistTest
	*/
    public static testmethod void validateUserAssistTest() {
        Final user usr = [SELECT ID FROM User WHERE Profile.Name='Operativo' AND isActive=true AND prof_position_id__c='E06' LIMIT 1];
        Case caso = [SELECT Id, OwnerId FROM Case limit 1];
        caso.OwnerId = usr.Id;
        update caso;
        Final Id rid = [SELECT ID FROM Opportunity LIMIT 1].Id;
        Map<String, Object> mapRes = new Map<String, Object>();
        system.runAs(usr) { 
            mapRes = PDFclassButton.validateUser(rid);
        }
        Final Boolean assert = !(Boolean)mapRes.get(IS_ERROR);
        System.assert(assert, 'Assertion Failed');
    }
    
    /**
     * Test reasignCaseSgofTest
	*/
    public static testmethod void reasignCaseSgofTest() {
        Final user usr = [SELECT ID FROM User WHERE Profile.Name='Operativo' AND isActive=true AND prof_position_id__c='E04' LIMIT 1];
        Final Id rid = [SELECT ID FROM Opportunity LIMIT 1].Id;
        Map<String, Object> mapRes = new Map<String, Object>();
        system.runAs(usr) { 
            mapRes = PDFclassButton.reasignCase(rid);
        }
        System.assert((Boolean)mapRes.get(IS_ERROR), 'Assertion Failed');
    }
    
    /**
     * Test reasignCaseAssistTest
	*/
    public static testmethod void reasignCaseAssistTest() {
        Final user usr = [SELECT ID FROM User WHERE Profile.Name='Operativo' AND isActive=true AND prof_position_id__c='E06' LIMIT 1];
        System.debug('Casos => '+[SELECT Id FROM Case]);
        Case caso = [SELECT Id, OwnerId FROM Case limit 1];
        caso.OwnerId = usr.Id;
        update caso;
        Final Id rid = [SELECT ID FROM Opportunity LIMIT 1].Id;
        Map<String, Object> mapRes = new Map<String, Object>();
        system.runAs(usr) { 
            mapRes = PDFclassButton.reasignCase(rid);
        }
        Final Boolean assert = !(Boolean)mapRes.get(IS_ERROR);
        //Boolean assert = (Boolean)mapRes.get(IS_ERROR);
        System.assert(assert, 'Assertion Failed');
    }
}