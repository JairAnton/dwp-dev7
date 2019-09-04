/**
* ------------------------------------------------------------------------------------------------
* @Name Formalization_Helper_tst
* @Author Diego Carbajal diego.carbajal.contractor@bbva.com
* @Date Created: 2019-08-28
* @Group 
* @Description Esta clase prueba los metodos de la clase Formalization_helper
*/
@isTest
public class Formalization_Helper_tst {
    
    public static Final String positionExecutive = 'EJECUTIVO BEC';
    public static Final String positionAssist = 'ASISTENTE BEC';
    public static Final String btnApprove = 'btnApprove';
    public static Final String comments = 'Comentarios de envio a formalización';
    public static Final String isError = 'isError';
    public static Final String fail = 'Fail';
    public static Final String oppName = 'TEST Formalization';
    public static Final String formalization = 'Formalization';
    
    /* testSetup - initData */
    @testSetup
    public static void initData() {
        Final Dwp_FormalizationProducts_AAC__c[] prdAssistFormalization = new Dwp_FormalizationProducts_AAC__c[]{};
        Final Set<String> prdToFormalization = new Set<String>{'PC00012', 'PC00011', 'PC00001_Depre', 'PC00005', 'PC00009', 'PC00001'};
        for(String prd:prdToFormalization) {
            prdAssistFormalization.add(new Dwp_FormalizationProducts_AAC__c(Name=prd, Product_Code__c=prd));
        }
        insert prdAssistFormalization;
        Final User u = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId()];
        /*Crea Asistente Operativo*/
        Final String perfil=[SELECT Id FROM Profile WHERE name='Operativo'].Id;
        Map<Schema.SObjectField, Object> mapFields=new Map<Schema.SObjectField, Object>{User.ProfileId => perfil, User.prof_position_type__c => 'ASISTENTE BEC'/*, User.prof_position_id__c => 'E06'*/};
        User userAsistant=TestFactory.getUser(true, mapFields);
        userAsistant.prof_position_id__c = 'E06';
        update userAsistant;

        mapFields.put(User.prof_position_type__c, 'SUBGERENTE BEC');
        User userSgof=TestFactory.getUser(true, mapFields);
        userSgof.prof_position_id__c = 'E04';
        update userSgof;
        Final String perfilExecutive=[SELECT Id FROM Profile WHERE name='Ejecutivo'].Id;
        mapFields=new Map<Schema.SObjectField, Object>{User.ProfileId => perfilExecutive, User.prof_position_type__c => 'EJECUTIVO BEC', User.isActive => true};
        Final User userExecutive = TestFactory.getUser(true, mapFields);
        //Create Account's
        Account acc;
        System.runAs(u) { 
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
    	Final User ejecutivo = [SELECT ID FROM User WHERE prof_position_type__c=:positionExecutive limit 1];
        Final Opportunity opp = [SELECT ID FROM Opportunity WHERE Name =:oppName limit 1];
        String res;
        Test.startTest();
        System.runAs(ejecutivo) {
            res = Product_cls.setFormalization(opp.Id,btnApprove,comments,'');
        }
        Test.stopTest();
        Final Case[] lstCases = [SELECT Id, status FROM Case WHERE RecordType.Name=:formalization AND opportunity_id__c=:opp.Id];
        Final Integer lstCaseSize = lstCases.size();
        System.assertEquals(1, lstCaseSize, fail);
    }
    
    /* testSetup - createCaseAssistantSuccessTest */
    @isTest
    public static void createCaseAssistantSuccessTest() {
    	Final User ejecutivo = [SELECT ID FROM User WHERE prof_position_type__c=:positionExecutive limit 1];
        Final Opportunity opp = [SELECT ID FROM Opportunity WHERE Name =:oppName limit 1];
        String res;
        Test.startTest();
        System.runAs(ejecutivo) {
            res = Product_cls.setFormalization(opp.Id,btnApprove,comments,'');
        }
        Test.stopTest();
        Final Case[] lstCases = [SELECT Id, status FROM Case WHERE RecordType.Name=:formalization AND opportunity_id__c=:opp.Id];
        Final Integer lstCaseSize = lstCases.size();
        System.assertEquals(1, lstCaseSize, fail);
    }
    
    /* testSetup - sendProductUnitSuccessTest */
    @isTest
    public static void sendProductUnitSuccessTest() {      
        Final Opportunity opp = [SELECT Id FROM Opportunity WHERE Name =:oppName limit 1];
        Map<String, Object> mapRes;
        Test.startTest();
        mapRes = Formalization_helper.sendProductUnit(opp.Id);
        Test.stopTest();
        System.assertEquals(false, mapRes.get(isError), fail);
    }
    
    /* testSetup - sendProductUnitErrorTest */
    @isTest
    public static void sendProductUnitErrorTest() {
        Final Id nullId;
        Map<String, Object> mapRes;
        Test.startTest();
        mapRes = Formalization_helper.sendProductUnit(nullId);
        Test.stopTest();
        System.assertEquals(true, mapRes.get(isError), fail);
    }
    
    /* testSetup - reasignCaseAssistantTest */
    @isTest
    public static void reasignCaseAssistantTest() {
        Final User ejecutivo = [SELECT ID FROM User WHERE prof_position_type__c=:positionExecutive limit 1];
        Final Opportunity opp = [SELECT ID FROM Opportunity WHERE Name =:oppName limit 1];
        System.runAs(ejecutivo) {
            Product_cls.setFormalization(opp.Id,btnApprove,comments,'');
        }
        Final User asistente = [SELECT ID, Name FROM User WHERE prof_position_type__c=:positionAssist limit 1];
        Final Case caso = [SELECT ID FROM Case WHERE opportunity_id__c=:opp.Id limit 1];
        Map<String, Object> mapRes = new Map<String, Object>();
        System.runAs(asistente) {
            mapRes = Formalization_helper.reasignCase(caso.Id);
        }
        System.assertEquals(false, mapRes.get(isError), fail);
    }
    
    /* testSetup - reasignCaseSgofTest */
    @isTest
    public static void reasignCaseSgofTest() {
        Final User ejecutivo = [SELECT ID FROM User WHERE prof_position_type__c=:positionExecutive limit 1];
        Final Opportunity opp = [SELECT ID FROM Opportunity WHERE Name = 'TEST Formalization 2' limit 1];
        System.runAs(ejecutivo) {
            Product_cls.setFormalization(opp.Id,btnApprove,comments,'');
        }
        setFormalizationGroupSubgerente();
        Final User subgerente = [SELECT ID, Name FROM User WHERE prof_position_type__c='SUBGERENTE BEC' limit 1];
        Final Case caso = [SELECT ID FROM Case WHERE opportunity_id__c=:opp.Id limit 1];
        Map<String, Object> mapRes = new Map<String, Object>();
        System.runAs(subgerente) {
            mapRes = Formalization_helper.reasignCase(caso.Id);
        }
        System.assertEquals(false, mapRes.get(isError), fail);
    }
    
    /* testSetup - condition6SuccessTest */
    @isTest
    public static void condition6SuccessTest() {
        Map<String, Object> mapRes = new Map<String, Object>();
        Final User ejecutivo = [SELECT ID FROM User WHERE prof_position_type__c=:positionExecutive limit 1];
        Final Opportunity opp = [SELECT ID FROM Opportunity WHERE Name =:oppName limit 1];
        System.runAs(ejecutivo) {
            Product_cls.setFormalization(opp.Id,btnApprove,comments,'');
        }
        Final User asistente = [SELECT ID, Name FROM User WHERE prof_position_type__c=:positionAssist limit 1];
        delete [SELECT Id, Group.DeveloperName FROM GroupMember WHERE UserOrGroupId=:asistente.id];
        Final Case caso = [SELECT Id FROM Case WHERE RecordType.DeveloperName =:formalization];
        Boolean validate;
        Test.startTest();
        System.runAs(asistente) {
            validate = PrincipalValidationHub.Condition6(caso.id);
        }
        Test.stopTest();
        System.assertEquals(true, validate, 'Fail assertion');
    }
    
    /* testSetup - condition6ErrorTest */
    @isTest
    public static void condition6ErrorTest() {
        Map<String, Object> mapRes = new Map<String, Object>();
        Final User ejecutivo = [SELECT ID FROM User WHERE prof_position_type__c=:positionExecutive limit 1];
        Final Opportunity opp = [SELECT ID FROM Opportunity WHERE Name = 'TEST Formalization 2' limit 1];
        System.runAs(ejecutivo) {
            Product_cls.setFormalization(opp.Id,btnApprove,comments,'');
        }
        Final User asistente = [SELECT ID, Name FROM User WHERE prof_position_type__c=:positionAssist limit 1];
        Final Case caso = [SELECT Id FROM Case WHERE RecordType.DeveloperName =:formalization];
        Boolean validate;
        Test.startTest();
        System.runAs(asistente) {
            validate = PrincipalValidationHub.Condition6(caso.id);
        }
        Test.stopTest();
        System.assertEquals(false, validate, 'Fail assertion');
    }
    
    /* testSetup - condition7SuccessTest */
    @isTest
    public static void condition7SuccessTest() {
        Map<String, Object> mapRes = new Map<String, Object>();
        Final User ejecutivo = [SELECT ID FROM User WHERE prof_position_type__c=:positionExecutive limit 1];
        Final Opportunity opp = [SELECT ID FROM Opportunity WHERE Name =:oppName limit 1];
        System.runAs(ejecutivo) {
            Product_cls.setFormalization(opp.Id,btnApprove,comments,'');
        }
        Final User asistente = [SELECT ID, Name FROM User WHERE prof_position_type__c=:positionAssist limit 1];
        delete [SELECT Id, Group.DeveloperName FROM GroupMember WHERE UserOrGroupId=:asistente.id];
        Final Case caso = [SELECT Id FROM Case WHERE RecordType.DeveloperName =:formalization];
        Boolean validate;
        Test.startTest();
        System.runAs(asistente) {
            validate = PrincipalValidationHub.Condition7(caso.id);
        }
        Test.stopTest();
        System.assertEquals(true, validate, 'Fail assertion');
    }
    
    /* testSetup - condition7ErrorTest */
    @isTest
    public static void condition7ErrorTest() {
        Map<String, Object> mapRes = new Map<String, Object>();
        Final User ejecutivo = [SELECT ID FROM User WHERE prof_position_type__c=:positionExecutive limit 1];
        Final Opportunity opp = [SELECT ID FROM Opportunity WHERE Name =:oppName limit 1];
        System.runAs(ejecutivo) {
            Product_cls.setFormalization(opp.Id,btnApprove,comments,'');
        }
        Final User asistente = [SELECT ID, Name FROM User WHERE prof_position_type__c=:positionAssist limit 1];
        Final Case caso = [SELECT Id FROM Case WHERE RecordType.DeveloperName =:formalization];
        Boolean validate;
        Test.startTest();
        System.runAs(asistente) {
            validate = PrincipalValidationHub.Condition7(caso.id);
        }
        Test.stopTest();
        System.assertEquals(false, validate, 'Fail assertion');
    }
    
    /* setFormalizationGroupAssistant */
    public static void setFormalizationGroupAssistant() {
        Final Group grupo = [SELECT ID, developerName FROM Group WHERE DeveloperName IN ('Asistentes_Operativos') limit 1];
        Final User asistente = [SELECT ID, Name FROM User WHERE prof_position_type__c=:positionAssist limit 1];
        insert new GroupMember(GroupId=grupo.Id, UserOrGroupId=asistente.Id);
    }
    
    /* setFormalizationGroupSubgerente */
    public static void setFormalizationGroupSubgerente() {
        Final Group grupo = [SELECT ID, developerName FROM Group WHERE DeveloperName IN ('Subgerentes_Operativos') limit 1];
        Final User subgerente = [SELECT ID FROM User WHERE prof_position_type__c='SUBGERENTE BEC' limit 1];
        insert new GroupMember(GroupId=grupo.Id, UserOrGroupId=subgerente.Id);
    }
    
    
}