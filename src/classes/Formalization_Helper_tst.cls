/*
------------------------------------------------------------------------------------------------
@Name Formalization_Helper_tst
@Author Diego Carbajal diego.carbajal.contractor@bbva.com
@Date Created: 2019-08-28
@Group 
@Description Esta clase prueba los metodos de la clase Formalization_helper
*/
@isTest
public class Formalization_Helper_tst {
    
    /*Campo POSITION_EXE inicializado para soluciones del SonarQ*/
    public static Final String POSITION_EXE = 'EJECUTIVO BEC';
    /*Campo POSITION_ASSI inicializado para soluciones del SonarQ*/
    public static Final String POSITION_ASSI = 'ASISTENTE BEC';
    /*Campo BTN_APPROVE inicializado para soluciones del SonarQ*/
    public static Final String BTN_APPROVE = 'btnApprove';
    /*Campo COMMENTS inicializado para soluciones del SonarQ*/
    public static Final String COMMENTS = 'Comentarios';
    /*Campo IS_ERROR inicializado para soluciones del SonarQ*/
    public static Final String IS_ERROR = 'isError';
    /*Campo FAIL inicializado para soluciones del SonarQ*/
    public static Final String FAIL = 'Fail';
    /*Campo OPP_NAME inicializado para soluciones del SonarQ*/
    public static Final String OPP_NAME = 'TEST Formalization';
    /*Campo FORMALIZATION inicializado para soluciones del SonarQ*/
    public static Final String FORMALIZATION = 'Formalization';
    
    /* testSetup - initData */
    @testSetup
    public static void initData() {
        Final Dwp_FormalizationProducts_AAC__c[] prdAssistForm = new Dwp_FormalizationProducts_AAC__c[]{};
        Final Set<String> prdToForm = new Set<String>{'PC00012', 'PC00011', 'PC00001_Depre', 'PC00005', 'PC00009', 'PC00001'};
        for(String prd:prdToForm) {
            prdAssistForm.add(new Dwp_FormalizationProducts_AAC__c(Name=prd, Product_Code__c=prd));
        }
        insert prdAssistForm;
        Final User admin = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId()];
        /*Crea Asistente Operativo*/
        Final String perfil=[SELECT Id FROM Profile WHERE name='Operativo'].Id;
        Map<Schema.SObjectField, Object> mapFields=new Map<Schema.SObjectField, Object>{User.ProfileId => perfil, User.prof_position_type__c => 'ASISTENTE BEC', User.prof_position_id__c => 'E06'};
        User userAsistant=TestFactory.getUser(true, mapFields);
        mapFields.put(User.prof_position_type__c, 'SUBGERENTE BEC');
        mapFields.put(User.prof_position_id__c, 'E04');
        User userSgof=TestFactory.getUser(true, mapFields);
        Final String perfilExecutive=[SELECT Id FROM Profile WHERE name='Ejecutivo'].Id;
        mapFields=new Map<Schema.SObjectField, Object>{User.ProfileId => perfilExecutive, User.prof_position_type__c => 'EJECUTIVO BEC'};
        Final User userExecutive = TestFactory.getUser(true, mapFields);
        //Create Account's
        Account acc;
        System.runAs(admin) { 
            mapFields=new Map<Schema.SObjectField, Object>{Account.OwnerId => userExecutive.Id, Account.Name => 'CLIENTE OPORTUNIDAD'};
             acc = TestFactory.getAccount(true, mapFields);
            
            //Crear Oportunidad con Producto - 1
            Final Opportunity testOP= new Opportunity(Name='TEST Formalization', stageName='02', AccountId=acc.Id, CloseDate=Date.today(), Amount = 10000, OwnerId = userExecutive.Id);
            insert testOP;
            //Opp 2
            Final Opportunity testOP2= new Opportunity(Name='TEST Formalization 2', stageName='02', AccountId=acc.Id, CloseDate=Date.today(), Amount = 10000, OwnerId = userExecutive.Id);
            insert testOP2;
            
            Final Product2 testPr = new Product2(Name='TestProd', type_of_quote__c='COTIZADOR', ProductCode='PC00012');
            insert testPr;
            //product 2
            Final Product2 testPr2 = new Product2(Name='TestProd', type_of_quote__c='COTIZADOR');
            insert testPr2;
            
            Final Pricebook2 testPB = new Pricebook2(CurrencyIsoCode='PEN', Name='MyPrice');
            insert testPB;
            Final Id pricebookId = Test.getStandardPricebookId();
    
            Final PricebookEntry testPE = new PricebookEntry(UnitPrice=120, CurrencyIsoCode='PEN', Pricebook2Id=pricebookId, Product2Id=testPr.Id, IsActive=true);
            insert testPE;
            
            Final PricebookEntry testPE2 = new PricebookEntry(UnitPrice=120, CurrencyIsoCode='PEN', Pricebook2Id=pricebookId, Product2Id=testPr2.Id, IsActive=true);
            insert testPE2;
            
            Final OpportunityLineItem testLOPP = new OpportunityLineItem(TotalPrice=120, OpportunityId=testOP.Id, PricebookEntryId=testPE.Id, Quantity=1, gipr_Tipo_Garantia__c='03', 
                                                                  Product2Id=testPr.Id);
            insert testLOPP;
            
            Final OpportunityLineItem testLOPP2 = new OpportunityLineItem(TotalPrice=120, OpportunityId=testOP2.Id, PricebookEntryId=testPE2.Id, Quantity=1, gipr_Tipo_Garantia__c='03', 
                                                                  Product2Id=testPr2.Id);
            insert testLOPP2;
        }
    }
    
    /* testSetup - createCaseSgofSuccessTest */
    @isTest
    public static void createCaseSgofSuccessTest() {
        Final User ejecutivo = [SELECT ID, isActive FROM User WHERE prof_position_type__c=:POSITION_EXE AND isActive=True limit 1];
        Final Opportunity opp = [SELECT ID FROM Opportunity WHERE Name =:OPP_NAME limit 1];
        Test.startTest();
        System.runAs(ejecutivo) {
            Product_cls.setFormalization(opp.Id,BTN_APPROVE,COMMENTS,'');
        }
        Test.stopTest();
        Final Case[] lstCases = [SELECT Id, status FROM Case WHERE RecordType.Name=:FORMALIZATION AND opportunity_id__c=:opp.Id];
        Final Integer lstCaseSize = lstCases.size();
        Final Boolean assertion = lstCaseSize == 1 ? true : false;
        System.assert(assertion, FAIL);
    }
    
    /* testSetup - createCaseAssistantSuccessTest */
    @isTest
    public static void createCaseAssistantSuccessTest() {
        Final User ejecutivo = [SELECT ID, isActive FROM User WHERE prof_position_type__c=:POSITION_EXE AND isActive=True limit 1];
        Final Opportunity opp = [SELECT ID FROM Opportunity WHERE Name =:OPP_NAME limit 1];
        Test.startTest();
        System.runAs(ejecutivo) {
            Product_cls.setFormalization(opp.Id,BTN_APPROVE,COMMENTS,'');
        }
        Test.stopTest();
        Final Case[] lstCases = [SELECT Id, status FROM Case WHERE RecordType.Name=:FORMALIZATION AND opportunity_id__c=:opp.Id];
        Final Integer lstCaseSize = lstCases.size();
        Final Boolean assertion = lstCaseSize == 1 ? true : false;
        System.assert(assertion, FAIL);
    }
    
    /* testSetup - sendProductUnitSuccessTest */
    @isTest
    public static void sendProductUnitSuccessTest() {      
        Final Opportunity opp = [SELECT Id FROM Opportunity WHERE Name =:OPP_NAME limit 1];
        Map<String, Object> mapRes;
        Test.startTest();
        mapRes = Formalization_helper.sendProductUnit(opp.Id);
        Test.stopTest();
        Final Boolean assertion = (Boolean)mapRes.get(IS_ERROR) ? false : true;
        System.assert(assertion, FAIL);
    }
    
    /* testSetup - sendProductUnitErrorTest */
    @isTest
    public static void sendProductUnitErrorTest() {
        Id nullId;
        Map<String, Object> mapRes;
        Test.startTest();
        mapRes = Formalization_helper.sendProductUnit(nullId);
        Test.stopTest();
        Final Boolean assertion = (Boolean)mapRes.get(IS_ERROR) ? true : false;
        System.assert(assertion, FAIL);
    }
    
    /* testSetup - reasignCaseAssistantTest */
    @isTest
    public static void reasignCaseAssistantTest() {
        Final User ejecutivo = [SELECT ID, isActive FROM User WHERE prof_position_type__c=:POSITION_EXE AND isActive=True limit 1];
        Final User asistente = [SELECT ID, isActive, Name FROM User WHERE prof_position_type__c=:POSITION_ASSI AND isActive=True limit 1];
        Final Opportunity opp = [SELECT ID FROM Opportunity WHERE Name =:OPP_NAME limit 1];
        System.runAs(ejecutivo) {
            Product_cls.setFormalization(opp.Id,BTN_APPROVE,COMMENTS,'');
        }
        Final Case caso = [SELECT ID FROM Case WHERE opportunity_id__c=:opp.Id limit 1];
        Map<String, Object> mapRes = new Map<String, Object>();
        System.runAs(asistente) {
            mapRes = Formalization_helper.reasignCase(caso.Id);
        }
        Final Boolean assertion = (Boolean)mapRes.get(IS_ERROR) ? false : true;
        System.assert(assertion, FAIL);
    }
    
    /* testSetup - reasignCaseSgofTest */
    @isTest
    public static void reasignCaseSgofTest() {
        Final User ejecutivo = [SELECT ID, isActive FROM User WHERE prof_position_type__c=:POSITION_EXE AND isActive=True limit 1];
        Final User subgerente = [SELECT ID, isActive, Name FROM User WHERE prof_position_type__c='SUBGERENTE BEC' AND isActive=True limit 1];
        Final Opportunity opp = [SELECT ID FROM Opportunity WHERE Name = 'TEST Formalization 2' limit 1];
        System.runAs(ejecutivo) {
            Product_cls.setFormalization(opp.Id,BTN_APPROVE,COMMENTS,'');
        }
        Final Case caso = [SELECT ID FROM Case WHERE opportunity_id__c=:opp.Id limit 1];
        Map<String, Object> mapRes = new Map<String, Object>();
        System.runAs(subgerente) {
            mapRes = Formalization_helper.reasignCase(caso.Id);
        }
        Final Boolean assertion = (Boolean)mapRes.get(IS_ERROR) ? false : true;
        System.assert(assertion, FAIL);
    }
    
    /* testSetup - condition6SuccessTest */
    @isTest
    public static void condition6SuccessTest() {
        Final User ejecutivo = [SELECT ID, isActive FROM User WHERE prof_position_type__c=:POSITION_EXE AND isActive=True limit 1];
        Final User asistente = [SELECT ID, isActive, Name FROM User WHERE prof_position_type__c=:POSITION_ASSI AND isActive=True limit 1];
        Final Opportunity opp = [SELECT ID FROM Opportunity WHERE Name =:OPP_NAME limit 1];
        System.runAs(ejecutivo) {
            Product_cls.setFormalization(opp.Id,BTN_APPROVE,COMMENTS,'');
        }
        delete [SELECT Id, Group.DeveloperName FROM GroupMember WHERE UserOrGroupId=:asistente.id];
        Final Case caso = [SELECT Id FROM Case WHERE RecordType.DeveloperName =:FORMALIZATION];
        Boolean validate;
        Test.startTest();
        System.runAs(asistente) {
            validate = PrincipalValidationHub.condition6(caso.id);
        }
        Test.stopTest();
        System.assert(validate, FAIL);
    }
    
    /* testSetup - condition6ErrorTest */
    @isTest
    public static void condition6ErrorTest() {
        Final User ejecutivo = [SELECT ID, isActive FROM User WHERE prof_position_type__c=:POSITION_EXE AND isActive=True limit 1];
        Final User asistente = [SELECT ID, isActive, Name FROM User WHERE prof_position_type__c=:POSITION_ASSI AND isActive=True limit 1];
        Final Opportunity opp = [SELECT ID FROM Opportunity WHERE Name = 'TEST Formalization 2' limit 1];
        System.runAs(ejecutivo) {
            Product_cls.setFormalization(opp.Id,BTN_APPROVE,COMMENTS,'');
        }
        Final Case caso = [SELECT Id FROM Case WHERE RecordType.DeveloperName =:FORMALIZATION];
        Boolean validate;
        Test.startTest();
        System.runAs(asistente) {
            validate = PrincipalValidationHub.Condition6(caso.id);
        }
        Test.stopTest();
        validate = validate ? false : true;
        System.assert(validate, FAIL);
    }
    
    /* testSetup - condition7SuccessTest */
    @isTest
    public static void condition7SuccessTest() {
        Final User ejecutivo = [SELECT ID, isActive FROM User WHERE prof_position_type__c=:POSITION_EXE AND isActive=True limit 1];
        Final User asistente = [SELECT ID, isActive, Name FROM User WHERE prof_position_type__c=:POSITION_ASSI AND isActive=True limit 1];
        Final Opportunity opp = [SELECT ID FROM Opportunity WHERE Name =:OPP_NAME limit 1];
        System.runAs(ejecutivo) {
            Product_cls.setFormalization(opp.Id,BTN_APPROVE,COMMENTS,'');
        }
        delete [SELECT Id, Group.DeveloperName FROM GroupMember WHERE UserOrGroupId=:asistente.id];
        Final Case caso = [SELECT Id FROM Case WHERE RecordType.DeveloperName =:FORMALIZATION];
        Boolean validate;
        Test.startTest();
        System.runAs(asistente) {
            validate = PrincipalValidationHub.condition7(caso.id);
        }
        Test.stopTest();
        System.assert(validate, FAIL);
    }
    
    /* testSetup - condition7ErrorTest */
    @isTest
    public static void condition7ErrorTest() {
        Final User ejecutivo = [SELECT ID, isActive FROM User WHERE prof_position_type__c=:POSITION_EXE AND isActive=True limit 1];
        Final User asistente = [SELECT ID, isActive, Name FROM User WHERE prof_position_type__c=:POSITION_ASSI AND isActive=True limit 1];
        Final Opportunity opp = [SELECT ID FROM Opportunity WHERE Name =:OPP_NAME limit 1];
        System.runAs(ejecutivo) {
            Product_cls.setFormalization(opp.Id,BTN_APPROVE,COMMENTS,'');
        }
        Final Case caso = [SELECT Id FROM Case WHERE RecordType.DeveloperName =:FORMALIZATION];
        Boolean validate;
        Test.startTest();
        System.runAs(asistente) {
            validate = PrincipalValidationHub.condition7(caso.id);
        }
        Test.stopTest();
        validate = validate ? false : true;
        System.assert(validate, FAIL);
    }
    
}