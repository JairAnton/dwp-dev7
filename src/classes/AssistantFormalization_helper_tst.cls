/**
* ------------------------------------------------------------------------------------------------
* @Name AssistantFormalization_helper_tst
* @Author Diego Carbajal diego.carbajal.contractor@bbva.com
* @Date Created: 2019-08-28
* @Group 
* @Description Esta clase prueba los metodos de la clase AssistantFormalization_helper y Formalization_helper
*/
@isTest
public class AssistantFormalization_helper_tst {
    
    public static Final String positionExecutive = 'EJECUTIVO BEC';
    public static Final String positionAssist = 'ASISTENTE BEC';
    public static Final String btnApprove = 'btnApprove';
    public static Final String comments = 'Comentarios de envio a formalización';
    public static Final String isError = 'isError';
    public static Final String fail = 'Fail';
    public static Final String oppName = 'TEST Formalization';

    /* testSetup - initData */
    @testSetup
    public static void initData() {
        Final Dwp_FormalizationProducts_AAC__c[] prdAssistFormalization = new Dwp_FormalizationProducts_AAC__c[]{};
        Final Set<String> prdToFormalization = new Set<String>{'PC00012', 'PC00011', 'PC00001_Depre', 'PC00005', 'PC00009', 'PC00001'};
        for(String prd:prdToFormalization){
            prdAssistFormalization.add(new Dwp_FormalizationProducts_AAC__c(Name=prd, Product_Code__c=prd));
        }
        insert prdAssistFormalization;
        Final User u = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId()];
        /*Crea Asistente Operativo*/
        Final String perfil=[SELECT Id FROM Profile WHERE name='Operativo'].Id;
        Map<Schema.SObjectField, Object> mapFields=new Map<Schema.SObjectField, Object>{User.ProfileId => perfil, User.prof_position_type__c => 'ASISTENTE BEC'};
        User userAsistant=TestFactory.getUser(true, mapFields);
        userAsistant.prof_position_id__c = 'E06';
        update userAsistant;
        //ASISTENTE 2
        mapFields=new Map<Schema.SObjectField, Object>{User.ProfileId => perfil, User.prof_position_type__c => 'ASISTENTE BEC 2'};
        User userAsistant2=TestFactory.getUser(true, mapFields);
        userAsistant2.prof_position_id__c = 'E06';
        update userAsistant2;
        /*Crea Subgerente Operativo*/
        mapFields.put(User.prof_position_type__c, 'SUBGERENTE BEC');
        User userSgof=TestFactory.getUser(true, mapFields);
        userSgof.prof_position_id__c = 'E04';
        update userSgof;
        /*Crea Ejecutivo*/
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
            
            Final Product2 testPr = new Product2(Name='TestProd', type_of_quote__c='COTIZADOR', ProductCode='PC00012');
            insert testPr;
            
            Final Pricebook2 testPB = new Pricebook2(CurrencyIsoCode='PEN', Name='MyPrice');
            insert testPB;
            Final Id pricebookId = Test.getStandardPricebookId();
    
            Final PricebookEntry testPE = new PricebookEntry(UnitPrice=120, CurrencyIsoCode='PEN', Pricebook2Id=pricebookId, Product2Id=testPr.Id, IsActive=true);
            insert testPE;
            
            Final OpportunityLineItem testLOPP = new OpportunityLineItem(TotalPrice=120, OpportunityId=testOP.Id, PricebookEntryId=testPE.Id, Quantity=1, gipr_Tipo_Garantia__c='03', 
                                                                  Product2Id=testPr.Id);
            insert testLOPP;
        }
    }
    
    /* isTest - validateAssistantErrorTest */
    @isTest
    public static void validateAssistantErrorTest() {
        Final User ejecutivo = [SELECT ID FROM User WHERE prof_position_type__c=:positionExecutive limit 1];
        Final Opportunity opp = [SELECT ID FROM Opportunity WHERE Name =:oppName limit 1];
        Map<String, Object> mapRes;
        System.runAs(ejecutivo) {
            Product_cls.setFormalization(opp.Id,btnApprove,comments,'');
        }
        Test.startTest();
        mapRes = AssistantFormalization_helper.validateAssistant(opp.Id);  
        Test.stopTest();
        System.assertEquals(true, mapRes.get(isError), 'El resultado del metodo debería ser True');
    }
    
    /* isTest - validateAssistantSuccessTest */
    @isTest
    public static void validateAssistantSuccessTest() {
        Final User ejecutivo = [SELECT ID FROM User WHERE prof_position_type__c=:positionExecutive limit 1];
        Final Opportunity opp = [SELECT ID FROM Opportunity WHERE Name =:oppName limit 1];
        System.runAs(ejecutivo) {
            Product_cls.setFormalization(opp.Id,btnApprove,comments,'');
        }
        Final User asistente = [SELECT ID FROM User WHERE prof_position_type__c=:positionAssist limit 1];
        Map<String, Object> mapRes;
        System.runAs(asistente) {
         	mapRes = AssistantFormalization_helper.validateAssistant(opp.Id);   
        }
        System.assertEquals(false, mapRes.get(isError), fail);
    }
    
    /* isTest - reasignCaseAssistantErrorTest */
    @isTest
    public static void reasignCaseAssistantErrorTest() {
        Final User ejecutivo = [SELECT ID FROM User WHERE prof_position_type__c=:positionExecutive limit 1];
        Final Opportunity opp = [SELECT ID FROM Opportunity WHERE Name =:oppName limit 1];
        System.runAs(ejecutivo) {
            Product_cls.setFormalization(opp.Id,btnApprove,comments,'');
        }
        Final User asistente = [SELECT ID FROM User WHERE prof_position_type__c=:positionAssist limit 1];
        delete [SELECT Id FROM GroupMember WHERE UserOrGroupId=:asistente.Id];
        Map<String, Object> mapRes;
        System.runAs(asistente) {
         	mapRes = AssistantFormalization_helper.reasignCaseFromOpp(opp.Id);
        }
        System.assertEquals(true, mapRes.get(isError), fail);
    }
    
    /* isTest - reasignCaseAssistantSuccessTest */
    @isTest
    public static void reasignCaseAssistantSuccessTest() {
        Final User admin = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId()];
        Map<String, Object> mapRes;
        User ejecutivo, asistente;
        Final Opportunity opp = [SELECT ID FROM Opportunity WHERE Name =:oppName limit 1];
        Final User[] usuarios = [SELECT ID, prof_position_type__c FROM User WHERE prof_position_type__c IN ('ASISTENTE BEC', 'EJECUTIVO BEC') limit 2];
        for(User u:usuarios) {
            if(u.prof_position_type__c == positionAssist) {
                asistente = u;
            } else if(u.prof_position_type__c == positionExecutive) {
                ejecutivo = u;
            }
        }
        System.runAs(ejecutivo) {
            Product_cls.setFormalization(opp.Id,btnApprove,comments,'');           
        }
        System.runAs(admin) {
            Formalization_Helper_tst.setFormalizationGroupAssistant();
        }
        
        Test.startTest();
        System.runAs(asistente) {
         	mapRes = AssistantFormalization_helper.reasignCaseFromOpp(opp.Id);
        }
        Test.stopTest();
        System.assertEquals(false, mapRes.get(isError), fail);
    }
    
    /* isTest - getDataAssistantSuccessTest */
    @isTest
    public static void getDataAssistantSuccessTest() {
        Final User admin = [SELECT ID FROM User WHERE Id=:UserInfo.getUserId()];
        Final Opportunity opp = [SELECT ID FROM Opportunity WHERE Name =:oppName limit 1];
        System.runAs(admin) {
            Product_cls.setFormalization(opp.Id,btnApprove,comments,'');
			Formalization_Helper_tst.setFormalizationGroupAssistant();
        }
        Final User asistente = [SELECT ID FROM User WHERE prof_position_type__c=:positionAssist limit 1];
        Map<String, Object> mapRes;
        Test.startTest();
        System.runAs(asistente) {
            AssistantFormalization_helper.reasignCaseFromOpp(opp.Id);
         	mapRes = AssistantFormalization_helper.getData(opp.Id);   
        }
        Test.stopTest();
        System.assertEquals(false, mapRes.get(isError), fail);
    }
    
    /* isTest - sentToFormalizeSTFTest */
    @isTest
    public static void sentToFormalizeSTFTest() {
        Final Map<String, Object> data = new Map<String, Object>{'option' => 'sentToFormalize', 'contractNumber' => '0011-1234-1234567890', 'comments' => 'comentarios'};
        Final User admin = [SELECT ID FROM User WHERE Id=:UserInfo.getUserId()];
        Final Opportunity opp = [SELECT ID FROM Opportunity WHERE Name =:oppName limit 1];
        System.runAs(admin) {
            Product_cls.setFormalization(opp.Id,btnApprove,comments,'');
			Formalization_Helper_tst.setFormalizationGroupAssistant();
        }
        Final User asistente = [SELECT ID FROM User WHERE prof_position_type__c=:positionAssist limit 1];
        Test.startTest();
        System.runAs(asistente) {
            AssistantFormalization_helper.reasignCaseFromOpp(opp.Id);
         	AssistantFormalization_helper.sentToFormalize(opp.Id, JSON.serialize(data));
        }
        Test.stopTest();
        Final Case caso = [SELECT ID, status FROM Case WHERE opportunity_id__c=:opp.Id limit 1];
        System.assertEquals('07', caso.status, fail);
    }
    
    /* isTest - sentToFormalizeSTFValidationErrorTest */
    @isTest
    public static void sentToFormalizeSTFValidationErrorTest() {
        Final Map<String, Object> data = new Map<String, Object>{'option' => 'sentToFormalize', 'contractNumber' => '0011-1234-12567890', 'comments' => 'comentarios'};
        Final User admin = [SELECT ID FROM User WHERE Id=:UserInfo.getUserId()];
        Final Opportunity opp = [SELECT ID FROM Opportunity WHERE Name =:oppName limit 1];
        System.runAs(admin) {
            Product_cls.setFormalization(opp.Id,btnApprove,comments,'');
			Formalization_Helper_tst.setFormalizationGroupAssistant();
        }
        Final User asistente = [SELECT ID FROM User WHERE prof_position_type__c=:positionAssist limit 1];
        Map<String, Object> mapRes;
        Test.startTest();
        System.runAs(asistente) {
            AssistantFormalization_helper.reasignCaseFromOpp(opp.Id);
         	mapRes = AssistantFormalization_helper.sentToFormalize(opp.Id, JSON.serialize(data));   
        }
        Test.stopTest();
        System.assertEquals(true, mapRes.get(isError), fail);
    }
    
    /* isTest - sentToFormalizeRBDTest */
    @isTest
    public static void sentToFormalizeRBDTest() {
        Final Map<String, Object> data = new Map<String, Object>{'option' => 'returnByDocumentation', 'devolutionReason' => '08', 'comments' => 'comentarios'};
        Final User admin = [SELECT ID FROM User WHERE Id=:UserInfo.getUserId()];
        Final Opportunity opp = [SELECT ID FROM Opportunity WHERE Name =:oppName limit 1];
        System.runAs(admin) {
            Product_cls.setFormalization(opp.Id,btnApprove,comments,'');
			Formalization_Helper_tst.setFormalizationGroupAssistant();
        }
        Final User asistente = [SELECT ID FROM User WHERE prof_position_type__c=:positionAssist limit 1];
        Test.startTest();
        System.runAs(asistente) {
            AssistantFormalization_helper.reasignCaseFromOpp(opp.Id);
            AssistantFormalization_helper.sentToFormalize(opp.Id, JSON.serialize(data));   
        }
        Test.stopTest();
        Final Case caso = [SELECT ID, status FROM Case WHERE opportunity_id__c=:opp.Id limit 1];
        System.assertEquals('06', caso.status, fail);
    }
    
    /* isTest - sentToFormalizeRBDValidationERRORTest */
    @isTest
    public static void sentToFormalizeRBDValidationERRORTest() {
        Final Map<String, Object> data = new Map<String, Object>{'option' => 'returnByDocumentation', 'devolutionReason' => '10', 'comments' => 'comentarios'};
        Final User admin = [SELECT ID FROM User WHERE Id=:UserInfo.getUserId()];
        Final Opportunity opp = [SELECT ID FROM Opportunity WHERE Name =:oppName limit 1];
        System.runAs(admin) {
            Product_cls.setFormalization(opp.Id,btnApprove,comments,'');
			Formalization_Helper_tst.setFormalizationGroupAssistant();
        }
        Final User asistente = [SELECT ID FROM User WHERE prof_position_type__c=:positionAssist limit 1];
        Map<String, Object> mapRes;
        Test.startTest();
        System.runAs(asistente) {
            AssistantFormalization_helper.reasignCaseFromOpp(opp.Id);
         	mapRes = AssistantFormalization_helper.sentToFormalize(opp.Id, JSON.serialize(data));   
        }
        Test.stopTest();
        System.assertEquals(true, mapRes.get(isError), fail);
    }
    
    /* isTest - sentToFormalizeERRORTest */
    @isTest
    public static void sentToFormalizeERRORTest() {
        Final Map<String, Object> data = new Map<String, Object>{'option' => 'wrongValue', 'devolutionReason' => '08', 'comments' => 'comentarios'};
        Final User admin = [SELECT ID FROM User WHERE Id=:UserInfo.getUserId()];
        Final Opportunity opp = [SELECT ID FROM Opportunity WHERE Name =:oppName limit 1];
        System.runAs(admin) {
            Product_cls.setFormalization(opp.Id,btnApprove,comments,'');
			Formalization_Helper_tst.setFormalizationGroupAssistant();
        }
        Final User asistente = [SELECT ID FROM User WHERE prof_position_type__c=:positionAssist limit 1];
        Map<String, Object> mapRes;
        Test.startTest();
        System.runAs(asistente) {
            AssistantFormalization_helper.reasignCaseFromOpp(opp.Id);
         	mapRes = AssistantFormalization_helper.sentToFormalize(opp.Id, JSON.serialize(data));   
        }
        Test.stopTest();
        System.assertEquals(true, mapRes.get(isError), fail);
    }
    
    /* isTest - validateAssistantSuccessTestAssigned */
    @isTest
    public static void validateAssistantSuccessTestAssigned() {
        Final User ejecutivo = [SELECT ID FROM User WHERE prof_position_type__c=:positionExecutive limit 1];
        Final Opportunity opp = [SELECT ID FROM Opportunity WHERE Name =:oppName limit 1];
        System.runAs(ejecutivo) {
            Product_cls.setFormalization(opp.Id,btnApprove,comments,'');
        }
        Formalization_Helper_tst.setFormalizationGroupAssistant();
        Final User asistente = [SELECT ID, Name FROM User WHERE prof_position_type__c=:positionAssist limit 1];
        System.runAs(asistente) {
            AssistantFormalization_helper.reasignCaseFromOpp(opp.Id);
        }
        Final User asistente2 = [SELECT ID, Name FROM User WHERE prof_position_type__c='ASISTENTE BEC 2' limit 1];
        Map<String, Object> mapRes;
        Test.startTest();
        System.runAs(asistente2) { 
            mapRes = AssistantFormalization_helper.reasignCaseFromOpp(opp.Id);
        }
        Test.stopTest();
        System.assertEquals(false, mapRes.get(isError), fail);
    }
    
    /* isTest - validateAssistantSuccessTestAgree */
    @isTest
    public static void validateAssistantSuccessTestAgree() {
        Final User ejecutivo = [SELECT ID FROM User WHERE prof_position_type__c=:positionExecutive limit 1];
        Final Opportunity opp = [SELECT ID FROM Opportunity WHERE Name =:oppName limit 1];
        System.runAs(ejecutivo) {
            Product_cls.setFormalization(opp.Id,btnApprove,comments,'');
        }
        Formalization_Helper_tst.setFormalizationGroupAssistant();
        Final User asistente = [SELECT ID, Name FROM User WHERE prof_position_type__c=:positionAssist limit 1];
        Map<String, Object> mapRes;
        System.runAs(asistente) {
            AssistantFormalization_helper.reasignCaseFromOpp(opp.Id);
            Test.startTest();
            mapRes = AssistantFormalization_helper.validateAssistant(opp.Id);  
            Test.stopTest();
        }
        System.assertEquals(false, mapRes.get(isError), fail);
    }
    
    /* isTest - createOrUpdateCaseUpdateSuccessTest */
    @isTest
    public static void createOrUpdateCaseUpdateSuccessTest() {
        Final Map<String, Object> data = new Map<String, Object>{'option' => 'returnByDocumentation', 'devolutionReason' => '08', 'comments' => 'comentarios'};
		Final User admin = [SELECT ID FROM User WHERE Id=:UserInfo.getUserId()];
        Final Opportunity opp = [SELECT ID FROM Opportunity WHERE Name =:oppName limit 1];
        System.runAs(admin) {
            Product_cls.setFormalization(opp.Id,btnApprove,comments,'');
			Formalization_Helper_tst.setFormalizationGroupAssistant();
        }
        Final User asistente = [SELECT ID FROM User WHERE prof_position_type__c=:positionAssist limit 1];
        System.runAs(asistente) {
            AssistantFormalization_helper.reasignCaseFromOpp(opp.Id);
            AssistantFormalization_helper.sentToFormalize(opp.Id, JSON.serialize(data));   
        }
        System.runAs(admin) {
            Product_cls.setFormalization(opp.Id,btnApprove,comments,'');
        }
        Final Case caso = [SELECT ID, status FROM Case WHERE opportunity_id__c=:opp.Id limit 1];
        System.assertEquals('05', caso.status, fail);
    }
    
}