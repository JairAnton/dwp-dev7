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
        final User admin = [SELECT Id, prof_position_id__c, UserRole.Name FROM User WHERE id=:UserInfo.getUserId()];
        final UserRole userRole = [SELECT Id,Name FROM UserRole LIMIT 1];
        admin.prof_position_id__c = 'ADMIN';
        admin.UserRoleId = userRole.Id;
        update admin;
        Map<String,Object> res = new Map<String,Object>();
        Test.startTest();
        System.runAs(admin) {
        	res = BE_CA_NewCampaignRoleValidation_Ctr.validateUser();
        }
        Test.stopTest();
        System.assertEquals(res.get('isExcecutiveUser'), false);
        
    }

}