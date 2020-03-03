/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_SingleRelatedList_Tst>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2019-09-13
   @Description test for BE_SingleRelatedList_Ctr class
   @Changes
   Date        Author   Email                  Type
   2019-09-13  LMBR     lolo.bravo@bbva.com    Creation
   -------------------------------------------------------------------------------------------------
 */
@IsTest
public without sharing class BE_SingleRelatedList_Tst {
    
    /**
     @Description return about setting metadata
    */
    @IsTest
    static void getDynamicResponseTest() {
        Test.startTest();
        BE_SingleRelatedList_Ctr.Params params=new BE_SingleRelatedList_Ctr.Params();
        BE_SingleRelatedList_Ctr.Response response=new BE_SingleRelatedList_Ctr.Response();
        params.sObjName='Opportunity';
        params.sObjFields='Name';
        params.filterSQOL='AccountId=:recordId';
        final Account acc=new Account(Name='DYNAMICRELATEDLIST_TEST');
        insert acc;
        final List<Opportunity> listAccAcc = new List<Opportunity>();
        listAccAcc.add(new Opportunity(AccountId=acc.Id,Name='TestOpp',StageName='01'));
        response=BE_SingleRelatedList_Ctr.getDynamicResponse(acc.Id, params);
        System.assertEquals(true, response.isSuccess,'Success');
        insert listAccAcc;
        Test.stopTest();  
    }

    /**
     @Description return about setting metadata
    */
    @IsTest
    static void getSObjectFieldsTest() {
        Test.startTest();
        Map<String,String> configMap=BE_SingleRelatedList_Ctr.getSObjectFields('Opportunity');
        System.assertEquals('string', configMap.get('Name'), 'Correct sObject');
        Test.stopTest();
    }
    
    /**
     @Description return about setting metadata
    */
    @IsTest
    static void getConfigMetaTest() {
        final String devMetadata='TESTMETADATA_TST';
        Test.startTest();
        List<BE_SingleRelatedList_Setting__mdt> configMeta=(List<BE_SingleRelatedList_Setting__mdt>) BE_SingleRelatedList_Ctr.getConfigMeta(devMetadata);
        Test.stopTest();
        configMeta=(List<BE_SingleRelatedList_Setting__mdt>)Json.deserialize('[{"DeveloperName":"TESTMETADATA_TST","MasterLabel":"Phone"}]', List<BE_SingleRelatedList_Setting__mdt>.class);
        System.assertEquals(1,configMeta.size(), 'Size correcto');
    }

}