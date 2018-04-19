/**
*Developed by:       	Indra
*Autor:                 Isaías Velázquez
*Project:               DWP Sales
*Description:           Test Class to handle Event,Task and Emails.
*
*Changes (Version)       
*No.        CreationDate            Autor                      Description
*-------------------------------------------------------------------------------
*------   ----------------   --------------------   ----------------------------
*1.0       	19-04-2018        Isaías Velázquez                   Creation
**/

@isTest
private class Activity_Tsk_Evt_Email_Handlers_Test {
	static Map<String, Profile> perfilMapa = new Map<String, Profile>();    
    static Map<String, UserRole> RolMapa = new Map<String, UserRole>();
    static List<Profile> p; 
    static List<RecordType> rTypesClientes;
    static List<UserRole> userRole;
  
    
    static{
        p = new List<Profile>([SELECT Id, Name FROM Profile]);
        userRole = new List<UserRole>([SELECT Id, Name FROM UserRole]);
        
        for(Profile perfil:p){ perfilMapa.put(perfil.Name, perfil); }
 
    }

	@isTest static void Opportunity_onActivityChange() {

		User u = new User();
	    u.Username='u2@u.com.u';
	    u.LastName='uLast2';
	    u.Email='u2@u.com';
	    u.Alias= 'uAlias2';
	    u.CommunityNickname='2uComm';
	    u.TimeZoneSidKey='America/Mexico_City';
	    u.LocaleSidKey='en_US';
	    u.EmailEncodingKey='ISO-8859-1';
	    u.ProfileId=  perfilMapa.get('Ejecutivo').Id;
	    u.LanguageLocaleKey='en_US';
	    insert u;

		test.startTest();
		System.runAs(u){    
	     Account acc = new Account(Name = 'Test Account');
         insert acc;
            
         Opportunity opp = new Opportunity();
         opp.Name = 'Test Opportunity';
         opp.StageName = '01';
         opp.CloseDate = Date.today();
         opp.AccountId = acc.Id;
         
         insert opp;
         opp.StageName = '02';
         update opp;
            
         Task tsk = new Task(WhatId = opp.Id, Subject = 'Test Subject', Status = 'In Progress');
         insert tsk;
         Event evt = new Event(WhatId = opp.Id, Subject = 'Test Subject',DurationInMinutes = 360,ActivityDateTime =Date.today());
         insert evt;
         EmailMessage email = new EmailMessage(RelatedtoId = opp.Id, FromName ='Usuario',FromAddress	='email@email.com',Subject='Email',TextBody='TEXTO');
         insert email;
            
         update opp;
	     System.assertNotEquals(tsk.Id, null,'Se completo con exito');
	 	 }
	     test.stopTest();
	}
	
}