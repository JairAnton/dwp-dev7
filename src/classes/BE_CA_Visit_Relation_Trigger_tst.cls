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
    /** Test Method*/
    @isTest
    static void testCAVisitRelationTrg() {
        Boolean expectedExceptionThrown = true;
        Test.startTest();
        Account acc = New Account(
        	Name = 'Test Account'
        );
        insert acc;
        Final altm__Commercial_Alert__c alert = new altm__Commercial_Alert__c(
        	Name='Test Alert',
            altm__participant_id__c = acc.id
        );
        
        Final dwp_kitv__Visit__c visit = new dwp_kitv__Visit__c(
        	Name='Test Visit',
            dwp_kitv__visit_start_date__c = Datetime.newInstance(2020, 5, 28, 1, 6, 8),
            dwp_kitv__visit_duration_number__c = '15'
        );
        
        insert alert;
        insert visit;
        
        Final Commercial_Alert_Visit_Relation__c relation = new Commercial_Alert_Visit_Relation__c(
            visit_id__c = visit.Id,
            commercial_id__c = alert.Id
        );
        
        Database.SaveResult result = Database.insert(relation);
        
        Final Commercial_Alert_Visit_Relation__c duplicatedRelation = new Commercial_Alert_Visit_Relation__c(
            visit_id__c = visit.Id,
            commercial_id__c = alert.Id
        );
        
        try{
            Database.SaveResult resultDuplicated = Database.insert(duplicatedRelation, false);
        }
        catch(Exception ex) {
            expectedExceptionThrown =  ex.getMessage().contains('El registro ya existe') ? true : false;
        }
        Test.stopTest();            
        System.assert(result.isSuccess());
        System.assertEquals(expectedExceptionThrown, true);

    }

}