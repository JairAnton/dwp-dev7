/**
 * ------------------------------------------------------------------------------------------------
 * @Name BE_AccountPlanning_HomeView_cls
 * @Author Diego Carbajal diego.carbajal@bbva.com
 * @Date Created: 2020-05-01
 * @Group
 * @Description BE_AccountPlanning_HomeView_cls
 *
 */
public with sharing class BE_AccountPlanning_HomeView_cls extends Be_DTP_ResponseModel_cls {
	/*
	 * @Description  method getData
	 */
	public override Be_DTP_ResponseModel_cls.Response getData(String filter) {
		Final Be_DTP_ResponseModel_cls.Response response = new Be_DTP_ResponseModel_cls.Response();
		response.isSuccess = false;
		response.message = 'Ha ocurrido un error, por favor contacte a su administrador.';
		try {
			response.isSuccess = true;
			response.data = getEjecutivoData(filter);
		} catch(Exception e) {
			System.debug('BE_AccountPlanning_HomeView_cls');
			System.debug(e.getMessage());
		}
		return response;
	}

	/*
	 * @Description  method getEjecutivoData
	 */
	private static List<Map<String, Object>> getEjecutivoData(String filter) {
		Final List<Map<String, Object>> lstData = new List<Map<String, Object>>();
		List<acpl__Account_Planning__c> lstAP = new List<acpl__Account_Planning__c>();
		switch on filter {
			when 'priority' {
				lstAP = [SELECT Id, acpl__participant_id__c, segment_desc__c, acpl__participant_id__r.Name, toLabel(acpl__gf_ap_status_type_name__c),
				         acpl__gf_ap_limit_date__c, toLabel(acpl__gf_ap_priority_type_name__c),
				         (SELECT Id, bupl__gf_ap_team_user_id__c FROM acpl__Account_Planning_Team_Members__r) FROM
				         acpl__Account_Planning__c WHERE RecordType.developerName = 'Account_Planning' AND 
                         acpl__gf_ap_substatus_type_name__c NOT IN ('Expired') AND acpl__gf_ap_launch_name__c = 'Period by priority' ORDER BY Name];
			}
			when 'validated' {
				lstAP = [SELECT Id, acpl__participant_id__c, segment_desc__c, acpl__participant_id__r.Name, toLabel(acpl__gf_ap_status_type_name__c),
				         acpl__gf_ap_limit_date__c, toLabel(acpl__gf_ap_priority_type_name__c),
				         (SELECT Id, bupl__gf_ap_team_user_id__c FROM acpl__Account_Planning_Team_Members__r) FROM
				         acpl__Account_Planning__c WHERE RecordType.developerName = 'Account_Planning' AND 
                         acpl__gf_ap_status_type_name__c = 'Validated' AND acpl__gf_ap_substatus_type_name__c = 'In place' ORDER BY Name];
			}
			when 'closed_this_month' {
				lstAP = [SELECT Id, acpl__participant_id__c, segment_desc__c, acpl__participant_id__r.Name, toLabel(acpl__gf_ap_status_type_name__c),
				         acpl__gf_ap_limit_date__c, toLabel(acpl__gf_ap_priority_type_name__c),
				         (SELECT Id, bupl__gf_ap_team_user_id__c FROM acpl__Account_Planning_Team_Members__r) FROM
				         acpl__Account_Planning__c WHERE RecordType.developerName = 'Account_Planning' AND acpl__gf_ap_limit_date__c = THIS_MONTH 
                         AND acpl__gf_ap_substatus_type_name__c NOT IN('Expired', 'In place') ORDER BY Name];
			}
			when 'closed_next_month' {
				lstAP = [SELECT Id, acpl__participant_id__c, segment_desc__c, acpl__participant_id__r.Name, toLabel(acpl__gf_ap_status_type_name__c),
				         acpl__gf_ap_limit_date__c, toLabel(acpl__gf_ap_priority_type_name__c),
				         (SELECT Id, bupl__gf_ap_team_user_id__c FROM acpl__Account_Planning_Team_Members__r) FROM
				         acpl__Account_Planning__c WHERE RecordType.developerName = 'Account_Planning' AND acpl__gf_ap_limit_date__c = NEXT_MONTH 
                         AND acpl__gf_ap_substatus_type_name__c NOT IN('Expired', 'In place') ORDER BY Name];
			}
		}
		Map<String, Object> mapData;
		for(acpl__Account_Planning__c ap : lstAP) {
			for(bupl__AP_Team__c apTeam: ap.acpl__Account_Planning_Team_Members__r) {
				if(apTeam.bupl__gf_ap_team_user_id__c == UserInfo.getUserId()) {
					mapData = new Map<String, Object> {'Id' => ap.Id, 'clientName' => ap.acpl__participant_id__r.Name,
						                               'status' => ap.acpl__gf_ap_status_type_name__c, 'DueDate' => ap.acpl__gf_ap_limit_date__c,
						                               'priority' => ap.acpl__gf_ap_priority_type_name__c, 'segment' => ap.segment_desc__c,
						                               'linkAP' => URL.getSalesforceBaseUrl().toExternalForm() + '/' + ap.Id};
					lstData.add(mapData);
				}
			}
		}
		return lstData;
	}
}