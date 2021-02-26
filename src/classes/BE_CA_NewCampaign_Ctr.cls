/**
   ----------------------------------------------------------------------------------------------------
   @Name <BE_CA_NewCampaign_Ctr>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2020-02-24
   @Description Class  for Create Contact of Non Client
   @Changes
    Date        Author   Email                  Type
    2020-02-24  LMBR     lolo.bravo@bbva.com    Creation
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
        try {
            System.debug('sObj');
            System.debug(sObj);
            System.debug('params');
            System.debug(params);
            //CREAR UNA CAMPAÑA GERENCIA PARA CADA EJECUTIVO QUE ESTE POR DEBAJO EN LOS ROLES
            //GERENTE DE OFICINA, GERENTE REGIONAL
            //AGREGAR UNA COMMERCIAL ALERT
            //LLAVE EL CODIGO DEL EJECUTIVO (P028037)
            //
            //UserInfo.getUserId();
            //
            Id currentUserId = UserInfo.getUserId();
        	Id currentRoleId = UserInfo.getUserRoleId();
            
            currentRoleId = '00E1I000000tPMcUAM';
            
            Set<Id> allSubUsers = getRoleSubordinateUsers(currentRoleId);
            List<Campaign> campaignList = new List<Campaign>();
            List<altm__Commercial_Alert__c> alertList = new List<altm__Commercial_Alert__c>();
            
            
            System.debug('result from allSubUsers:');
            System.debug(allSubUsers);

            for(Id userId : allSubUsers) {
                Campaign campaign = new Campaign();
                campaign.Name = String.valueOf(sObj.get(altm__Commercial_Alert__c.Name));
                campaign.StartDate = Date.valueOf(sObj.get(altm__Commercial_Alert__c.altm__commercial_alert_start_date__c));
                campaign.EndDate = Date.valueOf(sObj.get(altm__Commercial_Alert__c.altm__commercial_alert_end_date__c));
                campaign.OwnerId = userId;
                campaignList.add(campaign);
            }
            
            if( campaignList.size() != 0)
            {
                insert campaignList;
                System.debug('---campaign inserted----');
                System.debug(campaignList.size());
                
                for(Campaign campaign : campaignList)
                {
                    altm__Commercial_Alert__c alert = new altm__Commercial_Alert__c();
                    alert.Name = String.valueOf(sObj.get(altm__Commercial_Alert__c.Name));
                    alert.altm__commercial_alert_start_date__c = campaign.StartDate;
                    alert.altm__commercial_alert_end_date__c = campaign.EndDate;
                    alert.commercial_alert_category__c = String.valueOf(sObj.get(altm__Commercial_Alert__c.commercial_alert_category__c));
                    alert.altm__commercial_alert_record_type__c = String.valueOf(sObj.get(altm__Commercial_Alert__c.altm__commercial_alert_record_type__c));
                    alert.altm__User_id__c = campaign.OwnerId;
                    alertList.add(alert);
                }
                
                insert alertList;
                System.debug('---alert inserted----');
                System.debug(alertList);
            }
            
            System.debug('campaignList');
            System.debug(campaignList);
            
            res.isSuccess=true;
            res.data=sObj;
        } catch (DmlException e) {
            res.isSuccess=false;
            res.message=e.getMessage();
        }
        return res;
    }
    	
    private static Set<ID> getRoleSubordinateUsers(Id roleId) {
        Set<Id> allSubRoleIds = getAllSubRoleIds(new Set<ID>{roleId});
        Map<Id,User> users = new Map<Id, User>([Select Id, Name From User where IsActive = True AND UserRoleId IN :allSubRoleIds]);
        return users.keySet();
    }
    
    private static Set<ID> getAllSubRoleIds(Set<ID> roleIds) {
        Set<ID> currentRoleIds = new Set<ID>();
        string EXCECUTIVE_ROLE_NAME = 'EJECUTIVO BANCA EMPRESAS%';        
        for(UserRole userRole :[select Id from UserRole where ParentRoleId IN :roleIds AND ParentRoleID != null AND Name like :EXCECUTIVE_ROLE_NAME]) {
            currentRoleIds.add(userRole.Id);
        }
        if(currentRoleIds.size() > 0){
            currentRoleIds.addAll(getAllSubRoleIds(currentRoleIds));
        }
        return currentRoleIds;
    }
    
}