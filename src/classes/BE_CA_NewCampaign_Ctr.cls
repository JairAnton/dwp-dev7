/**
   ----------------------------------------------------------------------------------------------------
   @Name <BE_CA_NewCampaign_Ctr>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2020-02-24
   @Description Class  for Create Contact of Non Client
   @Changes
    Date        Author   Email                                      Type
    2020-02-24  LMBR     lolo.bravo@bbva.com                        Creation
    2020-03-01  LMBR     luis.vargas.matute.contractor@bbva.com     Update
   ----------------------------------------------------------------------------------------------------
 */
public with sharing class BE_CA_NewCampaign_Ctr extends BE_CustomQuickActionCRUD_Cls {

    /**
    @Description createRecords
    @param  List<SObject> sObjs
    @return BE_SingleRelatedListCRUD_Cls.Response response
    */
    public override BE_CustomQuickActionCRUD_Cls.Response createRecord(sObject sObj,Map<String,Object> params) {
        
        final BE_CustomQuickActionCRUD_Cls.Response res = new BE_CustomQuickActionCRUD_Cls.Response();
        final Id currentRoleId = UserInfo.getUserRoleId();
        final list<string> ejecutive_position_code = new list<string> {'E03','I32'};
        final string recordTypeName= 'Record_Type_Client';
        
        try {           
            List<altm__Commercial_Alert__c> alerList = new List<altm__Commercial_Alert__c>();
            final Map<String,User> allExcUsers = getRoleSubordinateUsers(currentRoleId, ejecutive_position_code);
            final Map<Id,Campaign> campaignMap = generateCampaigns(allExcUsers, sObj);
            if( !campaignMap.isEmpty() ) {
                upsert campaignMap.values();
                alerList = generateAlerts(sObj, recordTypeName, allExcUsers, campaignMap);
                if( !alerList.isEmpty() ) {
                    upsert alerList;
                }
            }

            res.isSuccess=true;
            res.data=sObj;
        } catch (DmlException e) {
            res.isSuccess=false;
            res.message=e.getMessage();
        }
        return res;
    }
    
    /**
    @Description Get Roles of Hierarchy
    @param  Id roleId, list<string> pos_code
    @return Set<ID> response
    */
    private static Map<String,User> getRoleSubordinateUsers(Id roleId, list<string> pos_code) {
        final Set<Id> allSubRoleIds = getAllSubRoleIds(new Set<ID>{roleId});
        //final Map<Id,User> users = new Map<Id, User>([Select Id, Name,user_id__c From User where IsActive = True AND UserRoleId IN :allSubRoleIds AND prof_position_id__c IN :pos_code]);
        final Map<String,User> usersMap = new Map<String,User>();
        for(user userItem:[Select Id, Name,user_id__c,Unique_id__c From User where IsActive = True AND UserRoleId IN :allSubRoleIds AND prof_position_id__c IN :pos_code]) {
            usersMap.put(userItem.user_id__c,userItem);
        }
        return usersMap;
    }
    
    /**
    @Description Get All Sub Roles
    @param  Set<ID> roleIds
    @return Set<ID> response
    */
    private static Set<ID> getAllSubRoleIds(Set<ID> roleIds) {
        Set<ID> currentRoleIds = new Set<ID>();      
        for(UserRole userRole :[select Id from UserRole where ParentRoleId IN :roleIds]) {
            currentRoleIds.add(userRole.Id);
        }
        if(currentRoleIds.size() > 0) {
            currentRoleIds.addAll(getAllSubRoleIds(currentRoleIds));
        }
        return currentRoleIds;
    }
    
    /**
    @Description Generate Campaigns Mapper
    @param  set<ID> allSubUsers, SObject sObj
    @return Map<Id,Campaign> response
    */
    private static Map<Id,Campaign> generateCampaigns(Map<String,User> allSubUsers, SObject sObj) {
        final Map<Id,Campaign> campaignResponse = new Map<Id,Campaign>();
        for(User userItem : allSubUsers.values()) {
            final Campaign campaign = new Campaign();
            campaign.unique_id__c =
             DateTime.valueOf(sObj.get(altm__Commercial_Alert__c.altm__commercial_alert_end_date__c)).format('yyyyMMdd')+
             String.valueOf(sObj.get(altm__Commercial_Alert__c.altm__commercial_alert_record_type__c))+
             userItem.Unique_id__c;
            campaign.Name = String.valueOf(sObj.get(altm__Commercial_Alert__c.Name));
            campaign.StartDate = Date.valueOf(sObj.get(altm__Commercial_Alert__c.altm__commercial_alert_start_date__c));
            campaign.EndDate = Date.valueOf(sObj.get(altm__Commercial_Alert__c.altm__commercial_alert_end_date__c));
            campaign.Type = String.valueOf(sObj.get(altm__Commercial_Alert__c.altm__commercial_alert_task_type__c));
            campaign.IsActive = true;
            campaign.OwnerId = userItem.Id;
            campaignResponse.put(userItem.Id, campaign);
            System.debug('###campaign###'+campaign);

        }
        return campaignResponse;
    }
    
    /**
    @Description Generate Alerts List
    @param  SObject sObj, string recordTypeName, Set<Id> allExcUsers, Map<Id,Campaign> campaignMap
    @return List<altm__Commercial_Alert__c>
    */
    private static List<altm__Commercial_Alert__c> generateAlerts(SObject sObj, string recordTypeName, Map<String,User> allExcUsers, Map<Id,Campaign> campaignMap) {
        final string stageType = 'Pending';
        final List<altm__Commercial_Alert__c> response = new List<altm__Commercial_Alert__c>(); 
        for (Account acc : [SELECT ID,unique_id__c, Owner.user_id__c FROM Account WHERE Owner.user_id__c IN :allExcUsers.keySet() AND RecordType.DeveloperName = :recordTypeName]) {
             final altm__Commercial_Alert__c alert = new altm__Commercial_Alert__c();
           	 alert.altm__commercial_alert_id__c = 
             acc.unique_id__c +
             String.valueOf(sObj.get(altm__Commercial_Alert__c.altm__commercial_alert_record_type__c))+
             String.valueOf(sObj.get(altm__Commercial_Alert__c.commercial_alert_category__c))+
             String.valueOf(sObj.get(altm__Commercial_Alert__c.altm__commercial_alert_task_type__c))+
             Date.valueOf(sObj.get(altm__Commercial_Alert__c.altm__commercial_alert_end_date__c))+
             acc.OwnerId;
             alert.altm__commercial_alert_start_date__c = Date.valueOf(sObj.get(altm__Commercial_Alert__c.altm__commercial_alert_start_date__c));
             alert.altm__commercial_alert_end_date__c = Date.valueOf(sObj.get(altm__Commercial_Alert__c.altm__commercial_alert_end_date__c));
             alert.commercial_alert_category__c = String.valueOf(sObj.get(altm__Commercial_Alert__c.commercial_alert_category__c));
             alert.altm__commercial_alert_record_type__c = String.valueOf(sObj.get(altm__Commercial_Alert__c.altm__commercial_alert_record_type__c));
             alert.OwnerId = acc.OwnerId;
             alert.altm__participant_id__c = acc.Id;
             alert.altm__commercial_alert_task_type__c = String.valueOf(sObj.get(altm__Commercial_Alert__c.altm__commercial_alert_task_type__c));
             alert.altm__alert_stage_type__c = stageType;
             alert.Name = alert.commercial_alert_category__c + ' ' + alert.altm__commercial_alert_task_type__c  + ' ' 
                 + Datetime.valueOf(sObj.get(altm__Commercial_Alert__c.altm__commercial_alert_start_date__c)).format('yyyy-MM-dd'); 
             final Campaign relatedCampaign = campaignMap.get(acc.OwnerId);
             if( relatedCampaign != null) {
                alert.altm__campaign_id__c = relatedCampaign.id;
                response.add(alert);
             }
             System.debug('###---alert---###'+alert);


        }
        return response;
    }
    
}