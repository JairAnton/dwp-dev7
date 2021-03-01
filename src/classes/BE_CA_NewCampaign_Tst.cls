/**
   ----------------------------------------------------------------------------------------------------
   @Name <BE_CA_NewCampaign_Tst>
   @Author Eduardo Vargas (luis.vargas.matute.contractor@bbva.com)
   @Date 2020-03-01
   @Description Test Class  for Create Contact of Non Client (BE_CA_NewCampaign_Ctr)
   @Changes
    Date        Author   Email       					           Type
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
        //final list<string> ejecutivePositionCode = new list<string> {'E03','I32'}; manager = E01
        //final string recordTypeNameAccount= 'BE_CLIENT';        
        Final User admin = [SELECT Id FROM User WHERE id=:UserInfo.getUserId()];
        Final Account acc = BE_EconomicGroup_DebtAndFee_tst.generateData(admin);
        System.debug('Account');
        System.debug(acc);
        acc.RecordTypeId = '0121I000000aNyPQAU';
        
        System.runAs(admin) {
            update acc;
        }

    }
    
     /**
	 * @Description  Test BE_CA_NewCampaign_Ctr
	 */
    @IsTest
    public static void getValues() {
        Final User manager = [SELECT Id FROM User WHERE prof_position_id__c = 'E01'];
        BE_CA_NewCampaign_Ctr s = new BE_CA_NewCampaign_Ctr();
        BE_CustomQuickActionCRUD_Cls.Response response = new BE_CustomQuickActionCRUD_Cls.Response();
        response.isSuccess = false;
        
        Final Map<String,Object> params = new Map<String,Object>{'config' => 'test'};
        Final altm__Commercial_Alert__c sObj = new altm__Commercial_Alert__c(altm__commercial_alert_record_type__c= 'Management',
                                                                            altm__commercial_alert_end_date__c = Date.parse('2021-03-17 00:00:00'),
                                                                            altm__commercial_alert_start_date__c = Date.parse('2021-03-08 00:00:00'),
                                                                            commercial_alert_category__c = 'Recursos',
                                                                            Name = 'Test Name');
        Test.startTest();
        System.runAs(manager) {
            response = s.createRecord(sObj, params);
        }
        
        Test.stopTest();
		System.assert(response.isSuccess, true);

    }
    
}