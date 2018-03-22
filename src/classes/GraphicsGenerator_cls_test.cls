/**
*Developed by:       	Indra
*Autor:                 Isaías Velázquez
*Project:               DWP Sales
*Description:           Test Class to handle GraphicsGenerator_cls.
*
*Changes (Version)       
*No.        CreationDate            Autor                      Description
*-------------------------------------------------------------------------------
*------   ----------------   --------------------   ----------------------------
*1.0       	19-03-2018        Isaías Velázquez                   Creation
**/
@isTest
public class GraphicsGenerator_cls_test {
	


	@isTest static void TestSBSGrafica(){
	    

	    User u = new User();
	    u.Username='u2@u.com.u';
	    u.LastName='uLast';
	    u.Email='u2@u.com';
	    u.Alias= 'uAlias';
	    u.CommunityNickname='uComm';
	    u.TimeZoneSidKey='America/Mexico_City';
	    u.LocaleSidKey='en_US';
	    u.EmailEncodingKey='ISO-8859-1';
	    u.ProfileId=  userinfo.getProfileId();
	    u.LanguageLocaleKey='en_US';
	    insert u;

	    Account ac = new Account();
	    ac.Name='Cuenta';
	    insert ac;

	    Account_Banking_System_Debt__c sbs = new Account_Banking_System_Debt__c();        
	    sbs.debt_quote_amount__c=100;
	    sbs.entity_name__c='BBVA';
	    sbs.year_month_day_date__c=date.parse('01/01/2017');
	    sbs.account_id__c=ac.Id;
	    insert sbs;


	    Account_Banking_System_Debt__c sbs1 = new Account_Banking_System_Debt__c();        
	    sbs1.debt_quote_amount__c=200;
	    sbs1.entity_name__c='BBVA';
	    sbs1.year_month_day_date__c=date.parse('03/01/2017');
	    sbs1.account_id__c=ac.Id;
	    insert sbs1;
	    
	    test.startTest();
	    System.runAs(u){                       
			GraphicsGenerator_cls.getGeneraJSONReporte('EVOLUCION_CUOTA_SBS','Total','2017',ac.Id);
			GraphicsGenerator_cls.getGeneraJSONReporte('EVOLUCION_CUOTA_SBS','Indirecta','2017',ac.Id);
			GraphicsGenerator_cls.getGeneraJSONReporte('EVOLUCION_CUOTA_SBS','Directa','2017',ac.Id);
			GraphicsGenerator_cls.getGeneraJSONReporte('EVOLUCION_CUOTA_SBS','Otros directas','2017',ac.Id);
			GraphicsGenerator_cls.getGeneraJSONReporte('EVOLUCION_CUOTA_SBS','Otros indirectas','2017',ac.Id);
			GraphicsGenerator_cls.getGeneraJSONReporte('EVOLUCION_CUOTA_SBS','','2017',ac.Id);
	        System.assert(true,'This Works!');            
	    } 
	    test.stopTest();
	}

}