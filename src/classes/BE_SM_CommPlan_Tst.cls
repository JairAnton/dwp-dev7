/**
   -------------------------------------------------------------------------------------------------
   @Name BE_SM_CommPlan_Tst
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2020-11-19
   @Description
   @Changes
   Date        Author   Email                  Type
   2020-11-19  LMBR    lolo.bravo@bbva.com    Creation
   -------------------------------------------------------------------------------------------------
 */
@isTest
public with sharing class BE_SM_CommPlan_Tst {
     /*
	 * @Description  method setUp
	 */
	@TestSetup
	static void setupData() {
        /** USER */
        final User ejecutivo = TestFactory.createUser('EjecutivoCPLAN', 'Ejecutivo');
        ejecutivo.prof_position_id__c = 'E03';
        update ejecutivo;
        /** ACCOUNT */
        final Account acc = TestFactory.getAccount(true, new Map<Schema.SObjectField, Object>{Account.OwnerId => ejecutivo.Id});
        final Date initDate = Date.newInstance(2020, 11, 04);
        /** ACCOUNT INFORMATION */
        insert new Account_BBVA_Information__c(current_balance_amount__c=1000,account_id__c=acc.Id, type__c = '01',product_desc__c = 'Comex' ,product_group_classification_id__c='Directa');
        /** ACCOUNT PLAN */
        insert new dwp_frct__management_plan__c(dwp_frct__management_plan_end_date__c=initDate.addDays(15),dwp_frct__management_plan_start_date__c=initDate,OwnerId=ejecutivo.Id);
        /** SALES MEETING */
        System.runAs(ejecutivo) {
            insert new slmt__Sales_Meeting__c(Name='SalesMeeting202010',DateTime__c=initDate,slmt__management_plan_meeting_date__c = initDate, Collaborator__c = ejecutivo.Id);
        }
        /** PRODUCT */
        final List<Product2> products= new List<Product2>{
        new Product2(Name = 'Comex exportación', Family = 'Financiamiento a corto plazo', ProductCode = 'PC00003',Type__c='Direct'),
        new Product2(Name = 'Depósito a plazo', Family = 'Recursos', ProductCode = 'PC00018'),
        new Product2(Name = 'Carta fianza económica', Family = 'Riesgo de firma', ProductCode = 'PC00012')};
        insert products;
        /** OPPORTUNITY */
        final Opportunity[] lstOpp = new Opportunity[]{};
        for(Integer i = 2; i <= 4; i++) {
            lstOpp.add(new Opportunity(ownerId = ejecutivo.Id, Name = 'testopp '+i, AccountId = acc.Id, StageName = '0'+i, Amount = 100, 
                                       CloseDate = initDate.addDays(15), Field_Sup_Closing_Date__c = initDate));
        }
        insert lstOpp;
        /** PRICE BOOK */
        final Id pricebookId = Test.getStandardPricebookId();
        final List<PricebookEntry> pBookEntries= new List<PricebookEntry>{
            new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = products[0].Id, UnitPrice = 10000, IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = products[1].Id, UnitPrice = 10000, IsActive = true),
            new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = products[2].Id, UnitPrice = 10000, IsActive = true)    
        };
        insert pBookEntries;
        /** OPPORTUNITYLINEITEM */
        final OpportunityLineItem[] lstOli = new OpportunityLineItem[]{};
        for (Integer i = 0; i < 3; i++) {
            lstOli.add(new OpportunityLineItem(OpportunityId =lstOpp[i].Id, Quantity = 1, TotalPrice = 10.00, PricebookEntryId = pBookEntries[i].Id, Product2Id = products[i].Id));
        }
        insert lstOli;
    }
     /*
	 * @Description commPlanQVCT Class
	 */
    @isTest
    static void commPlanQVCTst() {
        final slmt__Sales_Meeting__c salesMeeting = [SELECT Id,Name,slmt__management_plan_meeting_date__c, Collaborator__c FROM slmt__Sales_Meeting__c LIMIT 1];
        final BE_SM_CommPlanQVC_Cls cplan= new BE_SM_CommPlanQVC_Cls();
        final List<Map<String,String>> results=cplan.getCardDetails((Sobject)salesMeeting, '');
        System.assertEquals(results.size(),4, 'Assertion Error');
    }
    /*
	 * @Description  method cPlanInversionRentable
	 */
    @isTest
    static void cPlanInversionRentableTst() {
        final slmt__Sales_Meeting__c salesMeeting = [SELECT Id,Name,slmt__management_plan_meeting_date__c, Collaborator__c FROM slmt__Sales_Meeting__c LIMIT 1];
        final BE_SingleRelatedList_Setting__mdt srl = [SELECT Id, FieldsQuery__c, sObjectApiName__c FROM BE_SingleRelatedList_Setting__mdt 
                                                       WHERE DeveloperName = 'BE_SM_CPlan_InversionRentable'];
        System.runAs(new User(Id=salesMeeting.Collaborator__c)) {
            salesMeeting.slmt__management_plan_meeting_date__c = Date.newInstance(2020, 11, 11);
            update salesMeeting;
        }
        Test.startTest();
        final BE_SingleRelatedListCRUD_Cls.Response response=new BE_SM_CPlan_InversionRentable_Ctr().readRecords(new Map<String, Object>{'recordId' => salesMeeting.Id, 'sObjName' => srl.sObjectApiName__c, 'sObjFields' => srl.FieldsQuery__c});
        Test.stopTest();
        System.assertEquals(response.data.size(), 1, 'Success cPlanInversionRentable');
    }
    
    /*
	 * @Description  method cPlanRecursos
	 */
    @isTest
    static void cPlanRecursosTst() {
        final slmt__Sales_Meeting__c salesMeeting = [SELECT Id,Name,slmt__management_plan_meeting_date__c, Collaborator__c FROM slmt__Sales_Meeting__c LIMIT 1];
        final BE_SingleRelatedList_Setting__mdt srl = [SELECT Id, FieldsQuery__c, sObjectApiName__c FROM BE_SingleRelatedList_Setting__mdt 
                                                       WHERE DeveloperName = 'BE_SM_CPlan_Recursos'];
        System.runAs(new User(Id=salesMeeting.Collaborator__c)) {
            salesMeeting.slmt__management_plan_meeting_date__c = Date.newInstance(2020, 11, 11);
        	update salesMeeting;
        }
        Test.startTest();
        final BE_SingleRelatedListCRUD_Cls.Response response=new BE_SM_CPlan_Recursos_Ctr().readRecords(new Map<String, Object>{'recordId' => salesMeeting.Id, 'sObjName' => srl.sObjectApiName__c, 'sObjFields' => srl.FieldsQuery__c});
        Test.stopTest();
        System.assertEquals(response.data.size(), 1, 'Sucess cPlanRecursos');
    }

    /*
	 * @Description  method getPendingPipeline
	 */
    @isTest
    static void cPlanRiesgosFirmaTst() {
        final slmt__Sales_Meeting__c salesMeeting = [SELECT Id,Name,slmt__management_plan_meeting_date__c, Collaborator__c FROM slmt__Sales_Meeting__c LIMIT 1];
        final BE_SingleRelatedList_Setting__mdt srl = [SELECT Id, FieldsQuery__c, sObjectApiName__c FROM BE_SingleRelatedList_Setting__mdt 
                                                       WHERE DeveloperName = 'BE_SM_CPlan_RiesgoFirma'];
        System.runAs(new User(Id=salesMeeting.Collaborator__c)) {
            salesMeeting.slmt__management_plan_meeting_date__c = Date.newInstance(2020, 11, 11);
        	update salesMeeting;
        }
        Test.startTest();
        final BE_SingleRelatedListCRUD_Cls.Response response=new BE_SM_CPlan_RiesgoFirma_Ctr().readRecords(new Map<String, Object>{'recordId' => salesMeeting.Id, 'sObjName' => srl.sObjectApiName__c, 'sObjFields' => srl.FieldsQuery__c});
        Test.stopTest();
        System.assertEquals(response.data.size(), 1, 'cPlanRiesgosFirma');
    }
}