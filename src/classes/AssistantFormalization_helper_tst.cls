/*
* ------------------------------------------------------------------------------------------------
* @Name AssistantFormalization_helper_tst
* @Author Diego Carbajal diego.carbajal.contractor@bbva.com
* @Date Created: 2019-08-28
* @Group 
* @Description Esta clase prueba los metodos de la clase AssistantFormalization_helper y Formalization_helper
*/
@isTest
public class AssistantFormalization_helper_tst {
    
    /*Campo POSITION_EXE inicializado para soluciones del SonarQ*/
    public static Final String POSITION_EXE = 'EJECUTIVO BEC';
    /*Campo POSITION_ASSI inicializado para soluciones del SonarQ*/
    public static Final String POSITION_ASSI = 'ASISTENTE BEC';
    /*Campo BTN_APPROVE inicializado para soluciones del SonarQ*/
    public static Final String BTN_APPROVE = 'btnApprove';
    /*Campo COMMENTS inicializado para soluciones del SonarQ*/
    public static Final String COMMENTS = 'comments';
    /*Campo IS_ERROR inicializado para soluciones del SonarQ*/
    public static Final String IS_ERROR = 'isError';
    /*Campo FAIL inicializado para soluciones del SonarQ*/
    public static Final String FAIL = 'Fail';
    /*Campo OPP_NAME inicializado para soluciones del SonarQ*/
    public static Final String OPP_NAME = 'TEST Formalization';
    /*Campo OPTION inicializado para soluciones del SonarQ*/
    public static Final String OPTION = 'option';
    /*Campo DEVOL_REASON inicializado para soluciones del SonarQ*/
    public static Final String DEVOL_REASON = 'devolutionReason';

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
        Map<Schema.SObjectField, Object> mapFields=new Map<Schema.SObjectField, Object>{User.ProfileId => perfil, User.prof_position_type__c => 'ASISTENTE BEC'};
        User userAsistant=TestFactory.getUser(true, mapFields);
        userAsistant.prof_position_id__c = 'E06';
        userAsistant.isActive = true;
        update userAsistant;
        //ASISTENTE 2
        mapFields=new Map<Schema.SObjectField, Object>{User.ProfileId => perfil, User.prof_position_type__c => 'ASISTENTE BEC 2'};
        User userAsistant2=TestFactory.getUser(true, mapFields);
        userAsistant2.prof_position_id__c = 'E06';
        userAsistant2.isActive = true;
        update userAsistant2;
        /*Crea Subgerente Operativo*/
        mapFields.put(User.prof_position_type__c, 'SUBGERENTE BEC');
        User userSgof=TestFactory.getUser(true, mapFields);
        userSgof.prof_position_id__c = 'E04';
        userSgof.isActive = true;
        update userSgof;
        /*Crea Ejecutivo*/
        Final String perfilExecutive=[SELECT Id FROM Profile WHERE name='Ejecutivo'].Id;
        mapFields=new Map<Schema.SObjectField, Object>{User.ProfileId => perfilExecutive, User.prof_position_type__c => 'EJECUTIVO BEC'};
        Final User userExecutive = TestFactory.getUser(true, mapFields);
        userExecutive.isActive = true;
        update userExecutive;
        //Create Account's
        Account acc;
        System.runAs(admin) { 
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
        Final User admin = [SELECT ID FROM User WHERE id=:UserInfo.getUserId()];
        Final User ejecutivo = [SELECT ID, isActive FROM User WHERE prof_position_type__c=:POSITION_EXE limit 1];
        System.runAs(admin){
            ejecutivo.isActive = true;
            update ejecutivo;
        }
        Final Opportunity opp = [SELECT ID FROM Opportunity WHERE Name =:OPP_NAME limit 1];
        Map<String, Object> mapRes;
        System.runAs(ejecutivo) {
            Product_cls.setFormalization(opp.Id,BTN_APPROVE,COMMENTS,'');
        }
        Test.startTest();
        mapRes = AssistantFormalization_helper.validateAssistant(opp.Id);  
        Test.stopTest();
        System.assert((Boolean)mapRes.get(IS_ERROR), FAIL);
    }
    
    /* isTest - validateAssistantSuccessTest */
    @isTest
    public static void validateAssistantSuccessTest() {
        Final User admin = [SELECT ID FROM User WHERE id=:UserInfo.getUserId()];
        Final User ejecutivo = [SELECT ID, isActive FROM User WHERE prof_position_type__c=:POSITION_EXE limit 1];
        System.runAs(admin){
            ejecutivo.isActive = true;
            update ejecutivo;
        }
        Final Opportunity opp = [SELECT ID FROM Opportunity WHERE Name =:OPP_NAME limit 1];
        System.runAs(ejecutivo) {
            Product_cls.setFormalization(opp.Id,BTN_APPROVE,COMMENTS,'');
        }
        Final User asistente = [SELECT ID FROM User WHERE prof_position_type__c=:POSITION_ASSI limit 1];
        Map<String, Object> mapRes;
        System.runAs(asistente) {
         	mapRes = AssistantFormalization_helper.validateAssistant(opp.Id);   
        }
        Final Boolean assertion = (Boolean)mapRes.get(IS_ERROR) ? false : true;
        System.assert(assertion, FAIL);
    }
    
    /* isTest - reasignCaseAssistantErrorTest */
    @isTest
    public static void reasignCaseAssistantErrorTest() {
        Final User admin = [SELECT ID FROM User WHERE id=:UserInfo.getUserId()];
        Final User ejecutivo = [SELECT ID, isActive FROM User WHERE prof_position_type__c=:POSITION_EXE limit 1];
        Final User asistente = [SELECT ID, isActive FROM User WHERE prof_position_type__c=:POSITION_ASSI limit 1];
        System.runAs(admin){
            ejecutivo.isActive = true;
            asistente.IsActive = true;
            update ejecutivo;
            update asistente;
        }
        Final Opportunity opp = [SELECT ID FROM Opportunity WHERE Name =:OPP_NAME limit 1];
        System.runAs(ejecutivo) {
            Product_cls.setFormalization(opp.Id,BTN_APPROVE,COMMENTS,'');
        }
        
        delete [SELECT Id FROM GroupMember WHERE UserOrGroupId=:asistente.Id];
        Map<String, Object> mapRes;
        System.runAs(asistente) {
         	mapRes = AssistantFormalization_helper.reasignCaseFromOpp(opp.Id);
        }
        System.assert((Boolean)mapRes.get(IS_ERROR), FAIL);
    }
    
    /* isTest - reasignCaseAssistantSuccessTest */
    @isTest
    public static void reasignCaseAssistantSuccessTest() {
        Final User admin = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId()];
        Map<String, Object> mapRes;
        Opportunity opp = [SELECT ID FROM Opportunity WHERE Name =:OPP_NAME limit 1];
        User ejecutivo = [SELECT ID, prof_position_type__c, isActive FROM User WHERE prof_position_type__c IN ('EJECUTIVO BEC') limit 1];
        User asistente = [SELECT ID, prof_position_type__c, isActive FROM User WHERE prof_position_type__c IN ('ASISTENTE BEC') limit 1];
        System.runAs(admin){
            ejecutivo.isActive = true;
            asistente.IsActive = true;
            update ejecutivo;
            update asistente;
        }
        System.runAs(ejecutivo) {
            Product_cls.setFormalization(opp.Id,BTN_APPROVE,COMMENTS,'');           
        }
        System.runAs(admin) {
            Formalization_Helper_tst.setFormalizationGroupAssistant();
        }
        
        Test.startTest();
        System.runAs(asistente) {
         	mapRes = AssistantFormalization_helper.reasignCaseFromOpp(opp.Id);
        }
        Test.stopTest();
        Final Boolean assertion = (Boolean)mapRes.get(IS_ERROR) ? false : true;
        System.assert(assertion, FAIL);
    }
    
    /* isTest - getDataAssistantSuccessTest */
    @isTest
    public static void getDataAssistantSuccessTest() {
        Final User admin = [SELECT ID FROM User WHERE Id=:UserInfo.getUserId()];
        Final Opportunity opp = [SELECT ID FROM Opportunity WHERE Name =:OPP_NAME limit 1];
        Final User asistente = [SELECT ID, isActive FROM User WHERE prof_position_type__c=:POSITION_ASSI limit 1];
        System.runAs(admin) {
            asistente.isActive = true;
            update asistente;
            Product_cls.setFormalization(opp.Id,BTN_APPROVE,COMMENTS,'');
			Formalization_Helper_tst.setFormalizationGroupAssistant();
        }
        Map<String, Object> mapRes;
        Test.startTest();
        System.runAs(asistente) {
            AssistantFormalization_helper.reasignCaseFromOpp(opp.Id);
         	mapRes = AssistantFormalization_helper.getData(opp.Id);   
        }
        Test.stopTest();
        Final Boolean assertion = (Boolean)mapRes.get(IS_ERROR) ? false : true;
        System.assert(assertion, FAIL);
    }
    
    /* isTest - sentToFormalizeSTFTest */
    @isTest
    public static void sentToFormalizeSTFTest() {
        Final Map<String, Object> data = new Map<String, Object>{OPTION => 'sentToFormalize', 'contractNumber' => '0011-1234-1234567890', COMMENTS => COMMENTS};
        Final User admin = [SELECT ID FROM User WHERE Id=:UserInfo.getUserId()];
        Final Opportunity opp = [SELECT ID FROM Opportunity WHERE Name =:OPP_NAME limit 1];
        Final User asistente = [SELECT ID, isActive FROM User WHERE prof_position_type__c=:POSITION_ASSI limit 1];
        System.runAs(admin) {
            asistente.IsActive = true;
            update asistente;
            Product_cls.setFormalization(opp.Id,BTN_APPROVE,COMMENTS,'');
			Formalization_Helper_tst.setFormalizationGroupAssistant();
        }
        Test.startTest();
        System.runAs(asistente) {
            AssistantFormalization_helper.reasignCaseFromOpp(opp.Id);
         	AssistantFormalization_helper.sentToFormalize(opp.Id, JSON.serialize(data));
        }
        Test.stopTest();
        Final Case caso = [SELECT ID, status FROM Case WHERE opportunity_id__c=:opp.Id limit 1];
        Final Boolean assertion = caso.status == '07' ? true : false;
        System.assert(assertion, FAIL);
    }
    
    /* isTest - sentToFormalizeSTFValidationErrorTest */
    @isTest
    public static void sentToFormalizeSTFValidationErrorTest() {
        Final Map<String, Object> data = new Map<String, Object>{OPTION => 'sentToFormalize', 'contractNumber' => '0011-1234-12567890'};
        Final User admin = [SELECT ID FROM User WHERE Id=:UserInfo.getUserId()];
        Final Opportunity opp = [SELECT ID FROM Opportunity WHERE Name =:OPP_NAME limit 1];
        Final User asistente = [SELECT ID, IsActive FROM User WHERE prof_position_type__c=:POSITION_ASSI limit 1];
        System.runAs(admin) {
            asistente.IsActive = true;
            update asistente;
            Product_cls.setFormalization(opp.Id,BTN_APPROVE,COMMENTS,'');
			Formalization_Helper_tst.setFormalizationGroupAssistant();
        }
        Map<String, Object> mapRes;
        Test.startTest();
        System.runAs(asistente) {
            AssistantFormalization_helper.reasignCaseFromOpp(opp.Id);
         	mapRes = AssistantFormalization_helper.sentToFormalize(opp.Id, JSON.serialize(data));   
        }
        Test.stopTest();
        System.assert((Boolean)mapRes.get(IS_ERROR), FAIL);
    }
    
    /* isTest - sentToFormalizeRBDTest */
    @isTest
    public static void sentToFormalizeRBDTest() {
        Final Map<String, Object> data = new Map<String, Object>{OPTION => 'returnByDocumentation', DEVOL_REASON => '08', COMMENTS => COMMENTS};
        Final User admin = [SELECT ID FROM User WHERE Id=:UserInfo.getUserId()];
        Final Opportunity opp = [SELECT ID FROM Opportunity WHERE Name =:OPP_NAME limit 1];
        Final User asistente = [SELECT ID, isActive FROM User WHERE prof_position_type__c=:POSITION_ASSI limit 1];
        System.runAs(admin) {
            asistente.IsActive = true;
            update asistente;
            Product_cls.setFormalization(opp.Id,BTN_APPROVE,COMMENTS,'');
			Formalization_Helper_tst.setFormalizationGroupAssistant();
        }
        Test.startTest();
        System.runAs(asistente) {
            AssistantFormalization_helper.reasignCaseFromOpp(opp.Id);
            AssistantFormalization_helper.sentToFormalize(opp.Id, JSON.serialize(data));   
        }
        Test.stopTest();
        Final Case caso = [SELECT ID, status FROM Case WHERE opportunity_id__c=:opp.Id limit 1];
        Final Boolean assertion = caso.status == '06' ? true : false;
        System.assert(assertion, FAIL);
    }
    
    /* isTest - sentToFormalizeRBDValidationERRORTest */
    @isTest
    public static void sentToFormalizeRBDValidationERRORTest() {
        Final Map<String, Object> data = new Map<String, Object>{OPTION => 'returnByDocumentation', DEVOL_REASON => '10', COMMENTS => COMMENTS};
        Final User admin = [SELECT ID FROM User WHERE Id=:UserInfo.getUserId()];
        Final Opportunity opp = [SELECT ID FROM Opportunity WHERE Name =:OPP_NAME limit 1];
        Final User asistente = [SELECT ID, isActive FROM User WHERE prof_position_type__c=:POSITION_ASSI limit 1];
        System.runAs(admin) {
            asistente.IsActive = true;
            update asistente;
            Product_cls.setFormalization(opp.Id,BTN_APPROVE,COMMENTS,'');
			Formalization_Helper_tst.setFormalizationGroupAssistant();
        }
        Map<String, Object> mapRes;
        Test.startTest();
        System.runAs(asistente) {
            AssistantFormalization_helper.reasignCaseFromOpp(opp.Id);
         	mapRes = AssistantFormalization_helper.sentToFormalize(opp.Id, JSON.serialize(data));   
        }
        Test.stopTest();
        System.assert((Boolean)mapRes.get(IS_ERROR), FAIL);
    }
    
    /* isTest - sentToFormalizeERRORTest */
    @isTest
    public static void sentToFormalizeERRORTest() {
        Final Map<String, Object> data = new Map<String, Object>{OPTION => 'wrongValue', DEVOL_REASON => '08', COMMENTS => COMMENTS};
        Final User admin = [SELECT ID FROM User WHERE Id=:UserInfo.getUserId()];
        Final Opportunity opp = [SELECT ID FROM Opportunity WHERE Name =:OPP_NAME limit 1];
        Final User asistente = [SELECT ID, isActive FROM User WHERE prof_position_type__c=:POSITION_ASSI limit 1];
        System.runAs(admin) {
            asistente.IsActive = true;
            update asistente;
            Product_cls.setFormalization(opp.Id,BTN_APPROVE,COMMENTS,'');
			Formalization_Helper_tst.setFormalizationGroupAssistant();
        }
        Map<String, Object> mapRes;
        Test.startTest();
        System.runAs(asistente) {
            AssistantFormalization_helper.reasignCaseFromOpp(opp.Id);
         	mapRes = AssistantFormalization_helper.sentToFormalize(opp.Id, JSON.serialize(data));   
        }
        Test.stopTest();
        System.assert((Boolean)mapRes.get(IS_ERROR), FAIL);
    }
    
    /* isTest - validateAssistantSuccessTestAssigned */
    @isTest
    public static void validateAssistantSuccessTestAssigned() {
        Final User admin = [SELECT ID FROM User WHERE id=:UserInfo.getUserId()];
        Final User ejecutivo = [SELECT ID, isActive FROM User WHERE prof_position_type__c=:POSITION_EXE limit 1];
        Final Opportunity opp = [SELECT ID FROM Opportunity WHERE Name =:OPP_NAME limit 1];
        Final User asistente = [SELECT ID, isActive, Name FROM User WHERE prof_position_type__c=:POSITION_ASSI limit 1];
        Final User asistente2 = [SELECT ID, isActive, Name FROM User WHERE prof_position_type__c='ASISTENTE BEC 2' limit 1];
        System.runAs(admin) {
            ejecutivo.IsActive = true;
            asistente.IsActive = true;
            asistente2.IsActive = true;
            update ejecutivo;
            update asistente;
            update asistente2;
        }
        System.runAs(ejecutivo) {
            Product_cls.setFormalization(opp.Id,BTN_APPROVE,COMMENTS,'');
        }
        ejecutivo.IsActive = false;
        update ejecutivo;
        Formalization_Helper_tst.setFormalizationGroupAssistant();
        System.runAs(asistente) {
            AssistantFormalization_helper.reasignCaseFromOpp(opp.Id);
        }
        Map<String, Object> mapRes;
        Test.startTest();
        System.runAs(asistente2) { 
            mapRes = AssistantFormalization_helper.reasignCaseFromOpp(opp.Id);
        }
        Test.stopTest();
        Final Boolean assertion = (Boolean)mapRes.get(IS_ERROR) ? false : true;
        System.assert(assertion, FAIL);
    }
    
    /* isTest - validateAssistantSuccessTestAgree */
    @isTest
    public static void validateAssistantSuccessTestAgree() {
        Final User admin = [SELECT ID FROM User WHERE id=:UserInfo.getUserId()];
        Final User ejecutivo = [SELECT ID, isActive FROM User WHERE prof_position_type__c=:POSITION_EXE limit 1];
        Final Opportunity opp = [SELECT ID FROM Opportunity WHERE Name =:OPP_NAME limit 1];
        Final User asistente = [SELECT ID, isActive, Name FROM User WHERE prof_position_type__c=:POSITION_ASSI limit 1];
        System.runAs(admin) {
            ejecutivo.IsActive = true;
            asistente.IsActive = true;
            update ejecutivo;
            update asistente;
        }
        System.runAs(ejecutivo) {
            Product_cls.setFormalization(opp.Id,BTN_APPROVE,COMMENTS,'');
        }
        Formalization_Helper_tst.setFormalizationGroupAssistant();
        Map<String, Object> mapRes;
        System.runAs(asistente) {
            AssistantFormalization_helper.reasignCaseFromOpp(opp.Id);
            Test.startTest();
            mapRes = AssistantFormalization_helper.validateAssistant(opp.Id);  
            Test.stopTest();
        }
        Final Boolean assertion = (Boolean)mapRes.get(IS_ERROR) ? false : true;
        System.assert(assertion, FAIL);
    }
    
    /* isTest - createOrUpdateCaseUpdateSuccessTest */
    @isTest
    public static void createOrUpdateCaseUpdateSuccessTest() {
        Final Map<String, Object> data = new Map<String, Object>{OPTION => 'returnByDocumentation', DEVOL_REASON => '08', COMMENTS => COMMENTS};
		Final User admin = [SELECT ID FROM User WHERE Id=:UserInfo.getUserId()];
        Final Opportunity opp = [SELECT ID FROM Opportunity WHERE Name =:OPP_NAME limit 1];
        Final User asistente = [SELECT ID, isActive FROM User WHERE prof_position_type__c=:POSITION_ASSI limit 1];
        System.runAs(admin) {
            asistente.IsActive = true;
            update asistente;
            Product_cls.setFormalization(opp.Id,BTN_APPROVE,COMMENTS,'');
			Formalization_Helper_tst.setFormalizationGroupAssistant();
        }
        System.runAs(asistente) {
            AssistantFormalization_helper.reasignCaseFromOpp(opp.Id);
            AssistantFormalization_helper.sentToFormalize(opp.Id, JSON.serialize(data));   
        }
        System.runAs(admin) {
            Product_cls.setFormalization(opp.Id,BTN_APPROVE,COMMENTS,'');
        }
        Final Case caso = [SELECT ID, status FROM Case WHERE opportunity_id__c=:opp.Id AND OwnerId=:asistente.Id limit 1];
        Final Boolean assertion = caso.status == '05' ? true : false;
        System.assert(assertion, FAIL);
    }
    
}