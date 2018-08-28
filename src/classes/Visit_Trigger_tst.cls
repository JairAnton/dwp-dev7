
/*
@Author: Arsenio Perez Lopez
@Proyect: BBVA PERU
@CreatedDate: 06-07-2018
@Version:1
@Hysteresis of changes:
- Creation of the class
*/
@isTest
public class Visit_Trigger_tst{
    
    static user usuario;
    static dwp_kitv__Visit__c visit;
    static dwp_kitv__Visit_Contact__c contactVisit;
    static dwp_kitv__Visit_Management_Team__c VisitMana;
    /**
    *Method Created: Basic data
    **/  
    @testSetup 
    static void setData() {
        usuario = TestFactory.createUser('Ejecutivo1', 'System Administrator');
        visit= TestFactory.createVisitKit();
        contactVisit= TestFactory.VisitConta(visit.Id);
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

}