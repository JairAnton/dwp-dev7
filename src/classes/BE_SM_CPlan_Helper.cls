/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_SM_CPlan_Helper>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2020-11-15
   @Description 
   @Changes
   Date        Author   Email                  Type
   2020-11-15  LMBR     lolo.bravo@bbva.com    Creation
   -------------------------------------------------------------------------------------------------
 */
public without sharing class BE_SM_CPlan_Helper {
    /** USERS POSITION CODE */
    final static List<List<String>> USERS_CODE=new List<List<String>>{(List<String>)System.Label.lblEjecutivoCode.split(','),(List<String>)System.Label.lblGOFCode.split(',')};
    /** FORMAT DATE */
    final static String FORMAT_DATE='yyy-MM-dd';
    /**
    @Description getOppIds
    @param  Map<String,Object> params
    @param  String proFamily
    @return Set<Id> oppIds
     */
    public static Set<Id> getOppIds(Map<String,Object> params, String proFamily) {
        final slmt__Sales_Meeting__c salesMeeting= [SELECT Name,Collaborator__r.prof_position_id__c,slmt__management_plan_meeting_date__c,Collaborator__c FROM slmt__Sales_Meeting__c WHERE Id=:(String)params.get('recordId')];
        final DateTime salesDate=(DateTime)salesMeeting.slmt__management_plan_meeting_date__c;
        final Integer numberOfDays = Date.daysInMonth(salesDate.year(), salesDate.month());
        final DateTime firstDayOfMonth = DateTime.newInstance(salesDate.year(), salesDate.month(), 1);
        final DateTime lastDayOfMonth = DateTime.newInstance(salesDate.year(),salesDate.month(), numberOfDays);
        final Set<Id> oppIds=new Set<Id>();
        /** OLIS */
        String queryOli= 'SELECT Id, OpportunityId FROM OpportunityLineItem WHERE  Product2.Family=\''+String.escapeSingleQuotes(proFamily)+ '\' AND  Opportunity.CloseDate >='+firstDayOfMonth.format(FORMAT_DATE) 
        + ' AND Opportunity.CloseDate <='+lastDayOfMonth.format(FORMAT_DATE)+' AND Opportunity.isClosed = false AND Opportunity.isWon = false';
        if(USERS_CODE[0].contains(salesMeeting.Collaborator__r.prof_position_id__c)) {
            queryOli=queryOli + ' AND Opportunity.OwnerId=\''+salesMeeting.Collaborator__c+'\' ORDER BY Opportunity.Amount DESC LIMIT 10';
        } else if(USERS_CODE[1].contains(salesMeeting.Collaborator__r.prof_position_id__c)) {
            final User_Branch__c branchUser = [SELECT Id,branch_name__r.branch_id__c FROM User_Branch__c WHERE User__c=:salesMeeting.Collaborator__c];
            queryOli=queryOli + ' AND Opportunity.Account.branch_id__r.branch_id__c=\''+branchUser.branch_name__r.branch_id__c+'\' ORDER BY Opportunity.Amount DESC LIMIT 10';
        }
        System.debug('###QUERY OLI###'+queryOli);
        for (OpportunityLineItem  oli: Database.query(queryOli)) {
            oppIds.add(oli.OpportunityId);
        }
        return oppIds;
    }
    
    /**
	 @Description  method getOpportunities
     @param  Set<Id> setIds
     @param  Map<String, Object> params
     @return BE_SingleRelatedListCRUD_Cls.Response response
	 */
    public static BE_SingleRelatedListCRUD_Cls.Response getOpportunities(Set<Id> setIds, Map<String, Object> params) {
        final BE_SingleRelatedListCRUD_Cls.Response response = new BE_SingleRelatedListCRUD_Cls.Response();
        final String query = 'SELECT Id, CurrencyIsoCode, '+ String.escapeSingleQuotes((String)params.get('sObjFields'))+ ' FROM '+ 
        String.escapeSingleQuotes((String)params.get('sObjName')) + ' WHERE Id IN:setIds';
        response.data = Database.query(query);
        response.isSuccess = true;
        return response;
    }
}