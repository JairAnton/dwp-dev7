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
global without sharing class BE_Calce_Delete_Batch implements Database.Batchable<sObject> {
    /*date used to process*/
    global final Date dateCal;
    /*query used to process*/
    global final String query;
    
    /**
    @Description constructor method
	@param Date date used to delete calce
    */
    global BE_Calce_Delete_Batch(Date dateCal) {
        this.dateCal = dateCal;
    }
    
    /**
    @Description constructor method
	*/
    global BE_Calce_Delete_Batch() {
        this.dateCal = System.today().addMonths(-1);
    }

    /**
    @Description start method
    @param Database.BatchableContext BatchableContextof batch
    @return Database.QueryLocator QueryLocator result query of calce
    */
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('SELECT Id FROM Calce__c WHERE close_date__c <= :dateCal');
    }

    /**
    @Description execute method
    @param Database.BatchableContext BatchableContextof batch
	@param List<Calce__c> list of calce
    */
    global void execute(Database.BatchableContext BC, List<Calce__c> lstCalce) {
        delete lstCalce;
    }

    /**
    @Description finish method
	*/
    public void finish(Database.BatchableContext BC) {
        
    }
}