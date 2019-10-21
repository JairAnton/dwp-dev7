/* -------------------------------------------------------------------
* Jose Rodriguez               07/08/2019          Original version.<p />
*
* @author Jose Rodriguez
*/
public without sharing virtual class MinutaWrap { 

    Public static list<dwp_kitv__Visit_Topic__c> visitTopic {get;set;}
    Public static list<dwp_kitv__Visit_Contact__c> visitContacsAux {get;set;}
    Public static list<dwp_kitv__Visit_Contact__c> visitContacs {get;set;}
    Public static list<dwp_kitv__Visit_Management_Team__c> visitManagementTeam {get;set;}
    Public static list<Task> visitAgreements {get;set;}
	Public static list<User> usuarios {get;set;}
    public static String urlLogo {get; set;}
    public static String urlLogoWhite {get; set;}
    public static String urlLogoFacebook {get; set;}
    public static String urlLogoTwiter {get; set;}
    public static String urlStyle {get; set;}
   
    /*Method to set values*/
    public static string setValues(String visitId) {
        try {
            visitTopic = [Select dwp_kitv__opportunity_id__c,dwp_kitv__opportunity_id__r.name, dwp_kitv__topic_desc__c, 
                          dwp_kitv__visit_done_type__c from dwp_kitv__Visit_Topic__c where dwp_kitv__visit_id__c =:visitId];
            visitContacsAux = new list<dwp_kitv__Visit_Contact__c>();
            visitContacs = new list<dwp_kitv__Visit_Contact__c>();
			visitContacsAux = [Select dwp_kitv__contact_id__c, dwp_kitv__contact_id__r.name, dwp_kitv__contact_email_desc__c, contact_prof_position_type__c, 
                            dwp_kitv__contact_called_type__c from dwp_kitv__Visit_Contact__c where dwp_kitv__visit_id__c =:visitId ];
            for(dwp_kitv__Visit_Contact__c c:visitContacsAux) {
                if(c.dwp_kitv__contact_email_desc__c!='') {
                    visitContacs.add(c);
                }
            }
            System.debug('--Contactos-->'+ visitContacs);
        	visitManagementTeam = [Select dwp_kitv__user_id__c, dwp_kitv__user_id__r.name, 
                                   dwp_kitv__contact_email_desc__c, user_prof_position_type__c from dwp_kitv__Visit_Management_Team__c 
                                   where dwp_kitv__visit_id__c =:visitId and dwp_kitv__contact_email_desc__c !='' and  dwp_owner_visit__c=false];
            Final dwp_kitv__Visit_Management_Team__c owner = [SELECT id, dwp_kitv__user_id__c FROM dwp_kitv__Visit_Management_Team__c WHERE dwp_kitv__visit_id__c=:visitId AND 
                                                       dwp_owner_visit__c=true limit 1];
            usuarios =  new list<User>();
            Final User ownerUser = [select id, name, email, prof_position_type__c from User where id =:owner.dwp_kitv__user_id__c limit 1];
            usuarios.add(ownerUser);
            Set<String> strUserId = new Set<String>();
            for(dwp_kitv__Visit_Management_Team__c vm: visitManagementTeam) {
                strUserId.add(vm.dwp_kitv__user_id__c);
            }
            usuarios.addAll([select id, name, email, prof_position_type__c from User where id IN: strUserId]);
            System.debug('--usuarios-->'+ usuarios);
            visitAgreements = [Select id,ActivityDate,Subject,Status,Owner.Name, RecordType.Name  from Task  where RecordType.Name ='Agreement' and dwp_kitv__visit_id__c =: visitId]; 
            Final List<Document> lstMembrete = [SELECT Id FROM Document WHERE DeveloperName = 'Logo_BBVA'];
            Final List<Document> lstMembreteWhite = [SELECT Id FROM Document WHERE DeveloperName = 'Logo_BBVA_white'];
            Final List<Document> lstLogoFace = [SELECT Id FROM Document WHERE DeveloperName = 'facebook_logo'];
            Final List<Document> lstLogoTwiter = [SELECT Id FROM Document WHERE DeveloperName = 'twitter_logo'];
            Final String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm() + '/servlet/servlet.ImageServer?id=';
            String param = '&oid=';
            urlLogo = sfdcBaseURL+lstMembrete[0].Id+param+UserInfo.getOrganizationId();
            urlLogoFacebook = sfdcBaseURL+lstLogoFace[0].Id+param+UserInfo.getOrganizationId();
            urlLogoTwiter = sfdcBaseURL+lstLogoTwiter[0].Id+param+UserInfo.getOrganizationId();
            urlLogoWhite = sfdcBaseURL+lstMembreteWhite[0].Id+param+UserInfo.getOrganizationId();
        } catch(System.Exception e) {
            system.debug('Exception : '+e.getMessage());
        }
        return 'SUCCESS';
    }
}