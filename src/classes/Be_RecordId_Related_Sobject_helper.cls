/**
 * ------------------------------------------------------------------------------------------------
 * @Name Be_RecordId_Related_Sobject_helper
 * @Author Diego Carbajal diego.carbajal@bbva.com
 * @Date Created: 	2020-05-01
 * @Date Modified: 	2020-10-23
 * @Group
 * @Description Clase helper para componentes, graficos de reporte y Variables de crecimiento en AP
 *
 */
public without sharing class Be_RecordId_Related_Sobject_helper {
	/**
	   @Description report
	 */
	public Be_Dynamic_Report_Chart__c report {get; set;}
	/**
	   @Description currentRecord
	 */
	public Sobject currentRecord {get; set;}
    /**
	   @Description RT_ECO_GRP
	 */
    static Final String RT_ECO_GRP = 'Record_Type_Economic_Group';
    
	/**
	   @Description Be_RecordId_Related_Sobject_helper
	 */
	public Be_RecordId_Related_Sobject_helper() {
		report = Be_Dynamic_Report_Chart__c.getInstance(ApexPages.currentPage().getParameters().get('configName').escapeHTML3());
		report.Filters__c = report.Filters__c.replace('recordId', ApexPages.currentPage().getParameters().get('Id').escapeHTML3());
	}

	/**
	   @Description getRecordIdSobject
	 */
	@AuraEnabled
	public static String getRecordIdSobject(String sObjType, String field, String recordId) {
		Final String query = 'SELECT Id, ' + String.escapeSingleQuotes(field) + ' FROM ' + String.escapeSingleQuotes(sObjType) + ' WHERE Id=:recordId LIMIT 1';
		Final List<sObject> listSobject = Database.query(query);
		String result = '';
		if(!listSobject.isEmpty()) {
			result = (String)listSobject[0].get(field);
		}
		return result;
	}

	/**
	   @Description getUrlPage
	 */
	@AuraEnabled
	public static Map<String, Object> getUrlPage(String params) {
        Final Map<String, Object> mapParams = (Map<String, Object>) JSON.deserializeUntyped(params);
		Final Map<String, Object> mapRes = new Map<String, Object> {'isError' => true};
		Final String reportDVN = (String)mapParams.get('reportDeveloperName');
		Final List<Report> lstReport = [SELECT Id FROM Report WHERE DeveloperName =:reportDVN LIMIT 1];
		Final String record = getRecordIdSobject((String)mapParams.get('sObjType'), (String)mapParams.get('field'), (String)mapParams.get('recordId'));
        if(!lstReport.isEmpty() && String.isNotEmpty(record)) {
			mapRes.put('isError', false);
			mapRes.put('url', URL.getSalesforceBaseUrl().toExternalForm() + '/apex/Be_Dynamic_ReportChart_vfp?Id=' + record + 
                       '&configName=' + reportDVN);
		}
		return mapRes;
	}

	/**
	   @Description getVisitValues
	 */
	@AuraEnabled
	public static List<Integer> getVisitValues(String recordId) {
		Final Integer[] lstData = new Integer[3];
		Final acpl__Account_Planning__c[] lstAP = BE_AP_Administration_helper.getAP(recordId);
		if(!lstAP.isEmpty() && String.isNotBlank(lstAP[0].acpl__participant_id__c)) {
			Final Set<Id> clientsIds = getClientsIds(lstAP[0]);
            dwp_kitv__Visit__c[] lstTmp = [SELECT Id FROM dwp_kitv__Visit__c WHERE dwp_kitv__visit_start_date__c = LAST_YEAR AND dwp_kitv__account_id__c IN: clientsIds];
			lstData[0] = lstTmp.size();
            lstTmp = [SELECT Id FROM dwp_kitv__Visit__c WHERE dwp_kitv__visit_start_date__c = THIS_YEAR AND dwp_kitv__account_id__c IN: clientsIds];
			lstData[1] = lstTmp.size();
            lstTmp = [SELECT Id FROM dwp_kitv__Visit__c WHERE dwp_kitv__visit_start_date__c >= TODAY AND dwp_kitv__account_id__c IN: clientsIds];
			lstData[2] = lstTmp.size();
		}
		return lstData;
	}

	/**
	   @Description getClientsIds
	 */
	private static Set<Id> getClientsIds(acpl__Account_Planning__c apRecord) {
		Set<Id> clientsIds;
		if(apRecord.acpl__participant_id__r.RecordType.DeveloperName == RT_ECO_GRP) {
			Final Map<Id, Account> mapClients = new Map<Id, Account>([SELECT Id FROM Account WHERE parentId=:apRecord.acpl__participant_id__c]);
			clientsIds = mapClients.keySet();
		} else {
			clientsIds = new Set<Id>{apRecord.acpl__participant_id__c};
		}
		return clientsIds;
	}

	/**
	   @Description getMetadataConfig
	 */
	@AuraEnabled
    public static Map<String, Object> getMetadataConfig(String recordId) {
        Final Map<String, Object> mapConfig = new Map<String, Object>{'isSuccess' => false, 'Msg' => 'No se ha encontrado la metadata seleccionada.'};
        try {
            Final acpl__Account_Planning__c[] lstAP = [SELECT Id, acpl__participant_id__r.RecordType.DeveloperName FROM 
                                                        acpl__Account_Planning__c WHERE Id=: recordId LIMIT 1];
            Final String metadataConfig = lstAP[0].acpl__participant_id__r.RecordType.DeveloperName == 'Record_Type_Economic_Group' ? 
                                                                            'AP_Growth_Driver_Groups_PN' : 'AP_Growth_Driver_Clients_PN' ;
            if(String.isNotBlank(metadataConfig)) {
                Final BE_SingleRelatedList_Setting__mdt[] lstSRL = [SELECT Id, HeadActions__c FROM BE_SingleRelatedList_Setting__mdt 
                                                                    WHERE DeveloperName =: metadataConfig LIMIT 1];
                mapConfig.put('isSuccess', true);
                mapConfig.put('data', lstSRL[0].HeadActions__c);
                mapConfig.remove('Msg');
            }
        } catch (Exception e) {
            mapConfig.put('Msg', e.getMessage());
            System.debug(mapConfig.get('Msg'));
        }
        return mapConfig;
    }
}