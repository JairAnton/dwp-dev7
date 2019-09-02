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
        Map<Schema.SObjectField, Object> mapFields=new Map<Schema.SObjectField, Object>{User.ProfileId => perfil, User.prof_position_type__c => 'ASISTENTE BEC'/*, User.prof_position_id__c => 'E06'*/};
        User userAsistant=TestFactory.getUser(true, mapFields);
        userAsistant.prof_position_id__c = 'E06';
        update userAsistant;

        mapFields.put(User.prof_position_type__c, 'SUBGERENTE BEC');
        User userSgof=TestFactory.getUser(true, mapFields);
        userSgof.prof_position_id__c = 'E04';
        update userSgof;
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
            //Opp 2
            Opportunity testOP2= new Opportunity(Name='TEST Formalization 2', stageName='02', AccountId=acc.Id, CloseDate=Date.today(), Amount = 10000, OwnerId = userExecutive.Id);
            insert testOP2;
            
            Product2 testPr = new Product2(Name='TestProd', type_of_quote__c='COTIZADOR', ProductCode='PC00012');
            insert testPr;
            //product 2
            Product2 testPr2 = new Product2(Name='TestProd', type_of_quote__c='COTIZADOR');
            insert testPr2;
            
            Pricebook2 testPB = new Pricebook2(CurrencyIsoCode='PEN', Name='MyPrice');
            insert testPB;
            Id pricebookId = Test.getStandardPricebookId();
    
            PricebookEntry testPE = new PricebookEntry(UnitPrice=120, CurrencyIsoCode='PEN', Pricebook2Id=pricebookId, Product2Id=testPr.Id, IsActive=true);
            insert testPE;
            
            PricebookEntry testPE2 = new PricebookEntry(UnitPrice=120, CurrencyIsoCode='PEN', Pricebook2Id=pricebookId, Product2Id=testPr2.Id, IsActive=true);
            insert testPE2;
            
            OpportunityLineItem testLOPP = new OpportunityLineItem(TotalPrice=120, OpportunityId=testOP.Id, PricebookEntryId=testPE.Id, Quantity=1, gipr_Tipo_Garantia__c='03', 
                                                                  Product2Id=testPr.Id);
            insert testLOPP;
            
            OpportunityLineItem testLOPP2 = new OpportunityLineItem(TotalPrice=120, OpportunityId=testOP2.Id, PricebookEntryId=testPE2.Id, Quantity=1, gipr_Tipo_Garantia__c='03', 
                                                                  Product2Id=testPr2.Id);
            insert testLOPP2;
        }
    }
    
    @isTest
    public static void createCase_Sgof_Success_Test(){
        User u = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId()];
    	User ejecutivo = [SELECT ID FROM User WHERE prof_position_type__c='EJECUTIVO BEC' limit 1];
        Opportunity opp = [SELECT ID FROM Opportunity WHERE Name = 'TEST Formalization' limit 1];
        String res;
        Test.startTest();
        System.runAs(ejecutivo){
            res = Product_cls.setFormalization(opp.Id,'btnApprove','Comentarios de envio a formalización','obs');
        }
        Test.stopTest();
        Case[] lstCases = [SELECT Id, status FROM Case WHERE RecordType.Name='Formalization' AND opportunity_id__c=:opp.Id];
        System.assertEquals(1, lstCases.size(), 'Fail');
    }
    
    @isTest
    public static void createCase_Assistant_Success_Test(){
    	User ejecutivo = [SELECT ID FROM User WHERE prof_position_type__c='EJECUTIVO BEC' limit 1];
        Opportunity opp = [SELECT ID FROM Opportunity WHERE Name = 'TEST Formalization' limit 1];
        String res;
        Test.startTest();
        System.runAs(ejecutivo){
            res = Product_cls.setFormalization(opp.Id,'btnApprove','Comentarios de envio a formalización','obs');
        }
        Test.stopTest();
        Case[] lstCases = [SELECT Id, status FROM Case WHERE RecordType.Name='Formalization' AND opportunity_id__c=:opp.Id];
        System.assertEquals(1, lstCases.size(), 'Fail');
    }
    
    @isTest
    public static void sendProductUnit_Success_Test(){      
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'TEST Formalization' limit 1];
        Map<String, Object> mapRes;
        Test.startTest();
        mapRes = Formalization_helper.sendProductUnit(opp.Id);
        Test.stopTest();
        System.assertEquals(false, mapRes.get('isError'), 'Fail');
    }
    
    @isTest
    public static void sendProductUnit_Error_Test(){
        Id nullId;
        Map<String, Object> mapRes;
        Test.startTest();
        mapRes = Formalization_helper.sendProductUnit(nullId);
        Test.stopTest();
        System.assertEquals(true, mapRes.get('isError'), 'Fail');
    }
    
    @isTest
    public static void reasignCase_Assistant_Test(){
        User ejecutivo = [SELECT ID FROM User WHERE prof_position_type__c='EJECUTIVO BEC' limit 1];
        Opportunity opp = [SELECT ID FROM Opportunity WHERE Name = 'TEST Formalization' limit 1];
        System.runAs(ejecutivo){
            Product_cls.setFormalization(opp.Id,'btnApprove','Comentarios de envio a formalización','obs');
        }
        User asistente = [SELECT ID, Name FROM User WHERE prof_position_type__c='ASISTENTE BEC' limit 1];
        Case caso = [SELECT ID FROM Case WHERE opportunity_id__c=:opp.Id limit 1];
        Map<String, Object> mapRes = new Map<String, Object>();
        System.runAs(asistente){
            mapRes = Formalization_helper.reasignCase(caso.Id);
        }
        System.assertEquals(false, mapRes.get('isError'), 'Fail');
    }
    
    @isTest
    public static void reasignCase_Sgof_Test(){
        User ejecutivo = [SELECT ID FROM User WHERE prof_position_type__c='EJECUTIVO BEC' limit 1];
        Opportunity opp = [SELECT ID FROM Opportunity WHERE Name = 'TEST Formalization 2' limit 1];
        System.runAs(ejecutivo){
            Product_cls.setFormalization(opp.Id,'btnApprove','Comentarios de envio a formalización','obs');
        }
        setFormalizationGroupSubgerente();
        User subgerente = [SELECT ID, Name FROM User WHERE prof_position_type__c='SUBGERENTE BEC' limit 1];
        Case caso = [SELECT ID FROM Case WHERE opportunity_id__c=:opp.Id limit 1];
        Map<String, Object> mapRes = new Map<String, Object>();
        System.runAs(subgerente){
            mapRes = Formalization_helper.reasignCase(caso.Id);
        }
        System.assertEquals(false, mapRes.get('isError'), 'Fail');
    }
    
    @isTest
    public static void condition6_Success_Test(){
        Map<String, Object> mapRes = new Map<String, Object>();
        User ejecutivo = [SELECT ID FROM User WHERE prof_position_type__c='EJECUTIVO BEC' limit 1];
        Opportunity opp = [SELECT ID FROM Opportunity WHERE Name = 'TEST Formalization' limit 1];
        System.runAs(ejecutivo){
            Product_cls.setFormalization(opp.Id,'btnApprove','Comentarios de envio a formalización','obs');
        }
        User asistente = [SELECT ID, Name FROM User WHERE prof_position_type__c='ASISTENTE BEC' limit 1];
        delete [SELECT Id, Group.DeveloperName FROM GroupMember WHERE UserOrGroupId=:asistente.id];
        Case caso = [SELECT Id FROM Case WHERE RecordType.DeveloperName = 'Formalization'];
        Boolean validate;
        Test.startTest();
        System.runAs(asistente){
            validate = PrincipalValidationHub.Condition6(caso.id);
        }
        Test.stopTest();
        System.assertEquals(true, validate, 'Fail assertion');
    }
    
    @isTest
    public static void condition6_Error_Test(){
        Map<String, Object> mapRes = new Map<String, Object>();
        User ejecutivo = [SELECT ID FROM User WHERE prof_position_type__c='EJECUTIVO BEC' limit 1];
        Opportunity opp = [SELECT ID FROM Opportunity WHERE Name = 'TEST Formalization 2' limit 1];
        System.runAs(ejecutivo){
            Product_cls.setFormalization(opp.Id,'btnApprove','Comentarios de envio a formalización','obs');
        }
        User asistente = [SELECT ID, Name FROM User WHERE prof_position_type__c='ASISTENTE BEC' limit 1];
        Case caso = [SELECT Id FROM Case WHERE RecordType.DeveloperName = 'Formalization'];
        Boolean validate;
        Test.startTest();
        System.runAs(asistente){
            validate = PrincipalValidationHub.Condition6(caso.id);
        }
        Test.stopTest();
        System.assertEquals(false, validate, 'Fail assertion');
    }
    
    @isTest
    public static void condition7_Success_Test(){
        Map<String, Object> mapRes = new Map<String, Object>();
        User ejecutivo = [SELECT ID FROM User WHERE prof_position_type__c='EJECUTIVO BEC' limit 1];
        Opportunity opp = [SELECT ID FROM Opportunity WHERE Name = 'TEST Formalization' limit 1];
        System.runAs(ejecutivo){
            Product_cls.setFormalization(opp.Id,'btnApprove','Comentarios de envio a formalización','obs');
        }
        User asistente = [SELECT ID, Name FROM User WHERE prof_position_type__c='ASISTENTE BEC' limit 1];
        delete [SELECT Id, Group.DeveloperName FROM GroupMember WHERE UserOrGroupId=:asistente.id];
        Case caso = [SELECT Id FROM Case WHERE RecordType.DeveloperName = 'Formalization'];
        Boolean validate;
        Test.startTest();
        System.runAs(asistente){
            validate = PrincipalValidationHub.Condition7(caso.id);
        }
        Test.stopTest();
        System.assertEquals(true, validate, 'Fail assertion');
    }
    
    @isTest
    public static void condition7_Error_Test(){
        Map<String, Object> mapRes = new Map<String, Object>();
        User ejecutivo = [SELECT ID FROM User WHERE prof_position_type__c='EJECUTIVO BEC' limit 1];
        Opportunity opp = [SELECT ID FROM Opportunity WHERE Name = 'TEST Formalization' limit 1];
        System.runAs(ejecutivo){
            Product_cls.setFormalization(opp.Id,'btnApprove','Comentarios de envio a formalización','obs');
        }
        User asistente = [SELECT ID, Name FROM User WHERE prof_position_type__c='ASISTENTE BEC' limit 1];
        Case caso = [SELECT Id FROM Case WHERE RecordType.DeveloperName = 'Formalization'];
        Boolean validate;
        Test.startTest();
        System.runAs(asistente){
            validate = PrincipalValidationHub.Condition7(caso.id);
        }
        Test.stopTest();
        System.assertEquals(false, validate, 'Fail assertion');
    }
    
    public static void setFormalizationGroupAssistant(){
        Group grupo = [SELECT ID, developerName FROM Group WHERE DeveloperName IN ('Asistentes_Operativos') limit 1];
        User asistente = [SELECT ID, Name FROM User WHERE prof_position_type__c='ASISTENTE BEC' limit 1];
        System.debug('asistente => '+asistente);
        GroupMember grm = new GroupMember(GroupId=grupo.Id, UserOrGroupId=asistente.Id);
        insert grm;
    }
    
    public static void setFormalizationGroupSubgerente(){
        Group grupo = [SELECT ID, developerName FROM Group WHERE DeveloperName IN ('Subgerentes_Operativos') limit 1];
        User subgerente = [SELECT ID FROM User WHERE prof_position_type__c='SUBGERENTE BEC' limit 1];
        GroupMember grm = new GroupMember(GroupId=grupo.Id, UserOrGroupId=subgerente.Id);
        insert grm;
    }
    
    
}