/**
   -------------------------------------------------------------------------------------------------
   @Name BE_SM_Factory_tst
   @Author Diego Carbajal Pastor (diego.carbajal@bbva.com)
   @Date 2020-11-10
   @Description
   @Changes
   Date        Author   Email                  Type
   2020-11-10  DCP     diego.carbajal@bbva.com    Creation
   -------------------------------------------------------------------------------------------------
 */
@isTest
public with sharing class BE_SM_Factory_tst {
    
    /** @Description  variable ID_EJE*/
    public static Final Id ID_EJE = [SELECT Id FROM Profile WHERE Name = 'Ejecutivo' LIMIT 1].Id;
    
    /*
	 * @Description  method createSalesMeeting
	 */
    public static slmt__Sales_Meeting__c createSalesMeeting(DateTime smDT, Id colaboratorId, String smType, Boolean doInsert) {
        Final slmt__Sales_Meeting__c smRecord = new slmt__Sales_Meeting__c(DateTime__c = smDT, Collaborator__c = colaboratorId, 
                                                                           Name = 'SM Test '+Math.random(), Type_of_meeting__c = smType);
        if(doInsert) {insert smRecord;}
        return smRecord;
    }
    
    /** @Description  createProduct*/
	public static Product2 createProduct(String code) {
		Final Product2 prod = new Product2(Name = 'Product Test', Family = 'Test', ProductCode = code, Unique_id__c = code);
		insert prod;
		return prod;
	}
    
    /** @Description  createProduct*/
	public static PricebookEntry createPriceBookEntry(Id pricebookId, Id productId, Decimal unitPrice) {
		Final PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = productId, UnitPrice = unitPrice, IsActive = true);
		insert standardPrice;
		return standardPrice;
    }

    /** @Description  generalSetUp*/
    public static void generalSetUp() {
        Final User userGOF = TestFactory.getUser(true, new Map<Schema.SObjectField, Object>{User.ProfileId => ID_EJE, User.prof_position_id__c => 'E01'});
        Final User ejecutivo = TestFactory.getUser(true, new Map<Schema.SObjectField, Object>{User.ProfileId => ID_EJE, User.prof_position_id__c => 'E03', 
            																					User.ManagerId => userGOF.Id});
        Final Account acc = TestFactory.getAccount(true, new Map<Schema.SObjectField, Object>{Account.OwnerId => ejecutivo.Id});
        Final Date initDate = Date.newInstance(2020, 11, 11);
        System.runAs(ejecutivo) {
            createSalesMeeting(DateTime.newInstance(2020, 11, 11), ejecutivo.Id, 'Planning', true);
        }
        Final Opportunity[] lstOpp = new Opportunity[]{};
        for(Integer i = 2; i <= 7; i++) {
            lstOpp.add(new Opportunity(ownerId = ejecutivo.Id, Name = 'testopp '+i, AccountId = acc.Id, StageName = '0'+i, Amount = 100, 
                                       CloseDate = initDate, Field_Sup_Closing_Date__c = initDate));
        }
        insert lstOpp;
        lstOpp[0].closeDate = initDate.addMonths(1);
        update lstOpp[0];
        Test.setCreatedDate(lstOpp[0].Id, initDate.addDays(-10));
        Final List<String> lstProducts = System.Label.Opp_LP_Products.split(',');
        Final Product2 product = createProduct(lstProducts[0]);
        Final PricebookEntry standardPrice = createPriceBookEntry(Test.getStandardPricebookId(), product.Id, 10000);
        Final OpportunityLineItem[] lstOli = new OpportunityLineItem[]{};
        for(Opportunity opp:lstOpp) {
            lstOli.add(new OpportunityLineItem(OpportunityId = opp.Id, Quantity = 1, TotalPrice = 10.00, PricebookEntryId = standardPrice.Id, Product2Id = product.Id));
        }
        insert lstOli;
    }
    
    /** @Description  testSM for Sonar*/
    @isTest
	public static void testSM() {
        Test.startTest();
        Final slmt__Sales_Meeting__c slmt = createSalesMeeting(DateTime.newInstance(1,1,2021), UserInfo.getUserId(), 'Planning', false);
        Test.stopTest();
        System.assertEquals('Planning', slmt.Type_of_meeting__c, 'Assertion Error');
	}
    
}