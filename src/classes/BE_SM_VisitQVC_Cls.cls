/**
   -------------------------------------------------------------------------------------------------
   @Name BE_SM_VisitQVC_Cls
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-11-11
   @Description
   @Changes
   Date        Author   Email                  				Type
   2020-11-11  MAMCH    martin.mori.contractor@bbva.com    	Creation
   -------------------------------------------------------------------------------------------------
 */
global without sharing class BE_SM_VisitQVC_Cls implements slmt.Sales_Meeting_Item_Details_Itf {
    /*
	 * @Description method getCardDetails
	 */
    public List<Map<String,String>> getCardDetails(sObject contextRecord, String cardId) {
        Integer monthVisit = 0;
        Integer lastVisit = 0;
        Integer nextVisit = 0;
        Final Set<Id> userIds = BE_SM_Utils.getColaborators(String.valueOf(contextRecord.get('Collaborator__c')));
        Final Date smDate = Date.valueOf(contextRecord.get('slmt__management_plan_meeting_date__c'));
        for(dwp_kitv__Visit_Management_Team__c visitTeam : [SELECT Id, dwp_kitv__visit_id__c, dwp_kitv__user_id__c, dwp_kitv__visit_id__r.dwp_kitv__visit_status_type__c, dwp_kitv__visit_id__r.start_date_calculated__c FROM dwp_kitv__Visit_Management_Team__c 
                                                            WHERE dwp_kitv__user_id__c IN :userIds AND ((dwp_kitv__visit_id__r.start_date_calculated__c <= :smDate.addDays(30) AND dwp_kitv__visit_id__r.start_date_calculated__c >= :smDate.addDays(-30)) OR 
                                                            (CALENDAR_YEAR(dwp_kitv__visit_id__r.start_date_calculated__c) = :smDate.year() AND CALENDAR_MONTH(dwp_kitv__visit_id__r.start_date_calculated__c) = :smDate.month()))]) {
            Final Integer noOfDays = smDate.daysBetween(visitTeam.dwp_kitv__visit_id__r.start_date_calculated__c);
            monthVisit = getMonthVisits(visitTeam, smDate, monthVisit);
            lastVisit = getLastVisits(visitTeam, noOfDays, lastVisit);
            nextVisit = getNextVisits(visitTeam, noOfDays, nextVisit);
        }
        
        Final List<Map<String,String>> lstReturn = new List<Map<String,String>>();
        lstReturn.add(createItem(new List<String>{'', 'Visitas', '08', cardId}));
        lstReturn.add(createItem(new List<String>{'Realizadas en el mes', String.valueOf(monthVisit + ' de 30'), '08', cardId}));
        lstReturn.add(createItem(new List<String>{'Realizadas (ult 30 días)', String.valueOf(lastVisit), '06', cardId}));
        lstReturn.add(createItem(new List<String>{'Planificadas (prox 30 días)', String.valueOf(nextVisit), '06', cardId}));
        return lstReturn;
    }
    
    /*
	 * @Description method getMonthVisits
	 */
    private Integer getMonthVisits(dwp_kitv__Visit_Management_Team__c visitTeam, Date smDate, Integer monthVisit) {
        Integer returnVal = monthVisit;
        if(visitTeam.dwp_kitv__visit_id__r.dwp_kitv__visit_status_type__c == '06' && visitTeam.dwp_kitv__visit_id__r.start_date_calculated__c.year() == smDate.year() && visitTeam.dwp_kitv__visit_id__r.start_date_calculated__c.month() == smDate.month()) {
            returnVal++;
        }
        return returnVal;
    }
    
    /*
	 * @Description method getNextVisits
	 */
    private Integer getNextVisits(dwp_kitv__Visit_Management_Team__c visitTeam, Integer noOfDays, Integer nextVisit) {
        Integer returnVal = nextVisit;
        if(noOfDays>0 && noOfDays<=30 && (visitTeam.dwp_kitv__visit_id__r.dwp_kitv__visit_status_type__c == '01' || visitTeam.dwp_kitv__visit_id__r.dwp_kitv__visit_status_type__c == '02' || visitTeam.dwp_kitv__visit_id__r.dwp_kitv__visit_status_type__c == '03')) {
            returnVal++;
        }
        return returnVal;
    }
    
    /*
	 * @Description method getLastVisits
	 */
    private Integer getLastVisits(dwp_kitv__Visit_Management_Team__c visitTeam, Integer noOfDays, Integer lastVisit) {
        Integer returnVal = lastVisit;
        if(noOfDays<=0 && noOfDays>=-30 && (visitTeam.dwp_kitv__visit_id__r.dwp_kitv__visit_status_type__c == '04' || visitTeam.dwp_kitv__visit_id__r.dwp_kitv__visit_status_type__c == '05' || visitTeam.dwp_kitv__visit_id__r.dwp_kitv__visit_status_type__c == '06')) {
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