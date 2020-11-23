global class BE_SM_CampaignQVC_Cls implements slmt.Sales_Meeting_Item_Details_Itf {
    
    public List<Map<String,String>> getCardDetails(sObject contextRecord, String cardId) {
        Integer monthVisit = 0;
        Integer lastVisit = 0;
        Integer nextVisit = 0;
        /*for(dwp_kitv__Visit_Management_Team__c visitTeam : [SELECT Id, dwp_kitv__visit_id__c, dwp_kitv__user_id__c, dwp_kitv__visit_id__r.dwp_kitv__visit_status_type__c, dwp_kitv__visit_id__r.dwp_kitv__visit_start_date__c FROM dwp_kitv__Visit_Management_Team__c 
                                                            WHERE dwp_kitv__user_id__c = :String.valueOf(contextRecord.get('OwnerId')) AND 
                                                           ((dwp_kitv__visit_id__r.start_date_calculated__c <= :Date.valueOf(contextRecord.get('slmt__management_plan_meeting_date__c')).addDays(7) AND dwp_kitv__visit_id__r.start_date_calculated__c >= :Date.valueOf(contextRecord.get('slmt__management_plan_meeting_date__c')).addDays(-7)) OR 
                                                            (CALENDAR_YEAR(dwp_kitv__visit_id__r.start_date_calculated__c) = :Date.valueOf(contextRecord.get('slmt__management_plan_meeting_date__c')).year() AND CALENDAR_MONTH(dwp_kitv__visit_id__r.start_date_calculated__c) = :Date.valueOf(contextRecord.get('slmt__management_plan_meeting_date__c')).month()))]) {
            Integer noOfDays = Date.valueOf(visitTeam.dwp_kitv__visit_id__r.dwp_kitv__visit_start_date__c).daysBetween(Date.valueOf(contextRecord.get('slmt__management_plan_meeting_date__c')));
            if(visitTeam.dwp_kitv__visit_id__r.dwp_kitv__visit_status_type__c == '06' && visitTeam.dwp_kitv__visit_id__r.dwp_kitv__visit_start_date__c.year() == Date.valueOf(contextRecord.get('slmt__management_plan_meeting_date__c')).year() && visitTeam.dwp_kitv__visit_id__r.dwp_kitv__visit_start_date__c.month() == Date.valueOf(contextRecord.get('slmt__management_plan_meeting_date__c')).month()) {
                monthVisit++;
            }
            if(noOfDays>=0 && noOfDays<=7) {
                nextVisit++;
            } if(noOfDays<=0 && noOfDays>=-7) {
                lastVisit++;
            }
        }*/

        List<Map<String,String>> lstReturn = new List<Map<String,String>>();
        Map<String,String> title = new Map<String,String>();
        //title.put('label','Name');
        title.put('value','Campañas');
        title.put('type','08');
        title.put('format','NOTHING');
        title.put('icon','NOTHING');
        title.put('typeIcon','NOTHING');
        title.put('idRecord', cardId);
        title.put('isSubtitle','true');
        lstReturn.add(title);
        
        Map<String,String> item1 = new Map<String,String>();
        item1.put('label','Item 1');
        item1.put('value',String.valueOf(monthVisit));
        item1.put('type','06');
        item1.put('format','###,###,##0');
        item1.put('icon','NOTHING');
        item1.put('typeIcon','NOTHING');
        item1.put('idRecord', cardId);
        item1.put('isSubtitle','false');
        lstReturn.add(item1);
        
        Map<String,String> item2 = new Map<String,String>();
        item2.put('label','Item 2');
        item2.put('value',String.valueOf(lastVisit));
        item2.put('type','06');
        item2.put('format','###,###,##0');
        item2.put('icon','NOTHING');
        item2.put('typeIcon','NOTHING');
        item2.put('idRecord', cardId);
        item2.put('isSubtitle','false');
        lstReturn.add(item2);
        
        Map<String,String> item3 = new Map<String,String>();
        item3.put('label','Item 3');
        item3.put('value',String.valueOf(nextVisit));
        item3.put('type','06');
        item3.put('format','###,###,##0');
        item3.put('icon','NOTHING');
        item3.put('typeIcon','NOTHING');
        item3.put('idRecord', cardId);
        item3.put('isSubtitle','false');
        lstReturn.add(item3);
        
        return lstReturn;
    }
}