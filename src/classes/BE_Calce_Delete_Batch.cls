/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_Calce_Delete_BS>
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-06-21
   @Description Schedulable class from BE_Calce_Delete_Batch
   @Changes
   Date        Author   Email                  				Type
   2020-06-21  MAMC     martin.mori.contractor@bbva.com    	Creation
   -------------------------------------------------------------------------------------------------
 */
public without sharing class BE_Calce_Delete_Batch implements Database.Batchable<sObject> {
    /*date used to process*/
    public final Date dateCal;
    /*query used to process*/
    public final String query;
    
    /**
    @Description constructor method
	@param Date date used to delete calce
    */
    public BE_Calce_Delete_Batch(Date dateCal) {
        this.dateCal = dateCal;
    }
    
    /**
    @Description constructor method
	*/
    public BE_Calce_Delete_Batch() {
        this.dateCal = System.today().addMonths(-1);
    }

    /**
    @Description start method
    @param Database.BatchableContext BatchableContextof batch
    @return Database.QueryLocator QueryLocator result query of calce
    */
    public Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator('SELECT Id FROM Calce__c WHERE close_date__c <= :dateCal');
    }

    /**
    @Description execute method
    @param Database.BatchableContext BatchableContextof batch
	@param List<Calce__c> list of calce
    */
    public void execute(Database.BatchableContext context, List<Calce__c> lstCalce) {
        delete lstCalce;
    }

    /**
    @Description finish method
	*/
    public void finish(Database.BatchableContext context) {
        
    }
}
