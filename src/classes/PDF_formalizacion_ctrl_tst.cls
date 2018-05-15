@istest
public class PDF_formalizacion_ctrl_tst {
    
    @testSetup
    static void setupData() {

        
        
        
        //Create Accounts.
        List<Account> lstAccounts = new List<Account>();
        List<Opportunity> lstOpportunities = new List<Opportunity>();
        for(Integer intI = 0; intI < 2; intI++) {
            lstAccounts.add(new Account(Name = 'AccountName'+ intI));
            lstOpportunities.add(new Opportunity(Name='testopp'+intI, StageName='01', CloseDate=system.Date.today(),opportunity_status_type__c='01'));
        }
        insert lstAccounts;
        insert lstOpportunities;                             
                                     
        
      
    }

    
    public static testMethod void positiveTest(){
        List<Opportunity> lstOpportunities=[SELECT Id FROM  Opportunity];
        list<string> IDs = new list<string>();
        PageReference pageRef = Page.PDF_formalizacion_vfp;
       
        for(opportunity opp: lstOpportunities){
            IDs.add(opp.Id);
        }
        PDF_formalizacion_ctrl.PDF_formalization(IDs);
   pageRef.getParameters().put('id',lstOpportunities[0].id);
   test.setCurrentPage(pageRef);     
   ApexPages.StandardController sc = new ApexPages.standardController(lstOpportunities[0]);
  
   PDF_formalizacion_ctrl pdf = new PDF_formalizacion_ctrl(sc);
    }
}