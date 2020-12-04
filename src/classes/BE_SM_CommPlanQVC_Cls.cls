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
    final static List<String> DIRECT_FAMILY=new List<String>{'Financiamiento a corto plazo','Financiamiento a largo plazo'};
    /** USERS POSITION CODE */
    final static List<List<String>> USERS_CODE=new List<List<String>>{(List<String>)System.Label.lblEjecutivoCode.split(','),(List<String>)System.Label.lblGOFCode.split(',')};
    /**@Description Quotes*/
    final static String QUOTES='\'';
    /**@Description params to quotes*/
    final static String REFACTORPER='@@';
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
        final String collaborator=(String)contextRecord.get('Collaborator__c');
        final List<String> args = new String[]{'0','number','###,###,##0.00'};
        /** USER */
        final String userCode=[SELECT prof_position_id__c FROM User WHERE Id=:collaborator].prof_position_id__c;
        /** TOTAL COMMITMENT */
        final List<dwp_frct__management_plan__c> cplans=[SELECT dwp_frct__mngmt_plan_tot_commitment_amount__c  FROM dwp_frct__management_plan__c WHERE dwp_frct__management_plan_end_date__c>=:(Date)contextRecord.get('slmt__management_plan_meeting_date__c') 
        AND dwp_frct__management_plan_start_date__c<=:(Date)contextRecord.get('slmt__management_plan_meeting_date__c') AND OwnerId=:collaborator];
        totalCommitment=cplans.isEmpty()?0.0:cplans[0].dwp_frct__mngmt_plan_tot_commitment_amount__c;
        /** DIRECT COMMITMENT */
        for (dwp_frct__grouping__c  grouping: [SELECT ID,dwp_frct__original_commitment_amount__c FROM dwp_frct__grouping__c WHERE  dwp_frct__management_plan_id__r.OwnerId=:collaborator AND dwp_frct__solution_category_type__c IN:DIRECT_FAMILY]) {
            directCommitment=directCommitment+grouping.dwp_frct__original_commitment_amount__c;
        }
        /** ADVANCE DIRECT COMMITMENT */
        String query= 'SELECT Id, convertCurrency(current_balance_amount__c)current_balance_amount__c FROM Account_BBVA_Information__c'+
        ' WHERE type__c = @@01@@ AND product_desc__c NOT IN(@@ @@) AND is_last_date__c = true AND product_group_classification_id__c=@@Directa@@';
        if(USERS_CODE[0].contains(userCode)) {
            query=query + ' AND account_id__r.OwnerId=@@' + collaborator+'@@';
        } else if(USERS_CODE[1].contains(userCode)) {
            final User_Branch__c branchUser = [SELECT Id,branch_name__r.branch_id__c FROM User_Branch__c WHERE User__c=:collaborator];
            query=query + ' AND account_id__r.branch_id__r.branch_id__c=@@' + branchUser.branch_name__r.branch_id__c+'@@';
        }
        for (Account_BBVA_Information__c accInform : Database.query(String.escapeSingleQuotes(query).removeEndIgnoreCase('LIKE').replace(REFACTORPER,QUOTES))) {
            advDirCommitment=advDirCommitment+accInform.current_balance_amount__c;
        }
        final List<Map<String,String>> lstReturn = new List<Map<String,String>>();
        lstReturn.add(createItem(new List<String>{'', 'P. Comercial', '08',cardId}));
        lstReturn.add(createItem(new List<String>{'Total compromiso',String.valueOf('S/.'+ String.format(totalCommitment.format(),args)),'08',cardId}));
        lstReturn.add(createItem(new List<String>{'Compromiso directas',String.valueOf('S/.'+ String.format(directCommitment.format(),args)),'08',cardId}));
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