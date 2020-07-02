/**
 * ------------------------------------------------------------------------------------------------
 * @Name Be_RecordId_Related_Sobject_helper
 * @Author Diego Carbajal diego.carbajal@bbva.com
 * @Date Created: 2020-05-01
 * @Group
 * @Description Clase helper para componentes y graficos de reporte
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
		Final acpl__Account_Planning__c[] apR = BE_AP_Administration_helper.getAP(recordId);
		Final Integer apSize = apR.size();
		if(apSize > 0 && String.isNotBlank(apR[0].acpl__participant_id__c)) {
            dwp_kitv__Visit__c[] lstTmp = [SELECT Id FROM dwp_kitv__Visit__c WHERE dwp_kitv__visit_start_date__c = LAST_YEAR AND dwp_kitv__account_id__c =:apR[0].acpl__participant_id__c];
			lstData[0] = lstTmp.size();
            lstTmp = [SELECT Id FROM dwp_kitv__Visit__c WHERE dwp_kitv__visit_start_date__c = THIS_YEAR AND dwp_kitv__account_id__c =:apR[0].acpl__participant_id__c];
			lstData[1] = lstTmp.size();
            lstTmp = [SELECT Id FROM dwp_kitv__Visit__c WHERE dwp_kitv__visit_start_date__c >= TODAY AND dwp_kitv__account_id__c =:apR[0].acpl__participant_id__c];
			lstData[2] = lstTmp.size();
		}
		return lstData;
	}
}