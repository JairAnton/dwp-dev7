/**OpportunityProduct_Controller_tst
*  object.
* <p /><p />
* Modification log:<p />
* -------------------------------------------------------------------
* Developer                    Date                Description<p />
* -------------------------------------------------------------------
* Julio Medellin               7/05/2018          Original version.<p />
*
* @author Julio Medellin
*/
@istest
public class OpportunityProduct_Controller_tst {      
     //Setup data.
    @testSetup
    static void setupData(){ 
        //Create Accounts.
       test.startTest();
        Opportunity Opp = new Opportunity(Name='testopp', StageName='01', CloseDate=system.Date.today(),opportunity_status_type__c='01');
      
        List<Account> lstAccounts = new List<Account>();
        for(Integer intI = 0; intI < 2; intI++) {
            lstAccounts.add(new Account(Name = 'AccountName'+ intI));
        }
        insert lstAccounts;
        insert opp;
       
        Pricebook2 pb = new Pricebook2(Name='testPB');
        Product2 p = new  Product2(Name='testProduct');
        insert pb;
        insert p;
        PricebookEntry pes = new PricebookEntry(UnitPrice=1,Pricebook2Id =  Test.getStandardPricebookId(), Product2Id=p.id);
        insert pes;
        PricebookEntry pe = new PricebookEntry(UnitPrice=1,Pricebook2Id = pb.Id, Product2Id=p.id,IsActive=true);
        insert pe;
        OpportunityLineItem OLI  = new OpportunityLineItem(OpportunityId=opp.Id, 
                                                           Quantity=1,
                                                           TotalPrice=9,
                                                           PricebookEntryId=pe.Id,
                                                           Product2Id =p.id); 
        insert oli;
       test.stopTest(); 
    }

static testMethod  void positiveTest(){
    opportunity  opp = [SELECT ID FROM Opportunity LIMIT 1];
    OpportunityProduct_Controller OPC = new OpportunityProduct_Controller();
    OpportunityProduct_Controller.getTasks(opp.Id);
    OpportunityProduct_Controller.getOppLI(opp.id);
    OpportunityProduct_Controller.saveSIO(opp.Id,'SIO123');
    OpportunityProduct_Controller.sendApproval(opp.Id);
    
    
}

}