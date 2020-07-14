/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_Calce_Maintenance_Tst>
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-06-21
   @Description Test class from BE_Calce_Create_Batch, BE_Calce_Close_Batch, BE_Delete_Close_Batch
   @Changes
   Date        Author   Email                  				Type		Description
   2020-06-21  MAMC     martin.mori.contractor@bbva.com    	Creation
   2020-07-14  MAMC     martin.mori.contractor@bbva.com    	Modify		add setupData method
   -------------------------------------------------------------------------------------------------
 */
@isTest
private class BE_Calce_Maintenance_Tst {
	/**@Description TestSetup for generated data to use in the test methods*/
	@TestSetup
	static void setupData() {
        final User executiveUser = TestFactory.createUser('UserOwnerTest01', 'Ejecutivo');
        executiveUser.IsActive = true;
        executiveUser.prof_position_id__c = 'E03';
		final User assitantUser = TestFactory.createUser('UserAssitantTest011', 'Ejecutivo');
        assitantUser.IsActive = true;
        final List<User> ltsUser = new List<User>();
        ltsUser.add(executiveUser);
        ltsUser.add(assitantUser);
        update ltsUser;
        final User userAux = [SELECT Id, Name, ManagerId FROM User WHERE IsActive = TRUE AND Profile.Name = 'Ejecutivo' AND prof_position_id__c IN ('E03', 'I32') LIMIT 1][0];
		final User_Assistant_Team__c assistant = new User_Assistant_Team__c(assistant_id__c = assitantUser.id, user_id__c = userAux.id);
		insert assistant;
        
		final dwp_frct__management_plan__c plan = new dwp_frct__management_plan__c(Name = 'PlaPPGoNE',
                                                                                   OwnerId = userAux.Id,
                                                                                   dwp_frct__management_plan_start_date__c = Date.today().addDays(-1),
                                                                                   dwp_frct__management_plan_end_date__c = Date.today());
        insert plan;
		final List<dwp_frct__grouping__c> groupList = new List<dwp_frct__grouping__c>();
		final List<BE_FamilyGroupingForecast__c> faProdLst = new List<BE_FamilyGroupingForecast__c>();
		faProdLst.add(new BE_FamilyGroupingForecast__c(Name = 'Financiamiento a corto plazo'));
		faProdLst.add(new BE_FamilyGroupingForecast__c(Name = 'Financiamiento a largo plazo'));
		faProdLst.add(new BE_FamilyGroupingForecast__c(Name = 'Recursos'));
		faProdLst.add(new BE_FamilyGroupingForecast__c(Name = 'Riesgo de firma'));
		upsert faProdLst;
		final Map<String, BE_FamilyGroupingForecast__c>familyProductMap = BE_FamilyGroupingForecast__c.getAll();
		for(String typeFamily: familyProductMap.keySet()) {
			groupList.add(new dwp_frct__grouping__c(
							  dwp_frct__management_plan_id__c = plan.Id,
							  dwp_frct__solution_category_type__c = typeFamily,
							  dwp_frct__management_expected_drop_amount__c = 100,
							  dwp_frct__opportunity_amortization_amount__c = 100,
							  dwp_frct__opportunity_antcp_expiry_amount__c = 100,
							  dwp_frct__opportunity_cancellation_amount__c = 100,
							  dwp_frct__opportunity_closed_amount__c = 100,
							  dwp_frct__opportunity_selected_tot_amount__c = 100,
							  dwp_frct__original_commitment_amount__c = 100
							  ));
		}
		insert groupList;
        
        final Account acc = TestFactory.createAccount();
        final Opportunity opp1 = TestFactory.createOpportunity(acc.Id, System.UserInfo.getUserId());
        final Opportunity opp2 = TestFactory.createOpportunity(acc.Id, System.UserInfo.getUserId());
        final Product2 prod1 = new Product2(
            Name = 'Carta de crédito de exportación',
            ProductCode = 'PC00015',
            Description = 'Producto code 15',
            IsActive = true,
            Family = 'Riesgo de firma',
            Type_of_quote__c = 'Carta de credito',
            Unique_id__c = '0292430',
            formalization__c = true,
            pdf__c = true,
            price_penalty__c = true,
            risk_sanction__c = true,
            type__c = 'Indirect');
        insert prod1;
        final Product2 prod2 = new Product2(
            Name = 'Comex importación (manual)	',
            ProductCode = 'PC00002',
            Description = 'Producto code 02',
            IsActive = true,
            Family = 'Financiamiento a corto plazo	',
            Type_of_quote__c = 'COTIZA Beta	',
            Unique_id__c = '0161720	',
            formalization__c = true,
            pdf__c = true,
            price_penalty__c = true,
            risk_sanction__c = true,
            type__c = 'Direct');
        insert prod2;
        TestFactory.createOLI(opp1.Id, prod1.Id);
        TestFactory.createOLI(opp2.Id, prod2.Id);
        
        Final Calce__c calce = new Calce__c();
        calce.Name = 'Test Calce close';
        calce.close_date__c = Date.today();
        calce.start_date__c = Date.today();
        calce.status__c = 'Iniciado';
        calce.Indirect_commitment__c = 10;
        calce.Direct_commitment__c = 10;
        insert calce;
        final List<Calce_Details__c> ltsCalceDetail = new List<Calce_Details__c>();
        final Calce_Details__c calceDetail1 = new Calce_Details__c();
        calceDetail1.calce_id__c = calce.Id;
        calceDetail1.account_id__c = acc.Id;
        calceDetail1.amount__c = 80000;
        calceDetail1.amount_cancelled__c = 50000;
        calceDetail1.extension__c = false;
        calceDetail1.opportunity_id__c = opp1.Id;
        calceDetail1.product_code__c = 'PC00015';
        calceDetail1.product_id__c = prod1.Id;
        calceDetail1.product_name__c = 'Carta de crédito de exportación';
        calceDetail1.return__c = false;
        calceDetail1.sub_type__c = '01';
        calceDetail1.type__c = 'Indirect';
        ltsCalceDetail.add(calceDetail1);
        final Calce_Details__c calceDetail2 = new Calce_Details__c();
        calceDetail2.calce_id__c = calce.Id;
        calceDetail2.account_id__c = acc.Id;
        calceDetail2.amount__c = 500000;
        calceDetail2.amount_cancelled__c = 300000;
        calceDetail2.extension__c = false;
        calceDetail2.opportunity_id__c = opp2.Id;
        calceDetail2.product_code__c = 'PC00002';
        calceDetail2.product_id__c = prod2.Id;
        calceDetail2.product_name__c = 'Comex importación';
        calceDetail2.return__c = true;
        calceDetail2.sub_type__c = '03';
        calceDetail2.type__c = 'Direct';
        ltsCalceDetail.add(calceDetail2);
        insert ltsCalceDetail;
	}
	
    /**
    @Description test method for BE_Calce_Create_Batch class
    */
    @isTest
    public static void createCalceTest() {
        Test.StartTest();
        final BE_Calce_Create_BS calceCreSch = new BE_Calce_Create_BS();
        system.schedule('Test Sched calce create', '0 0 8 * * ?', calceCreSch);
        System.Database.executeBatch(new BE_Calce_Create_Batch());
        Final List<CronTrigger> lts = [SELECT ID FROM CronTrigger LIMIT 1];
        System.assert(!lts.isEmpty(), 'success create!!!');
        test.stopTest();
    }
    
    /**
    @Description test method for BE_Calce_Create_Batch class
    */
    @isTest
    public static void createCalceDayTest() {
        Test.StartTest();
        System.Database.executeBatch(new BE_Calce_Create_Batch(Date.today()));
        Final List<AsyncApexJob> lts = [SELECT ID FROM AsyncApexJob LIMIT 1];
        System.assert(!lts.isEmpty(), 'success create!!!');
        test.stopTest();
    }
    
    /**
    @Description test method for BE_Calce_Close_Batch class
    */
    @isTest
    public static void closeCalceTest() {
        Test.StartTest();
        final BE_Calce_Close_BS calceCloSch = new BE_Calce_Close_BS();
        system.schedule('Test Sched calce close', '0 0 20 * * ?', calceCloSch);
        System.Database.executeBatch(new BE_Calce_Close_Batch());
        Final List<CronTrigger> lts = [SELECT ID FROM CronTrigger LIMIT 10];
        System.assert(!lts.isEmpty(), 'success close!!!');
        test.stopTest();
    }
    
    /**
    @Description test method for BE_Calce_Delete_Batch class
    */
    @isTest
    public static void deleteCalceTest() {
        Final Calce__c calce = new Calce__c();
        calce.Name = 'Test Calce delete';
        calce.close_date__c = Date.today().addDays(-40);
        insert calce;
        Test.StartTest();
        final BE_Calce_Delete_BS calceDelSch = new BE_Calce_Delete_BS();
        system.schedule('Test Sched calce delete', '0 0 23 * * ?', calceDelSch);
        System.Database.executeBatch(new BE_Calce_Delete_Batch());
        Final List<CronTrigger> lts = [SELECT ID FROM CronTrigger LIMIT 1];
        System.assert(!lts.isEmpty(), 'success delete!!!');
        test.stopTest();
    }
    
    /**
    @Description test method for BE_Calce_Delete_Batch class
    */
    @isTest
    public static void deleteCalceDayTest() {
        Final Calce__c calce = new Calce__c();
        calce.Name = 'Test Calce delete2';
        calce.close_date__c = Date.today().addDays(-45);
        calce.status__c = 'Iniciado';
        insert calce;
        Test.StartTest();
        System.Database.executeBatch(new BE_Calce_Delete_Batch(Date.today().addDays(-45)));
        Final List<AsyncApexJob> lts = [SELECT ID FROM AsyncApexJob LIMIT 10];
        System.assert(!lts.isEmpty(), 'success !!!');
        test.stopTest();
    }
}
