/**
    @Author Jair Anton Atuncar (jair.anton.contractor@bbva.com)
    @Description (Vista Resumen PPG) Test Summary for Executive
    Date        Author   Email                  				Type
    2021-08-02  JAA     jair.anton.contractor@bbva.com    	    Initial version
**/

@isTest
public class BE_MP_Executive_Summary_Test {
    private static Final String stageLabel = 'Prospecting';
    private static Final String indirectLabel = 'Indirect';
    private static Final String decriptionLabel = 'Producto code 15';
    private static Final String typeQuoteLabel = 'Carta de credito';

    static testMethod void testSummaryExecutive() {
        Final List<dwp_frct__management_plan__c> mPlanList = [SELECT Id, Name FROM dwp_frct__management_plan__c WHERE Name = 'Test Plan Ejecutivo(Test3) Month1' LIMIT 1];
        
        Final Map<String,Object> planMap = new Map<String,Object>();
        planMap.put('recordId', mPlanList[0].Id);
        
        Test.StartTest();
        
        Final BE_MP_Executive_Summary_Cls summaryExecutive = new BE_MP_Executive_Summary_Cls();
        Final BE_SingleRelatedListCRUD_Cls.Response resp1 = summaryExecutive.readRecords(planMap);
        System.assert(resp1.isSuccess, 'success!!!');
        
        test.stopTest();
    }
    
    @TestSetup
	static void testSetupData() {
    	Final Profile prof = [SELECT Id FROM Profile WHERE Name = 'System Administrator' OR Name = 'Administrador del sistema'];

        Final List<UserRole> roleList = new List<UserRole>();
        roleList.add(new UserRole(Name = 'CEO', ParentRoleId = null));
        roleList.add(new UserRole(Name = 'Finance Approver'));
        roleList.add(new UserRole(Name = 'Finance1'));
        insert roleList;
        System.assertEquals(3, roleList.size());

        Final User usr1 = createUserTest(roleList[0].Id, prof.Id, 'Test1 Gerente Regional', 'LastName1');
        insert usr1;
        
        Final User usr2 = createUserTest(roleList[1].Id, prof.Id, 'Test2 Gerente', 'LastName2');
        usr2.ManagerId = usr1.Id;
        insert usr2;

        Final User usr3 = createUserTest(roleList[2].Id, prof.Id, 'Test3 Ejecutivo', 'LastName3');
        usr3.ManagerId = usr2.Id;
        insert usr3;
        
        System.runas(usr2) {
            Final List<dwp_frct__management_plan__c> mplanList = new List<dwp_frct__management_plan__c>();
            mplanList.add(new dwp_frct__management_plan__c(Name = 'Test Plan Ejecutivo(Test3) Month1', OwnerId = usr3.Id, dwp_frct__user_id__c = usr3.ManagerId, dwp_frct__management_plan_stage_type__c = '01', 
                                                                dwp_frct__management_plan_start_date__c = Date.today(), dwp_frct__management_plan_end_date__c = Date.today().addMonths(3)));
            insert mplanList;
            System.assertEquals(1, mplanList.size());

            createGrouping(mplanList, usr3);
        }
    }

    private static void createGrouping(List<dwp_frct__management_plan__c> mplanList, User usr3) {
        Final List<dwp_frct__grouping__c> groupList = new List<dwp_frct__grouping__c>();
        groupList.add(new dwp_frct__grouping__c(dwp_frct__solution_category_type__c = 'Financiamiento a corto plazo', dwp_frct__management_plan_id__c = mplanList[0].Id));
        groupList.add(new dwp_frct__grouping__c(dwp_frct__solution_category_type__c = 'Financiamiento a largo plazo', dwp_frct__management_plan_id__c = mplanList[0].Id));
        groupList.add(new dwp_frct__grouping__c(dwp_frct__solution_category_type__c = 'Riesgo de firma', dwp_frct__management_plan_id__c = mplanList[0].Id));
        groupList.add(new dwp_frct__grouping__c(dwp_frct__solution_category_type__c = 'Recursos', dwp_frct__management_plan_id__c = mplanList[0].Id));
        insert groupList;
        System.assertEquals(4, groupList.size());
        
        Final List<Opportunity> oppList = createOpp(usr3);
        System.assertEquals(6, oppList.size());

        Final List<dwp_frct__grouping_opp__c> groupOppList = new List<dwp_frct__grouping_opp__c>();
        groupOppList.add(new dwp_frct__grouping_opp__c(dwp_frct__management_plan_id__c = mplanList[0].Id, dwp_frct__grouping_id__c = groupList[0].Id, dwp_frct__opportunity_id__c = oppList[0].Id));
        groupOppList.add(new dwp_frct__grouping_opp__c(dwp_frct__management_plan_id__c = mplanList[0].Id, dwp_frct__grouping_id__c = groupList[0].Id, dwp_frct__opportunity_id__c = oppList[1].Id));
        groupOppList.add(new dwp_frct__grouping_opp__c(dwp_frct__management_plan_id__c = mplanList[0].Id, dwp_frct__grouping_id__c = groupList[1].Id, dwp_frct__opportunity_id__c = oppList[2].Id));
        groupOppList.add(new dwp_frct__grouping_opp__c(dwp_frct__management_plan_id__c = mplanList[0].Id, dwp_frct__grouping_id__c = groupList[1].Id, dwp_frct__opportunity_id__c = oppList[3].Id));
        groupOppList.add(new dwp_frct__grouping_opp__c(dwp_frct__management_plan_id__c = mplanList[0].Id, dwp_frct__grouping_id__c = groupList[2].Id, dwp_frct__opportunity_id__c = oppList[4].Id));
        groupOppList.add(new dwp_frct__grouping_opp__c(dwp_frct__management_plan_id__c = mplanList[0].Id, dwp_frct__grouping_id__c = groupList[3].Id, dwp_frct__opportunity_id__c = oppList[5].Id));
        insert groupOppList;
        System.assertEquals(6, groupOppList.size());
    }

    private static List<Opportunity> createOpp(User usr3) {
        Final Account acc = new Account(Name = 'TestAcct');
        insert acc;
        
        Final List<Opportunity> oppList = new List<Opportunity>();
        oppList.add(new Opportunity(Name = 'XXX Test1', CloseDate = Date.today().addDays(-20), StageName = stageLabel, Amount = 111111, AccountId = acc.id, OwnerId = usr3.Id, Type='01'));
        oppList.add(new Opportunity(Name = 'XXX Test2', CloseDate = Date.today(), StageName = stageLabel, Amount = 111111, AccountId = acc.id, OwnerId = usr3.Id, Type='02'));
        oppList.add(new Opportunity(Name = 'XXX Test3', CloseDate = Date.today().addDays(-20), StageName = stageLabel, Amount = 200000, AccountId = acc.id, OwnerId = usr3.Id, Type='01'));
        oppList.add(new Opportunity(Name = 'XXX Test4', CloseDate = Date.today(), StageName = stageLabel, Amount = 111111, AccountId = acc.id, OwnerId = usr3.Id, Type='02'));
        oppList.add(new Opportunity(Name = 'XXX Test5', CloseDate = Date.today().addDays(-20), StageName = stageLabel, Amount = 111111, AccountId = acc.id, OwnerId = usr3.Id, Type='01'));
        oppList.add(new Opportunity(Name = 'XXX Test7', CloseDate = Date.today().addDays(-20), StageName = stageLabel, Amount = 200000, AccountId = acc.id, OwnerId = usr3.Id, Type='01'));
        insert oppList;
        System.assertEquals(6, oppList.size());
        
        Final List<Product2> productList = new List<Product2>();
        productList.add(new Product2(Name = 'Product1', ProductCode = 'PC00015', Description = decriptionLabel, IsActive = true, Family = 'Financiamiento a corto plazo', Type_of_quote__c = typeQuoteLabel, 
                                            Unique_id__c = '0292430', formalization__c = true, pdf__c = true, price_penalty__c = true, risk_sanction__c = true, type__c = indirectLabel));
        productList.add(new Product2(Name = 'Product2', ProductCode = 'PC00016', Description = decriptionLabel, IsActive = true, Family = 'Financiamiento a largo plazo', Type_of_quote__c = typeQuoteLabel, 
                                            Unique_id__c = '0292431', formalization__c = true, pdf__c = true, price_penalty__c = true, risk_sanction__c = true, type__c = indirectLabel));
        productList.add(new Product2(Name = 'Product3', ProductCode = 'PC00017', Description = decriptionLabel, IsActive = true, Family = 'Riesgo de firma', Type_of_quote__c = typeQuoteLabel, 
                                            Unique_id__c = '0292432', formalization__c = true, pdf__c = true, price_penalty__c = true, risk_sanction__c = true, type__c = indirectLabel));
        productList.add(new Product2(Name = 'Product4', ProductCode = 'PC00018', Description = decriptionLabel, IsActive = true, Family = 'Recursos', Type_of_quote__c = typeQuoteLabel , 
                                            Unique_id__c = '0292433', formalization__c = true, pdf__c = true, price_penalty__c = true, risk_sanction__c = true, type__c = indirectLabel));
        insert productList;
        System.assertEquals(4, productList.size());

        Final List<PriceBookEntry> priceList = new List<PriceBookEntry>();
        priceList.add(new PriceBookEntry(Product2Id = productList[0].Id, PriceBook2Id = Test.getStandardPricebookId(), UnitPrice = 1, UseStandardPrice = false, IsActive = true));
        priceList.add(new PriceBookEntry(Product2Id = productList[1].Id, PriceBook2Id = Test.getStandardPricebookId(), UnitPrice = 1, UseStandardPrice = false, IsActive = true));        
        priceList.add(new PriceBookEntry(Product2Id = productList[2].Id, PriceBook2Id = Test.getStandardPricebookId(), UnitPrice = 1, UseStandardPrice = false, IsActive = true));
        priceList.add(new PriceBookEntry(Product2Id = productList[3].Id, PriceBook2Id = Test.getStandardPricebookId(), UnitPrice = 1, UseStandardPrice = false, IsActive = true));
        insert priceList;
        System.assertEquals(4, priceList.size());
        
        Final List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
        oliList.add(new OpportunityLineItem(OpportunityId = oppList[0].Id, Product2Id = productList[0].Id, Quantity = 1, TotalPrice = 123, PriceBookEntryId = priceList[0].Id));
        oliList.add(new OpportunityLineItem(OpportunityId = oppList[1].Id, Product2Id = productList[0].Id, Quantity = 1, TotalPrice = 123, PriceBookEntryId = priceList[0].Id));
        oliList.add(new OpportunityLineItem(OpportunityId = oppList[2].Id, Product2Id = productList[1].Id, Quantity = 1, TotalPrice = 123, PriceBookEntryId = priceList[1].Id));
        oliList.add(new OpportunityLineItem(OpportunityId = oppList[3].Id, Product2Id = productList[1].Id, Quantity = 1, TotalPrice = 123, PriceBookEntryId = priceList[1].Id));
        oliList.add(new OpportunityLineItem(OpportunityId = oppList[4].Id, Product2Id = productList[2].Id, Quantity = 1, TotalPrice = 123, PriceBookEntryId = priceList[2].Id));
        oliList.add(new OpportunityLineItem(OpportunityId = oppList[5].Id, Product2Id = productList[3].Id, Quantity = 1, TotalPrice = 123, PriceBookEntryId = priceList[3].Id));
        insert oliList;
        System.assertEquals(6, oliList.size());

        return oppList;
    }
    
    private static User createUserTest(Id roleId, Id profID, String fName, String lName) {
        Final Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        Final String orgId = UserInfo.getOrganizationId();
        Final String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Final String uniqueName = orgId + dateString + randomInt;
        
        return new User(firstname = fName, lastName = lName, email = uniqueName + '@test' + orgId + '.org', Username = uniqueName + '@test' + orgId + '.org', EmailEncodingKey = 'ISO-8859-1', 
                                        Alias = uniqueName.substring(18, 23), TimeZoneSidKey = 'Europe/Paris', LocaleSidKey = 'es', LanguageLocaleKey = 'es',ProfileId = profId, UserRoleId = roleId);
    }
}