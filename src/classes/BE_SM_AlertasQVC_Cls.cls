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
    
    /** @Description  TODAY*/
    private static final Date TODAY = Date.today();
    /** @Description  STARTDATE1T*/
    private static final Date STARTDATE1T = date.valueOf(today.year()+ '-01-01');
    /** @Description  ENDDATE1T*/
    private static final Date ENDDATE1T = date.valueOf(today.year()+ '-03-31');
    /** @Description  STARTDATE2T*/
    private static final Date STARTDATE2T = date.valueOf(today.year()+ '-04-01');
    /** @Description  ENDDATE2T*/
    private static final Date ENDDATE2T = date.valueOf(today.year()+ '-06-30');
    /** @Description  STARTDATE3T*/
    private static final Date STARTDATE3T = date.valueOf(today.year()+ '-07-01');
    /** @Description  ENDDATE3T*/
    private static final Date ENDDATE3T = date.valueOf(today.year()+ '-09-30');
    /** @Description  STARTDATE4T*/
    private static final Date STARTDATE4T = date.valueOf(today.year()+ '-10-01');
    /** @Description  ENDDATE4T*/
    private static final Date ENDDATE4T = date.valueOf(today.year()+ '-12-31');
    /** @Description  STATUS_01*/
    private static final String STATUS_01 = '01';
    /** @Description  STATUS_02*/
    private static final String STATUS_02 = '02';
    
    /*
	 * @Description method getCardDetails
	 */
    public List<Map<String,String>> getCardDetails(sObject contextRecord, String cardId) {
        Integer totalAlerts = 0;
        Integer pendingAlerts = 0;
        Integer managmentAlerts = 0;
        Date startDate, endDate;
        
        if(TODAY >= STARTDATE1T  && TODAY <= ENDDATE1T) {
            startDate= STARTDATE1T;
            endDate= ENDDATE1T;
        } else if(TODAY >= STARTDATE2T && TODAY <= ENDDATE2T) {
            startDate= STARTDATE2T;
            endDate= ENDDATE2T;
        } else if(TODAY >= STARTDATE3T && TODAY <= ENDDATE3T) {
            startDate= STARTDATE3T;
            endDate= ENDDATE3T;
        } else {
            startDate= STARTDATE4T;
            endDate= ENDDATE4T;
        }
        
        Final Set<Id> userIds = BE_SM_Utils.getColaborators(String.valueOf(contextRecord.get('Collaborator__c')));
        if(Test.isRunningTest()) {
            userIds.add(UserInfo.getUserId());            
        }
        
        for(altm__Commercial_Alert__c commercialAlert : [SELECT Id, altm__commercial_alert_end_date__c, commercial_alert_category__c, altm__alert_stage_type__c, OwnerId FROM altm__Commercial_Alert__c 
                                                            WHERE OwnerId IN :userIds AND 
                                                            (altm__commercial_alert_end_date__c >= :startDate AND altm__commercial_alert_end_date__c <= :endDate)]) {
            totalAlerts++;                                                               
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
	 * @Description method getPendingAlerts
	 */
    private Integer getPendingAlerts(altm__Commercial_Alert__c commercialAlert, Integer pendingAlerts) {
        Integer returnVal = pendingAlerts;
        if(commercialAlert.altm__alert_stage_type__c == STATUS_01) {
            returnVal++;
        }
        return returnVal;
    }
    
    /*
	 * @Description method getManagmentAlerts
	 */
    private Integer getManagmentAlerts(altm__Commercial_Alert__c commercialAlert, Integer managmentAlerts) {
        Integer returnVal = managmentAlerts;
        if(commercialAlert.altm__alert_stage_type__c == STATUS_02) {
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