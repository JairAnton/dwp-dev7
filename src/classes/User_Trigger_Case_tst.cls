/**
* ------------------------------------------------------------------------------------------------
* @Name User_Trigger_Case_tst
* @Author Diego Carbajal diego.carbajal.contractor@bbva.com
* @Date Created: 2019-09-02
* @Group 
* @Description Esta clase valida la funcionalidad de los metodos de la clase User_Trigger_Case_cls
* 
*/
@isTest
public class User_Trigger_Case_tst {

    /*Campo ASSERT_ERROR inicializado para soluciones del SonarQ*/
    public static Final String ASSERT_ERROR = 'Error with assertion';
    /*Campo POSITION_EXE inicializado para soluciones del SonarQ*/
    public static Final Set<String> GRP = new Set<String>{'Asistentes_Operativos', 'Subgerentes_Operativos'};
    /**
    * --------------------------------------------------------------------------------------
    * @Description 
    * Metodo que valida la funcionalidad de los metodos:
    * newMembersFormalizatio
    **/
    
    /* isTest - newMembersFormalizationTest */
    @isTest
    public static void newMembersFormalizationTest() {
        Final List<User> newUsers = new List<User>();
        Final String profile = [SELECT Id FROM Profile WHERE Name = 'Operativo'].Id;
        for(Integer i=0; i<20; i++) {
            if(i < 10) {
                newUsers.add(new User(LastName='User '+i, Username='User'+i+'@user.com.u', Email='User'+i+'@user.com.u', Alias=i+'uAas2', TimeZoneSidKey='America/Mexico_City',
                                 IsActive=true, LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='es', prof_position_id__c = 'E06', ProfileId=profile));
            } else {
                newUsers.add(new User(LastName='User '+i, Username='User'+i+'@user.com.u', Email='User'+i+'@user.com.u', Alias=i+'uAas2', TimeZoneSidKey='America/Mexico_City',
                                 IsActive=true, LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='es', prof_position_id__c = 'E04', ProfileId=profile));
            }
        }
        Test.startTest();
        insert newUsers;
        Test.stopTest();
        Final Integer newUsersInGroup = Database.countQuery('SELECT Count() FROM GroupMember WHERE UserOrGroupId IN:newUsers AND Group.DeveloperName IN: GRP');
        System.assertEquals(20, newUsersInGroup, ASSERT_ERROR);
    }
    
    /**
    * --------------------------------------------------------------------------------------
    * @Description 
    * Metodo que valida la funcionalidad de los metodos:
    * updFormalizationDeactiveOwners
    * changeRolAssis_Sgof
    **/
    @isTest
    public static void updFormalizationDeactiveOwnersTest() {
        Final List<User> newUsers = new List<User>();
        Final String profile = [SELECT Id FROM Profile WHERE Name = 'Operativo'].Id;
        for(Integer i=0; i<20; i++) {
            if(i < 10) {
                newUsers.add(new User(LastName='User '+i, Username='User'+i+'@user.com.u', Email='User'+i+'@user.com.u', Alias=i+'uAas2', TimeZoneSidKey='America/Mexico_City',
                                 IsActive=true, LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='es', prof_position_id__c = 'E06', ProfileId=profile));
            } else {
                newUsers.add(new User(LastName='User '+i, Username='User'+i+'@user.com.u', Email='User'+i+'@user.com.u', Alias=i+'uAas2', TimeZoneSidKey='America/Mexico_City',
                                 IsActive=true, LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='es', prof_position_id__c = 'E04', ProfileId=profile));
            }
        }
        insert newUsers;
        
        Final Map<Schema.SObjectField, Object> mapFields=new Map<Schema.SObjectField, Object>{Account.Name => 'CLIENTE OPORTUNIDAD'};
        Final Account acc = TestFactory.getAccount(true, mapFields);
        List<Opportunity> opps = new List<Opportunity>();
        List<Case> casos = new List<Case>();
        for(Integer i=0; i<20; i++) {
            opps.add(new Opportunity(Name='TEST Formalization', stageName='02', AccountId=acc.Id, CloseDate=Date.today(), Amount = 10000, Dwp_DevolutionUser__c=newUsers[i].Id));
            if(i < 10) {
             	newUsers[i].prof_position_id__c='';
            } else {
                newUsers[i].isActive=false;
            }
        }
        newUsers[19].prof_position_id__c='';
        insert opps;
        
        Final Product2 testPr = new Product2(Name='TestProd', type_of_quote__c='COTIZADOR', ProductCode='PC00012');
        insert testPr;
            
        Final Pricebook2 testPB = new Pricebook2(CurrencyIsoCode='PEN', Name='MyPrice');
        insert testPB;
        Final Id pricebookId = Test.getStandardPricebookId();
    
        Final PricebookEntry testPE = new PricebookEntry(UnitPrice=120, CurrencyIsoCode='PEN', Pricebook2Id=pricebookId, Product2Id=testPr.Id, IsActive=true);
        insert testPE;
        
        Final Set<Id> uIds = new Set<Id>();
        List<OpportunityLineItem> lstOli = new List<OpportunityLineItem>();
        for(Integer i=0; i<20; i++) {
            uIds.add(newUsers[i].Id);
            lstOli.add(new OpportunityLineItem(TotalPrice=120, OpportunityId=opps[i].Id, PricebookEntryId=testPE.Id, Quantity=1, gipr_Tipo_Garantia__c='03', 
                                                                  Product2Id=testPr.Id));
            if(i < 10) {
             	casos.add(new Case(OwnerId=newUsers[i].Id, status='05', DWP_AssistantOwner__c=newUsers[i].Id, opportunity_id__c=opps[i].Id));
            } else {
                casos.add(new Case(OwnerId=newUsers[i].Id, status='07', DWP_SgofOwner__c=newUsers[i].Id, opportunity_id__c=opps[i].Id));
            }
        }
        casos[19].status='08';
        
        insert lstOli;
		insert casos;
        Final User admin = [SELECT Id FROM User WHERE Id=:UserInfo.getUserId()];
        Test.startTest();
        System.runAs(admin) {
         	update newUsers;   
        }
        Test.stopTest();
        Final User[] deactiveUsers = [SELECT Id FROM User WHERE Id IN: uIds AND isActive=false];
        Final Integer deactiveUsersSize = deactiveUsers.size();
        Final User[] changeRolUsers = [SELECT Id FROM User WHERE Id IN: uIds AND isActive=true];
        Final Integer changeRolUsersSize = changeRolUsers.size();
        System.assertEquals(10, deactiveUsersSize, ASSERT_ERROR);
        System.assertEquals(10, changeRolUsersSize, ASSERT_ERROR);
    }
    
    /**
    * --------------------------------------------------------------------------------------
    * @Description 
    * Metodo que valida la funcionalidad de los metodos:
    * addUserToFormalizationGroup
    **/
    @isTest
    public static void addUserToFormalizationGroupTest() {
        List<User> newUsers = new List<User>();
        Final String profile = [SELECT Id FROM Profile WHERE Name = 'Operativo'].Id;
        for(Integer i=0; i<20; i++){
            newUsers.add(new User(LastName='User '+i, Username='User'+i+'@user.com.u', Email='User'+i+'@user.com.u', Alias=i+'uAas2', TimeZoneSidKey='America/Mexico_City',
                                  IsActive=true, LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='es', prof_position_id__c = '', ProfileId=profile));
        }
        insert newUsers;
        for(Integer i=0; i<20; i++) {
            if(i < 10) {
                newUsers[i].prof_position_id__c='E06';
            } else {
                newUsers[i].prof_position_id__c='E04';
            }
        }
        Test.startTest();
		update newUsers;
        Test.stopTest();
        Final Integer newUsersInGroup = Database.countQuery('SELECT Count() FROM GroupMember WHERE UserOrGroupId IN:newUsers AND Group.DeveloperName IN: GRP');
        System.assertEquals(20, newUsersInGroup, ASSERT_ERROR);
    }
}