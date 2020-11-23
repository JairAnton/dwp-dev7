/**
   -------------------------------------------------------------------------------------------------
   @Name BE_SM_Minute_Wrapper
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-11-11
   @Description
   @Changes
   Date        Author   Email                  				Type
   2020-11-11  MAMCH    martin.mori.contractor@bbva.com    	Creation
   -------------------------------------------------------------------------------------------------
 */
public without sharing virtual class BE_SM_Minute_Wrapper {
	/** @Description slmtTopics*/
    public static List<Task> slmtTopics {get; set;}
	/** @Description urlLogo*/
    public static String urlLogo {get; set;}
	/** @Description urlLogoWhite*/
    public static String urlLogoWhite {get; set;}
	/** @Description urlLogoFacebook*/
    public static String urlLogoFacebook {get; set;}
	/** @Description urlLogoTwiter*/
    public static String urlLogoTwiter {get; set;}
    
    /*
	 * @Description method setValues
	 */
    public static string setValues(String slmtId) {
		try {
			slmtTopics = [SELECT Id, ActivityDate, Subject, Status, Owner.Name, What.Name FROM Task 
                          WHERE RecordType.DeveloperName = 'Sales_Meeting' AND slmt__management_plan_meeting_id__c = :slmtId
                          ORDER BY Status ASC, ActivityDate DESC];
			Final String lstMembrete = [SELECT Id FROM Document WHERE DeveloperName = 'Logo_BBVA' LIMIT 1].isEmpty() ? '' : [SELECT Id FROM Document WHERE DeveloperName = 'Logo_BBVA' LIMIT 1].Id;
			Final String lstMembreteWhite = [SELECT Id FROM Document WHERE DeveloperName = 'Logo_BBVA_white' LIMIT 1].isEmpty() ? '' : [SELECT Id FROM Document WHERE DeveloperName = 'Logo_BBVA_white' LIMIT 1].Id;
			Final String lstLogoFace = [SELECT Id FROM Document WHERE DeveloperName = 'facebook_logo' LIMIT 1].isEmpty() ? '' : [SELECT Id FROM Document WHERE DeveloperName = 'facebook_logo' LIMIT 1].Id;
			Final String lstLogoTwiter = [SELECT Id FROM Document WHERE DeveloperName = 'twitter_logo' LIMIT 1].isEmpty() ? '' : [SELECT Id FROM Document WHERE DeveloperName = 'twitter_logo' LIMIT 1].Id;
			Final String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm() + '/servlet/servlet.ImageServer?id=';
			Final String param = '&oid=';
            urlLogo = sfdcBaseURL + lstMembrete + param + UserInfo.getOrganizationId();
			urlLogoFacebook = sfdcBaseURL + lstLogoFace + param + UserInfo.getOrganizationId();
			urlLogoTwiter = sfdcBaseURL + lstLogoTwiter + param + UserInfo.getOrganizationId();
			urlLogoWhite = sfdcBaseURL + lstMembreteWhite + param + UserInfo.getOrganizationId();
			
		} catch(System.Exception e) {
			system.debug('Exception : ' + e.getMessage());
		}
		return 'SUCCESS';
	}
}