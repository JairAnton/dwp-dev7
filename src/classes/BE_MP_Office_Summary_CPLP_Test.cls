/**
    @Author Jair Anton Atuncar (jair.anton.contractor@bbva.com)
    @Description (Vista Resumen PPG) Test Summary of family Financiamiento Corto Plazo y Largo Plazo
    Date        Author   Email                  				Type
    2021-08-02  JAA     jair.anton.contractor@bbva.com    	    Initial version
**/

@isTest
public class BE_MP_Office_Summary_CPLP_Test {
    private static Final String stageLabel = 'Prospecting';

    static testMethod void testSummaryCPLP() {
        Final List<dwp_frct__management_plan__c> mPlanList = [SELECT Id, Name FROM dwp_frct__management_plan__c WHERE Name = 'Test Plan Gerente Month1'];
        
        Final Map<String,Object> planMap = new Map<String,Object>();
        planMap.put('recordId', mPlanList[0].Id);
        
        Test.StartTest();
        
        Final BE_MP_Office_Summary_CPLP_Cls summaryCPLP = new BE_MP_Office_Summary_CPLP_Cls();
        Final BE_SingleRelatedListCRUD_Cls.Response response = summaryCPLP.readRecords(planMap);
        System.assert(response.isSuccess, 'success!!!');
        
        test.stopTest();
    }
    
    @TestSetup
    static void testSetupData() {
    	Final Profile prof = [SELECT Id FROM Profile WHERE Name = 'System Administrator' OR Name = 'Administrador del sistema'];

        Final List<UserRole> roleList = new List<UserRole>();
        roleList.add(new UserRole( Name = 'CEO', ParentRoleId = null));
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
        
        Final User usr4 = createUserTest(roleList[2].Id, prof.Id, 'Test4 Ejecutivo', 'LastName4');
        usr4.ManagerId = usr2.Id;
        insert usr4;
        
        Final dwp_frct__management_plan__c mplan1 = new dwp_frct__management_plan__c();
        Final dwp_frct__management_plan__c mplan2 = new dwp_frct__management_plan__c();
        Final dwp_frct__management_plan__c mplan3 = new dwp_frct__management_plan__c();
        
        System.runas(usr2) {
            mplan1.Name = 'Test Plan Gerente Month1';
            mplan1.OwnerId = usr2.Id;
            mplan1.dwp_frct__user_id__c = usr2.ManagerId;
            mplan1.dwp_frct__management_plan_stage_type__c = '01';
            mplan1.dwp_frct__management_plan_start_date__c = Date.today();
            mplan1.dwp_frct__management_plan_end_date__c = Date.today().addMonths(3);
            insert mplan1;
            
            mplan2.Name = 'Test Plan Ejecutivo(Test3) Month1';
            mplan2.OwnerId = usr3.Id;
            mplan2.dwp_frct__user_id__c = usr3.ManagerId;
            mplan2.dwp_frct__management_plan_stage_type__c = '01';
            mplan2.dwp_frct__management_plan_start_date__c = Date.today();
            mplan2.dwp_frct__management_plan_end_date__c = Date.today().addMonths(3);
            insert mplan2;
            
            mplan3.Name = 'Test Plan Ejecutivo(Test4) Month1';
            mplan3.OwnerId = usr4.Id;
            mplan3.dwp_frct__user_id__c = usr4.ManagerId;
            mplan3.dwp_frct__management_plan_stage_type__c = '01';
            mplan3.dwp_frct__management_plan_start_date__c = Date.today();
            mplan3.dwp_frct__management_plan_end_date__c = Date.today().addMonths(3);
            insert mplan3;
            
            System.AssertNotEquals(mplan1, null);
            System.AssertNotEquals(mplan2, null);
            System.AssertNotEquals(mplan3, null);
            
            createGrouping(mplan2, mplan3, usr3, usr4);
        }
    }

    private static void createGrouping(dwp_frct__management_plan__c mplan2, dwp_frct__management_plan__c mplan3, User usr3, User usr4) {
        Final List<dwp_frct__grouping__c> groupList = new List<dwp_frct__grouping__c>();
        groupList.add(new dwp_frct__grouping__c(dwp_frct__solution_category_type__c = 'Financiamiento a corto plazo', dwp_frct__management_plan_id__c = mplan2.Id));
        groupList.add(new dwp_frct__grouping__c(dwp_frct__solution_category_type__c = 'Financiamiento a largo plazo', dwp_frct__management_plan_id__c = mplan2.Id));
        groupList.add(new dwp_frct__grouping__c(dwp_frct__solution_category_type__c = 'Financiamiento a largo plazo', dwp_frct__management_plan_id__c = mplan3.Id));
        groupList.add(new dwp_frct__grouping__c(dwp_frct__solution_category_type__c = 'Financiamiento a corto plazo', dwp_frct__management_plan_id__c = mplan3.Id));
        insert groupList;
        System.assertEquals(4, groupList.size());

        Final List<Opportunity> oppList = createOpp(usr3, usr4);
        System.assertEquals(6, oppList.size());
            
        Final List<dwp_frct__grouping_opp__c> groupOppList = new List<dwp_frct__grouping_opp__c>();
        groupOppList.add(new dwp_frct__grouping_opp__c(dwp_frct__management_plan_id__c = mplan2.Id, dwp_frct__grouping_id__c = groupList[1].Id, dwp_frct__opportunity_id__c = oppList[0].Id));
        groupOppList.add(new dwp_frct__grouping_opp__c(dwp_frct__management_plan_id__c = mplan2.Id, dwp_frct__grouping_id__c = groupList[1].Id, dwp_frct__opportunity_id__c = oppList[1].Id));
        groupOppList.add(new dwp_frct__grouping_opp__c(dwp_frct__management_plan_id__c = mplan3.Id, dwp_frct__grouping_id__c = groupList[2].Id, dwp_frct__opportunity_id__c = oppList[2].Id));
        groupOppList.add(new dwp_frct__grouping_opp__c(dwp_frct__management_plan_id__c = mplan3.Id, dwp_frct__grouping_id__c = groupList[2].Id, dwp_frct__opportunity_id__c = oppList[3].Id));
        groupOppList.add(new dwp_frct__grouping_opp__c(dwp_frct__management_plan_id__c = mplan2.Id, dwp_frct__grouping_id__c = groupList[0].Id, dwp_frct__opportunity_id__c = oppList[4].Id));
        groupOppList.add(new dwp_frct__grouping_opp__c(dwp_frct__management_plan_id__c = mplan3.Id, dwp_frct__grouping_id__c = groupList[3].Id, dwp_frct__opportunity_id__c = oppList[5].Id));   
        insert groupOppList;
        System.assertEquals(6, groupOppList.size());
    }

    private static List<Opportunity> createOpp(User usr3, User usr4) {
        Final Account acc = new Account(Name = 'TestAcct');
        insert acc;
        
        Final List<Opportunity> oppList = new List<Opportunity>();
        oppList.add(new Opportunity(Name = 'XXX Test 1', CloseDate = Date.today().addDays(-20), StageName = stageLabel, Amount = 111111, AccountId = acc.id, OwnerId = usr3.Id, Type='01'));
        oppList.add(new Opportunity(Name = 'XXX Test2', CloseDate = Date.today(), StageName = stageLabel, Amount = 111111, AccountId = acc.id, OwnerId = usr3.Id, Type='02'));
        oppList.add(new Opportunity(Name = 'XXX Test3', CloseDate = Date.today().addDays(-20), StageName = stageLabel, Amount = 200000, AccountId = acc.id, OwnerId = usr4.Id, Type='01'));
        oppList.add(new Opportunity(Name = 'XXX Test4', CloseDate = Date.today(), StageName = stageLabel, Amount = 111111, AccountId = acc.id, OwnerId = usr4.Id, Type='02'));
        oppList.add(new Opportunity(Name = 'XXX Test5', CloseDate = Date.today(), StageName = stageLabel, Amount = 111111, AccountId = acc.id, OwnerId = usr4.Id, Type='01'));
        oppList.add(new Opportunity(Name = 'XXX Test6', CloseDate = Date.today(), StageName = stageLabel, Amount = 111111, AccountId = acc.id, OwnerId = usr4.Id, Type='02'));
        insert oppList;
        System.assertEquals(6, oppList.size());
        
        Final List<Product2> productList = new List<Product2>();
        productList.add(new Product2(Name = 'Carta de crédito de exportación', ProductCode = 'PC00015', Description = 'Producto code 15', IsActive = true, Family = 'Financiamiento a corto plazo', Type_of_quote__c = 'Carta de credito', 
                                        Unique_id__c = '0292430', formalization__c = true, pdf__c = true, price_penalty__c = true, risk_sanction__c = true, type__c = 'Indirect'));
        productList.add(new Product2(Name = 'Carta de crédito de exportación', ProductCode = 'PC00015', Description = 'Producto code 15', IsActive = true, Family = 'Financiamiento a largo plazo', Type_of_quote__c = 'Carta de credito', 
                                        Unique_id__c = '0292431', formalization__c = true, pdf__c = true, price_penalty__c = true, risk_sanction__c = true, type__c = 'Indirect'));
        insert productList;
        System.assertEquals(2, productList.size());

        Final List<PriceBookEntry> priceList = new List<PriceBookEntry>();
        priceList.add(new PriceBookEntry(Product2Id = productList[0].Id, PriceBook2Id = Test.getStandardPricebookId(), UnitPrice = 1, UseStandardPrice = false, IsActive = true));
        priceList.add(new PriceBookEntry(Product2Id = productList[1].Id, PriceBook2Id = Test.getStandardPricebookId(), UnitPrice = 1, UseStandardPrice = false, IsActive = true));
        insert priceList;
        System.assertEquals(2, priceList.size());

        Final List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
        oliList.add(new OpportunityLineItem(OpportunityId = oppList[0].Id, Product2Id = priceList[0].Id, Quantity = 1, TotalPrice = 123, PriceBookEntryId = priceList[0].Id));
        oliList.add(new OpportunityLineItem(OpportunityId = oppList[1].Id, Product2Id = priceList[0].Id, Quantity = 1, TotalPrice = 123, PriceBookEntryId = priceList[0].Id));
        oliList.add(new OpportunityLineItem(OpportunityId = oppList[2].Id, Product2Id = priceList[1].Id, Quantity = 1, TotalPrice = 123, PriceBookEntryId = priceList[1].Id));
        oliList.add(new OpportunityLineItem(OpportunityId = oppList[3].Id, Product2Id = priceList[1].Id, Quantity = 1, TotalPrice = 123, PriceBookEntryId = priceList[1].Id));
        oliList.add(new OpportunityLineItem(OpportunityId = oppList[4].Id, Product2Id = priceList[0].Id, Quantity = 1, TotalPrice = 123, PriceBookEntryId = priceList[0].Id));
        oliList.add(new OpportunityLineItem(OpportunityId = oppList[5].Id, Product2Id = priceList[1].Id, Quantity = 1, TotalPrice = 123, PriceBookEntryId = priceList[1].Id));
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