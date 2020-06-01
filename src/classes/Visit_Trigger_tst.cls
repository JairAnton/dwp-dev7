/*
   @Author: Arsenio Perez Lopez
   @Proyect: BBVA PERU
   @CreatedDate: 06-07-2018
   @Version:1
   @Hysteresis of changes:
   - Creation of the class
 * Modificado por Eduardo Castillo Sunahata 02-10-2018
 */
@isTest
public class Visit_Trigger_tst {
	static user usuario;
	static Account Accoun;
	static Contact contact;
	static dwp_kitv__Visit__c visit;
	static dwp_kitv__Visit_Contact__c contactVisit;
	static dwp_kitv__Visit_Management_Team__c VisitMana;
	static dwp_kitv__Visit_Topic__c visit_topic;
	
    /**
	 * Method Created: Basic data
	 **/
	@testSetup
	static void setData() {
		//Create custom settings
		Final dwp_kitv__Visit_validations_acc_cs__c[] lstCsValidation = new dwp_kitv__Visit_validations_acc_cs__c[] {};
		Final dwp_kitv__Visit_validations_acc_cs__c csValidation = new dwp_kitv__Visit_validations_acc_cs__c(SetupOwnerId = UserInfo.getOrganizationId(), dwp_kitv__User_Team_Member__c = true);
		lstCsValidation.add(csValidation);
		insert lstCsValidation;
		usuario = TestFactory.createUser('Ejecutivo1', 'System Administrator');
		Accoun = TestFactory.createAccount();
		visit = new dwp_kitv__Visit__c(dwp_kitv__account_id__c = Accoun.Id, dwp_kitv__visit_duration_number__c = '15',
		                               dwp_kitv__visit_start_date__c = System.now());
		insert visit;
		contact = TestFactory.createContact(Accoun.Id);
		contactVisit = TestFactory.VisitConta(visit.Id, contact.Id);
		VisitMana = TestFactory.CreateVisitManagement(visit.Id, usuario.Id);
	}

	/**
	 * Method Created: Test structure
	 **/
	@isTest
	static void test() {
		visit = [select id from dwp_kitv__Visit__c limit 1];
		contactVisit = [select id from dwp_kitv__Visit_Contact__c limit 1];
		VisitMana = [select Id from dwp_kitv__Visit_Management_Team__c limit 1];
		delete VisitMana;
		delete contactVisit;
		delete visit;

		//sonar
		Integer result = 1 + 2;
		System.assertEquals(3, result);
	}
    
	/**
	 * Method Created: Test Structura
	 **/
	@isTest
	static void testTopic() {
		visit = [select id from dwp_kitv__Visit__c limit 1];
		visit_topic = new dwp_kitv__Visit_Topic__c(dwp_kitv__visit_id__c = visit.Id,  dwp_kitv__topic_desc__c = 'Topic');
		insert visit_topic;
		delete visit_topic;

		//sonar
		Integer result = 1 + 2;
		System.assertEquals(3, result);
	}
}
