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
    public static String URLLogo {get; set;}
    public static String URLLogoWhite {get; set;}
    public static String URLLogoFacebook {get; set;}
    public static String URLLogoTwiter {get; set;}
    public static String URLStyle {get; set;}
   
    
    public static string setValues(String visitId){
        try{
             visitTopic = new list<dwp_kitv__Visit_Topic__c>();
            visitTopic = [Select dwp_kitv__opportunity_id__c,dwp_kitv__opportunity_id__r.name, dwp_kitv__topic_desc__c, 
                          dwp_kitv__visit_done_type__c from dwp_kitv__Visit_Topic__c where dwp_kitv__visit_id__c =:visitId  ];
            visitContacsAux = new list<dwp_kitv__Visit_Contact__c>();
            visitContacs = new list<dwp_kitv__Visit_Contact__c>();
			visitContacsAux = [Select dwp_kitv__contact_id__c, dwp_kitv__contact_id__r.name, dwp_kitv__contact_email_desc__c, contact_prof_position_type__c, 
                            dwp_kitv__contact_called_type__c from dwp_kitv__Visit_Contact__c where dwp_kitv__visit_id__c =:visitId ];
            for(dwp_kitv__Visit_Contact__c c:visitContacsAux){
                if(c.dwp_kitv__contact_email_desc__c!=''){
                    visitContacs.add(c);
                }
            }
            System.debug('--Contactos-->'+ visitContacs);
            visitManagementTeam = new list<dwp_kitv__Visit_Management_Team__c>();
        	visitManagementTeam = [Select dwp_kitv__user_id__c, dwp_kitv__user_id__r.name, 
                                   dwp_kitv__contact_email_desc__c, user_prof_position_type__c from dwp_kitv__Visit_Management_Team__c 
                                   where dwp_kitv__visit_id__c =:visitId and dwp_kitv__contact_email_desc__c !='' ];
            dwp_kitv__Visit__c v = [select id,OwnerId
                      from dwp_kitv__Visit__c where Id =:visitId limit 1];
            usuarios =  new list<User>();
            User ownerUser = [select id, name, email, prof_position_type__c 
                              from User where id =:v.OwnerId  limit 1];
            usuarios.add(ownerUser);
            for(dwp_kitv__Visit_Management_Team__c vm: visitManagementTeam){
                User secundaryOwner = [select id, name, email, prof_position_type__c from User where id =:vm.dwp_kitv__user_id__c  limit 1];
            	usuarios.add(secundaryOwner);
            }
            System.debug('--usuarios-->'+ usuarios);
            visitAgreements = new List<Task>();
            visitAgreements = [Select id,ActivityDate,Subject,Status,Owner.Name, RecordType.Name  from Task  where RecordType.Name  ='Agreement' and dwp_kitv__visit_id__c =: visitId]; 
            List<Document> lstMembrete = [SELECT Id FROM Document WHERE DeveloperName = 'Logo_BBVA'];
            List<Document> lstMembreteWhite = [SELECT Id FROM Document WHERE DeveloperName = 'Logo_BBVA_white'];
            List<Document> lstLogoFace = [SELECT Id FROM Document WHERE DeveloperName = 'facebook_logo'];
            List<Document> lstLogoTwiter = [SELECT Id FROM Document WHERE DeveloperName = 'twitter_logo'];
            String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
            URLLogo = sfdcBaseURL+'/servlet/servlet.ImageServer?id='+lstMembrete[0].Id+'&oid='+UserInfo.getOrganizationId();    
            URLLogoWhite = sfdcBaseURL+'/servlet/servlet.ImageServer?id='+lstMembreteWhite[0].Id+'&oid='+UserInfo.getOrganizationId();  
            URLLogoFacebook = sfdcBaseURL+'/servlet/servlet.ImageServer?id='+lstLogoFace[0].Id+'&oid='+UserInfo.getOrganizationId();  
            URLLogoTwiter = sfdcBaseURL+'/servlet/servlet.ImageServer?id='+lstLogoTwiter[0].Id+'&oid='+UserInfo.getOrganizationId(); 
        }catch(System.Exception e){
            system.debug('Exception : '+e.getMessage());
        }
        return 'SUCCESS';
    }
}