/**
   ----------------------------------------------------------------------------------------------------
   @Name <BE_CA_NewCampaign_Tst>
   @Author Eduardo Vargas (luis.vargas.matute.contractor@bbva.com)
   @Date 2020-03-01
   @Description Test Class  for Update Financial Sponsor (BE_UpdateAcc_Ctr)
   @Changes
    Date        Author   Email                                     Type
    2020-03-01  LMBR     luis.vargas.matute.contractor@bbva.com    Creation
   ----------------------------------------------------------------------------------------------------
 */
@isTest
public class BE_UpdateAcc_Tst {

    /**
     * @Description  Test BE_UpdateAcc_Ctr
     */
    @IsTest
    public static void getValues() {
        
        final BE_UpdateAcc_Ctr updateClass = new BE_UpdateAcc_Ctr();
        BE_CustomQuickActionCRUD_Cls.Response response = new BE_CustomQuickActionCRUD_Cls.Response();
        response.isSuccess = false;
        
        Final Map<String,Object> params = new Map<String,Object>{'config' => 'test'};
        Final Account sObj = new Account(Name= 'TestAccount');
        insert sObj;
        sObj.Name = 'test account';
        Test.startTest();
        response = updateClass.updateRecord(sObj, params);
        Test.stopTest();
        System.assert(response.isSuccess, true);

    }
    
}