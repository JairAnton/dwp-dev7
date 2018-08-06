@isTest
public class NavigateFromEventToVisit_cmp_ctrl_Test {

    @isTest
    public static void test() {
        Account acc = TestFactory.createAccount();
        User user = TestFactory.createUser('testuser1', 'ejecutivo');
        User owner = TestFactory.createUser('owner', 'ejecutivo');
        Contact cont = TestFactory.createContact(acc.Id);
        gcal__GBL_Google_Calendar_Sync_Environment__c gcs = new gcal__GBL_Google_Calendar_Sync_Environment__c(Name='DEV');
        insert gcs;
        
        dwp_kitv__Visit__c visit = new dwp_kitv__Visit__c(
            dwp_kitv__account_id__c = acc.Id,
            dwp_kitv__visit_status_type__c	= '02',
        	dwp_kitv__visit_duration_number__c = '15', 
            dwp_kitv__visit_start_date__c = Date.today());
        insert visit;
        dwp_kitv__Visit_Contact__c visit_contact = new 	dwp_kitv__Visit_Contact__c(dwp_kitv__visit_id__c=visit.Id, dwp_kitv__contact_id__c=cont.Id);
        insert visit_contact;
        dwp_kitv__Visit_Management_Team__c visit_mt = new dwp_kitv__Visit_Management_Team__c(dwp_kitv__visit_id__c=visit.Id,dwp_kitv__user_id__c=user.Id);
        insert visit_mt;
        dwp_kitv__Visit_Topic__c visit_topic = new dwp_kitv__Visit_Topic__c(dwp_kitv__visit_id__c=visit.Id,	dwp_kitv__topic_desc__c='Topic');
        insert visit_topic;
        Event e=new Event(DurationInMinutes=30,ActivityDateTime=Date.today(), dwp_kitv__visit_id__c=visit.Id);
        insert e;
        String result = NavigateFromEventToVisit_cmp_ctrl.getInfo(e.Id);
        String actual = visit.Id;
		System.assertEquals(result, actual);        
    }
}