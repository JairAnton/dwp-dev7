@isTest
public class TestFactory {
    public static User createUser(String userName, String Perfil){
    	User u = new User();
        u.Username=userName+'u2@u.com.u';
		u.LastName=userName+'uLast2';
          u.Email=userName+'u2@u.com';
          u.Alias= userName.substring(0, 2)+'uAas2';
          u.CommunityNickname=userName+'2uComm';
          u.TimeZoneSidKey='America/Mexico_City';
          u.LocaleSidKey='en_US';
          u.EmailEncodingKey='ISO-8859-1';
          List<Profile> prof=new List<Profile>([SELECT Id, Name FROM Profile where Name=:Perfil]);
          u.ProfileId=  prof[0].Id;
          u.LanguageLocaleKey='en_US';
          insert u;
    	return u;
    }
    public static Opportunity createOpportunity(Id accountId,Id userId){
    	Opportunity opp = new Opportunity(ownerId=userId,Name='testopp', AccountId=accountId,StageName='01',Amount=100 ,CloseDate=system.Date.today(),opportunity_status_type__c='01');
    	insert opp;
        return opp;
    }
    
    public static Attachment createAttachment(Id parentId, String attachmentName){
    	Attachment attach=new Attachment(); 
        attach.Name= attachmentName; 
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body'); 
        attach.body=bodyBlob; 
        attach.parentId=parentId; 
        attach.ContentType = 'application/msword'; 
        attach.IsPrivate = false; 
        attach.Description = 'Test'; 
        insert attach; 
    	return attach;
    
	}    
    public static Product2 createProduct (){
    	Product2 prod = new Product2(Name = 'Swift',
                                     Family = 'Credit');
    	insert prod;
        return prod;
    }
    
    public static OpportunityLineItem createOLI (Id oppId,Id prodId){
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry(
        Pricebook2Id = pricebookId, Product2Id = prodId,UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        Pricebook2 customPB = new Pricebook2(Name='PriceBook', isActive=true);
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry(
        Pricebook2Id = customPB.Id, Product2Id = prodId,
        UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        OpportunityLineItem oli = New OpportunityLineItem(OpportunityId=oppId ,Quantity=1,TotalPrice=10.00,PricebookEntryId=customPrice.Id,Product2Id=prodId);
        insert oli;
        return oli;
    }
    
    public static Account createAccount(){
        Account acc=new Account(Name = 'TestAcct');
        insert acc;
        return acc;
    }
    
    public static Account_BBVA_Classification__c createAccBBVAClass(Id acc){
        Account_BBVA_Classification__c accClass = new  Account_BBVA_Classification__c(account_id__c=acc);
        insert accClass;
        return accClass;
	}

	public static Account_Banking_System_Classification__c createAccBankingSystClass(Id acc){
        Account_Banking_System_Classification__c accClass = new  Account_Banking_System_Classification__c(account_id__c=acc);
        insert accClass;
        return accClass;
	}
    
    public static Contact createContact(Id acc){
        Contact c = new  Contact(accountid=acc,LastName='test',FirstName='test',Salutation='Mr.',decision_making_desc__c='Si');
        insert c;
        return c;
	} 
    
    public static User_Branch__c createUserBranch (Id userId){
    	Branch__c branch = new Branch__c (Name='Test');
        insert branch;
        User_Branch__c userBranch = new User_Branch__c(branch_name__c=branch.id,User__c = userId);
    	insert userBranch;
        return userBranch; 
    }
    
    public static Account_Rating__c createAccRating (Id accountId){
    	Account_Rating__c accRating = new Account_Rating__c (account_id__c=accountId,total_rating_score_number__c=1);
        insert accRating;
        return accRating; 
    }
    
    public static Product_participants__c createParticipants (Id oppId){
    	Product_participants__c part = new Product_participants__c (Name='Test');
        insert part;
        return part; 
    }
    
    public static Product_Gurantee__c createGuarantee (Id oppId){
        Product_Gurantee__c guarant = new Product_Gurantee__c ();
        insert guarant;
        return guarant; 
    }
    
  
}