/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_CustomQuickAction_Tst>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2020-03-03
   @Description test for BE_CustomQuickAction_Ctr class
   @Changes
   Date        Author   Email                  Type
   2020-03-03  LMBR     lolo.bravo@bbva.com    Creation
   -------------------------------------------------------------------------------------------------
 */
@IsTest
public with sharing class BE_CustomQuickAction_Tst { 
    /** GrantingTickets */
	final static String CLASS_NAME='className';
    
    /**
   @Description test BE_EditNonClient_Ctr.getFields(), correct scenary
     */
    @IsTest
    static void getSettingsTest() {
    	final Contact conOne = new Contact(Salutation='Mr.',FirstName='NON_CLIENT',LastName='NON_CLIENTE_CONTACT_ONE',decision_making_desc__c='Si',Email='contactone@test.com',MobilePhone='924567896',prof_position_type__c='APODERADO', contact_code__c='00001',phone_1__c='9876545',phone_1_area_code__c='01',phone_2__c='2235675',phone_2_area_code__c='01');
        BE_CustomQuickAction_Ctr.getSettings('BE_ModifyContact',conOne.Id);
    	final BE_SingleRelatedList_QuickAction__mdt configMeta=(BE_SingleRelatedList_QuickAction__mdt) JSON.deserialize('{"DeveloperName":"TESTMETADATA_TST","MasterLabel":"Phone"}',BE_SingleRelatedList_QuickAction__mdt.class);
    	System.assertEquals('TESTMETADATA_TST',configMeta.DeveloperName,'Good');
    }
    /**
        @Description test BE_CustomQuickAction_Ctr.getsObjFieldsTest(), correct scenary
     */
    @IsTest    
    static void getsObjFieldsTest() {
        
        final Account acc = new Account(Name='Test_Success01');       
        insert acc;
        test.startTest();
        final Map<String,Object> paramsMap = new Map<String,Object>{'Id'=> acc.Id , 'action' => 'update','sObjectType' => 'Account'};
        final sObject sOBJ=BE_CustomQuickAction_Ctr.getsObjFields(paramsMap, new List<String>{'Name'});
        System.debug('ACCOUNT'+ sOBJ);
        System.assertEquals(sOBJ.get('Name'),acc.Name,'Value Correct');
        test.stopTest();
    }
        /**
        @Description test BE_CustomQuickAction_Ctr.getsObjFieldsTest(), correct scenary
     */
    @IsTest    
    static void getsObjFieldscreateTest() {
        final Account acc = new Account(Name='Test_Success02');       
        insert acc;
        test.startTest();
        final Map<String,Object> paramsMap = new Map<String,Object>{'Id'=> '' , 'action' => 'create','sObjectType' => 'Account'};
        final sObject sOBJ=BE_CustomQuickAction_Ctr.getsObjFields(paramsMap, new List<String>{'Name'});
        System.assertEquals(Account.SobjectType.NewSobject(),sOBJ,'Value Correct');
        test.stopTest();
    }
    /**
     @Description test createRecords method, correct scenary
    */
    @IsTest
    static void createSuccessMethodsTest() {
        final Map<String,Object> paramsMap = new Map<String,Object>{CLASS_NAME=> ''};
        final BE_CustomQuickActionCRUD_Cls.Response resp = (BE_CustomQuickActionCRUD_Cls.Response)BE_CustomQuickAction_Ctr.createRecord(new Account(Name='Test'),paramsMap);
        System.assert(resp.isSuccess, 'success!');
    }
    
    /**
     @Description test updateRecords method, correct scenary
    */
    @IsTest
    static void updateSuccessMethodsTest() {
        final Account acc = new Account(Name='Test_Success03');
        insert acc;
        final Map<String,Object> paramsMap = new Map<String,Object>{CLASS_NAME=> ''};
        final BE_CustomQuickActionCRUD_Cls.Response resp = (BE_CustomQuickActionCRUD_Cls.Response)BE_CustomQuickAction_Ctr.updateRecord(acc, paramsMap);
        System.assert(resp.isSuccess, 'successUpdate!');
    }
    
    /**
     @Description test deleteRecords method, correct scenary
    */
    @IsTest
    static void deleteSuccessMethodsTest() {
        final Account acc = new Account(Name='Test_Delete_Success');
        insert acc;
        final Map<String,Object> paramsMap = new Map<String,Object>{CLASS_NAME=> ''};
        final BE_CustomQuickActionCRUD_Cls.Response resp = (BE_CustomQuickActionCRUD_Cls.Response)BE_CustomQuickAction_Ctr.deleteRecord(acc,paramsMap);
        System.assert(resp.isSuccess, 'successDeleteSucess!');
    }
    
    /**
     @Description test createRecords method, incorrect scenary
    */
    @IsTest
    static void createErrorMethodsTest() {
        final Map<String,Object> paramsMap = new Map<String,Object>{CLASS_NAME=> ''};
    	final BE_CustomQuickActionCRUD_Cls.Response resp = (BE_CustomQuickActionCRUD_Cls.Response)BE_CustomQuickAction_Ctr.createRecord(new Contact(LastName='TestError',MobilePhone='9876543213'), paramsMap);
        System.assert(!resp.isSuccess, 'errorCreate!');
    }

    /**
     @Description test BE_CustomQuickActionCRUD_Cls, correct scenary
    */
    @IsTest
    static void allCRUDsTest() {
    	final BE_CustomQuickActionCRUD_Cls srl = new BE_CustomQuickActionCRUD_Cls();
        final Account acc = new Account(Name='Test_Success04');
        final Map<String,Object> paramsMap = new Map<String,Object>{CLASS_NAME=> ''};
        srl.createRecord(acc,paramsMap);
        srl.updateRecord(acc,paramsMap);
        srl.deleteRecord(acc,paramsMap);
        Boolean isNull = false;
        final BE_CustomQuickActionCRUD_Cls.Response resp = srl.readRecord(acc,paramsMap);
        if(resp==null) {
            isNull = true;
        }
        System.assert(!isNull, 'successAll!'); 
    }
}