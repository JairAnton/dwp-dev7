/**
* @author BBVA ADT Team
* @date 2018
*
* @group gcal
*/
@isTest
public class Event_Test {
	static Account acc;
    static Contact cont;
    static User defaultUser;
     @testSetup
    private static void setData() {
        acc = TestFactory.createAccount();

        cont = TestFactory.createContact(acc.Id);
        
        defaultUser = TestFactory.createUser('Test','Migracion');

        gcal__GBL_Google_Calendar_Sync_Environment__c env = new gcal__GBL_Google_Calendar_Sync_Environment__c();
        env.Name = 'DEV';
        insert env;
        Event evt = new Event();
        evt.Subject = 'PRUEBA';
        evt.Description = 'description';
        evt.Location = 'location';
        evt.StartDatetime = Datetime.now();
        evt.EndDatetime = Datetime.now();
        evt.gcal__GBL_Google_Event_Id__c = 'test1';
        evt.OwnerId = Userinfo.getUserId();
        insert evt;
        
    }    

      @isTest static void afterInsertTest(){
        Test.setMock(HttpCalloutMock.class, new gcal.GBL_Google_Calendar_Mock_Generator());
          Test.startTest();
        Event evt = new Event();
        evt.Subject = 'syncJobTest';
        evt.Description = 'description';
        evt.Location = 'location';
        evt.StartDatetime = Datetime.now();
        evt.EndDatetime = Datetime.now();
        insert evt;
        

        List <Event> lstEvt = [SELECT Id,gcal__GBL_Google_Event_Id__c FROM Event WHERE Subject = 'syncJobTest'];
          Test.stopTest();
    }
    @isTest 
    static void afterUpdateTest() {
        Test.startTest();
        Event evt = [SELECT Id, Subject, Description, Location, StartDatetime, EndDatetime, IsChild, OwnerId, gcal__GBL_Google_Event_Id__c from Event where Subject = 'PRUEBA'];
        
        if(evt.gcal__GBL_Google_Event_Id__c != 'test1'){
            evt.gcal__GBL_Google_Event_Id__c = 'test1';
            update evt;
        }
        Event evt2 = new Event(
            Subject = 'pruenatest',
            id = evt.Id,
            gcal__GBL_Google_Event_Id__c = 'test1',
            OwnerID = evt.OwnerId
        );
        update evt;
        Test.stopTest();
    }
    
    @isTest 
    static void afterDeleteTest() {
        Test.startTest();
        Event evt = [SELECT Id, gcal__GBL_Google_Event_Id__c, IsChild, OwnerId FROM Event LIMIT 1];
        if(evt.gcal__GBL_Google_Event_Id__c != 'test1'){
            evt.gcal__GBL_Google_Event_Id__c = 'test1';
            update evt;
        }
        
        delete evt;
        Test.stopTest();
    }

}