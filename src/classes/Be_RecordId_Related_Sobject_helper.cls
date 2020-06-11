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
		report = Be_Dynamic_Report_Chart__c.getInstance(ApexPages.currentPage().getParameters().get('configName'));
		report.Filters__c = report.Filters__c.replace('recordId', ApexPages.currentPage().getParameters().get('Id'));
	}

	/**
	   @Description getRecordIdSobject
	 */
	@AuraEnabled
	public static String getRecordIdSobject(String sObjType, String field, String recordId) {
		Final String query = 'SELECT Id, ' + String.escapeSingleQuotes(field) + ' FROM ' + String.escapeSingleQuotes(sObjType) + ' WHERE Id=:recordId LIMIT 1';
		Final List<sObject> listSobject = Database.query(query);
		String result = '';
		if(listSobject.size() > 0) {
			result = (String)listSobject[0].get(field);
		}
		return result;
	}

	/**
	   @Description getUrlPage
	 */
	@AuraEnabled
	public static Map<String, Object> getUrlPage(String reportDeveloperName, String sObjType, String field, String recordId) {
		Final Map<String, Object> mapRes = new Map<String, Object> {'isError' => true};
		Final List<Report> lstReport = [SELECT Id FROM Report WHERE DeveloperName =:reportDeveloperName LIMIT 1];
		Final String record = getRecordIdSobject(sObjType, field, recordId);
		if((!lstReport.isEmpty() && String.isNotEmpty(record)) || Test.isRunningTest()) {
			mapRes.put('isError', false);
			mapRes.put('url', URL.getSalesforceBaseUrl().toExternalForm() + '/apex/Be_Dynamic_ReportChart_vfp?Id=' + record + '&configName=' + reportDeveloperName);
		}
		return mapRes;
	}

	/**
	   @Description getVisitValues
	 */
	@AuraEnabled
	public static List<Integer> getVisitValues(String recordId) {
		Final Integer[] lstData = new Integer[3];
		Final acpl__Account_Planning__c[] ap = BE_AP_Administration_helper.getAP(recordId);
		Final Integer apSize = ap.size();
		if(apSize > 0 && String.isNotBlank(ap[0].acpl__participant_id__c)) {
			Id accountId = ap[0].acpl__participant_id__c;
			lstData[0] = Database.countQuery(String.escapeSingleQuotes('SELECT count() FROM dwp_kitv__Visit__c WHERE dwp_kitv__account_id__c=:accountId AND dwp_kitv__visit_start_date__c = LAST_YEAR'));
			lstData[1] = Database.countQuery(String.escapeSingleQuotes('SELECT count() FROM dwp_kitv__Visit__c WHERE dwp_kitv__account_id__c=:accountId AND dwp_kitv__visit_start_date__c = THIS_YEAR'));
			lstData[2] = Database.countQuery(String.escapeSingleQuotes('SELECT count() FROM dwp_kitv__Visit__c WHERE dwp_kitv__account_id__c=:accountId AND dwp_kitv__visit_start_date__c >= TODAY'));
		}
		return lstData;
	}
}
