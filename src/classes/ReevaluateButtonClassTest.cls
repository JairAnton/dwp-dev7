/**ReevaluateButtonClassTest
*  object.
* <p /><p />
* Modification log:<p />
* -------------------------------------------------------------------
* Developer                    Date                Description<p />
* -------------------------------------------------------------------
* Julio Medellin               18/05/2018          Original version.<p />
*
* @author Julio Medellin
*/
@istest
public  class ReevaluateButtonClassTest {
    
    @testSetup
    private static void setData() {
        User defaultUser;
        Account acctest;
        Opportunity opptest;
        Product2 prod;
        defaultUser = TestFactory.createUser('Test','Administrador del sistema');
        acctest = TestFactory.createAccount();
        opptest = TestFactory.createOpportunity(acctest.Id,defaultUser.Id);
        prod = testFactory.createProduct();
        testFactory.createOLI(opptest.Id, prod.Id);        
        } 
    
     public static testMethod void testPositive(){
         Id Idopp = [SELECT ID FROM Opportunity LIMIT 1].Id;
         ReevaluateButtonClass.start(Idopp);
         ReevaluateButtonClass.getErrorMessagesList(Idopp,'Opportunity','');
         ReevaluateButtonClass.updateOpp(Idopp);
         ReevaluateButtonClass.setToPrice(Idopp);
         ReevaluateButtonClass.setToRisk(Idopp);
    
        
     }
    
    

}