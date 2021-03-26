/**
 * Test class for AccountContact_Handler class.
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------------
 * Eduardo Vargas	            03/26/2020          Original version.<p />
 *
 * @author Eduardo Vargas
 */
@isTest(SeeAllData = false)
public class BE_CA_Visit_Relation_Trigger_tst {
    /** MESSAGE */
    final static String TEXT_MESSAGE='El registro ya existe';
    /** Test Method*/
    @isTest
    static void testCAVisitRelationTrg() {
        Boolean eExThrown = true;
        Test.startTest();
        final Account acc = New Account(
        	Name = 'Test Account'
        );
        insert acc;
        final altm__Commercial_Alert__c alert = new altm__Commercial_Alert__c(
        	Name='Test Alert',
            altm__participant_id__c = acc.id
        );
        
        final dwp_kitv__Visit__c visit = new dwp_kitv__Visit__c(
        	Name='Test Visit',
            dwp_kitv__visit_start_date__c = Datetime.newInstance(2020, 5, 28, 1, 6, 8),
            dwp_kitv__visit_duration_number__c = '15'
        );
        insert alert;
        insert visit;
        final Commercial_Alert_Visit_Relation__c relation = new Commercial_Alert_Visit_Relation__c(visit_id__c = visit.Id,commercial_id__c = alert.Id);
        final Database.SaveResult result = Database.insert(relation);
        final Commercial_Alert_Visit_Relation__c dupliRel = new Commercial_Alert_Visit_Relation__c( visit_id__c = visit.Id,commercial_id__c = alert.Id);
        try {
            final Database.SaveResult resultDup = Database.insert(dupliRel, false);
            System.debug('###resultDuplicated##'+resultDup);
        } catch(Exception ex) {
            eExThrown =  ex.getMessage().contains(TEXT_MESSAGE) ? true : false;
        }
        Test.stopTest();      
        System.assert(result.isSuccess(),'Success testCAVisitRelationTrg');
    }

}