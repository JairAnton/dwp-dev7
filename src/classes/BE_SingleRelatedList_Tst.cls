/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_SingleRelatedList_Tst>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2020-03-03
   @Description test for BE_SingleRelatedList_Ctr class
   @Changes
   Date        Author   Email                  Type
   2020-03-03  LMBR     lolo.bravo@bbva.com    Creation
   -------------------------------------------------------------------------------------------------
 */
@IsTest
public without sharing class BE_SingleRelatedList_Tst {
    
    /**
     @Description test for BE_SingleRelatedList_Ctr.getDynamicResponse(), correct scenary
    */
    @IsTest
    static void getDynamicResponseTest() {
        Test.startTest();
        final BE_SingleRelatedList_Ctr.Params params=new BE_SingleRelatedList_Ctr.Params();
        BE_SingleRelatedList_Ctr.Response response=new BE_SingleRelatedList_Ctr.Response();
        params.sObjName='Opportunity';
        params.sObjFields='Name';
        params.filterSQOL='AccountId=:recordId';
        final Account acc=new Account(Name='DYNAMICRELATEDLIST_TEST');
        insert acc;
        final List<Opportunity> listAccAcc = new List<Opportunity>();
        listAccAcc.add(new Opportunity(AccountId=acc.Id,Name='TestOpp',StageName='01'));
        response=BE_SingleRelatedList_Ctr.getDynamicResponse(acc.Id, params);
        System.assert(response.isSuccess,'Success');
        insert listAccAcc;
        Test.stopTest();  
    }

    /**
     @Description test for BE_SingleRelatedList_Ctr.getSObjectFields(), correct scenary
    */
    @IsTest
    static void getSObjectFieldsTest() {
        Test.startTest();
        final Map<String,String> configMap=BE_SingleRelatedList_Ctr.getSObjectFields('Opportunity');
        System.assertEquals('string', configMap.get('Name'), 'Correct sObject');
        Test.stopTest();
    }
    
    /**
     @Description test for BE_SingleRelatedList_Ctr. getConfigMeta(), correct scenary
    */
    @IsTest
    static void getConfigMetaTest() {
        Test.startTest();
        BE_SingleRelatedList_Ctr.getConfigMeta('TESTMETADATA_TST');
        Test.stopTest();
        final List<BE_SingleRelatedList_Setting__mdt> configMeta=(List<BE_SingleRelatedList_Setting__mdt>)JSON.deserialize('[{"DeveloperName":"TESTMETADATA_TST","MasterLabel":"Phone"}]', List<BE_SingleRelatedList_Setting__mdt>.class);
        System.assertEquals(1,configMeta.size(), 'Size correcto');
    }

}