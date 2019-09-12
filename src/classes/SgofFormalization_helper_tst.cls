/**
* ------------------------------------------------------------------------------------------------
* @Name SgofFormalization_helper_tst
* @Author Diego Carbajal diego.carbajal.contractor@bbva.com
* @Date Created: 2019-08-28
* @Group 
* @Description Esta clase prueba los metodos de la clase SgofFormalization_helper y Formalization_helper
*/
@isTest
public class SgofFormalization_helper_tst {

    /*Campo POSITION_EXE2 inicializado para soluciones del SonarQ*/
    public static Final String POSITION_EXE2 = 'EJECUTIVO BEC 2';
    /*Campo POSITION_SGOF inicializado para soluciones del SonarQ*/
    public static Final String POSITION_SGOF = 'SUBGERENTE BEC 2';
    /*Campo BTN_APPROVE inicializado para soluciones del SonarQ*/
    public static Final String BTN_APPROVE = 'btnApprove';
    /*Campo COMMENTS inicializado para soluciones del SonarQ*/
    public static Final String COMMENTS = 'comments';
    /*Campo IS_ERROR inicializado para soluciones del SonarQ*/
    public static Final String IS_ERROR = 'isError';
    /*Campo FAIL inicializado para soluciones del SonarQ*/
    public static Final String FAIL = 'fail';
    /*Campo OPTION inicializado para soluciones del SonarQ*/
    public static Final String OPTION = 'option';
    /*Campo DEVOL_REASON inicializado para soluciones del SonarQ*/
    public static Final String DEVOL_REASON = 'devolutionReason';
    /*Campo OPP_NAME inicializado para soluciones del SonarQ*/
    public static Final String OPP_NAME = 'TEST Formalization Sgof';
    
    /* testSetup - setup */
    @testSetup
    public static void setup() {
        Final Dwp_FormalizationProducts_AAC__c[] prdAssistForm = new Dwp_FormalizationProducts_AAC__c[]{};
        Final Set<String> prdToForm = new Set<String>{'PC00012', 'PC00011', 'PC00001_Depre', 'PC00005', 'PC00009', 'PC00001'};
        for(String prd:prdToForm) {
            prdAssistForm.add(new Dwp_FormalizationProducts_AAC__c(Name=prd, Product_Code__c=prd));
        }
        insert prdAssistForm;
        Final User admin = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId()];
        /*Crea Asistente Operativo*/
        Final String perfil=[SELECT Id FROM Profile WHERE name='Operativo'].Id;
        Map<Schema.SObjectField, Object> mapFields=new Map<Schema.SObjectField, Object>{User.ProfileId => perfil, User.prof_position_type__c => 'ASISTENTE BEC 2', User.prof_position_id__c => 'E06'};
        User userAsistant=TestFactory.getUser(true, mapFields);
        /*Crea Subgerente Operativo*/
        mapFields.put(User.prof_position_type__c, POSITION_SGOF);
        mapFields.put(User.prof_position_id__c, 'E04');
        User userSgof=TestFactory.getUser(true, mapFields);
        /*Crea Ejecutivo*/
        Final String perfilExecutive=[SELECT Id FROM Profile WHERE name='Ejecutivo'].Id;
        mapFields=new Map<Schema.SObjectField, Object>{User.ProfileId => perfilExecutive, User.prof_position_type__c => 'EJECUTIVO BEC 2'};
        Final User userExecutive = TestFactory.getUser(true, mapFields);
        //Create data for process
        System.runAs(admin) { 
            mapFields=new Map<Schema.SObjectField, Object>{Account.OwnerId => userExecutive.Id, Account.Name => 'CLIENTE OPORTUNIDAD SGOF'};
            Final Account acc = TestFactory.getAccount(true, mapFields);
            
            //Crear Oportunidad con Producto - 1
            Final Opportunity testOP= new Opportunity(Name='TEST Formalization Sgof', stageName='02', AccountId=acc.Id, CloseDate=Date.today(), Amount = 10000, OwnerId = userExecutive.Id);
            insert testOP;
            
            Final Product2 testPr = new Product2(Name='TestProd 2', type_of_quote__c='COTIZADOR');
            insert testPr;
            
            Final Pricebook2 testPB = new Pricebook2(CurrencyIsoCode='PEN', Name='MyPrice 2');
            insert testPB;
            Final Id pricebookId = Test.getStandardPricebookId();
    
            Final PricebookEntry testPE = new PricebookEntry(UnitPrice=120, CurrencyIsoCode='PEN', Pricebook2Id=pricebookId, Product2Id=testPr.Id, IsActive=true);
            insert testPE;
            
            Final OpportunityLineItem testLOPP = new OpportunityLineItem(TotalPrice=120, OpportunityId=testOP.Id, PricebookEntryId=testPE.Id, Quantity=1, gipr_Tipo_Garantia__c='03', 
                                                                  Product2Id=testPr.Id);
            insert testLOPP;
        }
    }
    
    /* isTest - validateSgofErrorTest */
    @isTest
    public static void validateSgofErrorTest() {
        Final User ejecutivo = [SELECT ID, isActive FROM User WHERE prof_position_type__c=:POSITION_EXE2 AND isActive=true limit 1];
        Final Opportunity opp = [SELECT ID FROM Opportunity WHERE Name =:OPP_NAME limit 1];
        Map<String, Object> mapRes;
        System.runAs(ejecutivo) {
            Product_cls.setFormalization(opp.Id,BTN_APPROVE,COMMENTS,'');
        }
        Test.startTest();
        mapRes = SgofFormalization_helper.validateSGof(opp.Id);  
        Test.stopTest();
        System.assert((Boolean)mapRes.get(IS_ERROR), FAIL);
    }
    
    /* isTest - validateSgofSuccessTest */
    @isTest
    public static void validateSgofSuccessTest() {
        Final User ejecutivo = [SELECT ID, isActive FROM User WHERE prof_position_type__c=:POSITION_EXE2 AND isActive=true limit 1];
        Final Opportunity opp = [SELECT ID FROM Opportunity WHERE Name =:OPP_NAME limit 1];
        System.runAs(ejecutivo) {
            Product_cls.setFormalization(opp.Id,BTN_APPROVE,COMMENTS,'');
        }
        Final User subgerente = [SELECT ID FROM User WHERE prof_position_type__c=:POSITION_SGOF AND isActive=true limit 1];
        Map<String, Object> mapRes;
        System.runAs(subgerente) {
         	mapRes = SgofFormalization_helper.validateSGof(opp.Id);
        }
        Final Boolean assertion = (Boolean)mapRes.get(IS_ERROR) ? false : true;
        System.assert(assertion, FAIL);
    }
    
    /* isTest - reasignCaseSgofErrorTest */
    @isTest
    public static void reasignCaseSgofErrorTest() {
        Final User ejecutivo = [SELECT ID, isActive FROM User WHERE prof_position_type__c=:POSITION_EXE2 AND isActive=true limit 1];
        Final Opportunity opp = [SELECT ID FROM Opportunity WHERE Name =:OPP_NAME limit 1];
        Final User subgerente = [SELECT ID, isActive FROM User WHERE prof_position_type__c=:POSITION_SGOF AND isActive=true limit 1];
        System.runAs(ejecutivo) {
            Product_cls.setFormalization(opp.Id,BTN_APPROVE,COMMENTS,'');
        }
        delete [SELECT Id FROM GroupMember WHERE UserOrGroupId=:subgerente.Id];
        Map<String, Object> mapRes;
        System.runAs(subgerente) {
         	mapRes = SgofFormalization_helper.reasignCaseFromOpp(opp.Id);
        }
        System.assert((Boolean)mapRes.get(IS_ERROR), FAIL);
    }
    
    /* isTest - reasignCaseSgofSuccessTest */
    @isTest
    public static void reasignCaseSgofSuccessTest() {
        User ejecutivo, subgerente;
        Final Opportunity opp = [SELECT ID FROM Opportunity WHERE Name =:OPP_NAME limit 1];
        Final User[] usuarios = [SELECT ID, prof_position_type__c, isActive FROM User WHERE prof_position_type__c IN ('SUBGERENTE BEC 2', 'EJECUTIVO BEC 2') AND isActive=true limit 2];
        for(User u:usuarios) {
            if(u.prof_position_type__c == POSITION_SGOF) {
                subgerente = u;
            } else if(u.prof_position_type__c == POSITION_EXE2) {
                ejecutivo = u;
            }
        }
        System.runAs(ejecutivo) {
            Product_cls.setFormalization(opp.Id,BTN_APPROVE,COMMENTS,'');           
        }
        Map<String, Object> mapRes;
        Test.startTest();
        System.runAs(subgerente) {
         	mapRes = SgofFormalization_helper.reasignCaseFromOpp(opp.Id);
        }
        Test.stopTest();
        Final Boolean assertion = (Boolean)mapRes.get(IS_ERROR) ? false : true;
        System.assert(assertion, FAIL);
    }
    
    /* isTest - getDataSubSuccessTest */
    @isTest
    public static void getDataSubSuccessTest() {
        Final User subgerente = [SELECT ID, isActive FROM User WHERE prof_position_type__c=:POSITION_SGOF AND isActive=true limit 1];
        Final Opportunity opp = [SELECT ID FROM Opportunity WHERE Name =:OPP_NAME limit 1];
        Product_cls.setFormalization(opp.Id,BTN_APPROVE,COMMENTS,'');
        Map<String, Object> mapRes;
        Test.startTest();
        System.runAs(subgerente) {
            SgofFormalization_helper.reasignCaseFromOpp(opp.Id);
         	mapRes = SgofFormalization_helper.getData(opp.Id);   
        }
        Test.stopTest();
        Final Boolean assertion = (Boolean)mapRes.get(IS_ERROR) ? false : true;
        System.assert(assertion, FAIL);
    }
    
    /* isTest - sentToFormalizeSTFTest */
    @isTest
    public static void sentToFormalizeSTFTest() {
        Final Map<String, Object> data = new Map<String, Object>{OPTION => 'sentToFormalize', 'contractNumber' => '0011-1234-1234567890', COMMENTS => COMMENTS};
        Final User subgerente = [SELECT ID, isActive FROM User WHERE prof_position_type__c=:POSITION_SGOF AND isActive=true limit 1];
        Final Opportunity opp = [SELECT ID FROM Opportunity WHERE Name =:OPP_NAME limit 1];
		Product_cls.setFormalization(opp.Id,BTN_APPROVE,COMMENTS,'');
        Test.startTest();
        System.runAs(subgerente) {
            SgofFormalization_helper.reasignCaseFromOpp(opp.Id);
         	SgofFormalization_helper.sentToFormalize(opp.Id, JSON.serialize(data));
        }
        Test.stopTest();
        Final Case caso = [SELECT ID, status FROM Case WHERE opportunity_id__c=:opp.Id limit 1];
        Final Boolean assertion = caso.status == '10' ? true : false;
        System.assert(assertion, FAIL);
    }
    
    /* isTest - sentToFormalizeSTFValidationErrorTest */
    @isTest
    public static void sentToFormalizeSTFValidationErrorTest() {
        Final Map<String, Object> data = new Map<String, Object>{OPTION => 'sentToFormalize', 'contractNumber' => '0011-1234-12567890', COMMENTS => COMMENTS};
        Final User subgerente = [SELECT ID, isActive FROM User WHERE prof_position_type__c=:POSITION_SGOF AND isActive=true limit 1];
        Final Opportunity opp = [SELECT ID FROM Opportunity WHERE Name =:OPP_NAME limit 1];
		Product_cls.setFormalization(opp.Id,BTN_APPROVE,COMMENTS,'');
        Map<String, Object> mapRes;
        Test.startTest();
        System.runAs(subgerente) {
            SgofFormalization_helper.reasignCaseFromOpp(opp.Id);
         	mapRes = SgofFormalization_helper.sentToFormalize(opp.Id, JSON.serialize(data));   
        }
        Test.stopTest();
        Final Boolean assertion = (Boolean)mapRes.get('success') ? false : true;
        System.assert(assertion, FAIL);
    }
    
    /* isTest - sentToFormalizeRBDTest */
    @isTest
    public static void sentToFormalizeRBDTest() {
        Final Map<String, Object> data = new Map<String, Object>{OPTION => 'returnByDocumentation', DEVOL_REASON => '08', COMMENTS => COMMENTS};
        Final Opportunity opp = [SELECT ID FROM Opportunity WHERE Name =:OPP_NAME limit 1];
        Final User subgerente = [SELECT ID, isActive FROM User WHERE prof_position_type__c=:POSITION_SGOF AND isActive=true limit 1];
		Product_cls.setFormalization(opp.Id,BTN_APPROVE,COMMENTS,'');
        Test.startTest();
        System.runAs(subgerente) {
            SgofFormalization_helper.reasignCaseFromOpp(opp.Id);
            SgofFormalization_helper.sentToFormalize(opp.Id, JSON.serialize(data));   
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
        Final User subgerente = [SELECT ID, isActive FROM User WHERE prof_position_type__c=:POSITION_SGOF AND isActive=true limit 1];
        Final Opportunity opp = [SELECT ID FROM Opportunity WHERE Name =:OPP_NAME limit 1];
        Product_cls.setFormalization(opp.Id,BTN_APPROVE,COMMENTS,'');
        Map<String, Object> mapRes;
        Test.startTest();
        System.runAs(subgerente) {
            SgofFormalization_helper.reasignCaseFromOpp(opp.Id);
         	mapRes = SgofFormalization_helper.sentToFormalize(opp.Id, JSON.serialize(data));   
        }
        Test.stopTest();
        Final Boolean assertion = (Boolean)mapRes.get('success') ? false : true;
        System.assert(assertion, FAIL);
    }
    
    /* isTest - sentToFormalizeERRORTest */
    @isTest
    public static void sentToFormalizeERRORTest() {
        Final Map<String, Object> data = new Map<String, Object>{OPTION => 'wrongValue', DEVOL_REASON => '08', COMMENTS => COMMENTS};
        Final Opportunity opp = [SELECT ID FROM Opportunity WHERE Name =:OPP_NAME limit 1];
        Final User subgerente = [SELECT ID, isActive FROM User WHERE prof_position_type__c=:POSITION_SGOF AND isActive=true limit 1];
        Product_cls.setFormalization(opp.Id,BTN_APPROVE,COMMENTS,'');
        Map<String, Object> mapRes;
        Test.startTest();
        System.runAs(subgerente) {
            SgofFormalization_helper.reasignCaseFromOpp(opp.Id);
         	mapRes = SgofFormalization_helper.sentToFormalize(opp.Id, JSON.serialize(data));   
        }
        Test.stopTest();
        Final Boolean assertion = (Boolean)mapRes.get('success') ? false : true;
        System.assert(assertion, FAIL);
    }
    
}