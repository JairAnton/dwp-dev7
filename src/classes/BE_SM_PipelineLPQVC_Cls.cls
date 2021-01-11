/**
   -------------------------------------------------------------------------------------------------
   @Name BE_SM_PipelineLPQVC_Cls
   @Author Diego Carbajal Pastor (diego.carbajal@bbva.com)
   @Date 2020-11-10
   @Description
   @Changes
   Date        Author   Email                  Type
   2020-11-10  DCP     diego.carbajal@bbva.com    Creation
   -------------------------------------------------------------------------------------------------
 */
global without sharing class BE_SM_PipelineLPQVC_Cls implements slmt.Sales_Meeting_Item_Details_Itf {

    /** @Description  Variable THIS_MONTH*/
    private static Final String THIS_MONTH = 'thisMonth';
    /** @Description  Variable THIS_AMOUNT*/
    private static Final String THIS_AMOUNT = 'thisAmount';
    /** @Description  Variable NEXT_MONTH*/
    private static Final String NEXT_MONTH = 'nextMonth';
    /** @Description  Variable NEXT_AMOUNT*/
    private static Final String NEXT_AMOUNT = 'nextAmount';

    /*
	 * @Description  method getCardDetails
	 */
    public List<Map<String,String>> getCardDetails(sObject contextRecord, String cardId) {
        Final slmt__Sales_Meeting__c salesMeeting= [SELECT slmt__management_plan_meeting_date__c, Collaborator__c 
                                                    FROM slmt__Sales_Meeting__c WHERE Id=:contextRecord.Id];
        Final Map<String, Decimal> mapResult = getCurrentOpps(salesMeeting);
        Final Integer thisMonth = Integer.valueOf(mapResult.get(THIS_MONTH));
        Final Integer thisMontNew = getNewOpps(salesMeeting);
        Final Integer nextMonth = Integer.valueOf(mapResult.get(NEXT_MONTH));
        Final List<String> formato = new String[]{'0','number','###,###,##0.00'};

        Final List<Map<String,String>> lstReturn = new List<Map<String,String>>();
        //Map<String,String> title = new Map<String,String>();

        lstReturn.add(createItem('', 'Pipeline LP', '08'));
        lstReturn.add(createItem('Activas en el mes', String.valueOf(thisMonth+' (S/.'+ 
                                                        String.format(mapResult.get(THIS_AMOUNT).format(),formato )+')'), '08'));
        lstReturn.add(createItem('Ingresadas en el mes', String.valueOf(thisMontNew), '06'));
        lstReturn.add(createItem('Activas en el mes siguiente', String.valueOf(nextMonth+' (S/.'+ String.format(mapResult.get(NEXT_AMOUNT).format(), formato) + ')'), '08'));
        
        return lstReturn;
    }

    /*
	 * @Description  method getCurrentOpps
	 */
    private Map<String, Decimal> getCurrentOpps(slmt__Sales_Meeting__c salesMeeting) {
        Final Map<String, Decimal> mapResult = new Map<String, Decimal>{THIS_MONTH => 0, NEXT_MONTH => 0, THIS_AMOUNT => 0, NEXT_AMOUNT => 0};
        Final BE_SingleRelatedListCRUD_Cls.Response response = BE_SM_Opportunity_helper.getSMPipeline(new Set<String>{'02', '03', '04', '05'}, 
                                                            new Map<String, Object>{'recordId' => salesMeeting.Id, 'sObjName' => 'Opportunity', 
                                                            'sObjFields' => 'CloseDate,StageName,Amount,convertCurrency(amount) convertedCurrency'});
        Date fecha; 
        if(response.isSuccess) {
            for(SObject obj :response.data) {
                fecha = (Date)obj.get('CloseDate');
                if(fecha.month() == salesMeeting.slmt__management_plan_meeting_date__c.month()) {
                    mapResult.put(THIS_MONTH, mapResult.get(THIS_MONTH) + 1);
                    mapResult.put(THIS_AMOUNT, mapResult.get(THIS_AMOUNT) + (Decimal)obj.get('convertedCurrency'));
                } else {
                    mapResult.put(NEXT_MONTH, mapResult.get(NEXT_MONTH) + 1);
                    mapResult.put(NEXT_AMOUNT, mapResult.get(NEXT_AMOUNT) + (Decimal)obj.get('convertedCurrency'));
                }
            }
        }
        return mapResult;
    }

    /*
	 * @Description  method getNewOpps
	 */
    private Integer getNewOpps(slmt__Sales_Meeting__c salesMeeting) {
        Final Set<String> setStages = new Set<String>{'01', '02', '03', '04', '05', '06', '07'};
        Final Set<Id> setIdsCol = BE_SM_Utils.getColaborators(salesMeeting.Collaborator__c);
        Final Set<Id> setAuxIdsOpp = BE_SM_Opportunity_helper.getOppIdsInColaboration(setIdsCol, setStages);
        Final List<String> lstProducts = System.Label.Opp_LP_Products.split(',');
        Final Integer year = salesMeeting.slmt__management_plan_meeting_date__c.year();
        Final Integer month = salesMeeting.slmt__management_plan_meeting_date__c.month();
        Final Date lastDate = Date.newInstance(year, month, Date.daysInMonth(year, month));
        Final Date initDate = Date.newInstance(year, month, 1);
        Final Set<Id> setIdsOpp = new Set<Id>();
        for(OpportunityLineItem oli: [SELECT Id, OpportunityId FROM OpportunityLineItem WHERE Opportunity.stageName IN: setStages 
                                    AND Opportunity.CreatedDate >=:initDate AND Opportunity.CreatedDate <=:lastDate AND Product2.Unique_id__c IN: lstProducts AND 
                                    (Opportunity.OwnerId IN:setIdsCol OR OpportunityId in:setAuxIdsOpp)]) {
            setIdsOpp.add(oli.OpportunityId);
        }
        return setIdsOpp.size();
    }

    /*
	 * @Description method createItem
	 */
    private Map<String,String> createItem(String label, String value, String type) {
        Final Map<String,String> item = new Map<String,String>();
        item.put('value',value);
        item.put('type',type);
        item.put('format','');
        item.put('icon','NOTHING');
        item.put('typeIcon','NOTHING');
        item.put('idRecord','Item3');
        item.put('isSubtitle','true');
        if(String.isNotBlank(label)) {
            item.put('label',label);
            item.put('isSubtitle','false');
        }
        return item;
    }
}