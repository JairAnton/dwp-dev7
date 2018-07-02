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
        List<task> lstTasks = new List<task>(); 
        for(Integer intI = 0; intI < 4; intI++) {
            lstAccounts.add(new Account(Name = 'AccountName'+ intI));
            lstTasks.add(new Task(Subject='SIO1234567##'+(intI+1)+'er Ingreso a Controller##',Status='Inbound Email'));
        }
        insert opp; 
        lstTasks.add(new Task(Subject=lstTasks[0].Subject,Status='Inbound Email',whatid=Opp.Id));
        insert lstTasks;
        insert lstAccounts;
          
        Pricebook2 pb = new Pricebook2(Name='testPB');
        Product2 p = new  Product2(Name='testProduct',ProductCode='example1');
        insert pb;
        insert p;
        PricebookEntry pes = new PricebookEntry(UnitPrice=1,Pricebook2Id =  Test.getStandardPricebookId(), Product2Id=p.id);
        insert pes;
        PricebookEntry pe = new PricebookEntry(UnitPrice=1,Pricebook2Id = pb.Id, Product2Id=p.id,IsActive=true);
        insert pe;
        OpportunityLineItem OLI  = new OpportunityLineItem(OpportunityId=opp.Id, 
                                                           Quantity=1,
                                                           UnitPrice=9,
                                                           PricebookEntryId=pe.Id,
                                                           Product2Id =p.id); 
        insert oli;
        Modality_Mode__c m = new Modality_Mode__c(name='prue',Product_Name__c='example1',Modalidad_producto__c='ema',Modality_Select__c='sample');
        insert m;
        test.stopTest(); 
    }
    static testMethod  void positiveTest(){
        task t = [SELECT Id FROM TASK LIMIT 1];
        opportunity  opp = [SELECT ID FROM Opportunity LIMIT 1];
        OpportunityProduct_Controller OPC = new OpportunityProduct_Controller();
        OpportunityProduct_Controller.getTasks('SIO1234567');
        OpportunityProduct_Controller.getOppLI(opp.id);
        OpportunityProduct_Controller.saveSIO(opp.Id,t.Id);
        OpportunityProduct_Controller.sendApproval(opp.Id);
        opp.Modality__c=null;
        update opp;
        OpportunityProduct_Controller.requestModality(opp.Id);
        
    }
}