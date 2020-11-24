/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_SM_CommPlanQVC_Cls>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2020-11-15
   @Description 
   @Changes
   Date        Author   Email                  Type
   2020-11-15  LMBR     lolo.bravo@bbva.com    Creation
   -------------------------------------------------------------------------------------------------
 */
global without sharing class BE_SM_CommPlanQVC_Cls implements slmt.Sales_Meeting_Item_Details_Itf {
    /** PRODUCT TYPE */
    final static String  PRODUCT_TYPE='Direct';
    /**
    @Description createRecords
    @param Object contextRecord (Sales Meeting)
    @param  cardId
    @return BE_SingleRelatedListCRUD_Cls.Response response
    */
    public List<Map<String,String>> getCardDetails(sObject contextRecord, String cardId) {
        Decimal totalCommitment =  0.00;
        Decimal directCommitment = 0.00;
        Decimal advDirCommitment = 0.00;
        final List<String> args = new String[]{'0','number','###,###,##0.00'};
        final DateTime salesDate=(DateTime)contextRecord.get('slmt__management_plan_meeting_date__c');
        final Integer numberOfDays = Date.daysInMonth(salesDate.year(), salesDate.month());
        final DateTime firstDayOfMonth = DateTime.newInstance(salesDate.year(), salesDate.month(), 1);
        final DateTime lastDayOfMonth = DateTime.newInstance(salesDate.year(),salesDate.month(), numberOfDays);
        final List<dwp_frct__management_plan__c> cplans=[SELECT dwp_frct__mngmt_plan_tot_commitment_amount__c  FROM dwp_frct__management_plan__c WHERE dwp_frct__management_plan_end_date__c>=:(Date)contextRecord.get('slmt__management_plan_meeting_date__c') 
        AND dwp_frct__management_plan_start_date__c<=:(Date)contextRecord.get('slmt__management_plan_meeting_date__c') AND OwnerId=:(String)contextRecord.get('Collaborator__c')];
        totalCommitment=cplans.isEmpty()?0.0:cplans[0].dwp_frct__mngmt_plan_tot_commitment_amount__c;
        for (OpportunityLineItem  oli: [SELECT Id,convertCurrency(Opportunity.Amount)Amount,OpportunityId FROM OpportunityLineItem WHERE  Product2.Type__c=:PRODUCT_TYPE AND  Opportunity.CloseDate >=:firstDayOfMonth.date() AND Opportunity.CloseDate <=:lastDayOfMonth.date() AND Opportunity.isClosed = false AND Opportunity.isWon = false AND Opportunity.OwnerId =:(String)contextRecord.get('Collaborator__c') ORDER BY Opportunity.Amount DESC]) {
            directCommitment=directCommitment+oli.Opportunity.Amount;
        }
        for (Account_BBVA_Information__c  accInform : [SELECT Id, convertCurrency(current_balance_amount__c)current_balance_amount__c FROM Account_BBVA_Information__c WHERE account_id__r.OwnerId=:(String)contextRecord.get('Collaborator__c') AND type__c = '01'  AND product_desc__c NOT IN('') AND is_last_date__c = true AND product_group_classification_id__c='Directa']) {
            advDirCommitment=advDirCommitment+accInform.current_balance_amount__c;
        }
        final List<Map<String,String>> lstReturn = new List<Map<String,String>>();
        lstReturn.add(createItem(new List<String>{'', 'P. Comercial', '08',cardId}));
        lstReturn.add(createItem(new List<String>{'Total Compromiso',String.valueOf('S/.'+ String.format(totalCommitment.format(),args)),'08',cardId}));
        lstReturn.add(createItem(new List<String>{'Compromiso Directas',String.valueOf('S/.'+ String.format(directCommitment.format(),args)),'08',cardId}));
        lstReturn.add(createItem(new List<String>{'Avance en directas',String.valueOf('S/.'+ String.format(advDirCommitment.format(),args)),'08',cardId}));
        return lstReturn;
    }

    /** @Description method createItem*/
    private Map<String,String> createItem(List<String> lstObj) {
        Final Map<String,String> item = new Map<String,String>();
        item.put('value',lstObj[1]);
        item.put('type',lstObj[2]);
        item.put('format','###,###,##0');
        item.put('icon','NOTHING');
        item.put('typeIcon','NOTHING');
        item.put('idRecord',lstObj[3]);
        item.put('isSubtitle','true');
        if(String.isNotBlank(lstObj[0])) {
            item.put('label',lstObj[0]);
            item.put('isSubtitle','false');
        }
        return item;
    }
}