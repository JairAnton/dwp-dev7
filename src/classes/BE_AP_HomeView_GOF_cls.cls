/**
 * ------------------------------------------------------------------------------------------------
 * @Name BE_AP_HomeView_GOF_cls
 * @Author Diego Carbajal diego.carbajal@bbva.com
 * @Date Created: 2020-06-08
 * @Group
 * @Description BE_AP_HomeView_GOF_cls
 *
 */
public class BE_AP_HomeView_GOF_cls extends Be_DTP_ResponseModel_cls {
	/*
	 * @Description  method getData
	 */
	public override Be_DTP_ResponseModel_cls.Response getData(String filter) {
		Final Be_DTP_ResponseModel_cls.Response response = new Be_DTP_ResponseModel_cls.Response();
		response.isSuccess = false;
		response.message = 'Ha ocurrido un error, por favor contacte a su administrador.';
		try {
			response.isSuccess = true;
			response.data = getGOFData(filter);
		} catch(Exception e) {
			System.debug('BE_AP_HomeView_GOF_cls');
			System.debug(e.getMessage());
		}
		return response;
	}

	/*
	 * @Description  method getGOFData
	 */
	private static List<Map<String, Object>> getGOFData(String filter) {
		Final List<Map<String, Object>> lstData = new List<Map<String, Object>>();
		List<acpl__Account_Planning__c> lstAP = new List<acpl__Account_Planning__c>();
		switch on filter {
			when 'not_started' {
				lstAP = [SELECT Id, acpl__participant_id__c, acpl__participant_id__r.Name, toLabel(acpl__gf_ap_status_type_name__c),
				         acpl__gf_ap_limit_date__c, toLabel(acpl__gf_ap_priority_type_name__c), segment_desc__c,
				         (SELECT Id, bupl__gf_ap_team_user_id__c FROM acpl__Account_Planning_Team_Members__r) FROM
				         acpl__Account_Planning__c WHERE RecordType.developerName = 'Account_Planning' AND
				                                                                    acpl__gf_ap_status_type_name__c = 'Not started' AND acpl__gf_ap_substatus_type_name__c = 'Not started'
				                                                                                                                                                             ORDER BY Name];
			}
			when 'in_progress' {
				lstAP = [SELECT Id, acpl__participant_id__c, acpl__participant_id__r.Name, toLabel(acpl__gf_ap_status_type_name__c),
				         acpl__gf_ap_limit_date__c, toLabel(acpl__gf_ap_priority_type_name__c), segment_desc__c,
				         (SELECT Id, bupl__gf_ap_team_user_id__c FROM acpl__Account_Planning_Team_Members__r) FROM
				         acpl__Account_Planning__c WHERE RecordType.developerName = 'Account_Planning' AND
				                                                                    acpl__gf_ap_status_type_name__c = 'In Progress' AND acpl__gf_ap_substatus_type_name__c != 'Expired'
				                                                                                                      ORDER BY Name];
			}
			when 'pending_validation' {
				lstAP = [SELECT Id, acpl__participant_id__c, acpl__participant_id__r.Name, toLabel(acpl__gf_ap_status_type_name__c),
				         acpl__gf_ap_limit_date__c, toLabel(acpl__gf_ap_priority_type_name__c), segment_desc__c FROM acpl__Account_Planning__c
				         WHERE RecordType.developerName = 'Account_Planning' AND acpl__gf_ap_status_type_name__c = 'Pending Validation' AND
				                                                                                                   acpl__gf_ap_substatus_type_name__c = 'Pending validation'
				                                                                                                                                        ORDER BY Name];
			}
			when 'validated' {
				lstAP = [SELECT Id, acpl__participant_id__c, acpl__participant_id__r.Name, toLabel(acpl__gf_ap_status_type_name__c),
				         acpl__gf_ap_limit_date__c, toLabel(acpl__gf_ap_priority_type_name__c), segment_desc__c,
				         (SELECT Id, bupl__gf_ap_team_user_id__c FROM acpl__Account_Planning_Team_Members__r) FROM
				         acpl__Account_Planning__c WHERE RecordType.developerName = 'Account_Planning' AND
				                                                                    acpl__gf_ap_status_type_name__c = 'Validated' AND acpl__gf_ap_substatus_type_name__c = 'In place'
				                                                                                                                                                           ORDER BY Name];
			}
			when 'closed_this_month' {
				lstAP = [SELECT Id, acpl__participant_id__c, acpl__participant_id__r.Name, toLabel(acpl__gf_ap_status_type_name__c),
				         acpl__gf_ap_limit_date__c, toLabel(acpl__gf_ap_priority_type_name__c), segment_desc__c,
				         (SELECT Id, bupl__gf_ap_team_user_id__c FROM acpl__Account_Planning_Team_Members__r) FROM
				         acpl__Account_Planning__c WHERE RecordType.developerName = 'Account_Planning' AND acpl__gf_ap_limit_date__c = THIS_MONTH
				                                                                                                                       AND acpl__gf_ap_substatus_type_name__c NOT IN('Expired', 'In place') ORDER BY Name];
			}
			when 'closed_next_month' {
				lstAP = [SELECT Id, acpl__participant_id__c, acpl__participant_id__r.Name, toLabel(acpl__gf_ap_status_type_name__c),
				         acpl__gf_ap_limit_date__c, toLabel(acpl__gf_ap_priority_type_name__c), segment_desc__c,
				         (SELECT Id, bupl__gf_ap_team_user_id__c FROM acpl__Account_Planning_Team_Members__r) FROM
				         acpl__Account_Planning__c WHERE RecordType.developerName = 'Account_Planning' AND acpl__gf_ap_limit_date__c = NEXT_MONTH
				                                                                                                                       AND acpl__gf_ap_substatus_type_name__c NOT IN('Expired', 'In place') ORDER BY Name];
			}
		}
		Map<String, Object> mapData;
		for(acpl__Account_Planning__c ap : lstAP) {
			mapData = new Map<String, Object> {'Id' => ap.Id, 'priority' => ap.acpl__gf_ap_priority_type_name__c,
				                               'clientName' => ap.acpl__participant_id__r.Name, 'segment' => ap.segment_desc__c,
				                               'DueDate' => ap.acpl__gf_ap_limit_date__c, 'status' => ap.acpl__gf_ap_status_type_name__c,
				                               'linkAP' => URL.getSalesforceBaseUrl().toExternalForm() + '/' + ap.Id};
			lstData.add(mapData);
		}
		return lstData;
	}
}
