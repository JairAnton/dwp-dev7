public with sharing class classMasterParticipant {

	@InvocableMethod(label='Upsert Master Participant' description='Upsert Master Participant')
	public static void upsertMasterParticipant (List<OpportunityLineItem> listRow) {

		List<Opportunity>  opName = [Select Id,Account.Name,Account.AccountNumber,opportunity_product__c,opportunity_product_family__c From Opportunity WHERE Id=:listRow[0].OpportunityId  LIMIT 1];
    List<Product2>  opProduct = [Select Name, Family From Product2 WHERE Id=:listRow[0].Product2Id LIMIT 1];
    if(!opProduct.isEmpty())
    {
        opName[0].opportunity_product__c=opProduct[0].Name;
        opName[0].opportunity_product_family__c=opProduct[0].Family;
        update opName[0];
    }
		List<fprd__GBL_Intervener__c> row =[SELECT Id FROM fprd__GBL_Intervener__c WHERE Product__c=: listRow[0].Product2Id and Opportunity__c=: listRow[0].OpportunityId and  isMaster__c=true];
 		if(row.isEmpty())
 		{
 			fprd__GBL_Intervener__c nRow = new fprd__GBL_Intervener__c();
 			nRow.Product__c=listRow[0].Product2Id;
 			nRow.Opportunity__c=listRow[0].OpportunityId; 			
 			nRow.Name=opName[0].Account.Name;
 			nRow.Participation__c='01';
      nRow.DOI__c='01';
      nRow.N_DOI__c=opName[0].Account.AccountNumber;
      nRow.Marital_Status__c='04';
      nRow.isMaster__c=true;
 			insert nRow;
  		}
  		else
  		{
  			row[0].Name=opName[0].Account.Name;  			
        row[0].Participation__c='01';
        row[0].DOI__c='01';
        row[0].Marital_Status__c='04';
        row[0].N_DOI__c=opName[0].Account.AccountNumber;
  			update row;
  		}        
    
	}
}