/**
   ----------------------------------------------------------------------------------------------------
   @Name <BE_NewCampaignRoleValidation_tst>
   @Author Eduardo Vargas (luis.vargas.matute.contractor@bbva.com)
   @Date 2020-03-01
   @Description Test Class  for Validate Excecutive User (BE_NewCampaignRoleValidation_Ctr)
   @Changes
    Date        Author   Email                                     Type
    2020-03-01  LMBR     luis.vargas.matute.contractor@bbva.com    Creation
   ----------------------------------------------------------------------------------------------------
 */
@isTest
public class BE_CA_NewCampaignRoleValidation_tst {
    
    /**
     * @Description  Test BE_CA_NewCampaign_Ctr
     */
    @IsTest
    static void validateUserTest() {
        
        Test.startTest();
        Map<String,Object> res = BE_CA_NewCampaignRoleValidation_Ctr.validateUser();
        Test.stopTest();
        System.assertEquals(res.get('isExcecutiveUser'), false);
        
    }

}