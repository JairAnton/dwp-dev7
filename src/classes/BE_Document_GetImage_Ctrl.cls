/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_Document_GetImage_Ctrl>
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-04-14
   @Description Class to get url of document that contains an image, this class is used for show image in email templates
   @Changes
   Date        Author   Email                               Type
   2020-04-14  MAMC     martin.mori.contractor@bbva.com     Creation
   -------------------------------------------------------------------------------------------------
 */
public with sharing class BE_Document_GetImage_Ctrl {
    /* developer name of document */
	public String developerName {get; set;}

	/**
	 @Description return String of document
     @return a String with url of document that contains an image.
   	*/
    public String stringUrl {
        get {
            final List<Document> lstMembrete = [SELECT Id FROM Document WHERE DeveloperName = :developerName];
            final String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm() + '/servlet/servlet.ImageServer?id=';
            String param = '&oid=';
            if(lstMembrete.isEmpty()==false) {
                param = lstMembrete[0].Id+param;
            }
            stringUrl = sfdcBaseURL+param+UserInfo.getOrganizationId();
            return stringUrl;
        }
        set {}
    }
}