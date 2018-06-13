/*-------------------------------------------------------------------------
 * Name: OpportunityNewRecord_cls
 * Description : Class to insert a record from Account
 * Created date : May 01 2018
 * Developer name: Isaías Velázquez Cortés Indra(México)
--------------------------------------------------------------------------*/
public with sharing class Opportunity_cls {

	@AuraEnabled 
    public static String InsertOpportunity (String OpportunityName,String AccountId,String CloseDate,String PlanningDate,Decimal cAmount,String cCurrencyIsoCode,String cComment,String cProbability){
    	String resultado;
    	date CDate;
    	date PDate;
    	try{
    		if(!String.isBlank(PlanningDate)) PDate = Date.valueOf(PlanningDate);
	       
    		if(!String.isBlank(CloseDate)) CDate = Date.valueOf(CloseDate);			

			if(!String.isBlank(PlanningDate) && String.isBlank(CloseDate)) CDate=PDate.addDays(45);			
			else if(String.isBlank(PlanningDate) && String.isBlank(CloseDate))
				CDate=Date.today().addDays(60);			
						
	        Opportunity row= new Opportunity();
	        row.StageName='02';
	        row.Name=OpportunityName;
	        row.AccountId=AccountId;
			row.CloseDate=CDate;
	        if(!String.isBlank(PlanningDate)) { row.opportunity_planning_date__c=PDate;	row.opportunity_status_type__c = '02';} else row.opportunity_status_type__c = '03';
	        if(cAmount!=0) row.Amount=cAmount;
	       	if(!String.isBlank(cCurrencyIsoCode)) row.CurrencyIsoCode=cCurrencyIsoCode;
	        row.Description=cComment;
	        row.success_probability_desc__c	=cProbability;	        
	        insert row;  	        
	        resultado = row.Id;      
	    
	    } catch (DMLException e){
        
               throw new AuraHandledException('ERROR: '
                    + e.getMessage());    
        }
        finally {
                // Something executed whether there was an error or not
        }
       
        return resultado;
    }

    @AuraEnabled public static String getAccountName(String IdAccount){
		String  result = [SELECT  Name FROM Account Where Id=: IdAccount LIMIT 1][0].Name;
		return result;
	}
}