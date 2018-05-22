/*-------------------------------------------------------------------------
 * Name: Product_cls
 * Description : Class to insert a record from Account
 * Created date : May 15 2018
 * Developer name: Isaías Velázquez Cortés Indra(México)
--------------------------------------------------------------------------*/

public with sharing class Product_cls {
	@AuraEnabled public static List<OpportunityLineItem> getIdProductByOpportunity(String IdOpportunity){
		List<OpportunityLineItem> row= [SELECT  Product2Id,gipr_Tipo_Garantia__c,gipr_Garantia__c FROM OpportunityLineItem Where OpportunityId=: IdOpportunity LIMIT 1];
		return row;
	}

	@AuraEnabled public static List<Product_Gurantee__c> getGuaranteeDataByProduct(String IdOpportunity,String IdProduct){	
		List<Product_Gurantee__c> objData= [SELECT Id,GuaranteeType__c,toLabel(Guarantee__c), toLabel(Modality__c), toLabel(Status__c),Term__c, toLabel(Periodicity__c),nGuarantee__c,Amount__c FROM Product_Gurantee__c Where Product__c=: IdProduct AND Opportunity__c=: IdOpportunity];
		return objData;
	}

	@AuraEnabled public static List<Product_Gurantee__c> getGuaranteeDataByProductValues(String PGuaranteeId){	

		List<Product_Gurantee__c> objData= [SELECT Id,GuaranteeType__c,Guarantee__c, Modality__c, Status__c,Term__c, Periodicity__c,nGuarantee__c,Amount__c FROM Product_Gurantee__c Where Id=: PGuaranteeId];
		return objData;
	}

	@AuraEnabled public static List<Product_Participants__c> getParticipantDataByProduct(String IdOpportunity,String IdProduct){	
		List<Product_Participants__c> objData= [SELECT Id,Name,toLabel(DOI__c), toLabel(Marital_Status__c), toLabel(Participation__c),N_DOI__c FROM Product_Participants__c Where Product__c=: IdProduct AND Opportunity__c=: IdOpportunity];
		return objData;
	}

	@AuraEnabled public static List<Product_Participants__c> getParticipantDataByProductValues(String PParticipantId){	
		List<Product_Participants__c> objData= [SELECT Id,Name,DOI__c, Marital_Status__c, Participation__c,N_DOI__c FROM Product_Participants__c Where  Id=: PParticipantId];
		return objData;
	}

	@AuraEnabled public static Boolean deleteGuaranteeDataByProduct(String IdProductGuarantee){
		Product_Gurantee__c objData= [SELECT Id FROM Product_Gurantee__c Where Id=: IdProductGuarantee];
		delete objDAta;
		return true;
	}

	@AuraEnabled public static Boolean deleteParticipantDataByProduct(String IdProductParticipant){
		Product_Participants__c objData= [SELECT Id FROM Product_Participants__c Where Id=: IdProductParticipant];
		delete objDAta;
		return true;
	}

	@AuraEnabled public static Boolean saveGuaranteeDataByProduct(String PGuaranteeId,String IdOpportunity,String IdProuduct,String GuaranteeType,String Guarantee,String Modality,Decimal Amount,String Status,Integer Term,String Periodicity,Integer nGuarantee){
		Product_Gurantee__c row;
		if(PGuaranteeId!=null)		
			row = [SELECT Id,GuaranteeType__c,Guarantee__c, Modality__c, Status__c,Term__c, Periodicity__c,nGuarantee__c,Amount__c FROM Product_Gurantee__c Where Id=: PGuaranteeId];
		else
			row = new Product_Gurantee__c();

		row.Opportunity__c=IdOpportunity;
		row.Product__c=IdProuduct;
		row.GuaranteeType__c=GuaranteeType;
		row.Guarantee__c=Guarantee;
		row.nGuarantee__c=nGuarantee;
		row.Modality__c=Modality;
		row.Amount__c=Amount;
		row.Status__c=Status;
		row.Term__c=Term;
		row.Periodicity__c=Periodicity;
		row.Term__c=Term;

		if(PGuaranteeId!=null)
			update row;			
		else insert row;	
		return true;
	}


	@AuraEnabled public static Boolean saveParticipantDataByProduct(String PParticipantId,String IdOpportunity,String IdProuduct,String Name,String DOI,Decimal N_DOI,String Participation,String Marital_Status){
		
		Product_Participants__c row;
		if(PParticipantId!=null)		
			row = [SELECT Id,Name,DOI__c, Marital_Status__c, Participation__c,N_DOI__c FROM Product_Participants__c Where Id=:PParticipantId ];
		else row = new Product_Participants__c();

		row.Opportunity__c=IdOpportunity;
		row.Product__c=IdProuduct;
		row.Name=Name;
		row.DOI__c=DOI;
		row.N_DOI__c=N_DOI;
		row.Participation__c=Participation;		
		row.Marital_Status__c=Marital_Status;		

		if(PParticipantId!=null)		
			update row;			
		else insert row;	
		
		return true;
	}
}