public with sharing class classMasterParticipant {

	@InvocableMethod(label='Upsert Master Participant' description='Upsert Master Participant')
	public static void upsertMasterParticipant (List<OpportunityLineItem> listRow) {

		List<Opportunity>  opName = [Select Account.Name From Opportunity WHERE Id=:listRow[0].OpportunityId  LIMIT 1];

		List<Product_Participants__c> row =[SELECT Id FROM Product_Participants__c WHERE Product__c=: listRow[0].Product2Id and Opportunity__c=: listRow[0].OpportunityId and  isMaster__c=true];
 		if(row.isEmpty())
 		{
 			Product_Participants__c nRow = new Product_Participants__c();
 			nRow.Product__c=listRow[0].Product2Id;
 			nRow.Opportunity__c=listRow[0].OpportunityId; 			
 			nRow.Name=opName[0].Account.Name;
 			nRow.isMaster__c=true;
 			insert nRow;
  		}
  		else
  		{
  			row[0].Name=opName[0].Account.Name;  			
  			update row;
  		}        
    
	}
}