/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_SM_CPlan_Recursos_Ctr>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2020-11-15
   @Description 
   @Changes
   Date        Author   Email                  Type
   2020-11-15  LMBR     lolo.bravo@bbva.com    Creation
   -------------------------------------------------------------------------------------------------
 */
public with sharing class BE_SM_CPlan_Recursos_Ctr  extends BE_SingleRelatedListCRUD_Cls {
    /** PRODUCT_TYPE */
    final static String PRODUCT_FAMILY='Recursos';
    /**
    @Description createRecords
    @param  List<SObject> sObjs
    @return BE_SingleRelatedListCRUD_Cls.Response response
    */
    public override BE_SingleRelatedListCRUD_Cls.Response readRecords(Map<String,Object> params) {
        final BE_SingleRelatedListCRUD_Cls.Response res= new BE_SingleRelatedListCRUD_Cls.Response();
        final slmt__Sales_Meeting__c salesMeeting= [SELECT Name,slmt__management_plan_meeting_date__c,Collaborator__c FROM slmt__Sales_Meeting__c WHERE Id=:(String)params.get('recordId')];
        final DateTime salesDate=(DateTime)salesMeeting.slmt__management_plan_meeting_date__c;
        final Integer numberOfDays = Date.daysInMonth(salesDate.year(), salesDate.month());
        final DateTime firstDayOfMonth = DateTime.newInstance(salesDate.year(), salesDate.month(), 1);
        final DateTime lastDayOfMonth = DateTime.newInstance(salesDate.year(),salesDate.month(), numberOfDays);
        List<String> oppIds=new List<String>();
        for (OpportunityLineItem  oli: [SELECT Id, OpportunityId FROM OpportunityLineItem WHERE  Product2.Family=:PRODUCT_FAMILY AND  Opportunity.CloseDate >=:firstDayOfMonth.date() AND Opportunity.CloseDate <=:lastDayOfMonth.date() AND Opportunity.isClosed = false AND Opportunity.isWon = false AND Opportunity.OwnerId =:salesMeeting.Collaborator__c  ORDER BY Opportunity.Amount DESC LIMIT 10]) {
            oppIds.add(oli.OpportunityId);
        }
        final String query = 'SELECT '+ params.get('sObjFields')+ ' FROM '+ params.get('sObjName') + ' WHERE Id IN:oppIds';
        res.isSuccess=true;
        res.data=Database.query(String.escapeSingleQuotes(query));
        return res;
    }
}