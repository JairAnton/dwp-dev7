@istest
public class ProfitabilityController_cls_test {

 @testSetup
    private static void setData() {
        User defaultUser;
        Account acctest;
        Account acctest2;
        Opportunity opptest;
        Product2 prod;
        defaultUser = TestFactory.createUser('Test','Migracion');
        acctest = TestFactory.createAccount();
        acctest2 = TestFactory.createAccount(acctest.Id);
        opptest = TestFactory.createOpportunity(acctest.Id,defaultUser.Id);
        prod = testFactory.createProduct();
        testFactory.createOLI(opptest.Id, prod.Id);
        TestFactory.createAccountProfit(acctest2.Id);       
        } 


    public static testMethod void  testPositive(){
       Id accid = [SELECT ID FROM Account LIMIT 1].Id;
        ProfitabilityController_cls  pc =  new ProfitabilityController_cls();
        ProfitabilityController_cls.AccountProfit(accid);
        
    }
}