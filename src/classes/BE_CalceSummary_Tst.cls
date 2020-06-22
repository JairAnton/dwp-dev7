/**
   ----------------------------------------------------------------------------------------------------
   @Name <BE_CalceNewOpportunities_Ctr>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2020-02-24
   @Description Class Ctr for NewOpportunities
   @Changes
    Date        Author   Email                  Type
    2020-06-21  LMBR     lolo.bravo@bbva.com    Creation
   ----------------------------------------------------------------------------------------------------
 */
@isTest
public with sharing class BE_CalceSummary_Tst {
    /**
    @Description test method updateSummary
    */
    @isTest
    public static void readRecordsTest() {
     final Calce__c calce= new Calce__c(Name=String.valueof(Date.Today()),status__c='Iniciado');
     insert calce;
     final BE_CalceSummary_Ctr.Response res=BE_CalceSummary_Ctr.updateSummaryCalce(calce);
     BE_CalceSummary_Ctr.getSummaryCalce(calce.Id);
     System.assert(res.isSuccess, 'Calce Summary Successfull.');
    }
    /**
    @Description test method updateSummary exception
    */
    @isTest
    public static void readRecordsTestException() {
     final Calce__c calce= new Calce__c(Name=String.valueof(Date.Today()),status__c='Iniciado');
     insert calce;
     calce.status__c='Test';
     final BE_CalceSummary_Ctr.Response res=BE_CalceSummary_Ctr.updateSummaryCalce(calce);
     System.assert(!res.isSuccess, 'Calce Summary Error.');
    }
}