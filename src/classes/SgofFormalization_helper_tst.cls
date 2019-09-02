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

    @testSetup
    public static void setup(){
        Dwp_FormalizationProducts_AAC__c[] prdAssistFormalization = new Dwp_FormalizationProducts_AAC__c[]{};
        Set<String> prdToFormalization = new Set<String>{'PC00012', 'PC00011', 'PC00001_Depre', 'PC00005', 'PC00009', 'PC00001'};
        for(String prd:prdToFormalization){
            prdAssistFormalization.add(new Dwp_FormalizationProducts_AAC__c(Name=prd, Product_Code__c=prd));
        }
        insert prdAssistFormalization;
        User u = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId()];
        /*Crea Asistente Operativo*/
        String perfil=[SELECT Id FROM Profile WHERE name='Operativo'].Id;
        Map<Schema.SObjectField, Object> mapFields=new Map<Schema.SObjectField, Object>{User.ProfileId => perfil, User.prof_position_type__c => 'ASISTENTE BEC 2'};
        User userAsistant=TestFactory.getUser(true, mapFields);
        userAsistant.prof_position_id__c = 'E06';
        update userAsistant;
        /*Crea Subgerente Operativo*/
        mapFields.put(User.prof_position_type__c, 'SUBGERENTE BEC 2');
        User userSgof=TestFactory.getUser(true, mapFields);
        userSgof.prof_position_id__c = 'E04';
        update userSgof;
        /*Crea Ejecutivo*/
        String perfilExecutive=[SELECT Id FROM Profile WHERE name='Ejecutivo'].Id;
        mapFields=new Map<Schema.SObjectField, Object>{User.ProfileId => perfilExecutive, User.prof_position_type__c => 'EJECUTIVO BEC 2', User.isActive => true};
        User userExecutive = TestFactory.getUser(true, mapFields);
        //Create data for process
        System.runAs(u){ 
            mapFields=new Map<Schema.SObjectField, Object>{Account.OwnerId => userExecutive.Id, Account.Name => 'CLIENTE OPORTUNIDAD SGOF'};
            Account acc = TestFactory.getAccount(true, mapFields);
            
            //Crear Oportunidad con Producto - 1
            Opportunity testOP= new Opportunity(Name='TEST Formalization Sgof', stageName='02', AccountId=acc.Id, CloseDate=Date.today(), Amount = 10000, OwnerId = userExecutive.Id);
            insert testOP;
            
            Product2 testPr = new Product2(Name='TestProd 2', type_of_quote__c='COTIZADOR');
            insert testPr;
            
            Pricebook2 testPB = new Pricebook2(CurrencyIsoCode='PEN', Name='MyPrice 2');
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
    public static void validateSgof_Error_Test(){
        User ejecutivo = [SELECT ID FROM User WHERE prof_position_type__c='EJECUTIVO BEC 2' limit 1];
        Opportunity opp = [SELECT ID FROM Opportunity WHERE Name = 'TEST Formalization Sgof' limit 1];
        Map<String, Object> mapRes;
        System.runAs(ejecutivo){
            Product_cls.setFormalization(opp.Id,'btnApprove','Comentarios de envio a formalización','obs');
        }
        Test.startTest();
        mapRes = SgofFormalization_helper.validateSGof(opp.Id);  
        Test.stopTest();
        System.assertEquals(true, mapRes.get('isError'), 'El resultado del metodo debería ser True');
    }
    
    @isTest
    public static void validateSgof_Success_Test(){
        User ejecutivo = [SELECT ID FROM User WHERE prof_position_type__c='EJECUTIVO BEC 2' limit 1];
        Opportunity opp = [SELECT ID FROM Opportunity WHERE Name = 'TEST Formalization Sgof' limit 1];
        System.runAs(ejecutivo){
            Product_cls.setFormalization(opp.Id,'btnApprove','Comentarios de envio a formalización','obs');
        }
        User subgerente = [SELECT ID FROM User WHERE prof_position_type__c='SUBGERENTE BEC 2' limit 1];
        Map<String, Object> mapRes;
        System.runAs(subgerente){
         	mapRes = SgofFormalization_helper.validateSGof(opp.Id);
        }
        System.assertEquals(false, mapRes.get('isError'), 'Fail');
    }
    
    @isTest
    public static void reasignCase_Sgof_Error_Test(){
        User ejecutivo = [SELECT ID FROM User WHERE prof_position_type__c='EJECUTIVO BEC 2' limit 1];
        Opportunity opp = [SELECT ID FROM Opportunity WHERE Name = 'TEST Formalization Sgof' limit 1];
        System.runAs(ejecutivo){
            Product_cls.setFormalization(opp.Id,'btnApprove','Comentarios de envio a formalización','obs');
        }
        User subgerente = [SELECT ID FROM User WHERE prof_position_type__c='SUBGERENTE BEC 2' limit 1];
        delete [SELECT Id FROM GroupMember WHERE UserOrGroupId=:subgerente.Id];
        Map<String, Object> mapRes;
        System.runAs(subgerente){
         	mapRes = SgofFormalization_helper.reasignCaseFromOpp(opp.Id);
        }
        System.assertEquals(true, mapRes.get('isError'), 'Fail');
    }
    
    @isTest
    public static void reasignCase_Sgof_Success_Test(){
        User us = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId()];
        User[] usuarios;
        User ejecutivo, subgerente;
        Opportunity opp = [SELECT ID FROM Opportunity WHERE Name = 'TEST Formalization Sgof' limit 1];
        usuarios = [SELECT ID, prof_position_type__c FROM User WHERE prof_position_type__c IN ('SUBGERENTE BEC 2', 'EJECUTIVO BEC 2') limit 2];
        for(User u:usuarios){
            if(u.prof_position_type__c == 'SUBGERENTE BEC 2'){
                subgerente = u;
            }else if(u.prof_position_type__c == 'EJECUTIVO BEC 2'){
                ejecutivo = u;
            }
        }
        System.runAs(ejecutivo){
            Product_cls.setFormalization(opp.Id,'btnApprove','Comentarios de envio a formalización','obs');           
        }
        System.runAs(us){
            setFormalizationGroupAssistant();
        }
        Map<String, Object> mapRes;
        Test.startTest();
        System.runAs(subgerente){
         	mapRes = SgofFormalization_helper.reasignCaseFromOpp(opp.Id);
        }
        Test.stopTest();
        System.assertEquals(false, mapRes.get('isError'), 'Fail');
    }
    
    @isTest
    public static void getData_Assistant_Success_Test(){
        User admin = [SELECT ID FROM User WHERE Id=:UserInfo.getUserId()];
        Opportunity opp = [SELECT ID FROM Opportunity WHERE Name = 'TEST Formalization Sgof' limit 1];
        System.runAs(admin){
            Product_cls.setFormalization(opp.Id,'btnApprove','Comentarios de envio a formalización','obs');
			setFormalizationGroupAssistant();
        }
        User subgerente = [SELECT ID FROM User WHERE prof_position_type__c='SUBGERENTE BEC 2' limit 1];
        Map<String, Object> mapRes;
        Test.startTest();
        System.runAs(subgerente){
            SgofFormalization_helper.reasignCaseFromOpp(opp.Id);
         	mapRes = SgofFormalization_helper.getData(opp.Id);   
        }
        Test.stopTest();
        System.assertEquals(false, mapRes.get('isError'), 'Fail');
    }
    
    @isTest
    public static void sentToFormalize_STF_Test(){
        Map<String, Object> data = new Map<String, Object>{'option' => 'sentToFormalize', 'contractNumber' => '0011-1234-1234567890', 'comments' => 'comentarios'};
        User admin = [SELECT ID FROM User WHERE Id=:UserInfo.getUserId()];
        Opportunity opp = [SELECT ID FROM Opportunity WHERE Name = 'TEST Formalization Sgof' limit 1];
        System.runAs(admin){
            Product_cls.setFormalization(opp.Id,'btnApprove','Comentarios de envio a formalización','obs');
			setFormalizationGroupAssistant();
        }
        User subgerente = [SELECT ID FROM User WHERE prof_position_type__c='SUBGERENTE BEC 2' limit 1];
        Test.startTest();
        System.runAs(subgerente){
            SgofFormalization_helper.reasignCaseFromOpp(opp.Id);
         	SgofFormalization_helper.sentToFormalize(opp.Id, JSON.serialize(data));
        }
        Test.stopTest();
        Case caso = [SELECT ID, status FROM Case WHERE opportunity_id__c=:opp.Id limit 1];
        System.assertEquals('10', caso.status, 'Fail');
    }
    
    @isTest
    public static void sentToFormalize_STF_ValidationError_Test(){
        Map<String, Object> data = new Map<String, Object>{'option' => 'sentToFormalize', 'contractNumber' => '0011-1234-12567890', 'comments' => 'comentarios'};
        User admin = [SELECT ID FROM User WHERE Id=:UserInfo.getUserId()];
        Opportunity opp = [SELECT ID FROM Opportunity WHERE Name = 'TEST Formalization Sgof' limit 1];
        System.runAs(admin){
            Product_cls.setFormalization(opp.Id,'btnApprove','Comentarios de envio a formalización','obs');
			setFormalizationGroupAssistant();
        }
        User subgerente = [SELECT ID FROM User WHERE prof_position_type__c='SUBGERENTE BEC 2' limit 1];
        Map<String, Object> mapRes;
        Test.startTest();
        System.runAs(subgerente){
            SgofFormalization_helper.reasignCaseFromOpp(opp.Id);
         	mapRes = SgofFormalization_helper.sentToFormalize(opp.Id, JSON.serialize(data));   
        }
        Test.stopTest();
        System.assertEquals(false, mapRes.get('success'), 'Fail');
    }
    
    @isTest
    public static void sentToFormalize_RBD_Test(){
        Map<String, Object> data = new Map<String, Object>{'option' => 'returnByDocumentation', 'devolutionReason' => '08', 'comments' => 'comentarios'};
        User admin = [SELECT ID FROM User WHERE Id=:UserInfo.getUserId()];
        Opportunity opp = [SELECT ID FROM Opportunity WHERE Name = 'TEST Formalization Sgof' limit 1];
        System.runAs(admin){
            Product_cls.setFormalization(opp.Id,'btnApprove','Comentarios de envio a formalización','obs');
			setFormalizationGroupAssistant();
        }
        User subgerente = [SELECT ID FROM User WHERE prof_position_type__c='SUBGERENTE BEC 2' limit 1];
        Test.startTest();
        System.runAs(subgerente){
            SgofFormalization_helper.reasignCaseFromOpp(opp.Id);
            SgofFormalization_helper.sentToFormalize(opp.Id, JSON.serialize(data));   
        }
        Test.stopTest();
        Case caso = [SELECT ID, status FROM Case WHERE opportunity_id__c=:opp.Id limit 1];
        System.assertEquals('06', caso.status, 'Fail');
    }
    
    @isTest
    public static void sentToFormalize_RBD_ValidationERROR_Test(){
        Map<String, Object> data = new Map<String, Object>{'option' => 'returnByDocumentation', 'devolutionReason' => '10', 'comments' => 'comentarios'};
        User admin = [SELECT ID FROM User WHERE Id=:UserInfo.getUserId()];
        Opportunity opp = [SELECT ID FROM Opportunity WHERE Name = 'TEST Formalization Sgof' limit 1];
        System.runAs(admin){
            Product_cls.setFormalization(opp.Id,'btnApprove','Comentarios de envio a formalización','obs');
			setFormalizationGroupAssistant();
        }
        User subgerente = [SELECT ID FROM User WHERE prof_position_type__c='SUBGERENTE BEC 2' limit 1];
        Map<String, Object> mapRes;
        Test.startTest();
        System.runAs(subgerente){
            SgofFormalization_helper.reasignCaseFromOpp(opp.Id);
         	mapRes = SgofFormalization_helper.sentToFormalize(opp.Id, JSON.serialize(data));   
        }
        Test.stopTest();
        System.assertEquals(false, mapRes.get('success'), 'Fail');
    }
    
    @isTest
    public static void sentToFormalize_ERROR_Test(){
        Map<String, Object> data = new Map<String, Object>{'option' => 'wrongValue', 'devolutionReason' => '08', 'comments' => 'comentarios'};
        User admin = [SELECT ID FROM User WHERE Id=:UserInfo.getUserId()];
        Opportunity opp = [SELECT ID FROM Opportunity WHERE Name = 'TEST Formalization Sgof' limit 1];
        System.runAs(admin){
            Product_cls.setFormalization(opp.Id,'btnApprove','Comentarios de envio a formalización','obs');
			setFormalizationGroupAssistant();
        }
        User subgerente = [SELECT ID FROM User WHERE prof_position_type__c='SUBGERENTE BEC 2' limit 1];
        Map<String, Object> mapRes;
        Test.startTest();
        System.runAs(subgerente){
            SgofFormalization_helper.reasignCaseFromOpp(opp.Id);
         	mapRes = SgofFormalization_helper.sentToFormalize(opp.Id, JSON.serialize(data));   
        }
        Test.stopTest();
        System.assertEquals(false, mapRes.get('success'), 'Fail');
    }
    
    public static void setFormalizationGroupAssistant(){
        Group grupo = [SELECT ID, developerName FROM Group WHERE DeveloperName IN ('Asistentes_Operativos') limit 1];
        User asistente = [SELECT ID, Name FROM User WHERE prof_position_type__c='ASISTENTE BEC 2' limit 1];
        System.debug('asistente => '+asistente);
        GroupMember grm = new GroupMember(GroupId=grupo.Id, UserOrGroupId=asistente.Id);
        insert grm;
    }
    
    public static void setFormalizationGroupSubgerente(){
        Group grupo = [SELECT ID, developerName FROM Group WHERE DeveloperName IN ('Subgerentes_Operativos') limit 1];
        User subgerente = [SELECT ID FROM User WHERE prof_position_type__c='SUBGERENTE BEC 2' limit 1];
        GroupMember grm = new GroupMember(GroupId=grupo.Id, UserOrGroupId=subgerente.Id);
        insert grm;
    }
}