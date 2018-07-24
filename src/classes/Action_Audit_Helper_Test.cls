@isTest
public class Action_Audit_Helper_Test {
    static dwp_cvad__Action_Audit__c action;
    @isTest
    static void getAudit(){
        Test.startTest();
        action = (Action_Audit_Helper.getAudit('auditName', 'apiName', 'recordId', date.today(), 'auditType', UserInfo.getUserId(), 'auditStyle', '030303', true));
        insert action;
        Action_Audit_Helper.getAuditDetail(action.Id, 'content', 2, 'title', 'disType');
        Test.stopTest();
    }

}