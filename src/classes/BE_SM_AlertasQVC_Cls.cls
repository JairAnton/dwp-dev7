/**
   -------------------------------------------------------------------------------------------------
   @Name BE_SM_AlertasQVC_Cls
   @Author Gerson R. Díaz Alvarado (gerson.diaz@bbva.com)
   @Date 2021-05-07
   @Description
   @Changes
   Date        Author   Email                  				Type
   2021-05-07  GRDA 	gerson.diaz@bbva.com		    	Creation
   -------------------------------------------------------------------------------------------------
 */
global without sharing class BE_SM_AlertasQVC_Cls implements slmt.Sales_Meeting_Item_Details_Itf {
    /*
	 * @Description method getCardDetails
	 */
    public List<Map<String,String>> getCardDetails(sObject contextRecord, String cardId) {
        Integer totalAlerts = 0;
        Integer pendingAlerts = 0;
        Integer managmentAlerts = 0;
        Integer wonAlerts = 0;
        Integer descartedAlerts = 0;
        final Date today = Date.today();
        final Date startDate, endDate;
        final Date StartDate1T = date.valueOf(String.valueOf(today.year())+ '-01-01');
        final Date EndDate1T = date.valueOf(String.valueOf(today.year())+ '-03-31');
        final Date StartDate2T = date.valueOf(String.valueOf(today.year())+ '-04-01');
        final Date EndDate2T = date.valueOf(String.valueOf(today.year())+ '-06-30');
        final Date StartDate3T = date.valueOf(String.valueOf(today.year())+ '-07-01');
        final Date EndDate3T = date.valueOf(String.valueOf(today.year())+ '-09-30');
        final Date StartDate4T = date.valueOf(String.valueOf(today.year())+ '-10-01');
        final Date EndDate4T = date.valueOf(String.valueOf(today.year())+ '-12-31');
        
        if(today >= StartDate1T  && today <= EndDate1T){
            startDate= StartDate1T;
            endDate= EndDate1T;
        }
        else if(today >= StartDate2T && today <= EndDate2T){
            startDate= StartDate2T;
            endDate= EndDate2T;
        }
        else if(today >= StartDate3T && today <= EndDate3T){
            startDate= StartDate3T;
            endDate= EndDate3T;
        }
        else{
            startDate= StartDate4T;
            endDate= EndDate4T;
        }
        
        Final Set<Id> userIds = BE_SM_Utils.getColaborators(String.valueOf(contextRecord.get('Collaborator__c')));
        if(Test.isRunningTest())
            userIds.add(UserInfo.getUserId());
        
        for(altm__Commercial_Alert__c commercialAlert : [SELECT Id, altm__commercial_alert_end_date__c, commercial_alert_category__c, altm__alert_stage_type__c, OwnerId FROM altm__Commercial_Alert__c 
                                                            WHERE OwnerId IN :userIds AND 
                                                            (altm__commercial_alert_end_date__c >= :startDate AND altm__commercial_alert_end_date__c <= :endDate)]) {
            totalAlerts = getTotalAlerts(commercialAlert, totalAlerts);                                                                
            pendingAlerts = getPendingAlerts(commercialAlert, pendingAlerts);
            managmentAlerts = getManagmentAlerts(commercialAlert, managmentAlerts);
        }
        
        Final List<Map<String,String>> lstReturn = new List<Map<String,String>>();
        lstReturn.add(createItem(new List<String>{'', 'Alertas', '08', cardId}));
        lstReturn.add(createItem(new List<String>{'Del Trimestre', String.valueOf(totalAlerts), '08', cardId}));
        lstReturn.add(createItem(new List<String>{'Pendiente de Iniciar', String.valueOf(managmentAlerts), '06', cardId}));
        lstReturn.add(createItem(new List<String>{'En Gestión', String.valueOf(managmentAlerts), '06', cardId}));
        return lstReturn;
    }
    
    /*
	 * @Description method getTotalAlerts
	 */
    private Integer getTotalAlerts(altm__Commercial_Alert__c commercialAlert, Integer totalAlert) {
        return ++totalAlert;
    }
    
    /*
	 * @Description method getPendingAlerts
	 */
    private Integer getPendingAlerts(altm__Commercial_Alert__c commercialAlert, Integer pendingAlerts) {
        Integer returnVal = pendingAlerts;
        if(commercialAlert.altm__alert_stage_type__c == '01') {
            returnVal++;
        }
        return returnVal;
    }
    
    /*
	 * @Description method getManagmentAlerts
	 */
    private Integer getManagmentAlerts(altm__Commercial_Alert__c commercialAlert, Integer managmentAlerts) {
        Integer returnVal = managmentAlerts;
        if(commercialAlert.altm__alert_stage_type__c == '02') {
            returnVal++;
        }
        return returnVal;
    }
    
    /*
	 * @Description method createItem
	 */
    private Map<String,String> createItem(List<String> ltsObj) {
        Final Map<String,String> item = new Map<String,String>();
        item.put('value',ltsObj[1]);
        item.put('type',ltsObj[2]);
        item.put('format','###,###,##0');
        item.put('icon','NOTHING');
        item.put('typeIcon','NOTHING');
        item.put('idRecord',ltsObj[3]);
        item.put('isSubtitle','true');
        if(String.isNotBlank(ltsObj[0])) {
            item.put('label',ltsObj[0]);
            item.put('isSubtitle','false');
        }
        return item;
    }
}