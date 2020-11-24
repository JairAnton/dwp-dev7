/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_SM_TopicQVC_Cls>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2020-11-15
   @Description 
   @Changes
   Date        Author   Email                  Type
   2020-11-15  LMBR     lolo.bravo@bbva.com    Creation
   -------------------------------------------------------------------------------------------------
 */
global without sharing class BE_SM_TopicQVC_Cls implements slmt.Sales_Meeting_Item_Details_Itf {
    /**
    @Description createRecords
    @param Object contextRecord (Sales Meeting)
    @param  cardId
    @return BE_SingleRelatedListCRUD_Cls.Response response
    */
    public List<Map<String,String>> getCardDetails(sObject contextRecord, String cardId) {
        Integer totalTopics = 0;
        Integer topicsManager = 0;
        Integer topicsColl = 0;
        for(Task tsk : [SELECT Id, Subject, OwnerId FROM Task WHERE  (OwnerId=:(String)contextRecord.get('Collaborator__c')  OR OwnerId=:(String)contextRecord.get('slmt__mngmt_plan_meeting_user_id__c')) AND slmt__management_plan_meeting_id__r.OwnerId=:(String)contextRecord.get('Collaborator__c') AND ActivityDate <=:(Date)contextRecord.get('slmt__management_plan_meeting_date__c')]) {
            totalTopics++;
            if(tsk.OwnerId == contextRecord.get('Collaborator__c')) {
                topicsColl++;
            } else if(tsk.OwnerId == contextRecord.get('slmt__mngmt_plan_meeting_user_id__c')) {
                topicsManager++;
            }
        }
        final List<Map<String,String>> lstReturn = new List<Map<String,String>>();
        lstReturn.add(createItem(new List<String>{'', 'Temas', '08',cardId}));
        lstReturn.add(createItem(new List<String>{'Temas a tratar',String.valueOf(totalTopics),'06',cardId}));
        lstReturn.add(createItem(new List<String>{'Temas del gestor',String.valueOf(topicsManager) + ' de ' + String.valueOf(totalTopics),'08',cardId}));
        lstReturn.add(createItem(new List<String>{'Temas del responsable', String.valueOf(topicsColl) + ' de ' + String.valueOf(totalTopics),'08',cardId}));
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