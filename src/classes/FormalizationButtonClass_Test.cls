@isTest
public class FormalizationButtonClass_Test {
    static Account acctest;
    static Opportunity opptest;
    static User defaultUser;
    
    static void setData() {        
        defaultUser = TestFactory.createUser('Test','Migracion');
        acctest = TestFactory.createAccount();
        opptest = TestFactory.createOpportunity(acctest.Id,defaultUser.Id);
    }
    @isTest
    static void updateOpp() {
        setData();
        Test.startTest();
        System.runAs(defaultUser) {
            String oppId = opptest.Id;            
            formalizationButtonClass.updateOpp(oppId);
        }
        Test.stopTest();
    }
    @isTest
    static void messageError(){
        setData();
        Test.startTest();
        System.runAs(defaultUser) {
            formalizationButtonClass.getErrorMessagesList('recordTest', 'sourceTest', 'validationClassTest');        
        }
        Test.stopTest();
    }
}