/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_NonClient_Tst>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2020-03-03
   @Description test for BE_NonClient_Ctr class
   @Changes
   Date        Author   Email                  Type
   2020-03-03  LMBR     lolo.bravo@bbva.com    Creation
   -------------------------------------------------------------------------------------------------
 */
@IsTest
public without sharing class BE_NonClient_Tst {
    /**
     @Description test BE_NonClient_Ctr.checkDuplicateNonClients(), correct scenary
    */
    @IsTest
    static void checkDuplicateNonClientsTest() {
      Test.startTest();
      final Id rTypeId =Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Record_Type_Non_Client').getRecordTypeId();
      final Account acc=new Account(Name='TEST_NON_CLIENT',AccountNumber='20876543265',recordTypeId=rTypeId);
      insert acc;
      final String resJSON=BE_NonClient_Ctr.checkDuplicateNonClients('TEST_NON_CLIENT','AccountNumber',acc.AccountNumber);
      final List<BE_NonClient_Ctr.WrapperAccount> lWrapper=(List<BE_NonClient_Ctr.WrapperAccount>)JSON.deserialize(resJSON, List<BE_NonClient_Ctr.WrapperAccount>.Class);
      System.assertEquals(1, lWrapper.size(), 'Sucesss');
      Test.stopTest();
    }

    /**
     @Description test BE_NonClient_Ctr.validateNonCliente(), correct scenary
    */
    @IsTest
    static void validateNonClienteTestSucess() {
        Test.startTest();
        final Account acc=new Account(Name='TEST_NON_CLIENT_TEST_SUCESS',AccountNumber='20876543262');
        final String res=BE_NonClient_Ctr.validateNonCliente(acc);
        final BE_NonClient_Ctr.ResultValidation resultVal= (BE_NonClient_Ctr.ResultValidation )JSON.deserialize(res,BE_NonClient_Ctr.ResultValidation.class);
        System.assertEquals('success',resultVal.status ,'Success');
        Test.stopTest();
    }

    /**
     @Description test BE_NonClient_Ctr.validateNonCliente(), error scenary
    */
    @IsTest
    static void validateNonClienteTestError() {
        Test.startTest();
        final Account acc=new Account(Name='TEST_NON_CLIENT_TEST_ERROR',AccountNumber='2087654326');
        final String res=BE_NonClient_Ctr.validateNonCliente(acc);
        final BE_NonClient_Ctr.ResultValidation resultVal= (BE_NonClient_Ctr.ResultValidation )JSON.deserialize(res,BE_NonClient_Ctr.ResultValidation.class);
        System.assertEquals('error',resultVal.status ,'Error');
        Test.stopTest();
    }

    /**
     @Description test BE_NonClient_Ctr.checkConvertedClients(), correct scenary
    */
    @IsTest
    static void checkConvertedClientsTest() {
        Test.startTest();
        final String res=BE_NonClient_Ctr.checkConvertedClients(null,null);
        System.assertEquals('',res ,'Empty Result');
        Test.stopTest();
    }
}