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
    /**
   @Description test BE_EditNonClient_Ctr.getFields(), correct scenary
     */
    @IsTest
    static void getFieldsTest() {
    	BE_CustomQuickAction_Ctr.getSettings('BE_ModifyContact');
    	final BE_SingleRelatedList_QuickAction__mdt configMeta=(BE_SingleRelatedList_QuickAction__mdt) JSON.deserialize('{"DeveloperName":"TESTMETADATA_TST","MasterLabel":"Phone"}',BE_SingleRelatedList_QuickAction__mdt.class);
    	System.assertEquals('TESTMETADATA_TST',configMeta.DeveloperName,'Good');
    }
    /**
        @Description test BE_CustomQuickAction_Ctr.getsObjFieldsTest(), correct scenary
     */
    static void getsObjFieldsTest(){
        final Account acc = new Account(Name='Test_Success');
        insert acc;
        final sObject sOBJ=BE_CustomQuickAction_Ctr.getsObjFields(acc.id, 'Account', new List<String>{'Name'});
        System.assertEquals(sOBJ.get('Name'),acc.Name,'Value Correct');
    }
    /**
     @Description test createRecords method, correct scenary
    */
    @IsTest
    static void createSuccessMethodsTest() {
        final BE_CustomQuickActionCRUD_Cls.Response resp = (BE_CustomQuickActionCRUD_Cls.Response)BE_CustomQuickAction_Ctr.createRecord(new Account(Name='Test'), '');
        System.assert(resp.isSuccess, 'success!');
    }
    
    /**
     @Description test updateRecords method, correct scenary
    */
    @IsTest
    static void updateSuccessMethodsTest() {
        Account acc = new Account(Name='Test_Success');
        insert acc;
        final BE_CustomQuickActionCRUD_Cls.Response resp = (BE_CustomQuickActionCRUD_Cls.Response)BE_CustomQuickAction_Ctr.updateRecord(acc, '');
        System.assert(resp.isSuccess, 'successUpdate!');
    }
    
    /**
     @Description test deleteRecords method, correct scenary
    */
    @IsTest
    static void deleteSuccessMethodsTest() {
        Account acc = new Account(Name='Test_Delete_Success');
        insert acc;
        final BE_CustomQuickActionCRUD_Cls.Response resp = (BE_CustomQuickActionCRUD_Cls.Response)BE_CustomQuickAction_Ctr.deleteRecord(acc, '');
        System.assert(resp.isSuccess, 'successDeleteSucess!');
    }
    
    /**
     @Description test createRecords method, incorrect scenary
    */
    @IsTest
    static void createErrorMethodsTest() {
    	final BE_CustomQuickActionCRUD_Cls.Response resp = (BE_CustomQuickActionCRUD_Cls.Response)BE_CustomQuickAction_Ctr.createRecord(null, '');
        System.assert(!resp.isSuccess, 'errorCreate!');
    }
    
    /**
     @Description test updateRecords method, incorrect scenary
    */
    @IsTest
    static void updateErrorMethodsTest() {
    	final BE_CustomQuickActionCRUD_Cls.Response resp = (BE_CustomQuickActionCRUD_Cls.Response)BE_CustomQuickAction_Ctr.updateRecord(null, '');
        System.assert(!resp.isSuccess, 'errorUpdate!');
    }
    
    /**
     @Description test deleteRecords method, incorrect scenary
    */
    @IsTest
    static void deleteErrorMethodsTest() {
    	final BE_CustomQuickActionCRUD_Cls.Response resp = (BE_CustomQuickActionCRUD_Cls.Response)BE_CustomQuickAction_Ctr.deleteRecord(null, '');
        System.assert(!resp.isSuccess, 'errorDelete!');
    }

    /**
     @Description test BE_CustomQuickActionCRUD_Cls, correct scenary
    */
    @IsTest
    static void allCRUDsTest() {
    	final BE_CustomQuickActionCRUD_Cls srl = new BE_CustomQuickActionCRUD_Cls();
        srl.createRecord(null);
        srl.updateRecord(null);
        srl.deleteRecord(null);
        Boolean isNull = false;
        final BE_CustomQuickActionCRUD_Cls.Response resp = srl.readRecord(null);
        if(resp==null) {
            isNull = true;
        }
        System.assert(!isNull, 'successAll!');
    }
}