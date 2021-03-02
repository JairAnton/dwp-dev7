/**
   ----------------------------------------------------------------------------------------------------
   @Name <BE_CA_NewCampaign_Tst>
   @Author Eduardo Vargas (luis.vargas.matute.contractor@bbva.com)
   @Date 2020-03-01
   @Description Test Class  for Create Contact of Non Client (BE_CA_NewCampaign_Ctr)
   @Changes
    Date        Author   Email                                     Type
    2020-03-01  LMBR     luis.vargas.matute.contractor@bbva.com    Creation
   ----------------------------------------------------------------------------------------------------
 */
@isTest
public class BE_CA_NewCampaign_Tst {
    
    
    /**
     * @Description  setUp
     */
    @TestSetup
    public static void setUp() {
        final String recordTypeId= [SELECT ID FROM RecordType WHERE sObjectType='Account' AND DeveloperName='Record_Type_Client'].Id;     
        final User admin = [SELECT Id FROM User WHERE id=:UserInfo.getUserId()];
        final Account acc = BE_EconomicGroup_DebtAndFee_tst.generateData(admin);
        acc.RecordTypeId =recordTypeId;
        System.runAs(admin) {
            update acc;
        }

    }
    
     /**
     * @Description  Test BE_CA_NewCampaign_Ctr
     */
    @IsTest
    public static void getValues() {
        Final User manager = [SELECT Id FROM User WHERE prof_position_id__c = 'E01' LIMIT 1];
        final BE_CA_NewCampaign_Ctr campaignClass = new BE_CA_NewCampaign_Ctr();
        final BE_CustomQuickActionCRUD_Cls.Response response = new BE_CustomQuickActionCRUD_Cls.Response();
        response.isSuccess = false;
        Final Map<String,Object> params = new Map<String,Object>{'config' => 'test'};
        Final altm__Commercial_Alert__c sObj = new altm__Commercial_Alert__c(altm__commercial_alert_record_type__c= 'Management',
                                                                            altm__commercial_alert_end_date__c = system.today(),
                                                                            altm__commercial_alert_start_date__c = system.today(),
                                                                            commercial_alert_category__c = 'Recursos',
                                                                            altm__commercial_alert_task_type__c = 'Activo',
                                                                            Name = 'Test Name');
        Test.startTest();
        System.runAs(manager) {
            response = campaignClass.createRecord(sObj, params);
        }
        
        Test.stopTest();
        System.assert(response.isSuccess, true);

    }
    
}