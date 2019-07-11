/**
 * Test class for NavigateFromEventToVisit_cmp_ctrl class.
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------------
 *                            09/07/2018          Original version.<p />
 *
 * @author 
 */
@isTest
public class NavigateFromEventToVisit_cmp_ctrl_Test {

    /**METHOD TO TEST NavigateFromEventToVisit_cmp_ctrl*/
    @isTest
    public static void test() {
        //Create custom settings
        Final dwp_kitv__Visit_validations_acc_cs__c[] lstCsValidation=new dwp_kitv__Visit_validations_acc_cs__c[]{};
        Final dwp_kitv__Visit_validations_acc_cs__c csValidation=new dwp_kitv__Visit_validations_acc_cs__c(SetupOwnerId=UserInfo.getOrganizationId(), dwp_kitv__User_Team_Member__c=true);
        lstCsValidation.add(csValidation);
        insert lstCsValidation;
        
        Final Account acc = TestFactory.createAccount();
        Final User user = TestFactory.createUser('testuser1', 'ejecutivo');
        TestFactory.createUser('owner', 'ejecutivo');
        Final Contact cont = TestFactory.createContact(acc.Id);
        Final gcal__GBL_Google_Calendar_Sync_Environment__c gcs = new gcal__GBL_Google_Calendar_Sync_Environment__c(Name='DEV');
        insert gcs;
        
        Final dwp_kitv__Visit__c visit = new dwp_kitv__Visit__c(
            dwp_kitv__account_id__c = acc.Id,
            dwp_kitv__visit_status_type__c	= '02',
        	dwp_kitv__visit_duration_number__c = '15', 
            dwp_kitv__visit_start_date__c = Date.today());
        insert visit;
        Final dwp_kitv__Visit_Contact__c visit_contact = new dwp_kitv__Visit_Contact__c(dwp_kitv__visit_id__c=visit.Id, dwp_kitv__contact_id__c=cont.Id);
        insert visit_contact;
        Final dwp_kitv__Visit_Management_Team__c visit_mt = new dwp_kitv__Visit_Management_Team__c(dwp_kitv__visit_id__c=visit.Id,dwp_kitv__user_id__c=user.Id);
        insert visit_mt;
        Final dwp_kitv__Visit_Topic__c visit_topic = new dwp_kitv__Visit_Topic__c(dwp_kitv__visit_id__c=visit.Id, dwp_kitv__topic_desc__c='Topic');
        insert visit_topic;
        Final Event eve=new Event(DurationInMinutes=30,ActivityDateTime=Date.today(), dwp_kitv__visit_id__c=visit.Id);
        insert eve;
        Final String result = NavigateFromEventToVisit_cmp_ctrl.getInfo(eve.Id);
        Final String actual = visit.Id;
		System.assertEquals(result, actual);        
    }
}