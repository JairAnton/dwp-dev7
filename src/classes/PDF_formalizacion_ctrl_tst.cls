@istest
public class PDF_formalizacion_ctrl_tst {

@testSetup
static void setupData() {
User u = new User(
ProfileId = [SELECT Id FROM Profile WHERE Name = 'Ejecutivo'].Id,
LastName = 'last',
Email = 'user@BBVA.com',
Username = 'userBBVA@BBVA.com' + System.currentTimeMillis(),
CompanyName = 'BBVA',
Title = 'title',
Alias = 'alias',
TimeZoneSidKey = 'America/Los_Angeles',
EmailEncodingKey = 'UTF-8',
LanguageLocaleKey = 'en_US',
LocaleSidKey = 'en_US');
insert u;


//Create Accounts.
List<Account> lstAccounts = new List<Account>();
List<Opportunity> lstOpportunities = new List<Opportunity>();
List<OpportunityLineItem> lstOpportunitiesLineItem = new List<OpportunityLineItem>();

lstAccounts.add(new Account(Name = 'AccountName'));



insert lstAccounts;

lstOpportunities.add(new Opportunity(Name='testopp',AccountId = lstAccounts[0].Id, StageName='01', CloseDate=system.Date.today(),opportunity_status_type__c='01',OwnerId=UserInfo.getUserId()));

insert lstOpportunities;

Product2 prod = new Product2(Name = 'Swift',
Family = 'Credit');
insert prod;
Account_BBVA_Classification__c  ABBVAC = new Account_BBVA_Classification__c(account_id__c= lstAccounts[0].Id);
insert ABBVAC;
Account_Banking_System_Classification__c CSBS  = new Account_Banking_System_Classification__c(account_id__c= lstAccounts[0].Id);
insert CSBS;
Contact Contacto = new Contact(Salutation='Sr.',decision_making_desc__c='Si',LastName='testLast',FirstName='test',AccountId =lstAccounts[0].Id);
insert Contacto;
Branch__c  oficina = new Branch__c();
insert oficina;
User_Branch__c usuarioOficina = new User_Branch__c(branch_name__c=oficina.Id,user__c=lstOpportunities[0].ownerId );
insert usuarioOficina;

Id pricebookId = Test.getStandardPricebookId();

PricebookEntry standardPrice = new PricebookEntry(
Pricebook2Id = pricebookId, Product2Id = prod.Id,
UnitPrice = 10000, IsActive = true);
insert standardPrice;

Pricebook2 customPB = new Pricebook2(Name='PriceBook', isActive=true);
insert customPB;

PricebookEntry customPrice = new PricebookEntry(
Pricebook2Id = customPB.Id, Product2Id = prod.Id,
UnitPrice = 12000, IsActive = true);
insert customPrice;

lstOpportunitiesLineItem.add(New OpportunityLineItem(OpportunityId=lstOpportunities[0].Id ,Quantity=1,TotalPrice=10,PricebookEntryId=customPrice.Id));

insert lstOpportunitiesLineItem;
}


public static testMethod void positiveTest(){
Opportunity opp=[SELECT Id FROM  Opportunity LIMIT 1];
PageReference pageRef = Page.PDF_formalizacion_vfp;
PDFclassButton.PDF_formalization(opp.Id);
pageRef.getParameters().put('id',opp.id);
test.setCurrentPage(pageRef);
ApexPages.StandardController sc = new ApexPages.standardController(opp);
PDF_formalizacion_ctrl pdf = new PDF_formalizacion_ctrl(sc);
}

public static testMethod void positiveTestPDFClassButton(){
Opportunity opp =[SELECT Id FROM  Opportunity LIMIT 1];
opp.StageName='05';
update opp;
test.startTest();
string recordId = opp.Id;
PDFclassButton.getErrorMessagesList(recordId,'','');
test.stopTest();
}

public static testMethod void negativeTestPDFClassButton(){
User u = [SELECT Id FROM USER WHERE email ='user@BBVA.com'];
Opportunity opp =[SELECT Id FROM  Opportunity LIMIT 1];
opp.StageName='01';
update opp;
test.startTest();
system.runAs(u){
string recordId =[SELECT Id FROM  Opportunity LIMIT 1].Id;
PDFclassButton.getErrorMessagesList(recordId,'','');
}
test.stopTest();
}


}
