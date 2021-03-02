/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_CA_NewVisit_Tst>
   @Author Deyby Bazan Villegas (deyby.bazan.contractor@bbva.com)
   @Date 2021-02-23
   @Description test for BE_CA_NewVisit_Ctr class
   @Changes
   Date        Author   Email                              Type
   2021-02-23  DBAV     deyby.bazan.contractor@bbva.com    Creation
   -------------------------------------------------------------------------------------------------
 */
@isTest
public with sharing class BE_CA_NewVisit_Tst {
    
 /**
 @Description test BE_CA_NewVisit_Ctr.createRecord(), correct scenary
 */   
 @IsTest
    static void createSuccessMethodsTest() {
        Final Account acc = new Account(Name='TEST Account');
        insert acc;
        Final altm__Commercial_Alert__c commAlert = new altm__Commercial_Alert__c(Name='TEST CommAlert',altm__participant_id__c=acc.Id);
        insert commAlert;        
        Final dwp_kitv__Visit__c visit = new dwp_kitv__Visit__c(Name='Test Visit',dwp_kitv__visit_duration_number__c='45',dwp_kitv__visit_start_date__c=System.now());
        Final Map<String,Object> paramsMap = new Map<String,Object>{'ClassName'=> '','recordId' => commAlert.Id};
        final BE_CA_NewVisit_Ctr newVisitClass = New BE_CA_NewVisit_Ctr();
        final BE_CustomQuickActionCRUD_Cls.Response res = newVisitClass.createRecord(visit,paramsMap);
        System.assert(res.isSuccess,'Correct Response');    

    }
    
 /**
 @Description test BE_CA_NewVisit_Ctr.createRecord(), incorrect scenary (catch)
 */   
    @IsTest
    static void createErrorMethodsTest() {
        Final altm__Commercial_Alert__c commAlert = new altm__Commercial_Alert__c(Name='TEST CommAlert');     
        Final dwp_kitv__Visit__c visit = new dwp_kitv__Visit__c(Name='Test Visit');
        Final Map<String,Object> paramsMap = new Map<String,Object>{'ClassName'=> '','recordId' => commAlert.Id};
        Final BE_CA_NewVisit_Ctr newVisitClass = New BE_CA_NewVisit_Ctr();
        Final BE_CustomQuickActionCRUD_Cls.Response res = newVisitClass.createRecord(visit,paramsMap);
        System.assert(res.isSuccess, 'Invalid Creation');
    }
}