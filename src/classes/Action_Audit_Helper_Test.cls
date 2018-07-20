@isTest
public class Action_Audit_Helper_Test {
    @isTest
    static void getAudit(){
        Test.startTest();
        Action_Audit_Helper.getAudit('auditName', 'apiName', 'recordId', date.today(), 'auditType', 'userId', 'auditStyle', 'sioCode', true);
        Test.stopTest();
        
    }
    @isTest
    static void getDetail(){
        Test.startTest();
        Action_Audit_Helper.getAuditDetail('auditId', 'content', 2, 'title', 'disType');
        Test.stopTest();
    }

}