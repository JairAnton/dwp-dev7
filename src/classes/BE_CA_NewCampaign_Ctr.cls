/**
   ----------------------------------------------------------------------------------------------------
   @Name <BE_CA_NewCampaign_Ctr>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2020-02-24
   @Description Class  for Create Contact of Non Client
   @Changes
    Date        Author   Email                  					Type
    2020-02-24  LMBR     lolo.bravo@bbva.com   		 				Creation
	2020-03-01	LMBR	 luis.vargas.matute.contractor@bbva.com		Update
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
            
            final Set<Id> allExcUsers = getRoleSubordinateUsers(currentRoleId, ejecutive_position_code);
            final Map<Id,Campaign> campaignMap = generateCampaigns(allExcUsers, sObj);
            if( !campaignMap.isEmpty() ) {
                insert campaignMap.values();
                alerList = generateAlerts(sObj, recordTypeName, allExcUsers, campaignMap);
                if( !alerList.isEmpty() ) {
                    insert alerList;
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
    private static Set<ID> getRoleSubordinateUsers(Id roleId, list<string> pos_code) {
        final Set<Id> allSubRoleIds = getAllSubRoleIds(new Set<ID>{roleId});
        final Map<Id,User> users = new Map<Id, User>([Select Id, Name From User where IsActive = True AND UserRoleId IN :allSubRoleIds AND prof_position_id__c IN :pos_code]);
        return users.keySet();
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
    private static Map<Id,Campaign> generateCampaigns(set<ID> allSubUsers, SObject sObj) {
        final Map<Id,Campaign> campaignResponse = new Map<Id,Campaign>();
        for(Id userId : allSubUsers) {
            final Campaign campaign = new Campaign();
            campaign.Name = String.valueOf(sObj.get(altm__Commercial_Alert__c.Name));
            campaign.StartDate = Date.valueOf(sObj.get(altm__Commercial_Alert__c.altm__commercial_alert_start_date__c));
            campaign.EndDate = Date.valueOf(sObj.get(altm__Commercial_Alert__c.altm__commercial_alert_end_date__c));
            campaign.OwnerId = userId;
            campaignResponse.put(userId, campaign);
        }
        return campaignResponse;
    }
    
    /**
    @Description Generate Alerts List
    @param  SObject sObj, string recordTypeName, Set<Id> allExcUsers, Map<Id,Campaign> campaignMap
    @return List<altm__Commercial_Alert__c>
    */
    private static List<altm__Commercial_Alert__c> generateAlerts(SObject sObj, string recordTypeName, Set<Id> allExcUsers, Map<Id,Campaign> campaignMap) {
       final List<altm__Commercial_Alert__c> response = new List<altm__Commercial_Alert__c>(); 
        for (Account acc : [SELECT ID, Owner.user_id__c FROM Account WHERE Owner.Id IN :allExcUsers AND RecordType.DeveloperName = :recordTypeName]) {
            final altm__Commercial_Alert__c alert = new altm__Commercial_Alert__c();
            alert.Name = String.valueOf(sObj.get(altm__Commercial_Alert__c.Name));
            alert.altm__commercial_alert_start_date__c = Date.valueOf(sObj.get(altm__Commercial_Alert__c.altm__commercial_alert_start_date__c));
            alert.altm__commercial_alert_end_date__c = Date.valueOf(sObj.get(altm__Commercial_Alert__c.altm__commercial_alert_end_date__c));
            alert.commercial_alert_category__c = String.valueOf(sObj.get(altm__Commercial_Alert__c.commercial_alert_category__c));
            alert.altm__commercial_alert_record_type__c = String.valueOf(sObj.get(altm__Commercial_Alert__c.altm__commercial_alert_record_type__c));
            alert.altm__User_id__c = acc.OwnerId;
            alert.altm__participant_id__c = acc.id;
            final Campaign relatedCampaign = campaignMap.get(acc.OwnerId);
            if( relatedCampaign != null) {
                alert.altm__campaign_id__c = relatedCampaign.id;
            	response.add(alert);
            }
        }
        return response;
    }
    
}