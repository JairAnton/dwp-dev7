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

    @testSetup
    public static void initData(){
        Dwp_FormalizationProducts_AAC__c[] prdAssistFormalization = new Dwp_FormalizationProducts_AAC__c[]{};
        Set<String> prdToFormalization = new Set<String>{'PC00012', 'PC00011', 'PC00001_Depre', 'PC00005', 'PC00009', 'PC00001'};
        for(String prd:prdToFormalization){
            prdAssistFormalization.add(new Dwp_FormalizationProducts_AAC__c(Name=prd, Product_Code__c=prd));
        }
        insert prdAssistFormalization;
        User u = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId()];
        /*Crea Asistente Operativo*/
        String perfil=[SELECT Id FROM Profile WHERE name='Operativo'].Id;
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
        String perfilExecutive=[SELECT Id FROM Profile WHERE name='Ejecutivo'].Id;
        mapFields=new Map<Schema.SObjectField, Object>{User.ProfileId => perfilExecutive, User.prof_position_type__c => 'EJECUTIVO BEC', User.isActive => true};
        User userExecutive = TestFactory.getUser(true, mapFields);
        //Create Account's
        Account acc;
        System.runAs(u){ 
            mapFields=new Map<Schema.SObjectField, Object>{Account.OwnerId => userExecutive.Id, Account.Name => 'CLIENTE OPORTUNIDAD'};
            acc = TestFactory.getAccount(true, mapFields);
            
            //Crear Oportunidad con Producto - 1
            Opportunity testOP= new Opportunity(Name='TEST Formalization', stageName='02', AccountId=acc.Id, CloseDate=Date.today(), Amount = 10000, OwnerId = userExecutive.Id);
            insert testOP;
            
            Product2 testPr = new Product2(Name='TestProd', type_of_quote__c='COTIZADOR', ProductCode='PC00012');
            insert testPr;
            
            Pricebook2 testPB = new Pricebook2(CurrencyIsoCode='PEN', Name='MyPrice');
            insert testPB;
            Id pricebookId = Test.getStandardPricebookId();
    
            PricebookEntry testPE = new PricebookEntry(UnitPrice=120, CurrencyIsoCode='PEN', Pricebook2Id=pricebookId, Product2Id=testPr.Id, IsActive=true);
            insert testPE;
            
            OpportunityLineItem testLOPP = new OpportunityLineItem(TotalPrice=120, OpportunityId=testOP.Id, PricebookEntryId=testPE.Id, Quantity=1, gipr_Tipo_Garantia__c='03', 
                                                                  Product2Id=testPr.Id);
            insert testLOPP;
        }
    }
    
    @isTest
    public static void validateAssistant_Error_Test(){
        User ejecutivo = [SELECT ID FROM User WHERE prof_position_type__c='EJECUTIVO BEC' limit 1];
        Opportunity opp = [SELECT ID FROM Opportunity WHERE Name = 'TEST Formalization' limit 1];
        Map<String, Object> mapRes;
        System.runAs(ejecutivo){
            Product_cls.setFormalization(opp.Id,'btnApprove','Comentarios de envio a formalización','obs');
        }
        Test.startTest();
        mapRes = AssistantFormalization_helper.validateAssistant(opp.Id);  
        Test.stopTest();
        System.assertEquals(true, mapRes.get('isError'), 'El resultado del metodo debería ser True');
    }
    
    @isTest
    public static void validateAssistant_Success_Test(){
        User ejecutivo = [SELECT ID FROM User WHERE prof_position_type__c='EJECUTIVO BEC' limit 1];
        Opportunity opp = [SELECT ID FROM Opportunity WHERE Name = 'TEST Formalization' limit 1];
        System.runAs(ejecutivo){
            Product_cls.setFormalization(opp.Id,'btnApprove','Comentarios de envio a formalización','obs');
        }
        User asistente = [SELECT ID FROM User WHERE prof_position_type__c='ASISTENTE BEC' limit 1];
        Map<String, Object> mapRes;
        System.runAs(asistente){
         	mapRes = AssistantFormalization_helper.validateAssistant(opp.Id);   
        }
        System.assertEquals(false, mapRes.get('isError'), 'Fail');
    }
    
    @isTest
    public static void reasignCase_Assistant_Error_Test(){
        User ejecutivo = [SELECT ID FROM User WHERE prof_position_type__c='EJECUTIVO BEC' limit 1];
        Opportunity opp = [SELECT ID FROM Opportunity WHERE Name = 'TEST Formalization' limit 1];
        System.runAs(ejecutivo){
            Product_cls.setFormalization(opp.Id,'btnApprove','Comentarios de envio a formalización','obs');
        }
        User asistente = [SELECT ID FROM User WHERE prof_position_type__c='ASISTENTE BEC' limit 1];
        delete [SELECT Id FROM GroupMember WHERE UserOrGroupId=:asistente.Id];
        Map<String, Object> mapRes;
        System.runAs(asistente){
         	mapRes = AssistantFormalization_helper.reasignCaseFromOpp(opp.Id);
        }
        System.assertEquals(true, mapRes.get('isError'), 'Fail');
    }
    
    @isTest
    public static void reasignCase_Assistant_Success_Test(){
        User us = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId()];
        Map<String, Object> mapRes;
        User[] usuarios;
        User ejecutivo, asistente;
        Opportunity opp = [SELECT ID FROM Opportunity WHERE Name = 'TEST Formalization' limit 1];
        usuarios = [SELECT ID, prof_position_type__c FROM User WHERE prof_position_type__c IN ('ASISTENTE BEC', 'EJECUTIVO BEC') limit 2];
        for(User u:usuarios){
            if(u.prof_position_type__c == 'ASISTENTE BEC'){
                asistente = u;
            }else if(u.prof_position_type__c == 'EJECUTIVO BEC'){
                ejecutivo = u;
            }
        }
        System.runAs(ejecutivo){
            Product_cls.setFormalization(opp.Id,'btnApprove','Comentarios de envio a formalización','obs');           
        }
        System.runAs(us){
            Formalization_Helper_tst.setFormalizationGroupAssistant();
        }
        
        Test.startTest();
        System.runAs(asistente){
         	mapRes = AssistantFormalization_helper.reasignCaseFromOpp(opp.Id);
        }
        Test.stopTest();
        System.assertEquals(false, mapRes.get('isError'), 'Fail');
    }
    
    @isTest
    public static void getData_Assistant_Success_Test(){
        User admin = [SELECT ID FROM User WHERE Id=:UserInfo.getUserId()];
        Opportunity opp = [SELECT ID FROM Opportunity WHERE Name = 'TEST Formalization' limit 1];
        System.runAs(admin){
            Product_cls.setFormalization(opp.Id,'btnApprove','Comentarios de envio a formalización','obs');
			Formalization_Helper_tst.setFormalizationGroupAssistant();
        }
        User asistente = [SELECT ID FROM User WHERE prof_position_type__c='ASISTENTE BEC' limit 1];
        Map<String, Object> mapRes;
        Test.startTest();
        System.runAs(asistente){
            AssistantFormalization_helper.reasignCaseFromOpp(opp.Id);
         	mapRes = AssistantFormalization_helper.getData(opp.Id);   
        }
        Test.stopTest();
        System.assertEquals(false, mapRes.get('isError'), 'Fail');
    }
    
    @isTest
    public static void sentToFormalize_STF_Test(){
        Map<String, Object> data = new Map<String, Object>{'option' => 'sentToFormalize', 'contractNumber' => '0011-1234-1234567890', 'comments' => 'comentarios'};
        User admin = [SELECT ID FROM User WHERE Id=:UserInfo.getUserId()];
        Opportunity opp = [SELECT ID FROM Opportunity WHERE Name = 'TEST Formalization' limit 1];
        System.runAs(admin){
            Product_cls.setFormalization(opp.Id,'btnApprove','Comentarios de envio a formalización','obs');
			Formalization_Helper_tst.setFormalizationGroupAssistant();
        }
        User asistente = [SELECT ID FROM User WHERE prof_position_type__c='ASISTENTE BEC' limit 1];
        Test.startTest();
        System.runAs(asistente){
            AssistantFormalization_helper.reasignCaseFromOpp(opp.Id);
         	AssistantFormalization_helper.sentToFormalize(opp.Id, JSON.serialize(data));
        }
        Test.stopTest();
        Case caso = [SELECT ID, status FROM Case WHERE opportunity_id__c=:opp.Id limit 1];
        System.assertEquals('07', caso.status, 'Fail');
    }
    
    @isTest
    public static void sentToFormalize_STF_ValidationError_Test(){
        Map<String, Object> data = new Map<String, Object>{'option' => 'sentToFormalize', 'contractNumber' => '0011-1234-12567890', 'comments' => 'comentarios'};
        User admin = [SELECT ID FROM User WHERE Id=:UserInfo.getUserId()];
        Opportunity opp = [SELECT ID FROM Opportunity WHERE Name = 'TEST Formalization' limit 1];
        System.runAs(admin){
            Product_cls.setFormalization(opp.Id,'btnApprove','Comentarios de envio a formalización','obs');
			Formalization_Helper_tst.setFormalizationGroupAssistant();
        }
        User asistente = [SELECT ID FROM User WHERE prof_position_type__c='ASISTENTE BEC' limit 1];
        Map<String, Object> mapRes;
        Test.startTest();
        System.runAs(asistente){
            AssistantFormalization_helper.reasignCaseFromOpp(opp.Id);
         	mapRes = AssistantFormalization_helper.sentToFormalize(opp.Id, JSON.serialize(data));   
        }
        Test.stopTest();
        System.assertEquals(true, mapRes.get('isError'), 'Fail');
    }
    
    @isTest
    public static void sentToFormalize_RBD_Test(){
        Map<String, Object> data = new Map<String, Object>{'option' => 'returnByDocumentation', 'devolutionReason' => '08', 'comments' => 'comentarios'};
        User admin = [SELECT ID FROM User WHERE Id=:UserInfo.getUserId()];
        Opportunity opp = [SELECT ID FROM Opportunity WHERE Name = 'TEST Formalization' limit 1];
        System.runAs(admin){
            Product_cls.setFormalization(opp.Id,'btnApprove','Comentarios de envio a formalización','obs');
			Formalization_Helper_tst.setFormalizationGroupAssistant();
        }
        User asistente = [SELECT ID FROM User WHERE prof_position_type__c='ASISTENTE BEC' limit 1];
        Test.startTest();
        System.runAs(asistente){
            AssistantFormalization_helper.reasignCaseFromOpp(opp.Id);
            AssistantFormalization_helper.sentToFormalize(opp.Id, JSON.serialize(data));   
        }
        Test.stopTest();
        Case caso = [SELECT ID, status FROM Case WHERE opportunity_id__c=:opp.Id limit 1];
        System.assertEquals('06', caso.status, 'Fail');
    }
    
    @isTest
    public static void sentToFormalize_RBD_ValidationERROR_Test(){
        Map<String, Object> data = new Map<String, Object>{'option' => 'returnByDocumentation', 'devolutionReason' => '10', 'comments' => 'comentarios'};
        User admin = [SELECT ID FROM User WHERE Id=:UserInfo.getUserId()];
        Opportunity opp = [SELECT ID FROM Opportunity WHERE Name = 'TEST Formalization' limit 1];
        System.runAs(admin){
            Product_cls.setFormalization(opp.Id,'btnApprove','Comentarios de envio a formalización','obs');
			Formalization_Helper_tst.setFormalizationGroupAssistant();
        }
        User asistente = [SELECT ID FROM User WHERE prof_position_type__c='ASISTENTE BEC' limit 1];
        Map<String, Object> mapRes;
        Test.startTest();
        System.runAs(asistente){
            AssistantFormalization_helper.reasignCaseFromOpp(opp.Id);
         	mapRes = AssistantFormalization_helper.sentToFormalize(opp.Id, JSON.serialize(data));   
        }
        Test.stopTest();
        System.assertEquals(true, mapRes.get('isError'), 'Fail');
    }
    
    @isTest
    public static void sentToFormalize_ERROR_Test(){
        Map<String, Object> data = new Map<String, Object>{'option' => 'wrongValue', 'devolutionReason' => '08', 'comments' => 'comentarios'};
        User admin = [SELECT ID FROM User WHERE Id=:UserInfo.getUserId()];
        Opportunity opp = [SELECT ID FROM Opportunity WHERE Name = 'TEST Formalization' limit 1];
        System.runAs(admin){
            Product_cls.setFormalization(opp.Id,'btnApprove','Comentarios de envio a formalización','obs');
			Formalization_Helper_tst.setFormalizationGroupAssistant();
        }
        User asistente = [SELECT ID FROM User WHERE prof_position_type__c='ASISTENTE BEC' limit 1];
        Map<String, Object> mapRes;
        Test.startTest();
        System.runAs(asistente){
            AssistantFormalization_helper.reasignCaseFromOpp(opp.Id);
         	mapRes = AssistantFormalization_helper.sentToFormalize(opp.Id, JSON.serialize(data));   
        }
        Test.stopTest();
        System.assertEquals(true, mapRes.get('isError'), 'Fail');
    }
    
    @isTest
    public static void validateAssistant_Success_Test_Assigned(){
        User ejecutivo = [SELECT ID FROM User WHERE prof_position_type__c='EJECUTIVO BEC' limit 1];
        Opportunity opp = [SELECT ID FROM Opportunity WHERE Name = 'TEST Formalization' limit 1];
        System.runAs(ejecutivo){
            Product_cls.setFormalization(opp.Id,'btnApprove','Comentarios de envio a formalización','obs');
        }
        Formalization_Helper_tst.setFormalizationGroupAssistant();
        User asistente = [SELECT ID, Name FROM User WHERE prof_position_type__c='ASISTENTE BEC' limit 1];
        System.runAs(asistente){
            AssistantFormalization_helper.reasignCaseFromOpp(opp.Id);
        }
        User asistente2 = [SELECT ID, Name FROM User WHERE prof_position_type__c='ASISTENTE BEC 2' limit 1];
        System.debug('asistente2 => '+asistente2);
        Map<String, Object> mapRes;
        Test.startTest();
        System.runAs(asistente2){ 
            mapRes = AssistantFormalization_helper.reasignCaseFromOpp(opp.Id);
        }
        Test.stopTest();
        System.assertEquals(false, mapRes.get('isError'), 'Fail');
    }
    
    @isTest
    public static void validateAssistant_Success_Test_Agree(){
        User ejecutivo = [SELECT ID FROM User WHERE prof_position_type__c='EJECUTIVO BEC' limit 1];
        Opportunity opp = [SELECT ID FROM Opportunity WHERE Name = 'TEST Formalization' limit 1];
        System.runAs(ejecutivo){
            Product_cls.setFormalization(opp.Id,'btnApprove','Comentarios de envio a formalización','obs');
        }
        Formalization_Helper_tst.setFormalizationGroupAssistant();
        User asistente = [SELECT ID, Name FROM User WHERE prof_position_type__c='ASISTENTE BEC' limit 1];
        Map<String, Object> mapRes;
        System.runAs(asistente){
            AssistantFormalization_helper.reasignCaseFromOpp(opp.Id);
            Test.startTest();
            mapRes = AssistantFormalization_helper.validateAssistant(opp.Id);  
            Test.stopTest();
        }
        System.assertEquals(false, mapRes.get('isError'), 'Fail');
    }
    
    @isTest
    public static void createOrUpdateCase_Update_Success_Test(){
        Map<String, Object> data = new Map<String, Object>{'option' => 'returnByDocumentation', 'devolutionReason' => '08', 'comments' => 'comentarios'};
        User admin = [SELECT ID FROM User WHERE Id=:UserInfo.getUserId()];
        Opportunity opp = [SELECT ID FROM Opportunity WHERE Name = 'TEST Formalization' limit 1];
        System.runAs(admin){
            Product_cls.setFormalization(opp.Id,'btnApprove','Comentarios de envio a formalización','obs');
			Formalization_Helper_tst.setFormalizationGroupAssistant();
        }
        User asistente = [SELECT ID FROM User WHERE prof_position_type__c='ASISTENTE BEC' limit 1];
        System.runAs(asistente){
            AssistantFormalization_helper.reasignCaseFromOpp(opp.Id);
            AssistantFormalization_helper.sentToFormalize(opp.Id, JSON.serialize(data));   
        }
        System.runAs(admin){
            Product_cls.setFormalization(opp.Id,'btnApprove','Comentarios de envio a formalización','obs');
        }
        Case caso = [SELECT ID, status FROM Case WHERE opportunity_id__c=:opp.Id limit 1];
        System.assertEquals('05', caso.status, 'Fail');
    }
    
}