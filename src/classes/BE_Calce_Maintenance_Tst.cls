/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_Calce_Maintenance_Tst>
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-06-21
   @Description Test class from BE_Calce_Create_Batch, BE_Calce_Close_Batch, BE_Delete_Close_Batch
   @Changes
   Date        Author   Email                  				Type
   2020-06-21  MAMC     martin.mori.contractor@bbva.com    	Creation
   -------------------------------------------------------------------------------------------------
 */
@isTest
private class BE_Calce_Maintenance_Tst {
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
        Final Calce__c calce = new Calce__c();
        calce.Name = 'Test Calce close1';
        calce.close_date__c = Date.today();
        calce.start_date__c = Date.today();
        calce.status__c = 'Iniciado';
        calce.Indirect_commitment__c = 10;
        calce.Direct_commitment__c = 10;
        insert calce;
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
