/*-------------------------------------------------------------------------
 * Name: Product_cls
 * Description : Class to insert a record from Account
 * Created date : May 15 2018
 * Developer name: Isaías Velázquez Cortés Indra(México)
--------------------------------------------------------------------------*/

public with sharing class Product_cls {
	@AuraEnabled public static List<OpportunityLineItem> getIdProductByOpportunity(String IdOpportunity){
		List<OpportunityLineItem> row= [SELECT  Product2Id,gipr_Tipo_Garantia__c,gipr_Garantia__c,PE_DATE_Fecha_cotizacion__c FROM OpportunityLineItem Where OpportunityId=: IdOpportunity LIMIT 1];
		if(!row.isEmpty())
			return row;
		else
			return null;
	}

	@AuraEnabled public static Boolean verifyIfHasQuoted(String IdOpportunity){
		List<OpportunityLineItem> rowOpp=getIdProductByOpportunity(IdOpportunity);
		if(!rowOpp.isEmpty())
		{
			if(rowOpp[0].PE_DATE_Fecha_cotizacion__c!=null && String.valueOf(rowOpp[0].PE_DATE_Fecha_cotizacion__c)!='') return true; else return false;
		}else return false;
	}

	@AuraEnabled public static List<Product_Gurantee__c> getGuaranteeDataByProduct(String IdOpportunity,String IdProduct){	
		List<Product_Gurantee__c> objData= [SELECT Id,GuaranteeType__c,toLabel(Guarantee__c), toLabel(Modality__c), toLabel(Status__c),Term__c, toLabel(Periodicity__c),nGuarantee__c,Amount__c,isMaster__c FROM Product_Gurantee__c Where Product__c=: IdProduct AND Opportunity__c=: IdOpportunity Order by isMaster__c desc];
		return objData;
	}

	@AuraEnabled public static List<Product_Gurantee__c> getGuaranteeDataByProductValues(String PGuaranteeId){	

		List<Product_Gurantee__c> objData= [SELECT Id,GuaranteeType__c,Guarantee__c, Modality__c, Status__c,Term__c, Periodicity__c,nGuarantee__c,Amount__c,isMaster__c FROM Product_Gurantee__c Where Id=: PGuaranteeId];
		return objData;
	}

	@AuraEnabled public static List<Product_Participants__c> getParticipantDataByProduct(String IdOpportunity,String IdProduct){	
		List<Product_Participants__c> objData= [SELECT Id,Name,toLabel(DOI__c), toLabel(Marital_Status__c), toLabel(Participation__c),N_DOI__c,isMaster__c FROM Product_Participants__c Where Product__c=: IdProduct AND Opportunity__c=: IdOpportunity Order by isMaster__c desc];
		return objData;
	}

	@AuraEnabled public static List<Product_Participants__c> getParticipantDataByProductValues(String PParticipantId){	
		List<Product_Participants__c> objData= [SELECT Id,Name,DOI__c, Marital_Status__c, Participation__c,N_DOI__c,isMaster__c FROM Product_Participants__c Where  Id=: PParticipantId];
		return objData;
	}
               
	@AuraEnabled public static List<compromiso__c> getCompromisoDataByProduct(String IdOpportunity){	
		List<compromiso__c> objData= [SELECT PE_FM_PRODUCT__c,PE_DIVISA_Importe__c,PE_NUM_Plazo_Vcto__c,PE_FOR_Fecha_Vcto__c,PE_NUM_Permanencia__c,CurrencyIsoCode FROM compromiso__c Where  Oportunidad__c=:IdOpportunity];
		return objData;
	}

	@AuraEnabled public static List<OpportunityLineItem> getOpportunityLineItemDataByProduct(String IdOpportunity,String IdProduct){	
		List<OpportunityLineItem> objData= [SELECT Product2.Name,Opportunity.Amount,gipr_Plazo__c,toLabel(gipr_Periodicidad__c),PE_POR_TEA_propuesta__c,PE_POR_Spread__c,PE_POR_Comision__c FROM OpportunityLineItem Where OpportunityId=:IdOpportunity and Product2Id=:IdProduct];
		return objData;
	}

	@AuraEnabled public static String getOportunidadSytem(String Filtro) {       
        return Object_Controller.getOportunidadSytem(Filtro);       
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
		else row = new Product_Gurantee__c();

		row.Opportunity__c=IdOpportunity;
		row.Product__c=IdProuduct;
		row.GuaranteeType__c=GuaranteeType;
		row.Guarantee__c=Guarantee;
		row.nGuarantee__c=nGuarantee;
		row.Modality__c=Modality;
		row.Amount__c=Amount;
		row.Status__c=Status;
		row.Term__c=integer.valueOf(Term);
		row.Periodicity__c=Periodicity;
		row.Term__c=Term;

		if(PGuaranteeId!=null) update row; else insert row;	
		return true;
	}


	@AuraEnabled public static Boolean saveParticipantDataByProduct(String PParticipantId,String IdOpportunity,String IdProuduct,String Name,String DOI,String N_DOI,String Participation,String Marital_Status){
		
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

		if(PParticipantId!=null) update row; else insert row;	
		
		return true;
	}

	@AuraEnabled public static String setSanctionPrice(String OpportunityId,String sanAction){
		try
		{
			List<Opportunity> itemOpp= [SELECT Id,opportunity_status_type__c FROM Opportunity WHERE Id=: OpportunityId];
			if(!itemOpp.isEmpty())
			{
				if(sanAction=='btnApprove'){//08
					itemOpp[0].StageName='04';
					itemOpp[0].opportunity_status_type__c='08';

				}
				else if(sanAction=='btnRaise'){//09
					itemOpp[0].StageName='04';
					itemOpp[0].opportunity_status_type__c='09';
				}
				update itemOpp[0];
				return 'true';
			}
			else
			{
				return 'Error';
			}
			
		}
		catch(Dmlexception exp)
		{
			return exp.getMessage();
		}
		
	}

	@AuraEnabled public static String setFormalization(String OpportunityId,String Action,String Body){
		try
		{
			List<Opportunity> itemOpp= [SELECT Id,opportunity_status_type__c,StageName,OwnerId FROM Opportunity WHERE Id=: OpportunityId];
			if(!itemOpp.isEmpty())
			{
				if(Action=='btnApprove'){
                      id id1 = userinfo.getProfileId();
       String prof = [SELECT Name FROM profile WHERE id = :id1 LIMIT 1].Name;
     
        if((prof=='Ejecutivo'&& userinfo.getUserId()==itemOpp[0].OwnerId) || prof=='Administrador del Sistema' || prof=='Migracion'){
            
            
            
            itemOpp[0].IsProcess__c=true;
            update itemOpp[0];   
            itemOpp[0].StageName=label.lblFormalizarEtapa;
            itemOpp[0].opportunity_status_type__c=label.lblFormalizarStatus;          
            FeedItem post = new FeedItem();
            post.ParentId = OpportunityId;
            post.Body = body;
            if(!string.isBlank(Body))
            insert post;
            else{
            itemOpp[0].IsProcess__c=false;
            update itemOpp[0];     
            return label.lblNoCommentsFormalization;
            } 
            }

					
				}
				update itemOpp[0];
                itemOpp[0].IsProcess__c=false;
                update itemOpp[0]; 
				return 'true';
			}
			else
			{
				return 'Error';
			}
			
		}
		catch(Dmlexception exp)
		{
			return exp.getMessage();
		}
		
	}

  	@InvocableMethod(label='Delete Master Guarantee' description='Delete the row from Product_Guarantee')
 	public static void deleteMasterGuarantee(List<OpportunityLineItem> listRow)
    {
        List<Product_Gurantee__c> row =[SELECT Id FROM Product_Gurantee__c WHERE Product__c=: listRow[0].Product2Id and Opportunity__c=: listRow[0].OpportunityId and  isMaster__c=true LIMIT 1];
 		
 		if(!row.isEmpty())
        	delete row;
    }




}