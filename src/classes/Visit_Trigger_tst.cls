/*
@Author: Arsenio Perez Lopez
@Proyect: BBVA PERU
@CreatedDate: 06-07-2018
@Version:1
@Hysteresis of changes:
- Creation of the class
*Modificado por Eduardo Castillo Sunahata 02-10-2018
*/
@isTest
public class Visit_Trigger_tst{
    
    static user usuario;
    static Account Accoun;
    static Contact contact;
    static dwp_kitv__Visit__c visit;
    static dwp_kitv__Visit_Contact__c contactVisit;
    static dwp_kitv__Visit_Management_Team__c VisitMana;
    static dwp_kitv__Visit_Topic__c visit_topic;
    /**
    *Method Created: Basic data
    **/  
    @testSetup 
    static void setData() {
        usuario = TestFactory.createUser('Ejecutivo1', 'System Administrator');
        visit= TestFactory.createVisitKit();
        Accoun= TestFactory.createAccount();
        contact = TestFactory.createContact(Accoun.Id);
        contactVisit= TestFactory.VisitConta(visit.Id,contact.Id);
        VisitMana = TestFactory.CreateVisitManagement(visit.Id,usuario.Id);
    }
    /**
    *Method Created: Test structure
    **/  
    @isTest
    static void test(){
        visit = [select id from dwp_kitv__Visit__c limit 1];
        contactVisit = [select id from dwp_kitv__Visit_Contact__c limit 1];
        VisitMana = [select Id from dwp_kitv__Visit_Management_Team__c limit 1];
		delete VisitMana;
        delete contactVisit;
        delete visit;
    }
    /**
     *Method Created: Test Structura 
     **/ 
    @isTest
    static void testTopic(){
        visit = [select id from dwp_kitv__Visit__c limit 1];
        visit_topic = new dwp_kitv__Visit_Topic__c(dwp_kitv__visit_id__c=visit.Id,	dwp_kitv__topic_desc__c='Topic');
        insert visit_topic;
        delete visit_topic;
    }

}