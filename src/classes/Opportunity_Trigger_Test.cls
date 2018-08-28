/*
 * @Name: Opportunity_tgr
 * @Description: Trigger de Ejecucion Opportunity
 * @Create by: 
 * 
 * V0-Creacion
*/
@isTest(seeAllData=true)
private class Opportunity_Trigger_Test {
	private static final String TRIGGER_CONTEXT_ERROR = 'Trigger Error';
	static Opportunity Opp = new Opportunity();
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

  	@isTest
  	static void testEjecutivo() {
        User u=CreaUsuario('Ejecutivo');  
    	User g=CreaUsuario('Operativo');
        CreatOpp(u);
       	test.startTest();
        try{    
    		Opp.ownerId=u.Id;
      		Update Opp;
    		Opp.ownerId=g.Id;
      		Update Opp;
        	}catch(Exception ex){
          	}    
        test.stopTest();
        
      
  	}
    @isTest
  	static void testOperativo() {
    	User u=CreaUsuario('Operativo');  
    	User a=CreaUsuario('Analista');
        User e=CreaUsuario('Especialista');
        CreatOpp(e);
       	test.startTest();
        try{
    		Opp.ownerId=u.Id;
      		Update Opp;          
    		Opp.ownerId=a.Id;
      		Update Opp;
        } catch(Exception ex){
        }
        test.stopTest();
  	}
    
    @isTest
	static void testEspecialista() {
		User u=CreaUsuario('Ejecutivo');  
    	User e=CreaUsuario('Especialista');
        CreatOpp(u);
    	test.startTest();
        try{
    		Opp.ownerId=u.Id;
      		Update Opp;          
    		Opp.ownerId=e.Id;
      		Update Opp;
        } catch(Exception ex){
        }
        test.stopTest();
  	}
    
    @isTest
	static void testAnalista() {
        User u=CreaUsuario('Ejecutivo');  
        User a=CreaUsuario('Analista');          
        CreatOpp(u);
        test.startTest();
        try{
            Opp.ownerId=u.Id;
            Update Opp;          
            Opp.ownerId=a.Id;
            Update Opp;
        } catch(Exception ex){
        }
        test.stopTest();
  	}
    
    @isTest
	static void testAnalista2() {
        User u=CreaUsuario('Especialista'); 
        User a=CreaUsuario('Analista');          
        CreatOpp(u);
        test.startTest();
        try{
            Opp.ownerId=a.Id;
            Update Opp;          
            Opp.ownerId=u.Id;
            Update Opp;
        } catch(Exception ex){
        }
        test.stopTest();
  	} 
    
    @isTest
	static void testAnalista3() {
        User u=CreaUsuario('Especialista'); 
        User a=CreaUsuario('Analista');          
        CreatOpp(u);
        test.startTest();
        try{
            Opp.ownerId=u.Id;
            Update Opp;          
            Opp.ownerId=a.Id;
            Update Opp;
        } catch(Exception ex){
        }
            test.stopTest();
  	}
    
    @isTest
    static void changeState11(){
        User u = TestFactory.createUser('TestUser1','Ejecutivo');
        Date todayDate = Date.today();
        Account acc = TestFactory.createAccount();
        Opportunity opp = TestFactory.createOpportunity(acc.Id, u.Id);
        Product2 prod = TestFactory.createProduct();
        OpportunityLineItem oli = TestFactory.createOLI(opp.Id, prod.Id);
        Opportunity_Solution_Commitment__c osc = new Opportunity_Solution_Commitment__c(opportunity_id__c=opp.Id);
        insert osc;
        opp.StageName = '04';
        opp.opportunity_status_type__c = '11';
        Test.startTest();
        update opp;
        List<OpportunityLineItem> oliList = [select Id, price_quote_date__c from OpportunityLineItem where OpportunityId =:opp.Id];
        List<Opportunity_Solution_Commitment__c> oscList = [select Id, price_quote_date__c from Opportunity_Solution_Commitment__c where opportunity_id__c =:opp.Id];
        List<Date> actual = new List<Date>{todayDate, todayDate};
        List<Date> result = new List<Date>{oliList[0].price_quote_date__c, oscList[0].price_quote_date__c};
        System.assertEquals(result, actual);
        Test.stopTest();
    }
    
    @isTest
    static void changeState08(){
        User u = TestFactory.createUser('TestUser1','Ejecutivo');
        Date todayDate = Date.today();
        Account acc = TestFactory.createAccount();
        Opportunity opp = TestFactory.createOpportunity(acc.Id, u.Id);
        Product2 prod = TestFactory.createProduct();
        OpportunityLineItem oli = TestFactory.createOLI(opp.Id, prod.Id);
        Opportunity_Solution_Commitment__c osc = new Opportunity_Solution_Commitment__c(opportunity_id__c=opp.Id);
        insert osc;
        opp.StageName = '04';
        opp.opportunity_status_type__c = '08';
        Test.startTest();
        update opp;
        List<OpportunityLineItem> oliList = [select Id, price_quote_date__c from OpportunityLineItem where OpportunityId =:opp.Id];
        List<Opportunity_Solution_Commitment__c> oscList = [select Id, price_quote_date__c from Opportunity_Solution_Commitment__c where opportunity_id__c =:opp.Id];
        List<Date> actual = new List<Date>{todayDate, todayDate};
        List<Date> result = new List<Date>{oliList[0].price_quote_date__c, oscList[0].price_quote_date__c};
        System.assertEquals(result, actual);
        Test.stopTest();
    }

    @isTest
    static void state10(){
    	User u=CreaUsuario('Ejecutivo');       
    	CreatOpp(u);
    	test.startTest();
        try{
        	Opp.StageName = '04';
        	Opp.opportunity_status_type__c = '10';
        	Opp.isProcess__c = true;
        	Update Opp;
        } catch(Exception ex){
        }
            test.stopTest();
    }
    
    @isTest
    static void state13(){
    	User u=CreaUsuario('Ejecutivo');       
    	CreatOpp(u);
    	test.startTest();
        try{
        	Opp.StageName = '04';
        	Opp.opportunity_status_type__c = '13';
        	Opp.isProcess__c = true;
        	Update Opp;
        } catch(Exception ex){
        }
            test.stopTest();
    }
    
    @isTest
    static void state19(){
    	User u=CreaUsuario('Ejecutivo');       
    	CreatOpp(u);
    	test.startTest();
        try{
        	Opp.StageName = '05';
        	Opp.opportunity_status_type__c = '19';
        	Opp.isProcess__c = true;
        	Update Opp;
        } catch(Exception ex){
        }
            test.stopTest();
    }
    
    @isTest
    static void state23(){
    	User u=CreaUsuario('Ejecutivo');       
    	CreatOpp(u);
    	test.startTest();
        try{
        	Opp.StageName = '06';
        	Opp.opportunity_status_type__c = '23';
        	Opp.isProcess__c = true;
        	Update Opp;
        } catch(Exception ex){
        }
            test.stopTest();
    }
    
    @isTest
    static void state12(){
    	User u=CreaUsuario('Ejecutivo');       
    	CreatOpp(u);
    	test.startTest();
        try{
        	Opp.StageName = '04';
        	Opp.opportunity_status_type__c = '12';
        	Opp.isProcess__c = true;
        	Update Opp;
        } catch(Exception ex){
        }
            test.stopTest();
    }
    
    @isTest
    static void state24(){
    	User u=CreaUsuario('Ejecutivo');       
    	CreatOpp(u);
    	test.startTest();
        try{
        	Opp.StageName = '04';
        	Opp.opportunity_status_type__c = '24';
        	Opp.isProcess__c = true;
        	Update Opp;
        } catch(Exception ex){
        }
            test.stopTest();
    }
    
    @isTest
    static void state18(){
    	User u=CreaUsuario('Ejecutivo');       
    	CreatOpp(u);
    	test.startTest();
        try{
        	Opp.StageName = '04';
        	Opp.opportunity_status_type__c = '18';
        	Opp.isProcess__c = true;
        	Update Opp;
        } catch(Exception ex){
        }
            test.stopTest();
    }

    @isTest
    static void state17(){
    	User u=CreaUsuario('Ejecutivo');       
    	CreatOpp(u);
    	test.startTest();
        try{
        	Opp.StageName = '04';
        	Opp.opportunity_status_type__c = '17';
        	Opp.isProcess__c = true;
        	Update Opp;
        } catch(Exception ex){
        }
            test.stopTest();
    }
    
    @isTest
    static void state08(){
    	User u=CreaUsuario('Ejecutivo');       
    	CreatOpp(u);
    	test.startTest();
        try{
        	Opp.StageName = '04';
        	Opp.opportunity_status_type__c = '19';
        	Opp.isProcess__c = true;
        	Update Opp;
        } catch(Exception ex){
        }
            test.stopTest();
    }
    
    @isTest
    static void state11(){
    	User u=CreaUsuario('Ejecutivo');       
    	CreatOpp(u);
    	test.startTest();
        try{
        	Opp.StageName = '04';
        	Opp.opportunity_status_type__c = '19';
        	Opp.isProcess__c = true;
        	Update Opp;
        } catch(Exception ex){
        }
            test.stopTest();
    }
    
    @isTest
    static void state09(){
    	User u=CreaUsuario('Ejecutivo');       
    	CreatOpp(u);
    	test.startTest();
        try{
        	Opp.StageName = '04';
        	Opp.opportunity_status_type__c = '09';
        	Opp.isProcess__c = true;
        	Update Opp;
        } catch(Exception ex){
        }
            test.stopTest();
    }
    
    @isTest
    static void state22(){
    	User u=CreaUsuario('Ejecutivo');       
    	CreatOpp(u);
    	test.startTest();
        try{
        	Opp.StageName = '07';
        	Opp.opportunity_status_type__c = '22';
        	Opp.isProcess__c = true;
        	Update Opp;
        } catch(Exception ex){
        }
            test.stopTest();
    }
    
    @isTest
    static void state21(){
    	User u=CreaUsuario('Ejecutivo');       
    	CreatOpp(u);
    	test.startTest();
        try{
        	Opp.StageName = '05';
        	Opp.opportunity_status_type__c = '21';
        	Opp.isProcess__c = true;
        	Update Opp;
        } catch(Exception ex){
        }
            test.stopTest();
    }
    
    @isTest
    static void state20(){
    	User u=CreaUsuario('Ejecutivo');       
    	CreatOpp(u);
    	test.startTest();
        try{
        	Opp.StageName = '05';
        	Opp.opportunity_status_type__c = '20';
        	Opp.isProcess__c = true;
        	Update Opp;
        } catch(Exception ex){
        }
            test.stopTest();
    }
    
    static void CreatOpp(User u){
    	Opp = new Opportunity(
            Name='Test',
            CloseDate=system.today(),
            Stagename='02'
       	);
        system.RunAs(u){
            insert Opp;
        }
    }
    
    static User CreaUsuario(String Perfil){
    	User u = new User();
        u.Username=Perfil+'u2@u.com.u';
        u.LastName=Perfil+'uLast2';
        u.Email=Perfil+'u2@u.com';
        u.Alias= Perfil.substring(0, 2)+'uAas2';
        u.CommunityNickname=Perfil+'2uComm';
        u.TimeZoneSidKey='America/Mexico_City';
        u.LocaleSidKey='en_US';
        u.EmailEncodingKey='ISO-8859-1';
        u.ProfileId=  perfilMapa.get(Perfil).Id;
        u.LanguageLocaleKey='en_US';
        insert u;
        return u;
    }
}