/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_SM_CPlan_InversionRentable_Ctr>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2020-11-15
   @Description 
   @Changes
   Date        Author   Email                  Type
   2020-11-15  LMBR     lolo.bravo@bbva.com    Creation
   -------------------------------------------------------------------------------------------------
 */
public without sharing class BE_SM_CPlan_InversionRentable_Ctr extends BE_SingleRelatedListCRUD_Cls {
    /** PRODUCT_TYPE */
    final static String PRODUCT_TYPE='Direct';
    /** USERS POSITION CODE */
    final static List<List<String>> USERS_CODE=new List<List<String>>{(List<String>)System.Label.lblEjecutivoCode.split(','),(List<String>)System.Label.lblGOFCode.split(',')};
    /** FORMAT DATE */
    final static String FORMAT_DATE='yyy-MM-dd';
    /** oppIds */
    Set<Id> oppIds;
    /**
    @Description createRecords
    @param  List<SObject> sObjs
    @return BE_SingleRelatedListCRUD_Cls.Response response
    */
    public override BE_SingleRelatedListCRUD_Cls.Response readRecords(Map<String,Object> params) {
        final slmt__Sales_Meeting__c salesMeeting= [SELECT slmt__management_plan_meeting_date__c,Collaborator__r.prof_position_id__c,Collaborator__c FROM slmt__Sales_Meeting__c WHERE Id=:(String)params.get('recordId')];
        final DateTime salesDate=salesMeeting.slmt__management_plan_meeting_date__c;
        final Integer numberOfDays = Date.daysInMonth(salesDate.year(), salesDate.month());
        final DateTime firstDayOfMonth = DateTime.newInstance(salesDate.year(), salesDate.month(), 1);
        final DateTime lastDayOfMonth = DateTime.newInstance(salesDate.year(),salesDate.month(), numberOfDays);
        oppIds=new Set<Id>();
        /** OLIS */
        String queryOli= 'SELECT Id, OpportunityId FROM OpportunityLineItem WHERE  Product2.Type__c=\''+String.escapeSingleQuotes(PRODUCT_TYPE)+ '\' AND  Opportunity.CloseDate >='+firstDayOfMonth.format(FORMAT_DATE)
        + ' AND Opportunity.CloseDate <='+lastDayOfMonth.format(FORMAT_DATE)+' AND Opportunity.isClosed = false AND Opportunity.isWon = false';
        if(USERS_CODE[0].contains(salesMeeting.Collaborator__r.prof_position_id__c)) {
            queryOli=queryOli + ' AND Opportunity.OwnerId=\''+salesMeeting.Collaborator__c+'\' ORDER BY Opportunity.Amount DESC LIMIT 10';
        } else if(USERS_CODE[1].contains(salesMeeting.Collaborator__r.prof_position_id__c)) {
            final User_Branch__c branchUser = [SELECT Id,branch_name__r.branch_id__c FROM User_Branch__c WHERE User__c=:salesMeeting.Collaborator__c];
            queryOli=queryOli + ' AND Opportunity.Account.branch_id__r.branch_id__c=\''+branchUser.branch_name__r.branch_id__c+'\' ORDER BY Opportunity.Amount DESC LIMIT 10';
        }
        System.debug('##QUERY###'+queryOli);
        for (OpportunityLineItem  oli: Database.query(queryOli)) {
            oppIds.add(oli.OpportunityId);
        }
        return BE_SM_CPlan_Helper.getOpportunities(oppIds, params);
    }
}