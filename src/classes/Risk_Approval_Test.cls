@isTest
public class Risk_Approval_Test {
    static Account acctest;
    static Opportunity opptest;
    static dwp_cvad__Action_Audit__c audit1, audit2, audit3;
    
    @testSetup
    static void setupData() {
		acctest = TestFactory.createAccount();
        opptest = TestFactory.createOpportunity(acctest.Id,UserInfo.getUserId());
        audit1 = Action_Audit_Helper.getAudit('Sanción Aprobado CM', Label.ApiNameAccount, acctest.Id, System.now(), Label.RiskApproval, UserInfo.getUserId(), Label.AuditStyleApproveTop, '1234', true);
        audit2 = Action_Audit_Helper.getAudit('Sanción Denegado', Label.ApiNameAccount, acctest.Id, System.now(), Label.RiskApproval, UserInfo.getUserId(), Label.AuditStyleDeny, '5678', true);
        audit3 = Action_Audit_Helper.getAudit('1er Ingreso a Controller', Label.ApiNameAccount, acctest.Id, System.now(), Label.RiskApproval, UserInfo.getUserId(), Label.AuditStyleElevate, '1900', true);
    }
    @isTest
    static void oppModalityDL() {
        setupData();
        Test.startTest();
            Opportunity oppDetails = Risk_Approval_cls.getOpportunity(opptest.Id);
            Risk_Approval_cls.sendApproval(oppDetails);
        Test.stopTest();
        System.assertEquals(oppDetails.StageName, Label.lblSanctionStage);
        System.assertEquals(oppDetails.opportunity_status_type__c, Label.lblOpportunityStatusApprovedInsideLine);
    }
    @isTest
    static void oppModalityRAAuthorized() {
        setupData();
        Test.startTest();
            Opportunity oppDetails = Risk_Approval_cls.getOpportunity(opptest.Id);
        	insert audit1;
            Risk_Approval_cls.getSIOCodesToSelect('', oppDetails);
        	Risk_Approval_cls.saveSIO(oppDetails, audit1.action_opp_sio_code__c);
        Test.stopTest();
        System.assertEquals(oppDetails.StageName, Label.lblSanctionStage);
        System.assertEquals(oppDetails.opportunity_status_type__c, Label.lblOpportunityStatusRiskAuth);
        List<dwp_cvad__Action_Audit__c> audits = [Select Id From dwp_cvad__Action_Audit__c Where dwp_cvad__action_audit_record_id__c = :oppDetails.Id];
        System.assertEquals(2, audits.size());
    }
    @isTest
    static void oppModalityRADenied() {
        setupData();
        Test.startTest();
            Opportunity oppDetails = Risk_Approval_cls.getOpportunity(opptest.Id);
        	insert audit2;
            Risk_Approval_cls.getSIOCodesToSelect('56', oppDetails);
        	Risk_Approval_cls.saveSIO(oppDetails, audit2.action_opp_sio_code__c);
        Test.stopTest();
        System.assertEquals(oppDetails.StageName, Label.lblSanctionStage);
        System.assertEquals(oppDetails.opportunity_status_type__c, Label.lblOpportunityStatusRiskDenied);
        List<dwp_cvad__Action_Audit__c> audits = [Select Id From dwp_cvad__Action_Audit__c Where dwp_cvad__action_audit_record_id__c = :oppDetails.Id];
        System.assertEquals(2, audits.size());
    }
    @isTest
    static void oppModalityRASentForAuth() {
        setupData();
        Test.startTest();
            Opportunity oppDetails = Risk_Approval_cls.getOpportunity(opptest.Id);
        	insert audit3;
            Risk_Approval_cls.getSIOCodesToSelect('', oppDetails);
        	Risk_Approval_cls.saveSIO(oppDetails, audit3.action_opp_sio_code__c);
        	Risk_Approval_cls.saveSIO(oppDetails, audit3.action_opp_sio_code__c);
        Test.stopTest();
        System.assertEquals(oppDetails.StageName, Label.lblSanctionStage);
        System.assertEquals(oppDetails.opportunity_status_type__c, Label.lblOpportunityStatusSentRisk);
        List<dwp_cvad__Action_Audit__c> audits = [Select Id From dwp_cvad__Action_Audit__c Where dwp_cvad__action_audit_record_id__c = :oppDetails.Id];
        System.assertEquals(3, audits.size());
    }
    @isTest
    static void passCatch() {
        Test.startTest();
            Opportunity oppDetails = Risk_Approval_cls.getOpportunity(null);
            Risk_Approval_cls.getSIOCodesToSelect('', oppDetails);
        	Risk_Approval_cls.saveSIO(oppDetails, '');
        	Risk_Approval_cls.sendApproval(oppDetails);
        Test.stopTest();
    }
}