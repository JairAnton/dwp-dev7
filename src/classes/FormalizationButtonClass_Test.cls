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
            System.assertNotEquals('', oppId); 
        }
        Test.stopTest();
    }
    @isTest
    static void messageError(){
        setData();
        Test.startTest();
        System.runAs(defaultUser) {
           List<String> lstErrorMessage = formalizationButtonClass.getErrorMessagesList('recordTest', 'sourceTest', 'validationClassTest');
            System.assertEquals(0, lstErrorMessage.size()); //Yulino 12/12/2018 : Se agrego Assets linea 19 y 29,se declaro variable lstErrorMessage lin. 28 (para el assets)     
        }
        Test.stopTest();
    }
}